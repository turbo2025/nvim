local map = vim.keymap.set
local task = require("core.tasks")
--------------------------------------------------------
-- Filetype -> Task Name
-- 语言模块在各自 `lang/<lang>/tasks.lua` 里注册这些任务名。
--------------------------------------------------------
local filetype_tasks = {
    go = { run = "go:run", test = "go:test" },
    rust = { run = "rust:run", test = "rust:test" },
    javascript = { run = "web:run", test = "web:test" },
    javascriptreact = { run = "web:run", test = "web:test" },
    typescript = { run = "web:run", test = "web:test" },
    typescriptreact = { run = "web:run", test = "web:test" },
    vue = { run = "web:run", test = "web:test" },
    svelte = { run = "web:run", test = "web:test" },
}
--------------------------------------------------------
-- Project
--------------------------------------------------------
local function run_for(key)
    return function()
        local entry = filetype_tasks[vim.bo.filetype]
        if not entry or not entry[key] then
            vim.notify(
                "No " .. key .. " task for filetype: " .. vim.bo.filetype,
                vim.log.levels.WARN
            )
            return
        end
        task.run(entry[key])
    end
end

map("n", "<leader>pr", run_for("run"), {
    desc = "Project Run",
})
map("n", "<leader>pt", run_for("test"), {
    desc = "Project Test",
})
map("n", "<leader>pl", function()
    vim.cmd("LazyGit")
end, {
    desc = "LazyGit",
})
