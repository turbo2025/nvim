--------------------------------------------------------
-- Project Env (direnv / mise)
-- 打开项目文件/切换目录时加载最近的 .envrc 或 mise 配置，
-- 让 LSP、formatter、任务使用项目工具链。
-- 启动 nvim 时的环境作为基线；优先级：direnv > mise。
--------------------------------------------------------
local M = {}

local base_env = vim.fn.environ()
local cache = {}
local warned = {}
local current_key = nil
local applied = {}
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

local has_direnv = vim.fn.executable("direnv") == 1
local has_mise = vim.fn.executable("mise") == 1

local mise_markers = {
    "mise.toml",
    ".mise.toml",
    ".tool-versions",
}

--------------------------------------------------------
-- Helpers
--------------------------------------------------------
local function dedupe_path(path)
    local seen, parts = {}, {}
    for part in path:gmatch("[^:]+") do
        if not seen[part] then
            seen[part] = true
            parts[#parts + 1] = part
        end
    end
    return table.concat(parts, ":")
end

local function with_mason(path)
    if type(path) ~= "string" then
        return path
    end
    if vim.fn.isdirectory(mason_bin) == 1 and not path:find(mason_bin, 1, true) then
        path = mason_bin .. ":" .. path
    end
    return dedupe_path(path)
end

local function find_project(source)
    if has_direnv then
        local root = vim.fs.root(source, ".envrc")
        if root then
            return "direnv", root
        end
    end
    if has_mise then
        local root = vim.fs.root(source, mise_markers)
        if root then
            return "mise", root
        end
    end
    return nil, nil
end

--------------------------------------------------------
-- Env
--------------------------------------------------------
local function restore_base()
    for key in pairs(applied) do
        if base_env[key] ~= nil then
            vim.env[key] = key == "PATH" and with_mason(base_env[key]) or base_env[key]
        else
            vim.env[key] = nil
        end
    end
    applied = {}
end

local function apply_env(env)
    restore_base()
    for key, value in pairs(env) do
        -- 工具自己的状态写回 nvim 会干扰下一次导出
        if type(value) == "string" and not key:match("^(DIRENV_|__MISE_)") then
            vim.env[key] = key == "PATH" and with_mason(value) or value
            applied[key] = true
        end
    end
end

--------------------------------------------------------
-- Export
--------------------------------------------------------
local function notify_failure(kind, root)
    local key = kind .. ":" .. root
    if warned[key] then
        return
    end
    warned[key] = true
    local hint = kind == "direnv" and "direnv allow" or "mise trust"
    vim.notify(
        kind .. ": 无法加载 " .. root .. " 的项目环境，先执行 `" .. hint .. "`",
        vim.log.levels.WARN
    )
end

local function export(kind, root)
    local key = kind .. ":" .. root
    if cache[key] == false then
        return nil
    end
    if cache[key] then
        return cache[key]
    end
    local cmd = kind == "direnv"
        and { "direnv", "export", "json" }
        or { "mise", "env", "--json" }
    local result = vim.system(cmd, {
        cwd = root,
        text = true,
    }):wait()
    if result.code ~= 0 then
        cache[key] = false
        notify_failure(kind, root)
        return nil
    end
    local ok, env = pcall(vim.json.decode, result.stdout or "")
    if not ok or type(env) ~= "table" then
        cache[key] = false
        notify_failure(kind, root)
        return nil
    end
    cache[key] = env
    return env
end

--------------------------------------------------------
-- Apply
--------------------------------------------------------
local function apply_project(kind, root)
    local key = kind and (kind .. ":" .. root) or nil
    if key == current_key then
        return
    end
    current_key = key
    if not key then
        restore_base()
        return
    end
    -- 先回到基线再计算新项目环境，避免上一个项目的 PATH/NIX_* 污染导出
    restore_base()
    local env = export(kind, root)
    if env then
        apply_env(env)
    end
end

function M.apply_for_buf(bufnr)
    bufnr = bufnr or 0
    if vim.bo[bufnr].buftype ~= "" then
        return
    end
    local name = vim.api.nvim_buf_get_name(bufnr)
    local kind, root = find_project(name ~= "" and bufnr or vim.fn.getcwd())
    apply_project(kind, root)
end

function M.apply_for_cwd()
    local kind, root = find_project(vim.fn.getcwd())
    apply_project(kind, root)
end

--------------------------------------------------------
-- Setup
--------------------------------------------------------
if not has_direnv and not has_mise then
    return M
end

-- 首个文件/当前目录在 lazy 加载 LSP 插件之前先应用环境，
-- 确保 gopls/ts_ls 等进程从正确的 PATH 启动。
local initial_source
if vim.fn.argc() > 0 then
    initial_source = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
else
    initial_source = vim.fn.getcwd()
end
local initial_kind, initial_root = find_project(initial_source)
apply_project(initial_kind, initial_root)

local function reload()
    cache = {}
    warned = {}
    current_key = nil
    M.apply_for_buf(0)
end

vim.api.nvim_create_user_command("ProjectEnvReload", reload, {
    desc = "Reload direnv/mise environment for current buffer",
})
vim.api.nvim_create_user_command("DirenvReload", reload, {
    desc = "Alias for :ProjectEnvReload",
})

local group = vim.api.nvim_create_augroup("ProjectEnv", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile", "BufEnter" }, {
    group = group,
    callback = function(args)
        M.apply_for_buf(args.buf)
    end,
})

vim.api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function()
        M.apply_for_buf(0)
    end,
})

vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
        if vim.fn.argc() == 0 then
            M.apply_for_buf(0)
        end
    end,
})

return M
