return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        build = ":TSUpdate",
        event = {
            "BufReadPost",
            "BufNewFile",
        },
        -- 装的是重写过的 main 分支：M.setup() 现在只认 install_dir，
        -- ensure_installed/highlight/indent/incremental_selection 这些老
        -- 字段全部是死配置（不报错，但什么都不做）。highlight 没生效之前
        -- 一直靠 vim 自带的正则语法高亮在顶替，看着没坏；但 foldexpr 用的
        -- treesitter parser 从来没被 attach 过，所以折叠符号不显示、za 也
        -- 没用。新 API 得自己在 FileType 里手动 start，indent 同理要手动
        -- 接 indentexpr。incremental_selection 这个功能在新版里直接没了，
        -- 真要用得换 nvim-treesitter-textobjects 之类的插件，先不加。
        config = function()
            -- main 分支把大部分语言的 folds.scm/textobjects 等 query 挪进了
            -- 插件自己的 runtime/ 子目录，这个子目录默认不在 runtimepath
            -- 上，nvim 内置的 vim.treesitter.foldexpr() 只吃 &rtp 里能查到
            -- 的 queries/<lang>/folds.scm，nvim 自带 runtime 又只带了
            -- c/lua/markdown/vim/query 这几个语言的 folds.scm，go 完全没有
            -- ——这就是折叠对 lua 有效、对 go 报 "E490: No fold found" 的
            -- 原因。把这个 runtime 目录加进 rtp 补上缺的 folds.scm。
            vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime")

            local ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "go",
                "gomod",
                "gowork",
                "gosum",
                "rust",
                "python",
                "bash",
                "json",
                "yaml",
                "toml",
                "markdown",
                "markdown_inline",
                "proto",
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "scss",
                "vue",
                "svelte",
            }
            require("nvim-treesitter").install(ensure_installed)

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local ok = pcall(vim.treesitter.start, args.buf)
                    if ok then
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                end,
            })
        end,
    },
}
