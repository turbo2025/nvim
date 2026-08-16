--------------------------------------------------------
-- Web (JS/TS/前端) Tasks
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Imports
--------------------------------------------------------
local runner = require("core.runner")
local root = require("core.root")
--------------------------------------------------------
-- Helpers
--------------------------------------------------------
local function package_manager()
    local base = root.node()
    if vim.uv.fs_stat(base .. "/pnpm-lock.yaml") then
        return "pnpm"
    end
    if vim.uv.fs_stat(base .. "/yarn.lock") then
        return "yarn"
    end
    if vim.uv.fs_stat(base .. "/bun.lockb") or vim.uv.fs_stat(base .. "/bun.lock") then
        return "bun"
    end
    return "npm"
end

local function run(cmd)
    runner.run_in(root.node(), cmd)
end

local function run_script(name)
    run({ package_manager(), "run", name })
end
--------------------------------------------------------
-- Tasks
--------------------------------------------------------
function M.install()
    run({ package_manager(), "install" })
end

function M.run_dev()
    run_script("dev")
end

function M.build()
    run_script("build")
end

function M.test()
    run_script("test")
end

function M.lint()
    run_script("lint")
end
--------------------------------------------------------
-- Register Project Tasks
--------------------------------------------------------
local tasks = require("core.tasks")
tasks.register("web:run", M.run_dev)
tasks.register("web:test", M.test)

return M
