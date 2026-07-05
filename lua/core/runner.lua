local M = {}
local terminal = require("core.terminal")
function M.run(cmd, opts)
    opts = vim.tbl_deep_extend("force", {
        save = true,
        mode = "terminal",
    }, opts or {})
    if opts.save and vim.bo.modified then
        vim.cmd("write")
    end
    if opts.mode == "terminal" then
        terminal.run(cmd)
        return
    end
    if opts.mode == "background" then
        vim.system(cmd)
        return
    end
    error("Unsupported runner mode: " .. opts.mode)
end

return M
