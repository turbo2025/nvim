local map = vim.keymap.set
--------------------------------------------------------
-- Navigation
--------------------------------------------------------
map("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
map("n", "gt", vim.lsp.buf.type_definition, { desc = "Type Definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "<C-k>", vim.lsp.buf.signature_help, {
    desc = "Signature Help",
})
--------------------------------------------------------
-- Code
--------------------------------------------------------
map("n", "<leader>cs", function()
    require("fzf-lua").lsp_document_symbols()
end, {
    desc = "Document Symbols",
})

map("n", "<leader>cw", function()
    require("fzf-lua").lsp_workspace_symbols()
end, {
    desc = "Workspace Symbols",
})
map("n", "<leader>ca", vim.lsp.buf.code_action, {
    desc = "Code Action",
})
map("n", "<leader>cr", vim.lsp.buf.rename, {
    desc = "Rename",
})
map("n", "<leader>cf", function()
    require("conform").format({
        async = true,
        lsp_format = "fallback",
    })
end, {
    desc = "Format",
})
map("n", "<leader>cd", vim.diagnostic.open_float, {
    desc = "Line Diagnostics",
})
map("n", "<leader>ci", function()
    vim.lsp.buf.code_action({
        apply = true,
        context = {
            only = {
                "source.organizeImports",
            },
        },
    })
end, {
    desc = "Organize Imports",
})
--------------------------------------------------------
-- Diagnostics
--------------------------------------------------------
map("n", "[d", vim.diagnostic.goto_prev, {
    desc = "Previous Diagnostic",
})
map("n", "]d", vim.diagnostic.goto_next, {
    desc = "Next Diagnostic",
})
