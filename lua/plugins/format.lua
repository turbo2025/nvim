return {
    {
        "stevearc/conform.nvim",
        event = {
            "BufWritePre",
        },
        opts = {
            format_on_save = {
                timeout_ms = 1000,
                lsp_format = "fallback",
            },
            formatters_by_ft = {
                lua = { "stylua" },
                go = {
                    "goimports",
                    "gofumpt",
                },
                rust = { "rustfmt" },
                python = { "ruff_format" },
            },
        },
    },
}
