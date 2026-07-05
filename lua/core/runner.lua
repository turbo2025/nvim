--------------------------------------------------------
-- Runner
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Imports
--------------------------------------------------------
local terminal = require("core.terminal")
--------------------------------------------------------
-- State
--------------------------------------------------------
M.last = nil
--------------------------------------------------------
-- Run
--------------------------------------------------------
---@param cmd string[]
---@param opts? {
---    save?: boolean,
---    mode?: "terminal"|"background",
---    cwd?: string,
---}
function M.run(cmd, opts)
    opts = vim.tbl_deep_extend("force", {
        save = true,
        mode = "terminal",
        cwd = nil,
    }, opts or {})
    if opts.save and vim.bo.modified then
        vim.cmd("write")
    end
    M.last = {
        cmd = vim.deepcopy(cmd),
        opts = vim.deepcopy(opts),
    }
    if opts.mode == "terminal" then
        terminal.run(cmd, {
            cwd = opts.cwd,
        })
        return
    end
    if opts.mode == "background" then
        vim.system(cmd, {
            cwd = opts.cwd,
            detach = true,
        })
        return
    end
    error("Unsupported runner mode: " .. tostring(opts.mode))
end

--------------------------------------------------------
-- Run Last
--------------------------------------------------------
function M.run_last()
    if not M.last then
        vim.notify("No previous command", vim.log.levels.WARN)
        return
    end
    M.run(M.last.cmd, M.last.opts)
end

return M
