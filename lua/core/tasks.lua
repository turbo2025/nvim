local M = {}
local runner = require("core.runner")
---@class Task
---@field cmd string[]
---@field save? boolean
---@field mode? "terminal"|"quickfix"|"background"
local tasks = {
    ----------------------------------------------------------------------
    -- Go
    ----------------------------------------------------------------------
    ["go:run"] = {
        cmd = { "go", "run", "." },
    },
    ["go:build"] = {
        cmd = { "go", "build", "./..." },
    },
    ["go:test"] = {
        cmd = { "go", "test", "./..." },
    },
    ["go:bench"] = {
        cmd = { "go", "test", "-bench", "." },
    },
    ["go:coverage"] = {
        cmd = {
            "go",
            "test",
            "-coverprofile=coverage.out",
            "./...",
        },
    },
    ["go:tidy"] = {
        cmd = { "go", "mod", "tidy" },
    },
    ["go:generate"] = {
        cmd = { "go", "generate", "./..." },
    },
    ----------------------------------------------------------------------
    -- Rust
    ----------------------------------------------------------------------
    ["rust:build"] = {
        cmd = { "cargo", "build" },
    },
    ["rust:test"] = {
        cmd = { "cargo", "test" },
    },
    ["rust:check"] = {
        cmd = { "cargo", "check" },
    },
    ["rust:clippy"] = {
        cmd = { "cargo", "clippy" },
    },
    ----------------------------------------------------------------------
    -- Python
    ----------------------------------------------------------------------
    ["python:test"] = {
        cmd = { "pytest" },
    },
    ["python:ruff"] = {
        cmd = { "ruff", "check", "." },
    },
    ["python:format"] = {
        cmd = { "ruff", "format", "." },
    },
    ----------------------------------------------------------------------
    -- Proto
    ----------------------------------------------------------------------
    ["proto:generate"] = {
        cmd = { "buf", "generate" },
    },
    ["proto:lint"] = {
        cmd = { "buf", "lint" },
    },
    ----------------------------------------------------------------------
    -- Docker
    ----------------------------------------------------------------------
    ["docker:up"] = {
        cmd = { "docker", "compose", "up" },
    },
    ["docker:down"] = {
        cmd = { "docker", "compose", "down" },
    },
    ----------------------------------------------------------------------
    -- AI
    ----------------------------------------------------------------------
    ["claude"] = {
        cmd = { "claude" },
    },
}
---@param name string
---@param opts? table
function M.run(name, opts)
    local task = tasks[name]
    if not task then
        vim.notify("Unknown task: " .. name, vim.log.levels.ERROR)
        return
    end
    opts = vim.tbl_deep_extend("force", {
        save = true,
        mode = "terminal",
    }, opts or {})
    runner.run(task.cmd, opts)
end

function M.register(name, task)
    tasks[name] = task
end

function M.list()
    return vim.tbl_keys(tasks)
end

function M.get(name)
    return tasks[name]
end

return M
