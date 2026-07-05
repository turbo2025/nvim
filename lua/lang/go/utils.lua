--------------------------------------------------------
-- Go Utilities
--------------------------------------------------------
local M = {}
--------------------------------------------------------
-- Helpers
--------------------------------------------------------
local function current_node()
    return vim.treesitter.get_node()
end
local function find_parent(node, type_name)
    while node do
        if node:type() == type_name then
            return node
        end
        node = node:parent()
    end
end
--------------------------------------------------------
-- Function
--------------------------------------------------------
function M.current_function()
    local node = find_parent(current_node(), "function_declaration")
    if not node then
        return nil
    end
    local name = node:field("name")[1]
    if not name then
        return nil
    end
    return vim.treesitter.get_node_text(name, 0)
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

return M
