return {
	{
		"folke/which-key.nvim",
		-- 恢复 session 时启动流程会把 VeryLazy 推到很后面，
		-- 表现为刚恢复完第一次按 <leader> 弹不出菜单。which-key
		-- 很轻，直接常驻加载，保证启动后立刻可用。
		lazy = false,
		opts = {},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.add({
				{ "<leader>a", group = "AI" },
				{ "<leader>b", group = "Buffer" },
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>h", group = "Hunk" },
				{ "<leader>m", group = "Go Mod" },
				{ "<leader>o", group = "Terminal" },
				{ "<leader>q", group = "Session / Quit" },
				{ "<leader>r", group = "Run" },
				{ "<leader>s", group = "Search" },
				{ "<leader>t", group = "Test" },
				{ "<leader>T", group = "Tab" },
				{ "<leader>w", group = "Window / Write" },
				{ "<leader>x", group = "Trouble" },
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
					{ "filename", path = 1 },
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
					-- 侧栏现在会自动常驻，这里做成 toggle：
					-- 已打开就关掉，避免重复开第二个 explorer
					local snacks = require("snacks")
					local explorer = snacks.picker.get({ source = "explorer" })[1]
					if explorer then
						explorer:close()
					else
						snacks.explorer()
					end
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
			-- snacks.input 不会自动接管 vim.ui.input；显式启用，
			-- 否则 LSP rename / DAP 条件断点等仍走默认输入框。
			Snacks.input.enable()
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
		"stevearc/oil.nvim",
		-- oil 要靠目录 buffer 的 BufReadCmd / 文件操作接管，懒加载会
		-- 错过注册时机，所以常驻加载（几十毫秒）。
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{
				"<leader>E",
				function()
					require("oil").open_float()
				end,
				desc = "Oil (float)",
			},
		},
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			-- 不抢 netrw：`nvim <dir>` 的默认行为保持不变，oil 只通过
			-- <leader>E（或 :Oil）手动打开。
			default_file_explorer = false,
			-- 与 snacks.rename 的 30s 补丁保持一致：gopls 重写 import
			-- 远超默认 1000ms，超时后 willRenameFiles 会被静默跳过。
			lsp_file_methods = {
				timeout_ms = 30000,
			},
			float = {
				padding = 2,
				max_width = 0.6,
				max_height = 0.8,
				border = "rounded",
			},
			keymaps = {
				-- 浮窗里 q 直接关掉；默认的 <C-c> 依然有效
				["q"] = { "actions.close", mode = "n" },
			},
		},
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
