--------------------------------------------------------
-- Imports
--------------------------------------------------------
local runner = require("core.runner")
--------------------------------------------------------
-- State
--------------------------------------------------------
local M = {}
local registry = {}
--------------------------------------------------------
-- Public
--------------------------------------------------------
---@param name string
---@param task table
function M.register(name, task)
    registry[name] = task
end

---@param name string
---@param opts? table
function M.run(name, opts)
    local task = registry[name]
    if not task then
        vim.notify(
            "Unknown task: " .. name,
            vim.log.levels.ERROR
        )
        return
    end
    runner.run(
        task.cmd,
        vim.tbl_deep_extend(
            "force",
            task,
            opts or {}
        )
    )
end

return M
