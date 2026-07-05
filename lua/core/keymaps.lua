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
--------------------------------------------------------
-- Clear Highlight
--------------------------------------------------------
map("n", "<Esc>", "<cmd>noh<cr>")
