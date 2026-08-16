return {
    {
        "mfussenegger/nvim-lint",

        event = "VeryLazy",

        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                go = { "golangcilint" },
                python = { "ruff" },
                rust = { "clippy" },
                javascript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescript = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                vue = { "eslint_d" },
                css = { "stylelint" },
                scss = { "stylelint" },
            }

            vim.keymap.set("n", "<leader>cl", function()
                lint.try_lint()
            end, {
                desc = "Run Linter",
            })
        end,
    },
}
