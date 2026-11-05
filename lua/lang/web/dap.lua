--------------------------------------------------------
-- Web DAP (vscode-js-debug)
-- 一个 js-debug-adapter（mason 安装）同时提供 pwa-node（Node/TS
-- 进程）和 pwa-chrome（浏览器）两种调试类型。
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Imports
--------------------------------------------------------
local dap = require("dap")
local root = require("core.root")
--------------------------------------------------------
-- Adapter
--------------------------------------------------------
local js_debug = vim.fn.exepath("js-debug-adapter")
if js_debug == "" then
    js_debug = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter"
end

local function make_adapter()
    return {
        type = "server",
        host = "127.0.0.1",
        port = "${port}",
        executable = {
            command = js_debug,
            args = { "${port}" },
        },
    }
end

if vim.fn.executable(js_debug) == 0 then
    vim.notify(
        "js-debug-adapter 未安装，请执行 :MasonInstall js-debug-adapter",
        vim.log.levels.WARN
    )
end

dap.adapters["pwa-node"] = make_adapter()
dap.adapters["pwa-chrome"] = make_adapter()
--------------------------------------------------------
-- Configurations
--------------------------------------------------------
local configs = {
    {
        type = "pwa-node",
        request = "launch",
        name = "Debug File (Node)",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
    },
    {
        type = "pwa-node",
        request = "launch",
        name = "Debug npm Script",
        runtimeExecutable = "npm",
        runtimeArgs = { "run", "dev" },
        cwd = "${workspaceFolder}",
        sourceMaps = true,
    },
    {
        type = "pwa-chrome",
        request = "launch",
        name = "Debug in Chrome",
        url = "http://localhost:3000",
        webRoot = "${workspaceFolder}",
    },
}

for _, ft in ipairs({
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
}) do
    dap.configurations[ft] = configs
end
--------------------------------------------------------
-- Debug File
--------------------------------------------------------
function M.debug_file()
    dap.run({
        type = "pwa-node",
        request = "launch",
        program = vim.fn.expand("%:p"),
        cwd = root.node(),
        sourceMaps = true,
    })
end

--------------------------------------------------------
-- Debug npm Script
--------------------------------------------------------
function M.debug_script()
    local name = vim.fn.input("npm script: ", "dev")
    if name == "" then
        return
    end
    dap.run({
        type = "pwa-node",
        request = "launch",
        runtimeExecutable = "npm",
        runtimeArgs = { "run", name },
        cwd = root.node(),
        sourceMaps = true,
    })
end

--------------------------------------------------------
-- Debug Chrome
--------------------------------------------------------
function M.debug_chrome()
    local url = vim.fn.input("URL: ", "http://localhost:3000")
    if url == "" then
        return
    end
    dap.run({
        type = "pwa-chrome",
        request = "launch",
        url = url,
        webRoot = root.node(),
    })
end

return M
