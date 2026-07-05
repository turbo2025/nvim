return {
    {
        "lewis6991/gitsigns.nvim",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        opts = {
            current_line_blame = true,
        },
        keys = {
            {
                "]h",
                function()
                    require("gitsigns").next_hunk()
                end,
                -- 下一个修改
                desc = "Next Hunk",
            },
            {
                "[h",
                function()
                    require("gitsigns").prev_hunk()
                end,
                -- 上一个修改
                desc = "Previous Hunk",
            },
            {
                "<leader>gh",
                function()
                    require("gitsigns").preview_hunk()
                end,
                -- 查看 Diff
                desc = "Preview Hunk",
            },
            {
                "<leader>gr",
                function()
                    require("gitsigns").reset_hunk()
                end,
                -- 回滚当前 Hunk
                desc = "Reset Hunk",
            },
            {
                "<leader>gb",
                function()
                    require("gitsigns").blame_line()
                end,
                -- 查看当前行 Blame
                desc = "Blame Line",
            },
            {
                "<leader>gc",
                function()
                    require("fzf-lua").git_commits()
                end,
                desc = "Git Commits",
            },
            {
                "<leader>gs",
                function()
                    require("fzf-lua").git_status()
                end,
                desc = "Git Status",
            },
        },
    },
}
