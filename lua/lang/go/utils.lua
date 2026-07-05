--------------------------------------------------------
-- Go Utils
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Treesitter
--------------------------------------------------------
local function get_node()
    return vim.treesitter.get_node()
end
local function find_parent(node, kind)
    while node do
        if node:type() == kind then
            return node
        end
        node = node:parent()
    end
end
local function node_name(node)
    local name = node:field("name")[1]
    if not name then
        return nil
    end
    return vim.treesitter.get_node_text(name, 0)
end
--------------------------------------------------------
-- Function
--------------------------------------------------------
function M.current_function()
    local node = find_parent(get_node(), "function_declaration")
    if not node then
        return nil
    end
    return node_name(node)
end

--------------------------------------------------------
-- Method
--------------------------------------------------------
function M.current_method()
    local node = find_parent(get_node(), "method_declaration")
    if not node then
        return nil
    end
    return node_name(node)
end

--------------------------------------------------------
-- Test
--------------------------------------------------------
function M.current_test()
    local fn = M.current_function()
    if fn and fn:match("^Test") then
        return fn
    end
    return nil
end

--------------------------------------------------------
-- Benchmark
--------------------------------------------------------
function M.current_benchmark()
    local fn = M.current_function()
    if fn and fn:match("^Benchmark") then
        return fn
    end
    return nil
end

--------------------------------------------------------
-- Package
--------------------------------------------------------
function M.current_package()
    return vim.fn.expand("%:p:h")
end

--------------------------------------------------------
-- File
--------------------------------------------------------
function M.current_file()
    return vim.fn.expand("%:p")
end

--------------------------------------------------------
-- Is Main
--------------------------------------------------------
function M.is_main()
    return vim.fn.search("^package main", "nw") > 0
end

--------------------------------------------------------
-- Is Test File
--------------------------------------------------------
function M.is_test_file()
    return vim.fn.expand("%:t"):match("_test%.go$") ~= nil
end

--------------------------------------------------------
-- Is Go File
--------------------------------------------------------
function M.is_go_file()
    return vim.bo.filetype == "go"
end

--------------------------------------------------------
-- Cursor
--------------------------------------------------------
function M.cursor()
    return vim.api.nvim_win_get_cursor(0)
end

return M
