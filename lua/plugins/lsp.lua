return {
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
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
            --------------------------------------------------------
            -- Enable
            --------------------------------------------------------
            vim.lsp.enable({
                "lua_ls",
                "gopls",
                "rust_analyzer",
                "basedpyright",
            })
        end,
    },
}
