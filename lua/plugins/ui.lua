return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.add({
				{ "<leader>a", group = "AI" },
				{ "<leader>b", group = "Buffer" },
				{ "<leader>c", group = "Code" },
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>s", group = "Search" },
				{ "<leader>t", group = "Toggle" },
				{ "<leader>w", group = "Window" },
			})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			options = {
				globalstatus = true,
				theme = "auto",
				component_separators = "",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					"diff",
				},
				lualine_c = {
					"filename",
				},
				lualine_x = {
					"diagnostics",
					"encoding",
					"filetype",
				},
				lualine_y = {
					"progress",
				},
				lualine_z = {
					"location",
				},
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{
				"[b",
				"<cmd>BufferLineCyclePrev<cr>",
				desc = "Prev Buffer",
			},
			{
				"]b",
				"<cmd>BufferLineCycleNext<cr>",
				desc = "Next Buffer",
			},
		},
		opts = {},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = {
			{
				"<leader>e",
				function()
					require("snacks").explorer()
				end,
				-- https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
				desc = "File Explorer",
			},
		},
		---@type snacks.Config
		opts = {
			dashboard = {
				enabled = true,
			},
			notifier = {
				enabled = false,
			},
			input = {
				enabled = true,
			},
			explorer = {
				enabled = true,
			},
			indent = {
				enabled = true,
				indent = {
					hl = {
						"SnacksIndent1",
						"SnacksIndent2",
						"SnacksIndent3",
						"SnacksIndent4",
						"SnacksIndent5",
						"SnacksIndent6",
						"SnacksIndent7",
						"SnacksIndent8",
					},
				},
			},
		},
		config = function(_, opts)
			require("snacks").setup(opts)
			-- snacks.rename hardcodes a 1s request_sync timeout for
			-- workspace/willRenameFiles; gopls needs much longer to
			-- rewrite imports across a real project, so it silently
			-- times out and cancels. Bump it way up.
			local rename = require("snacks.rename")
			function rename.on_rename_file(from, to, cb)
				local changes = {
					files = {
						{
							oldUri = vim.uri_from_fname(from),
							newUri = vim.uri_from_fname(to),
						},
					},
				}
				local clients = (vim.lsp.get_clients or vim.lsp.get_active_clients)()
				for _, client in ipairs(clients) do
					if client.supports_method("workspace/willRenameFiles") then
						local resp = client.request_sync("workspace/willRenameFiles", changes, 30000, 0)
						if resp and resp.result ~= nil then
							vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
						end
					end
				end
				if cb then
					cb()
				end
				for _, client in ipairs(clients) do
					if client.supports_method("workspace/didRenameFiles") then
						client.notify("workspace/didRenameFiles", changes)
					end
				end
			end
		end,
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "moon",
			transparent = false,
			on_highlights = function(hl, c)
				hl.WinSeparator = { fg = c.blue, bold = true }
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
