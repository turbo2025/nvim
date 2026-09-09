local map = vim.keymap.set
local terminal = require("core.terminal")
vim.keymap.set("n", "<leader>ot", terminal.toggle, {
    desc = "Toggle Terminal",
})
--------------------------------------------------------
-- Save / Quit
--------------------------------------------------------
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
--------------------------------------------------------
-- Buffer
--------------------------------------------------------
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
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
--------------------------------------------------------
-- Clear Highlight
--------------------------------------------------------
map("n", "<Esc>", "<cmd>noh<cr>")
