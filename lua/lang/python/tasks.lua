--------------------------------------------------------
-- Python Tasks
-- 使用 uv 作为包管理器/运行器（与 README 工具链一致）。
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Imports
--------------------------------------------------------
local runner = require("core.runner")
local util = require("lang.python.utils")
local root = require("core.root")
--------------------------------------------------------
-- State
--------------------------------------------------------
local last_test = nil
--------------------------------------------------------
-- Helpers
--------------------------------------------------------
local function run(cmd)
    runner.run_in(root.python(), cmd)
end
--------------------------------------------------------
-- Run
--------------------------------------------------------
function M.run_file()
    run({
        "uv",
        "run",
        "python",
        util.current_file(),
    })
end

--------------------------------------------------------
-- Test
--------------------------------------------------------
function M.test_file()
    run({
        "uv",
        "run",
        "pytest",
        util.current_file(),
    })
end

function M.test_all()
    run({
        "uv",
        "run",
        "pytest",
    })
end

function M.test_function()
    local test = util.current_test()
    if not test then
        vim.notify("No test function found", vim.log.levels.WARN)
        return
    end
    last_test = util.current_file() .. "::" .. test
    run({
        "uv",
        "run",
        "pytest",
        last_test,
    })
end

function M.test_last()
    if not last_test then
        vim.notify("No previous test", vim.log.levels.WARN)
        return
    end
    run({
        "uv",
        "run",
        "pytest",
        last_test,
    })
end

--------------------------------------------------------
-- Register Project Tasks
--------------------------------------------------------
local tasks = require("core.tasks")
tasks.register("python:run", M.run_file)
tasks.register("python:test", M.test_all)

return M
