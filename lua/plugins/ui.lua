return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.add({
                { "<leader>b", group = "Buffer" },
                { "<leader>c", group = "Code" },
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git" },
                { "<leader>s", group = "Search" },
                { "<leader>t", group = "Toggle" },
                { "<leader>w", group = "Window" },
            })
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            options = {
                globalstatus = true,
                theme = "auto",
                component_separators = "",
                section_separators = "",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    "diff",
                },
                lualine_c = {
                    "filename",
                },
                lualine_x = {
                    "diagnostics",
                    "encoding",
                    "filetype",
                },
                lualine_y = {
                    "progress",
                },
                lualine_z = {
                    "location",
                },
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
                enabled = false,
            },
            input = {
                enabled = true,
            },
        },
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "moon",
            transparent = false,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight")
        end,
    },
}
