return {
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            {
                "<leader>ff",
                function()
                    require("fzf-lua").files()
                end,
                desc = "Find Files",
            },
            {
                "<leader>fg",
                function()
                    require("fzf-lua").live_grep()
                end,
                desc = "Live Grep",
            },
            {
                "<leader>fb",
                function()
                    require("fzf-lua").buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>fr",
                function()
                    require("fzf-lua").oldfiles()
                end,
                desc = "Recent Files",
            },
            {
                "<leader>fh",
                function()
                    require("fzf-lua").help_tags()
                end,
                desc = "Help",
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
            {
                "<leader>sd",
                function()
                    require("fzf-lua").lsp_document_symbols()
                end,
                desc = "Document Symbols",
            },
            {
                "<leader>sw",
                function()
                    require("fzf-lua").lsp_workspace_symbols()
                end,
                desc = "Workspace Symbols",
            },
            {
                "<leader>fs",
                function()
                    require("fzf-lua").lsp_document_symbols()
                end,
                desc = "Symbols",
            },
            {
                "<leader>fw",
                function()
                    require("fzf-lua").grep_cword()
                end,
                desc = "Word",
            },
        },
        opts = {
            "ivy",
        },
    },
}
