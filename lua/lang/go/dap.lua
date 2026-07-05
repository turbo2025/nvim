--------------------------------------------------------
-- Go DAP
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Imports
--------------------------------------------------------
local dap = require("dap")
local util = require("lang.go.utils")
--------------------------------------------------------
-- Adapter
--------------------------------------------------------
dap.adapters.go = {
    type = "server",
    port = "${port}",
    executable = {
        command = "dlv",
        args = {
            "dap",
            "-l",
            "127.0.0.1:${port}",
        },
    },
}
--------------------------------------------------------
-- Configurations
--------------------------------------------------------
dap.configurations.go = {
    {
        type = "go",
        name = "Debug Package",
        request = "launch",
        program = "${fileDirname}",
    },
    {
        type = "go",
        name = "Debug File",
        request = "launch",
        program = "${file}",
    },
    {
        type = "go",
        name = "Debug Test File",
        request = "launch",
        mode = "test",
        program = "${file}",
    },
    {
        type = "go",
        name = "Debug Test Package",
        request = "launch",
        mode = "test",
        program = "${fileDirname}",
    },
}
--------------------------------------------------------
-- Debug Current Test
--------------------------------------------------------
function M.debug_current_test()
    local test = util.current_test()
    if not test then
        vim.notify("No test function found", vim.log.levels.WARN)
        return
    end
    dap.run({
        type = "go",
        request = "launch",
        mode = "test",
        program = util.current_file(),
        args = {
            "-test.run",
            "^" .. test .. "$",
        },
    })
end

--------------------------------------------------------
-- Debug Package
--------------------------------------------------------
function M.debug_package()
    dap.run({
        type = "go",
        request = "launch",
        mode = "debug",
        program = util.current_package(),
    })
end

--------------------------------------------------------
-- Debug Main
--------------------------------------------------------
function M.debug_main()
    if not util.is_main() then
        vim.notify("Current file is not package main", vim.log.levels.WARN)
        return
    end
    dap.run({
        type = "go",
        request = "launch",
        program = util.current_file(),
    })
end

--------------------------------------------------------
-- Debug Last
--------------------------------------------------------
function M.debug_last()
    dap.run_last()
end

return M
