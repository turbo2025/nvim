local augroup = vim.api.nvim_create_augroup

local autocmd = vim.api.nvim_create_autocmd

--------------------------------------------------------
-- Highlight when yanking
--------------------------------------------------------

local yank_group = augroup("YankHighlight", {})

autocmd("TextYankPost", {

    group = yank_group,

    callback = function()
        vim.highlight.on_yank()
    end,

})

--------------------------------------------------------
-- Return to last cursor position
--------------------------------------------------------

autocmd("BufReadPost", {

    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')

        local line_count = vim.api.nvim_buf_line_count(0)

        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,

})
