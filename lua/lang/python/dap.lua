--------------------------------------------------------
-- Python DAP (debugpy)
-- adapter 通过 `uv run --with debugpy` 临时拉起 debugpy，无需在项目里
-- 永久安装；被调试进程运行在同一 uv 环境里，pytest 等依赖直接可用。
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Imports
--------------------------------------------------------
local dap = require("dap")
local util = require("lang.python.utils")
local root = require("core.root")
--------------------------------------------------------
-- Adapter
--------------------------------------------------------
dap.adapters.python = {
    type = "executable",
    command = "uv",
    args = {
        "run",
        "--with",
        "debugpy",
        "python",
        "-m",
        "debugpy.adapter",
    },
}
--------------------------------------------------------
-- Configurations
--------------------------------------------------------
dap.configurations.python = {
    {
        type = "python",
        request = "launch",
        name = "Debug File",
        program = "${file}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        justMyCode = false,
    },
    {
        type = "python",
        request = "launch",
        name = "Debug Test File (pytest)",
        module = "pytest",
        args = { "${file}" },
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        justMyCode = false,
    },
}
--------------------------------------------------------
-- Debug File
--------------------------------------------------------
function M.debug_file()
    dap.run({
        type = "python",
        request = "launch",
        program = util.current_file(),
        cwd = root.python(),
        console = "integratedTerminal",
        justMyCode = false,
    })
end

--------------------------------------------------------
-- Debug Test File
--------------------------------------------------------
function M.debug_test_file()
    dap.run({
        type = "python",
        request = "launch",
        module = "pytest",
        args = { util.current_file() },
        cwd = root.python(),
        console = "integratedTerminal",
        justMyCode = false,
    })
end

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
        type = "python",
        request = "launch",
        module = "pytest",
        args = { util.current_file() .. "::" .. test },
        cwd = root.python(),
        console = "integratedTerminal",
        justMyCode = false,
    })
end

return M
