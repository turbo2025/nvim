return {
    {
        "mason-org/mason.nvim",
        cmd = "Mason",
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },

        config = function()
            vim.lsp.enable({
                "lua_ls",
                "gopls",
                "rust_analyzer",
                "basedpyright",
            })
        end,
    },
}
