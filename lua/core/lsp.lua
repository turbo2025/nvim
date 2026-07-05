--------------------------------------------------------
-- LSP Workflow
--------------------------------------------------------
local group = vim.api.nvim_create_augroup("LspAttach", {
    clear = true,
})
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        local bufnr = args.buf
        local map = function(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, {
                buffer = bufnr,
                silent = true,
                desc = desc,
            })
        end
        --------------------------------------------------------
        -- Navigation
        --------------------------------------------------------
        map("gd", vim.lsp.buf.definition, "Goto Definition")
        map("gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("gr", vim.lsp.buf.references, "Goto References")
        map("gi", vim.lsp.buf.implementation, "Goto Implementation")
        map("gt", vim.lsp.buf.type_definition, "Goto Type Definition")
        --------------------------------------------------------
        -- Hover
        --------------------------------------------------------
        map("K", vim.lsp.buf.hover, "Hover")
        map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
        --------------------------------------------------------
        -- Code
        --------------------------------------------------------
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("<leader>cr", vim.lsp.buf.rename, "Rename")
        map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
        map("<leader>cf", function()
            require("conform").format({
                async = true,
                lsp_format = "fallback",
            })
        end, "Format")
        --------------------------------------------------------
        -- Symbols
        --------------------------------------------------------
        map("<leader>cs", function()
            require("fzf-lua").lsp_document_symbols()
        end, "Document Symbols")
        map("<leader>cw", function()
            require("fzf-lua").lsp_workspace_symbols()
        end, "Workspace Symbols")
        --------------------------------------------------------
        -- Go
        --------------------------------------------------------
        map("<leader>ci", function()
            vim.lsp.buf.code_action({
                apply = true,
                context = {
                    only = {
                        "source.organizeImports",
                    },
                },
            })
        end, "Organize Imports")
        --------------------------------------------------------
        -- Diagnostics
        --------------------------------------------------------
        map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
        --------------------------------------------------------
        -- Inlay Hint (Neovim 0.12)
        --------------------------------------------------------
        if vim.lsp.inlay_hint then
            pcall(vim.lsp.inlay_hint.enable, true, {
                bufnr = bufnr,
            })
        end
    end,
})
