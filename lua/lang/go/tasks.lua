--------------------------------------------------------
-- Go Tasks
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Imports
--------------------------------------------------------
local runner = require("core.runner")
local util = require("lang.go.utils")
local root = require("core.root")
--------------------------------------------------------
-- State
--------------------------------------------------------
local last_test = nil
--------------------------------------------------------
-- Helpers
--------------------------------------------------------
local function run(cmd)
    runner.run(cmd, {
        cwd = root.go(),
    })
end
--------------------------------------------------------
-- Run
--------------------------------------------------------
function M.run()
    run({
        "go",
        "run",
        ".",
    })
end

function M.build()
    run({
        "go",
        "build",
        "./...",
    })
end

--------------------------------------------------------
-- Test
--------------------------------------------------------
function M.test_package()
    run({
        "go",
        "test",
        ".",
    })
end

function M.test_all()
    run({
        "go",
        "test",
        "./...",
    })
end

function M.test_function()
    local test = util.current_test()
    if not test then
        vim.notify("No test function found", vim.log.levels.WARN)
        return
    end
    last_test = test
    run({
        "go",
        "test",
        "-run",
        "^" .. test .. "$",
    })
end

function M.test_last()
    if not last_test then
        vim.notify("No previous test", vim.log.levels.WARN)
        return
    end
    run({
        "go",
        "test",
        "-run",
        "^" .. last_test .. "$",
    })
end

--------------------------------------------------------
-- Benchmark
--------------------------------------------------------
function M.benchmark_current()
    local bench = util.current_benchmark()
    if not bench then
        vim.notify("No benchmark function found", vim.log.levels.WARN)
        return
    end
    run({
        "go",
        "test",
        "-bench",
        "^" .. bench .. "$",
    })
end

function M.benchmark_package()
    run({
        "go",
        "test",
        "-bench",
        ".",
    })
end

--------------------------------------------------------
-- Coverage
--------------------------------------------------------
function M.coverage()
    run({
        "go",
        "test",
        "-coverprofile=coverage.out",
        ".",
    })
end

--------------------------------------------------------
-- Go Mod
--------------------------------------------------------
function M.tidy()
    run({
        "go",
        "mod",
        "tidy",
    })
end

function M.generate()
    run({
        "go",
        "generate",
        "./...",
    })
end

return M
