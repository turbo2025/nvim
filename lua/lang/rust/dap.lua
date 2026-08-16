--------------------------------------------------------
-- Rust DAP (codelldb)
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Imports
--------------------------------------------------------
local dap = require("dap")
--------------------------------------------------------
-- Adapter
--------------------------------------------------------
dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = "codelldb",
        args = {
            "--port",
            "${port}",
        },
    },
}
--------------------------------------------------------
-- Configurations
--------------------------------------------------------
dap.configurations.rust = {
    {
        name = "Rust Launch",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "/target/debug/",
                "file"
            )
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    },
}
--------------------------------------------------------
-- Debug
--------------------------------------------------------
function M.debug()
    dap.run({
        type = "codelldb",
        request = "launch",
        name = "Rust Launch",
        program = function()
            return vim.fn.input(
                "Path to executable: ",
                vim.fn.getcwd() .. "/target/debug/",
                "file"
            )
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    })
end

return M
