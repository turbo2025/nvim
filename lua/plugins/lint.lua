return {
    {
        "mfussenegger/nvim-lint",

        event = "VeryLazy",

        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                go = { "golangcilint" },
                python = { "ruff" },
            }

            vim.keymap.set("n", "<leader>cl", function()
                lint.try_lint()
            end, {
                desc = "Run Linter",
            })
        end,
    },
}
