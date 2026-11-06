local map = vim.keymap.set
local terminal = require("core.terminal")
vim.keymap.set("n", "<leader>ot", terminal.toggle, {
    desc = "Toggle Terminal",
})
--------------------------------------------------------
-- Save / Quit
--------------------------------------------------------
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>W", "<cmd>wa<cr>", { desc = "Write All" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
--------------------------------------------------------
-- Buffer
--------------------------------------------------------
-- 原生 :bdelete 删掉 buffer 后，如果它是唯一显示的普通 buffer，
-- Neovim 会顺手关掉承载它的窗口；剩下的 snacks explorer 侧栏失去了
-- 可以跳回的窗口，布局随之崩掉，表现为“关文件把左边的文件浏览器也关了”。
-- Snacks.bufdelete 会先把窗口切到另一个 listed buffer，再删 buffer，
-- 窗口和侧栏都能保住。
map("n", "<leader>bd", function()
    local buf = vim.api.nvim_get_current_buf()
    -- 焦点在 explorer / picker 里时，当前 buffer 是侧栏自己的
    -- scratch buffer（buflisted=false），删了就等于关掉侧栏。
    if not vim.bo[buf].buflisted or vim.bo[buf].buftype ~= "" then
        vim.notify("Not a file buffer", vim.log.levels.WARN)
        return
    end
    require("snacks").bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close Other Buffers" })
map("n", "<leader>bD", function()
    require("snacks").bufdelete.all()
end, { desc = "Close All Buffers" })
map("n", "<leader>bp", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path)
end, { desc = "Copy Absolute Path" })
map("n", "<leader>bP", function()
    local path = vim.fn.expand("%:.")
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path)
end, { desc = "Copy Relative Path" })
--------------------------------------------------------
-- Window
--------------------------------------------------------
map("n", "<leader>wh", "<C-w>h")
map("n", "<leader>wj", "<C-w>j")
map("n", "<leader>wk", "<C-w>k")
map("n", "<leader>wl", "<C-w>l")
-- 垂直，水平分屏以及关闭
map("n", "<leader>w|", "<cmd>vsplit<cr>", { desc = "Split Vertical" })
map("n", "<leader>w-", "<cmd>split<cr>", { desc = "Split Horizontal" })
map("n", "<leader>wc", "<cmd>close<cr>", { desc = "Close Window" })
--------------------------------------------------------
-- Tabpage
--------------------------------------------------------
map("n", "[t", "<cmd>tabprevious<cr>", { desc = "Prev Tab" })
map("n", "]t", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader>Tn", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader>Tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader>To", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
--------------------------------------------------------
-- Movement (screen line, not logical line — matters with wrap)
-- keeps relativenumber counts (5j/3k) jumping by logical line
--------------------------------------------------------
map({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
--------------------------------------------------------
-- Clear Highlight
--------------------------------------------------------
map("n", "<Esc>", "<cmd>noh<cr>")
