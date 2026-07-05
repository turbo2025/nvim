vim.o.winborder = "rounded"

vim.diagnostic.config({
    virtual_text = false,
    underline = true,
    severity_sort = true,
    update_in_insert = false,

    float = {
        border = "rounded",
        source = "if_many",
    },
})

vim.api.nvim_set_hl(0, "MatchParen", {
    bold = true,
    underline = true,
})
