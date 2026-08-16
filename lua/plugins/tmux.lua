return {
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
        end,
        keys = {
            {
                "<C-h>",
                "<cmd>TmuxNavigateLeft<cr>",
                desc = "Navigate Left",
            },
            {
                "<C-j>",
                "<cmd>TmuxNavigateDown<cr>",
                desc = "Navigate Down",
            },
            {
                "<C-k>",
                "<cmd>TmuxNavigateUp<cr>",
                desc = "Navigate Up",
            },
            {
                "<C-l>",
                "<cmd>TmuxNavigateRight<cr>",
                desc = "Navigate Right",
            },
        },
    },
}
