return {
    {
        "saghen/blink.cmp",
        version = "*",
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        config = function(_, opts)
            require("blink.cmp").setup(opts)
            -- 真正的病因找到了：blink.cmp 的 sources.providers 是懒初始化
            -- 的，只有真正触发过一次补全（比如打字弹出过补全菜单）之后才会
            -- 注册 "lsp" 这些 provider；而 get_signature_help() 直接遍历
            -- sources.providers，并不会主动触发这个初始化。所以在你打字
            -- 触发过补全之前调用签名提示，会静默返回空——不管绑的是哪个
            -- 键都没用，这才是之前 <C-k>/<C-s> 一直"没反应"的真正原因，跟
            -- 按键冲突无关（用真实 gopls 请求验证过整条链路）。这里强制
            -- 提前跑一次注册。
            require("blink.cmp.sources.lib").get_enabled_providers("default")
        end,
        opts = {
            keymap = {
                preset = "super-tab",
                -- 自定义键会跟 preset 合并，用 blink 自己的
                -- show_signature/hide_signature，不重新绑
                -- vim.lsp.buf.signature_help，避免跟内部状态打架。
                ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
                menu = {
                    border = "rounded",
                },
            },
            signature = {
                enabled = true,
            },
            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
            },
            fuzzy = {
                implementation = "prefer_rust_with_warning",
            },
        },
    },
}
