return {
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
        keys = {
            {
                "<leader>xx",
                function()
                    require("trouble").toggle("diagnostics")
                end,
                desc = "Diagnostics",
            },
            {
                "<leader>xX",
                function()
                    require("trouble").toggle("diagnostics", {
                        filter = {
                            buf = 0,
                        },
                    })
                end,
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>xs",
                function()
                    require("trouble").toggle("symbols")
                end,
                desc = "Symbols",
            },
            {
                "<leader>xl",
                function()
                    require("trouble").toggle("lsp")
                end,
                desc = "LSP",
            },
            {
                "<leader>xq",
                function()
                    require("trouble").toggle("quickfix")
                end,
                desc = "Quickfix",
            },
            {
                "<leader>xt",
                function()
                    require("trouble").toggle("todo")
                end,
                desc = "Todo",
            },
        },
    },
}
