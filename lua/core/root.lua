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

---@param markers string[]
---@param start? string
---@return string
function M.find(markers, start)
    start = start or vim.api.nvim_buf_get_name(0)
    local dir = vim.fs.dirname(start)
    local result = vim.fs.find(markers, {
        upward = true,
        path = dir,
    })[1]
    if result then
        return vim.fs.dirname(result)
    end
    return uv.cwd()
end

function M.go()
    return M.find({
        "go.mod",
        "go.work",
    })
end

function M.rust()
    return M.find({
        "Cargo.toml",
    })
end

function M.python()
    return M.find({
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
