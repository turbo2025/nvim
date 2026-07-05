return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = {
            "BufReadPost",
            "BufNewFile",
        },
        opts = {
            ensure_installed = {
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
            },
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        },
    },
}
