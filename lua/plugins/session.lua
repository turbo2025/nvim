return {
    {
        "folke/persistence.nvim",
        event = { "BufReadPre", "VimEnter" },
        config = function(_, opts)
            -- 装的这版 persistence.nvim 已经不认 opts.options 这个字段了
            -- （源码里根本没有处理它的代码，之前那份配置是死配置，白写），
            -- sessionoptions 得自己设。必须带上 "globals"，不然
            -- g:SnacksExplorerWasOpen 这种标记压根不会被 :mksession 写进
            -- 会话文件，下面重新打开 explorer 的逻辑就永远读不到它。
            vim.opt.sessionoptions = {
                "buffers",
                "curdir",
                "tabpages",
                "winsize",
                "help",
                "globals",
                "skiprtp",
                "folds",
            }
            require("persistence").setup(opts)
            -- 无参数启动（比如重启 nvim）自动恢复当前目录上次的会话
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    if vim.fn.argc() == 0 then
                        require("persistence").load()
                    end
                end,
                nested = true,
            })

            -- snacks.explorer 的 input/list/preview 子窗口是无名 scratch
            -- buffer，:mksession 遇到没有文件名的窗口只能落成一句孤零零的
            -- `enew`，恢复时就是空白 "[No Name]"（preview 子窗口预览的是什么
            -- 语言，这个空 buffer 的 filetype 就会被顺带设成那个语言，比如
            -- "go"）。翻源码发现 explorer 内部各子窗口的字段结构并不统一
            -- （比如 preview.win 在没渲染过内容时压根没有 win 句柄），没法
            -- 可靠地从 picker 对象上一个个抠出真实窗口句柄，所以换个不依赖
            -- snacks 内部实现的通用做法：存会话前扫一遍所有窗口，凡是"无
            -- 名字 + scratch(buftype=nofile) + 没有未保存改动"的窗口一律
            -- 同步关掉（只要不是最后一个窗口）。已经用真实场景验证过：加了
            -- 这段之后 mksession 生成的文件里不会再出现孤立的 `enew`。
            vim.api.nvim_create_autocmd("User", {
                pattern = "PersistenceSavePre",
                callback = function()
                    local explorer = Snacks.picker.get({ source = "explorer" })[1]
                    vim.g.SnacksExplorerWasOpen = explorer and 1 or 0
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        if #vim.api.nvim_list_wins() <= 1 then
                            break
                        end
                        local buf = vim.api.nvim_win_get_buf(win)
                        local scratchy = vim.api.nvim_buf_get_name(buf) == ""
                            and vim.bo[buf].buftype == "nofile"
                            and not vim.bo[buf].modified
                        if scratchy then
                            pcall(vim.api.nvim_win_close, win, true)
                        end
                    end
                end,
            })
            vim.api.nvim_create_autocmd("User", {
                pattern = "PersistenceLoadPost",
                callback = function()
                    if vim.g.SnacksExplorerWasOpen == 1 then
                        vim.schedule(function()
                            Snacks.explorer()
                        end)
                    end
                end,
            })
        end,
        keys = {
            {
                "<leader>qs",
                function()
                    require("persistence").load()
                end,
                desc = "Restore Session",
            },
            {
                "<leader>ql",
                function()
                    require("persistence").load({ last = true })
                end,
                desc = "Restore Last Session",
            },
            {
                "<leader>qd",
                function()
                    require("persistence").stop()
                end,
                desc = "Don't Save Current Session",
            },
        },
    },
}
