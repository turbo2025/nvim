local group = vim.api.nvim_create_augroup("Core", { clear = true })

--------------------------------------------------------
-- Highlight Yank
--------------------------------------------------------

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.highlight.on_yank()
    end,
})

--------------------------------------------------------
-- Restore Cursor
--------------------------------------------------------

vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    callback = function(event)
        local mark = vim.api.nvim_buf_get_mark(event.buf, '"')

        local line_count = vim.api.nvim_buf_line_count(event.buf)

        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

--------------------------------------------------------
-- Auto Create Directory
--------------------------------------------------------

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function(event)
        local dir = vim.fn.fnamemodify(event.match, ":p:h")

        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})
