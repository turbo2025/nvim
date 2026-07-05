local map = vim.keymap.set
local task = require("core.tasks")
--------------------------------------------------------
-- Project
--------------------------------------------------------
map("n", "<leader>pr", function()
    task.run("go:run")
end, {
    desc = "Project Run",
})
map("n", "<leader>pt", function()
    task.run("go:test")
end)
map("n", "<leader>pp", function()
    task.run("proto:generate")
end)
map("n", "<leader>pl", function()
    vim.cmd("LazyGit")
end)
