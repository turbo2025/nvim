--------------------------------------------------------
-- Imports
--------------------------------------------------------
local dap = require("dap")
local dapui = require("dapui")
--------------------------------------------------------
-- UI
--------------------------------------------------------
dap.listeners.before.attach["dapui"] = function()
    dapui.open()
end
dap.listeners.before.launch["dapui"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui"] = function()
    dapui.close()
end
--------------------------------------------------------
-- Helpers
--------------------------------------------------------
local map = vim.keymap.set
--------------------------------------------------------
-- Debug
--------------------------------------------------------
map("n", "<leader>dc", dap.continue, {
    desc = "Debug Continue",
})
map("n", "<leader>dl", dap.run_last, {
    desc = "Debug Last",
})
--------------------------------------------------------
-- Breakpoints
--------------------------------------------------------
map("n", "<leader>db", dap.toggle_breakpoint, {
    desc = "Toggle Breakpoint",
})
map("n", "<leader>dB", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint Condition: "))
end, {
    desc = "Conditional Breakpoint",
})
map("n", "<leader>dL", function()
    dap.set_breakpoint(nil, nil, vim.fn.input("Log Message: "))
end, {
    desc = "Log Point",
})
--------------------------------------------------------
-- Step
--------------------------------------------------------
map("n", "<leader>do", dap.step_over, {
    desc = "Step Over",
})
map("n", "<leader>di", dap.step_into, {
    desc = "Step Into",
})
map("n", "<leader>dO", dap.step_out, {
    desc = "Step Out",
})
--------------------------------------------------------
-- REPL / UI
--------------------------------------------------------
map("n", "<leader>dr", dap.repl.open, {
    desc = "DAP REPL",
})
map("n", "<leader>du", dapui.toggle, {
    desc = "DAP UI",
})
--------------------------------------------------------
-- Terminate
--------------------------------------------------------
map("n", "<leader>dx", function()
    dap.terminate()
    dapui.close()
end, {
    desc = "Terminate Debug",
})
