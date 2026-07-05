return {
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            ------------------------------------------------------------------
            -- Find
            ------------------------------------------------------------------
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
                "<leader>fw",
                function()
                    require("fzf-lua").grep_cword()
                end,
                desc = "Current Word",
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
                desc = "Help Tags",
            },
            {
                "<leader>fk",
                function()
                    require("fzf-lua").keymaps()
                end,
                desc = "Keymaps",
            },
            {
                "<leader>fc",
                function()
                    require("fzf-lua").commands()
                end,
                desc = "Commands",
            },
            {
                "<leader>fm",
                function()
                    require("fzf-lua").marks()
                end,
                desc = "Marks",
            },
            {
                "<leader>f.",
                function()
                    require("fzf-lua").resume()
                end,
                desc = "Resume Last Search",
            },
        },
        opts = {
            winopts = {
                height = 0.90,
                width = 0.90,
                preview = {
                    layout = "vertical",
                    vertical = "right:55%",
                },
            },
            fzf_opts = {
                ["--layout"] = "reverse",
                ["--info"] = "inline",
            },
        },
    },
}
