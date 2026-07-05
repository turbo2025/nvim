return {
    {
        "saghen/blink.cmp",
        version = "*",
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        opts = {
            keymap = {
                preset = "super-tab",
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
