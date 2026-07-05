local map = vim.keymap.set
local task = require("core.tasks")
local util = require("lang.go.utils")
require("lang.go.tasks")
local debug = require("lang.go.dap")
--------------------------------------------------------
-- Run
--------------------------------------------------------
map("n", "<leader>rr", function()
    task.run("go:run")
end, { desc = "Go Run" })
map("n", "<leader>rb", function()
    task.run("go:build")
end, { desc = "Go Build" })
--------------------------------------------------------
-- Test
--------------------------------------------------------
map("n", "<leader>tt", function()
    task.run("go:test")
end, { desc = "Go Test Package" })
map("n", "<leader>ta", function()
    task.run("go:test-all")
end, { desc = "Go Test All Packages" })
map("n", "<leader>tf", util.run_test, {
    desc = "Go Test Function",
})
map("n", "<leader>tl", util.run_last_test, {
    desc = "Go Test Last",
})
--------------------------------------------------------
-- Benchmark
--------------------------------------------------------
map("n", "<leader>tb", util.run_benchmark, {
    desc = "Go Benchmark",
})
--------------------------------------------------------
-- Coverage
--------------------------------------------------------
map("n", "<leader>tc", util.coverage, {
    desc = "Go Coverage",
})
--------------------------------------------------------
-- Mod
--------------------------------------------------------
map("n", "<leader>mt", function()
    task.run("go:tidy")
end, { desc = "Go Mod Tidy" })
map("n", "<leader>mg", function()
    task.run("go:generate")
end, { desc = "Go Generate" })
--------------------------------------------------------
-- Debug
--------------------------------------------------------
map("n", "<leader>dt", debug.debug_current_test, {
    desc = "Debug Current Test",
})
map("n", "<leader>dp", debug.debug_package, {
    desc = "Debug Package",
})
map("n", "<leader>dm", debug.debug_main, {
    desc = "Debug Main",
})
