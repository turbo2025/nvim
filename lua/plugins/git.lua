return {
    ----------------------------------------------------------------------
    -- Gitsigns
    ----------------------------------------------------------------------
    {
        "lewis6991/gitsigns.nvim",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        opts = {
            ------------------------------------------------------------------
            -- Inline Blame
            ------------------------------------------------------------------
            current_line_blame = false,
            current_line_blame_opts = {
                delay = 300,
                virt_text = true,
                virt_text_pos = "eol",
                ignore_whitespace = false,
            },
            ------------------------------------------------------------------
            -- Preview
            ------------------------------------------------------------------
            preview_config = {
                border = "rounded",
            },
        },
        config = function(_, opts)
            local gs = require("gitsigns")
            gs.setup(opts)
            local map = vim.keymap.set
            ------------------------------------------------------------------
            -- Navigation
            ------------------------------------------------------------------
            map("n", "]h", gs.next_hunk, {
                desc = "Next Hunk",
            })
            map("n", "[h", gs.prev_hunk, {
                desc = "Prev Hunk",
            })
            ------------------------------------------------------------------
            -- Hunk
            ------------------------------------------------------------------
            map("n", "<leader>hs", gs.stage_hunk, {
                desc = "Stage Hunk",
            })
            map("n", "<leader>hr", gs.reset_hunk, {
                desc = "Reset Hunk",
            })
            map("n", "<leader>hS", gs.stage_buffer, {
                desc = "Stage Buffer",
            })
            map("n", "<leader>hR", gs.reset_buffer, {
                desc = "Reset Buffer",
            })
            map("n", "<leader>hp", gs.preview_hunk, {
                desc = "Preview Hunk",
            })
            ------------------------------------------------------------------
            -- Blame
            ------------------------------------------------------------------
            map("n", "<leader>hb", function()
                gs.blame_line({ full = true })
            end, {
                desc = "Blame Line",
            })
            map("n", "<leader>gb", gs.toggle_current_line_blame, {
                desc = "Toggle Line Blame",
            })
            ------------------------------------------------------------------
            -- Diff
            ------------------------------------------------------------------
            map("n", "<leader>hd", gs.diffthis, {
                desc = "Diff This",
            })
            map("n", "<leader>hD", gs.toggle_deleted, {
                desc = "Toggle Deleted",
            })
        end,
    },
    ----------------------------------------------------------------------
    -- LazyGit
    ----------------------------------------------------------------------
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            {
                "<leader>gg",
                "<cmd>LazyGit<CR>",
                desc = "LazyGit",
            },
        },
    },
    ----------------------------------------------------------------------
    -- Merge Conflict
    ----------------------------------------------------------------------
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        event = "BufReadPre",
        opts = {
            default_mappings = true,
            default_commands = true,
            disable_diagnostics = false,
        },
    },
    ----------------------------------------------------------------------
    -- DiffView
    ----------------------------------------------------------------------
    {
        "sindrets/diffview.nvim",
        cmd = {
            "DiffviewOpen",
            "DiffviewFileHistory",
        },
        keys = {
            {
                "<leader>gd",
                "<cmd>DiffviewOpen<CR>",
                desc = "Git Diff",
            },
            {
                "<leader>gh",
                "<cmd>DiffviewFileHistory %<CR>",
                desc = "Current File History",
            },
            {
                "<leader>gH",
                "<cmd>DiffviewFileHistory<CR>",
                desc = "Repository History",
            },
        },
    },
}
