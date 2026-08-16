--------------------------------------------------------
-- Tasks
-- 语言模块通过 `tasks.register("<lang>:<name>", fn)` 注册任务，
-- `core.project` 等按 filetype 分发到这些任务。
--------------------------------------------------------
local M = {}
local registry = {}
--------------------------------------------------------
-- Public
--------------------------------------------------------
---@param name string
---@param fn fun(opts?: table)
function M.register(name, fn)
    registry[name] = fn
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
    task(opts)
end

return M
