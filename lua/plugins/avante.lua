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
                        -- DeepSeek 默认开启 thinking（effort=high）。关掉以获得
                        -- 更快、更省 token 的响应；需要深度推理时改成 "enabled"。
                        thinking = { type = "disabled" },
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
        },
    },
}
