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
                -- 给 linter 传项目根，否则 clippy/golangci-lint 会在 nvim 的 cwd
                -- 找不到 Cargo.toml/go.mod，直接以 101 退出。
                local root = vim.fs.root(0, {
                    "Cargo.toml",
                    "go.mod",
                    "go.work",
                    "pyproject.toml",
                    "uv.lock",
                    "poetry.lock",
                    "requirements.txt",
                    "package.json",
                    ".git",
                }) or vim.fn.getcwd()
                lint.try_lint(nil, { cwd = root })
            end, {
                desc = "Run Linter",
            })
        end,
    },
}
