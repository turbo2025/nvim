--------------------------------------------------------
-- Project Root
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Helpers
--------------------------------------------------------
local function find(markers)
    local path = vim.api.nvim_buf_get_name(0)
    local file = vim.fs.find(markers, {
        upward = true,
        path = path,
    })[1]
    if file then
        return vim.fs.dirname(file)
    end
    return vim.uv.cwd()
end
--------------------------------------------------------
-- Languages
--------------------------------------------------------
function M.go()
    return find({
        "go.work",
        "go.mod",
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
        "uv.lock",
        "poetry.lock",
        "requirements.txt",
    })
end

--------------------------------------------------------
-- Git
--------------------------------------------------------
function M.git()
    return find({
        ".git",
    })
end

--------------------------------------------------------
-- Current
--------------------------------------------------------
function M.cwd()
    return vim.uv.cwd()
end

return M
