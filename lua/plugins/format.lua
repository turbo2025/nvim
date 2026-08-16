return {
    {
        "stevearc/conform.nvim",
        event = {
            "BufWritePre",
        },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({
                        async = true,
                        lsp_format = "fallback",
                    })
                end,
                mode = "n",
                desc = "Format",
            },
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
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                vue = { "prettier" },
                svelte = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                html = { "prettier" },
            },
        },
    },
}
