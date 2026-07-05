--------------------------------------------------------
-- Imports
--------------------------------------------------------

local terminal = require("core.terminal")

--------------------------------------------------------
-- State
--------------------------------------------------------

local M = {}

M.last_cmd = nil

--------------------------------------------------------
-- Public
--------------------------------------------------------

---@param cmd string[]
---@param opts? table
function M.run(cmd, opts)
    opts = vim.tbl_deep_extend("force", {
        save = true,
        mode = "terminal",
        cwd = nil,
    }, opts or {})
    if opts.save and vim.bo.modified then
        vim.cmd("write")
    end
    M.last_cmd = {
        cmd = vim.deepcopy(cmd),
        opts = vim.deepcopy(opts),
    }
    if opts.mode == "terminal" then
        terminal.run(cmd, opts)
        return
    end
    if opts.mode == "background" then
        vim.system(cmd, {
            cwd = opts.cwd,
        })
        return
    end
    error("Unsupported runner mode: " .. opts.mode)
end

function M.run_last()
    if not M.last_cmd then
        vim.notify("No previous command", vim.log.levels.WARN)
        return
    end
    M.run(M.last_cmd.cmd, M.last_cmd.opts)
end

return M
