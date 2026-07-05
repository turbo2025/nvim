--------------------------------------------------------
-- Imports
--------------------------------------------------------
local map = vim.keymap.set
local go = require("lang.go.tasks")
local debug = require("lang.go.dap")
--------------------------------------------------------
-- Run
--------------------------------------------------------
map("n", "<leader>rr", go.run, {
    desc = "Go Run",
})
map("n", "<leader>rb", go.build, {
    desc = "Go Build",
})
--------------------------------------------------------
-- Test
--------------------------------------------------------
map("n", "<leader>tt", go.test_package, {
    desc = "Go Test Package",
})
map("n", "<leader>ta", go.test_all, {
    desc = "Go Test All Packages",
})
map("n", "<leader>tf", go.test_function, {
    desc = "Go Test Current Function",
})
map("n", "<leader>tl", go.test_last, {
    desc = "Go Test Last Function",
})
--------------------------------------------------------
-- Benchmark
--------------------------------------------------------
map("n", "<leader>tb", go.benchmark_current, {
    desc = "Go Benchmark Current",
})
map("n", "<leader>tB", go.benchmark_package, {
    desc = "Go Benchmark Package",
})
--------------------------------------------------------
-- Coverage
--------------------------------------------------------
map("n", "<leader>tc", go.coverage, {
    desc = "Go Coverage",
})
--------------------------------------------------------
-- Go Modules
--------------------------------------------------------
map("n", "<leader>mt", go.tidy, {
    desc = "Go Mod Tidy",
})
map("n", "<leader>mg", go.generate, {
    desc = "Go Generate",
})
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
map("n", "<leader>dl", debug.debug_last, {
    desc = "Debug Last",
})
