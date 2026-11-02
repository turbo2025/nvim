--------------------------------------------------------
-- Imports
--------------------------------------------------------
local py = require("lang.python.tasks")
local debug = require("lang.python.dap")
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
-- Indent (PEP8: 4 spaces)
--------------------------------------------------------
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
--------------------------------------------------------
-- Run
--------------------------------------------------------
buf_map("<leader>rr", py.run_file, "Python Run File")
--------------------------------------------------------
-- Test
--------------------------------------------------------
buf_map("<leader>tt", py.test_file, "Python Test File")
buf_map("<leader>ta", py.test_all, "Python Test All")
buf_map("<leader>tf", py.test_function, "Python Test Function")
buf_map("<leader>tl", py.test_last, "Python Test Last")
--------------------------------------------------------
-- Debug
--------------------------------------------------------
buf_map("<leader>df", debug.debug_file, "Debug File")
buf_map("<leader>dT", debug.debug_test_file, "Debug Test File")
buf_map("<leader>dt", debug.debug_current_test, "Debug Current Test")
