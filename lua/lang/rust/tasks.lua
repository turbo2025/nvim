--------------------------------------------------------
-- Rust Tasks
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
local function run(cmd)
    runner.run_in(root.rust(), cmd)
end
--------------------------------------------------------
-- Run / Build
--------------------------------------------------------
function M.run()
    run({ "cargo", "run" })
end

function M.build()
    run({ "cargo", "build" })
end

function M.check()
    run({ "cargo", "check" })
end

function M.clippy()
    run({ "cargo", "clippy", "--all-targets", "--all-features" })
end
--------------------------------------------------------
-- Test
--------------------------------------------------------
function M.test_all()
    run({ "cargo", "test" })
end

function M.test_package()
    run({ "cargo", "test", "--lib" })
end
--------------------------------------------------------
-- Register Project Tasks
--------------------------------------------------------
local tasks = require("core.tasks")
tasks.register("rust:run", M.run)
tasks.register("rust:test", M.test_all)

return M
