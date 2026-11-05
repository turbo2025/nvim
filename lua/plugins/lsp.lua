return {
    {
        "mason-org/mason.nvim",
        lazy = false,
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        config = function()
            --------------------------------------------------------
            -- Capabilities: workspace/willRenameFiles (snacks.rename sync)
            -- + blink.cmp's own capabilities. blink.cmp was never wired
            -- into any server's capabilities before, which it needs for
            -- completion/signature-help related extensions to work fully.
            --------------------------------------------------------
            vim.lsp.config("*", {
                capabilities = vim.tbl_deep_extend("force", {
                    workspace = {
                        fileOperations = {
                            willRename = true,
                            didRename = true,
                        },
                    },
                }, require("blink.cmp").get_lsp_capabilities()),
            })
            --------------------------------------------------------
            -- Server Config
            --------------------------------------------------------
            vim.lsp.config("lua_ls", require("lsp.lua_ls"))
            vim.lsp.config("gopls", require("lsp.gopls"))
            vim.lsp.config(
                "rust_analyzer",
                require("lsp.rust_analyzer")
            )
            vim.lsp.config(
                "basedpyright",
                require("lsp.basedpyright")
            )
            vim.lsp.config("ts_ls", require("lsp.ts_ls"))
            --------------------------------------------------------
            -- Enable
            --------------------------------------------------------
            local servers = {
                "lua_ls",
                "gopls",
                "rust_analyzer",
                "basedpyright",
                "ts_ls",
                "vue_ls",
            }
            -- 这些 server 来自 vscode-langservers-extracted；未安装时跳过，
            -- 避免每次打开 html/css/js 都报 Spawning language server failed。
            local optional = {
                eslint = "vscode-eslint-language-server",
                html = "vscode-html-language-server",
                cssls = "vscode-css-language-server",
                svelte = "svelteserver",
            }
            local project_root = vim.fs.root(0, { "package.json", ".git" })
                or vim.fs.root(vim.fn.getcwd(), { "package.json", ".git" })
            local function available(cmd)
                if vim.fn.executable(cmd) == 1 then
                    return true
                end
                return project_root ~= nil
                    and vim.fn.executable(
                        project_root .. "/node_modules/.bin/" .. cmd
                    ) == 1
            end
            for name, cmd in pairs(optional) do
                if available(cmd) then
                    table.insert(servers, name)
                end
            end
            -- Vue 的 <script lang="ts"> 需要 vtsls + @vue/typescript-plugin；
            -- vtsls 只处理 vue buffer，TS/React 仍由 ts_ls 负责，避免双 LSP。
            local vue_server = vim.fn.exepath("vue-language-server")
            local vue_candidates = {}
            if vue_server ~= "" then
                local root = vim.fn.fnamemodify(
                    vim.fn.resolve(vue_server),
                    ":h:h"
                )
                vim.list_extend(vue_candidates, {
                    -- Nix: vue-language-server 自带 typescript-plugin
                    root .. "/lib/language-tools/packages/typescript-plugin",
                    -- npm 全局安装：root 通常就是 @vue/language-server
                    root,
                    root .. "/lib/node_modules/@vue/language-server",
                    root .. "/lib/node_modules/@vue/typescript-plugin",
                    -- npm 项目本地安装
                    root .. "/node_modules/@vue/language-server",
                    root .. "/node_modules/@vue/typescript-plugin",
                })
            end
            if project_root then
                vim.list_extend(vue_candidates, {
                    project_root .. "/node_modules/@vue/language-server",
                    project_root .. "/node_modules/@vue/typescript-plugin",
                })
            end
            vim.list_extend(vue_candidates, {
                -- mason
                vim.fn.stdpath("data")
                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                vim.fn.stdpath("data")
                    .. "/mason/packages/vue-language-server/node_modules/@vue/typescript-plugin",
            })
            local vue_plugin = nil
            for _, candidate in ipairs(vue_candidates) do
                if vim.fn.isdirectory(candidate) == 1 then
                    vue_plugin = candidate
                    break
                end
            end
            if vim.fn.executable("vtsls") == 1 and vue_plugin then
                vim.lsp.config("vtsls", {
                    filetypes = { "vue" },
                    settings = {
                        vtsls = {
                            tsserver = {
                                globalPlugins = {
                                    {
                                        name = "@vue/typescript-plugin",
                                        location = vue_plugin,
                                        languages = { "vue" },
                                        configNamespace = "typescript",
                                    },
                                },
                            },
                        },
                    },
                })
                table.insert(servers, "vtsls")
            end
            vim.lsp.enable(servers)
        end,
    },
}
