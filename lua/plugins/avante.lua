-- 自定义 agent 工具：把常用测试/运行命令包成固定工具，模型不用再拼 shell。
-- 用 vim.system 异步执行（on_complete），避免阻塞 UI；cwd 固定为项目根目录。

local function avante_root()
    local ok, Utils = pcall(require, "avante.utils")
    if ok and type(Utils.get_project_root) == "function" then
        local root = Utils.get_project_root()
        if root and root ~= "" then return root end
    end
    return vim.fn.getcwd()
end

local function truncate_output(output, max)
    max = max or 24000
    if type(output) ~= "string" then output = tostring(output) end
    if #output <= max then return output end
    local head = 4000
    return output:sub(1, head)
        .. string.format("\n... [truncated %d bytes] ...\n", #output - max)
        .. output:sub(-(max - head))
end

local function finish_output(result)
    local output = (result.stdout or "") .. (result.stderr or "")
    if output == "" then output = "(no output)" end
    local code = result.code or -1
    if code ~= 0 then output = output .. string.format("\n[exit code %d]", code) end
    return truncate_output(output)
end

---@param cmd string[]
---@param opts table avante tool opts（含 on_log / on_complete）
---@param timeout integer|nil 超时毫秒数
local function run_command(cmd, opts, timeout)
    if vim.fn.executable(cmd[1]) ~= 1 and not vim.uv.fs_stat(cmd[1]) then
        return nil, "Command not found: " .. cmd[1]
    end
    local root = avante_root()
    if opts.on_log then
        opts.on_log("cwd: " .. root)
        opts.on_log("$ " .. table.concat(cmd, " "))
    end
    local sys_opts = { cwd = root, text = true, timeout = timeout or 300000 }
    if opts.on_complete then
        vim.system(cmd, sys_opts, vim.schedule_wrap(function(result)
            local output = finish_output(result)
            -- 非零退出码按 error 返回，内容里保留完整输出供模型阅读
            if (result.code or -1) ~= 0 then
                opts.on_complete(nil, output)
            else
                opts.on_complete(output, nil)
            end
        end))
        return nil
    end
    local result = vim.system(cmd, sys_opts):wait()
    local output = finish_output(result)
    if (result.code or -1) ~= 0 then return nil, output end
    return output
end

---优先使用项目自己的 Python：.venv / venv / uv / python3 / python
local function python_prefix(root)
    for _, rel in ipairs({ ".venv/bin/python", "venv/bin/python" }) do
        local path = root .. "/" .. rel
        if vim.uv.fs_stat(path) then return { path } end
    end
    if
        vim.fn.executable("uv") == 1
        and (vim.uv.fs_stat(root .. "/uv.lock") or vim.uv.fs_stat(root .. "/pyproject.toml"))
    then
        return { "uv", "run", "python" }
    end
    for _, exe in ipairs({ "python3", "python" }) do
        if vim.fn.executable(exe) == 1 then return { exe } end
    end
    return nil
end

local function optional_value(value)
    if value == nil or value == vim.NIL or value == "" then return nil end
    return value
end

-- avante 内置 bash 工具把 `path` 标为必填；模型偶尔只传 `command`，
-- 导致 helpers.get_abs_path(nil) 在 path.lua 里 string.byte(nil) 抛错，
-- 进而 on_stop 中断、侧栏一直停在 generating。这里给 nil/空值兜底为项目根，
-- 行为退化为“默认在项目根执行”，其余逻辑不变。
local function patch_avante_nil_path()
    local ok, Helpers = pcall(require, "avante.llm_tools.helpers")
    if not ok or type(Helpers.get_abs_path) ~= "function" then return end
    if Helpers.__nil_path_patched then return end
    local original = Helpers.get_abs_path
    Helpers.get_abs_path = function(rel_path)
        if rel_path == nil or rel_path == vim.NIL or rel_path == "" then rel_path = "." end
        return original(rel_path)
    end
    Helpers.__nil_path_patched = true
end

local custom_tools = {
    {
        name = "run_go_test",
        description = "Run `go test` in the project root and return the output. Use this instead of shell commands when checking Go tests.",
        param = {
            type = "table",
            fields = {
                {
                    name = "target",
                    description = "Package pattern passed to `go test`, e.g. ./... or ./internal/foo (default: ./...)",
                    type = "string",
                    optional = true,
                },
            },
            usage = { target = "Package pattern, default ./..." },
        },
        returns = { { name = "result", description = "go test output", type = "string" } },
        func = function(params, opts)
            local target = optional_value(params.target) or "./..."
            return run_command({ "go", "test", target }, opts, 600000)
        end,
    },
    {
        name = "run_pytest",
        description = "Run pytest in the project root (prefers the project venv/uv interpreter, falls back to `pytest`). Use it to check Python tests.",
        param = {
            type = "table",
            fields = {
                {
                    name = "target",
                    description = "Test path or node id passed to pytest, e.g. tests/test_api.py (default: whole project)",
                    type = "string",
                    optional = true,
                },
            },
            usage = { target = "Test path or node id" },
        },
        returns = { { name = "result", description = "pytest output", type = "string" } },
        func = function(params, opts)
            local root = avante_root()
            local cmd
            for _, rel in ipairs({ ".venv/bin/pytest", "venv/bin/pytest" }) do
                local path = root .. "/" .. rel
                if vim.uv.fs_stat(path) then
                    cmd = { path }
                    break
                end
            end
            if not cmd
                and vim.fn.executable("uv") == 1
                and (vim.uv.fs_stat(root .. "/uv.lock") or vim.uv.fs_stat(root .. "/pyproject.toml"))
            then
                cmd = { "uv", "run", "pytest" }
            end
            if not cmd and vim.fn.executable("pytest") == 1 then cmd = { "pytest" } end
            if not cmd then
                local prefix = python_prefix(root)
                if prefix then cmd = vim.list_extend(prefix, { "-m", "pytest" }) end
            end
            if not cmd then return nil, "pytest not found: install pytest or create a .venv" end
            local target = optional_value(params.target)
            if target then table.insert(cmd, target) end
            return run_command(cmd, opts, 600000)
        end,
    },
    {
        name = "run_npm_test",
        description = "Run `npm test` in the project root and return the output. Use it to check JS/TS tests.",
        param = {
            type = "table",
            fields = {
                {
                    name = "target",
                    description = "Optional argument forwarded to the test script (after `--`)",
                    type = "string",
                    optional = true,
                },
            },
            usage = { target = "Argument forwarded to npm test" },
        },
        returns = { { name = "result", description = "npm test output", type = "string" } },
        func = function(params, opts)
            local cmd = { "npm", "test" }
            local target = optional_value(params.target)
            if target then
                table.insert(cmd, "--")
                table.insert(cmd, target)
            end
            return run_command(cmd, opts, 600000)
        end,
    },
    {
        name = "run_python_script",
        description = "Run a Python file or inline Python code with the project interpreter. Use it for quick scripts instead of shell commands.",
        param = {
            type = "table",
            fields = {
                {
                    name = "script",
                    description = "Path to a Python file, relative to the project root",
                    type = "string",
                    optional = true,
                },
                {
                    name = "code",
                    description = "Inline Python code, used when script is omitted",
                    type = "string",
                    optional = true,
                },
            },
            usage = { script = "Path to a .py file", code = "Inline Python code" },
        },
        returns = { { name = "result", description = "Python stdout/stderr", type = "string" } },
        func = function(params, opts)
            local root = avante_root()
            local prefix = python_prefix(root)
            if not prefix then
                return nil, "No Python interpreter found (tried .venv, uv, python3, python)"
            end
            local cmd = vim.deepcopy(prefix)
            local script = optional_value(params.script)
            local code = optional_value(params.code)
            if script then
                table.insert(cmd, script)
            elseif code then
                table.insert(cmd, "-c")
                table.insert(cmd, code)
            else
                return nil, "Provide either script or code"
            end
            return run_command(cmd, opts, 120000)
        end,
    },
    {
        name = "git_status",
        description = "Show `git status --short --branch` for the project.",
        param = { type = "table", fields = {}, usage = {} },
        returns = { { name = "result", description = "git status output", type = "string" } },
        func = function(_, opts)
            return run_command({ "git", "status", "--short", "--branch" }, opts, 60000)
        end,
    },
    {
        name = "git_log",
        description = "Show recent commits as a one-line graph (`git log --oneline --decorate`).",
        param = {
            type = "table",
            fields = {
                {
                    name = "count",
                    description = "Number of commits to show, 1-200 (default: 20)",
                    type = "number",
                    optional = true,
                },
            },
            usage = { count = "Number of commits, default 20" },
        },
        returns = { { name = "result", description = "git log output", type = "string" } },
        func = function(params, opts)
            local count = tonumber(params.count) or 20
            count = math.max(1, math.min(200, math.floor(count)))
            return run_command({ "git", "log", "--oneline", "--decorate", "-n", tostring(count) }, opts, 60000)
        end,
    },
    {
        name = "git_branch",
        description = "List local branches with their upstream and last commit (`git branch -vv`).",
        param = { type = "table", fields = {}, usage = {} },
        returns = { { name = "result", description = "git branch output", type = "string" } },
        func = function(_, opts)
            return run_command({ "git", "branch", "-vv" }, opts, 60000)
        end,
    },
    {
        name = "git_show",
        description = "Show a commit or ref with a diffstat (`git show --stat`). Read-only.",
        param = {
            type = "table",
            fields = {
                {
                    name = "ref",
                    description = "Commit hash, branch, tag or HEAD (default: HEAD)",
                    type = "string",
                    optional = true,
                },
            },
            usage = { ref = "Commit/ref, default HEAD" },
        },
        returns = { { name = "result", description = "git show output", type = "string" } },
        func = function(params, opts)
            local ref = optional_value(params.ref) or "HEAD"
            -- 不允许以 - 开头，避免被当成 git 选项
            if ref:sub(1, 1) == "-" then return nil, "Invalid ref: " .. ref end
            return run_command({ "git", "show", "--stat", ref }, opts, 60000)
        end,
    },
}

return {
    {
        "yetone/avante.nvim",
        -- VeryLazy + build：首次安装时就地编译原生依赖（tokenizer / ACP）。
        -- 需要 make、cargo 和 C 编译器（由运行 Neovim 的环境提供）。
        event = "VeryLazy",
        version = false,
        build = "make",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            -- 用 <leader>ac 统一打开 AI 侧栏。avante 默认把 <leader>ac 绑成
            -- “把当前 buffer 加入上下文”，检测到冲突会跳过自己的绑定；
            -- 需要加文件时用 <leader>aB（全部打开的 buffer），或在侧栏里按 @。
            { "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Open DeepSeek Chat" },
        },
        opts = {
            -- avante 内置 deepseek provider：
            --   endpoint = https://api.deepseek.com
            --   model    = deepseek-chat
            --   api key  = DEEPSEEK_API_KEY（由启动 Neovim 的 shell 导出）
            -- 想换模型时改 providers.deepseek.model = "deepseek-v4-pro"。
            provider = "deepseek",
            providers = {
                deepseek = {
                    -- DeepSeek 当前提供 deepseek-flash / deepseek-v4-pro；
                    -- deepseek-chat 是映射到 flash 的兼容别名，这里显式指定。
                    model = "deepseek-flash",
                    extra_request_body = {
                        -- avante 的 openai provider 会默认带 max_completion_tokens=16384，
                        -- 而 DeepSeek 只认 max_tokens，未知字段会被拒绝（HTTP 400）。
                        -- 设置 max_tokens 后 avante 会自动移除 max_completion_tokens。
                        max_tokens = 8192,
                        -- 开启 DeepSeek thinking（默认 effort=high）：响应更慢、
                        -- 更耗 token，但工具调用参数更可靠；追求速度可改成 "disabled"。
                        thinking = { type = "enabled" },
                    },
                },
            },
            -- 行内自动建议默认关闭：打字频率高、按 token 计费，而补全已经
            -- 交给 minuet + 本地 Ollama（lua/plugins/minuet.lua）。
            -- 想改用 DeepSeek 补全就同时把 behaviour.auto_suggestions 设为 true。
            auto_suggestions_provider = "deepseek",
            behaviour = {
                auto_suggestions = false,
                -- agent 模式会读写文件/执行命令；保留确认步骤，避免误改。
                auto_approve_tool_permissions = false,
            },
            -- 文件/输入选择器复用已装的 snacks，不再为 avante 拉 telescope。
            selector = { provider = "snacks" },
            input = { provider = "snacks" },
            -- 常用命令工具（测试 / Python / git）。
            custom_tools = custom_tools,
        },
        -- 自定义 config：手动 setup 后再打 nil path 补丁。lazy 在同时提供
        -- opts 和 config 时不会自动调用 setup。
        config = function(_, opts)
            require("avante").setup(opts)
            patch_avante_nil_path()
        end,
    },
}
