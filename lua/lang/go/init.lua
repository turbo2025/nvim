--------------------------------------------------------
-- Imports
--------------------------------------------------------
local go = require("lang.go.tasks")
local debug = require("lang.go.dap")
--------------------------------------------------------
-- Helpers
--------------------------------------------------------
local function buf_map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, {
        buffer = 0,
        desc = desc,
    })
end
--------------------------------------------------------
-- Indent (gofmt uses tabs)
--------------------------------------------------------
vim.bo.expandtab = false
--------------------------------------------------------
-- Run
--------------------------------------------------------
buf_map("<leader>rr", go.run, "Go Run")
buf_map("<leader>rb", go.build, "Go Build")
--------------------------------------------------------
-- Test
--------------------------------------------------------
buf_map("<leader>tt", go.test_package, "Go Test Package")
buf_map("<leader>ta", go.test_all, "Go Test All Packages")
buf_map("<leader>tf", go.test_function, "Go Test Current Function")
buf_map("<leader>tl", go.test_last, "Go Test Last Function")
--------------------------------------------------------
-- Benchmark
--------------------------------------------------------
buf_map("<leader>tb", go.benchmark_current, "Go Benchmark Current")
buf_map("<leader>tB", go.benchmark_package, "Go Benchmark Package")
--------------------------------------------------------
-- Coverage
--------------------------------------------------------
buf_map("<leader>tc", go.coverage, "Go Coverage")
--------------------------------------------------------
-- Go Modules
--------------------------------------------------------
buf_map("<leader>mt", go.tidy, "Go Mod Tidy")
buf_map("<leader>mg", go.generate, "Go Generate")
--------------------------------------------------------
-- Organize Imports
--------------------------------------------------------
buf_map("<leader>ci", function()
    vim.lsp.buf.code_action({
        apply = true,
        context = {
            only = {
                "source.organizeImports",
            },
        },
    })
end, "Organize Imports")
--------------------------------------------------------
-- Debug
--------------------------------------------------------
buf_map("<leader>dt", debug.debug_current_test, "Debug Current Test")
buf_map("<leader>dp", debug.debug_package, "Debug Package")
buf_map("<leader>dm", debug.debug_main, "Debug Main")
