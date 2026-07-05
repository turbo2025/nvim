local M = {}
local state = {
    buf = nil,
    win = nil,
    job = nil,
    height = 15,
}
local function valid()
    return state.buf
        and vim.api.nvim_buf_is_valid(state.buf)
        and state.win
        and vim.api.nvim_win_is_valid(state.win)
end
function M.open()
    if valid() then
        vim.api.nvim_set_current_win(state.win)
        vim.cmd("startinsert")
        return
    end
    vim.cmd("botright " .. state.height .. "split")
    vim.cmd("terminal")
    state.buf = vim.api.nvim_get_current_buf()
    state.win = vim.api.nvim_get_current_win()
    state.job = vim.b.terminal_job_id
    vim.cmd("startinsert")
end

function M.close()
    if valid() then
        vim.api.nvim_win_close(state.win, true)
        state.win = nil
    end
end

function M.toggle()
    if valid() then
        M.close()
    else
        M.open()
    end
end

function M.run(cmd)
    M.open()
    vim.fn.chansend(state.job, "clear\n")
    vim.fn.chansend(state.job, table.concat(cmd, " ") .. "\n")
    vim.cmd("startinsert")
end

return M
