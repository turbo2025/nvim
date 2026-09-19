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
            -- Capabilities: workspace/willRenameFiles (snacks.rename sync)
            -- + blink.cmp's own capabilities. blink.cmp was never wired
            -- into any server's capabilities before, which it needs for
            -- completion/signature-help related extensions to work fully.
            --------------------------------------------------------
            vim.lsp.config("*", {
                capabilities = vim.tbl_deep_extend("force", {
                    workspace = {
                        fileOperations = {
                            willRename = true,
                            didRename = true,
                        },
                    },
                }, require("blink.cmp").get_lsp_capabilities()),
            })
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
