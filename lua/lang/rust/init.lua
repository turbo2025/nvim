--------------------------------------------------------
-- Imports
--------------------------------------------------------
local rust = require("lang.rust.tasks")
local debug = require("lang.rust.dap")
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
buf_map("<leader>rr", rust.run, "Cargo Run")
buf_map("<leader>rb", rust.build, "Cargo Build")
buf_map("<leader>rc", rust.check, "Cargo Check")
buf_map("<leader>rC", rust.clippy, "Cargo Clippy")
--------------------------------------------------------
-- Test
--------------------------------------------------------
buf_map("<leader>tt", rust.test_all, "Cargo Test")
buf_map("<leader>tp", rust.test_package, "Cargo Test Lib")
--------------------------------------------------------
-- Debug
--------------------------------------------------------
buf_map("<leader>dd", debug.debug, "Rust Debug (codelldb)")
