return {
    -- 不依赖 `go env`：当前环境没有 go 时，nvim-lspconfig 的默认
    -- root_dir 会调用 go 并抛 ENOENT，这里改用文件标记定位项目根。
    root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, {
            "go.work",
            "go.mod",
            ".git",
        })
        if root then
            on_dir(root)
        end
    end,
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            completeUnimported = true,
            usePlaceholders = true,
            renameMovesSubpackages = true,
            analyses = {
                unusedparams = true,
                unusedwrite = true,
                nilness = true,
                shadow = true,
            },
        },
    },
}
