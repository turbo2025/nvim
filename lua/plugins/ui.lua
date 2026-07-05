return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",

        opts = {
            preset = "modern",
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                theme = "auto",
                globalstatus = true,
            },
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            dashboard = {
                enabled = true,
            },
            notifier = {
                enabled = true,
            },
            input = {
                enabled = true,
            },
            picker = {
                enabled = true,
            },
            terminal = {
                enabled = true,
            },
        },
    },
}
