return {
    {
        "mason-org/mason.nvim",
        lazy = false,
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        config = function()
            --------------------------------------------------------
            -- Server Config
            --------------------------------------------------------
            vim.lsp.config("lua_ls", require("lsp.lua_ls"))
            vim.lsp.config("gopls", require("lsp.gopls"))
            vim.lsp.config(
                "rust_analyzer",
                require("lsp.rust_analyzer")
            )
            vim.lsp.config(
                "basedpyright",
                require("lsp.basedpyright")
            )
            vim.lsp.config("ts_ls", require("lsp.ts_ls"))
            vim.lsp.config("eslint", require("lsp.eslint"))
            vim.lsp.config("html", require("lsp.html"))
            vim.lsp.config("cssls", require("lsp.cssls"))
            vim.lsp.config("vue_ls", require("lsp.vue_ls"))
            --------------------------------------------------------
            -- Enable
            --------------------------------------------------------
            vim.lsp.enable({
                "lua_ls",
                "gopls",
                "rust_analyzer",
                "basedpyright",
                "ts_ls",
                "eslint",
                "html",
                "cssls",
                "vue_ls",
            })
        end,
    },
}
