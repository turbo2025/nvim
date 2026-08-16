--------------------------------------------------------
-- Language Modules
-- 按 filetype 惰性加载 `lang.<lang>` 模块，避免无关语言的 keymap /
-- DAP 配置污染所有 buffer。新增语言时在此处加一行映射即可。
--------------------------------------------------------
local group = vim.api.nvim_create_augroup("Langs", { clear = true })

local langs = {
    go = "lang.go",
    rust = "lang.rust",
    --------------------------------------------------------
    -- Web
    --------------------------------------------------------
    javascript = "lang.web",
    javascriptreact = "lang.web",
    typescript = "lang.web",
    typescriptreact = "lang.web",
    vue = "lang.web",
    svelte = "lang.web",
    html = "lang.web",
    css = "lang.web",
    scss = "lang.web",
}

for ft, mod in pairs(langs) do
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = ft,
        callback = function()
            require(mod)
        end,
    })
end
