--------------------------------------------------------
-- Python Utils
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
-- 方法（class 内的 def）在 treesitter 里同样是 function_definition，
-- 所以 current_function 对模块级函数和类方法都适用。
--------------------------------------------------------
function M.current_function()
    local node = find_parent(get_node(), "function_definition")
    if not node then
        return nil
    end
    return node_name(node)
end

--------------------------------------------------------
-- Class
--------------------------------------------------------
function M.current_class()
    local node = find_parent(get_node(), "class_definition")
    if not node then
        return nil
    end
    return node_name(node)
end

--------------------------------------------------------
-- Test (pytest 约定：test_ 前缀)
-- 类内测试方法返回 "ClassName::method"，否则返回 "method"；
-- 这样拼接出的 `file::ClassName::method` 才是 pytest 完整 nodeid。
--------------------------------------------------------
function M.current_test()
    local fn = M.current_function()
    if not fn or not fn:match("^test_") then
        return nil
    end
    local cls = M.current_class()
    if cls then
        return cls .. "::" .. fn
    end
    return fn
end

--------------------------------------------------------
-- File
--------------------------------------------------------
function M.current_file()
    return vim.fn.expand("%:p")
end

return M
