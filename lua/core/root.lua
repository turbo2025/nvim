--------------------------------------------------------
-- Imports
--------------------------------------------------------
local uv = vim.uv
--------------------------------------------------------
-- State
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Public
--------------------------------------------------------
local function find(pattern)
    local file = vim.fs.find(pattern, {
        upward = true,
        path = vim.api.nvim_buf_get_name(0),
    })[1]
    if file then
        return vim.fs.dirname(file)
    end
    return vim.loop.cwd()
end

function M.go()
    return find({
        "go.mod",
        "go.work",
    })
end

function M.rust()
    return find({
        "Cargo.toml",
    })
end

function M.python()
    return find({
        "pyproject.toml",
        "requirements.txt",
        ".venv",
    })
end

function M.git()
    return M.find({
        ".git",
    })
end

return M
