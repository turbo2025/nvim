--------------------------------------------------------
-- Imports
--------------------------------------------------------
local web = require("lang.web.tasks")
local debug = require("lang.web.dap")
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
-- Run / Build
--------------------------------------------------------
buf_map("<leader>rr", web.run_dev, "Run Dev")
buf_map("<leader>rb", web.build, "Build")
--------------------------------------------------------
-- Test / Lint
--------------------------------------------------------
buf_map("<leader>tt", web.test, "Test")
buf_map("<leader>rl", web.lint, "Lint")
--------------------------------------------------------
-- Install
--------------------------------------------------------
buf_map("<leader>ri", web.install, "Install Dependencies")
--------------------------------------------------------
-- Debug
--------------------------------------------------------
buf_map("<leader>df", debug.debug_file, "Debug File (Node)")
buf_map("<leader>ds", debug.debug_script, "Debug npm Script")
buf_map("<leader>dw", debug.debug_chrome, "Debug in Chrome")
