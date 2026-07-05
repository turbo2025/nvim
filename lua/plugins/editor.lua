return {
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {},
    },
    {
        "HiPhish/rainbow-delimiters.nvim",
        event = {
            "BufReadPost",
            "BufNewFile",
        },
    },
    {
        "folke/todo-comments.nvim",
        event = "BufReadPost",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
        keys = {
            {
                "<leader>st",
                "<cmd>TodoFzfLua<cr>",
                desc = "Todo",
            },
        },
    },
}
