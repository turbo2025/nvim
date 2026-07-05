return {
    settings = {
        gopls = {
            gofumpt = true,
            staticcheck = true,
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
                unusedparams = true,
                unusedwrite = true,
                nilness = true,
                shadow = true,
            },
        },
    },
}
