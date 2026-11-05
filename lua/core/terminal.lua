--------------------------------------------------------
-- Terminal
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- State
--------------------------------------------------------
local state = {
    win = nil,
    buf = nil,
    job = nil,
    height = 15,
}
--------------------------------------------------------
-- Helpers
--------------------------------------------------------
local function valid()
    return state.win
        and vim.api.nvim_win_is_valid(state.win)
        and state.buf
        and vim.api.nvim_buf_is_valid(state.buf)
end
--------------------------------------------------------
-- Open
--------------------------------------------------------
function M.open()
    if valid() then
        vim.api.nvim_set_current_win(state.win)
        return
    end
    vim.cmd(("botright %dsplit"):format(state.height))
    state.win = vim.api.nvim_get_current_win()
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(state.win, state.buf)
    state.job = vim.fn.termopen(vim.o.shell)
    vim.cmd("startinsert")
end

--------------------------------------------------------
-- Run
--------------------------------------------------------
---@param cmd string[]
---@param opts? { cwd?: string }
function M.run(cmd, opts)
    opts = opts or {}
    M.open()
    vim.fn.chansend(state.job, "clear\n")
    if opts.cwd then
        -- shellescape, not %q: %q 是 Lua 字符串转义，路径里的 $ 等仍会被 shell 展开
        vim.fn.chansend(state.job, "cd " .. vim.fn.shellescape(opts.cwd) .. "\n")
    end
    -- cmd 是 argv 数组，逐项转义后再拼给交互式 shell
    local escaped = vim.tbl_map(vim.fn.shellescape, cmd)
    vim.fn.chansend(state.job, table.concat(escaped, " ") .. "\n")
    vim.cmd("startinsert")
end

--------------------------------------------------------
-- Toggle
--------------------------------------------------------
function M.toggle()
    if valid() then
        vim.api.nvim_win_close(state.win, true)
        state.win = nil
        return
    end
    M.open()
end

--------------------------------------------------------
-- Close
--------------------------------------------------------
function M.close()
    if valid() then
        vim.api.nvim_win_close(state.win, true)
    end
    state.win = nil
end

return M
