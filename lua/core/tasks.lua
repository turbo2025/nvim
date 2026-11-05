--------------------------------------------------------
-- Tasks
-- 语言模块通过 `tasks.register("<lang>:<name>", fn)` 注册任务。
-- 当前 buffer-local keymap 直接调用语言模块函数，注册表保留给后续的
-- 全局入口或任务选择器使用。
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
