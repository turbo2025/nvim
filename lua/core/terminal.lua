--------------------------------------------------------
-- State
--------------------------------------------------------

local M = {}

local state = {
    win = nil,
    buf = nil,
    height = 15,
}

--------------------------------------------------------
-- Private
--------------------------------------------------------

local function open_window()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_set_current_win(state.win)
        return
    end
    vim.cmd("botright " .. state.height .. "split")
    state.win = vim.api.nvim_get_current_win()
end

--------------------------------------------------------
-- Public
--------------------------------------------------------

---@param cmd string[]
---@param opts? { cwd?: string }
function M.run(cmd, opts)
    opts = opts or {}
    open_window()
    -- 每次重新创建 terminal buffer，保证环境干净
    vim.cmd("enew")
    state.buf = vim.api.nvim_get_current_buf()
    vim.fn.termopen(cmd, {
        cwd = opts.cwd,
    })
    vim.cmd("startinsert")
end

function M.close()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
        state.win = nil
        state.buf = nil
    end
end

function M.toggle()
    if state.win and vim.api.nvim_win_is_valid(state.win) then
        M.close()
    else
        open_window()
    end
end

return M
