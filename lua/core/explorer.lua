--------------------------------------------------------
-- Explorer (常驻侧栏)
--
-- snacks.explorer 本质是个 picker：它不会自己常驻。启动、恢复
-- session、切到另一个文件、开新 tabpage 之后，侧栏都不会自动出现，
-- 每次都得手动按 <leader>e。
--
-- 这里在“当前是普通文件 buffer，但侧栏不存在”时自动补一个，
-- 并把焦点留在原来的文件窗口里（enter = false）。
--------------------------------------------------------
local M = {}

-- 正在创建侧栏（Snacks.explorer 的注册是异步的，见 ensure）
local pending = false

-- 这些 buffer 不该拉出侧栏：提交信息、rebase、dashboard、插件 UI 等
local skip_ft = {
	gitcommit = true,
	gitrebase = true,
	dashboard = true,
	lazy = true,
	qf = true,
	trouble = true,
	terminal = true,
}

local function snacks()
	return require("snacks")
end

local function should_open()
	-- 还没进 UI（--headless、启动早期）就别插手
	if vim.v.vim_did_enter == 0 then
		return false
	end
	-- 命令行窗口 / 浮窗 / 预览窗口里不打开
	if vim.fn.win_gettype() ~= "" then
		return false
	end

	local buf = vim.api.nvim_get_current_buf()
	if not vim.bo[buf].buflisted or vim.bo[buf].buftype ~= "" then
		return false
	end
	-- 空 buffer（:enew、新 tabpage）没有文件，不需要树
	if vim.api.nvim_buf_get_name(buf) == "" or skip_ft[vim.bo[buf].filetype] then
		return false
	end

	-- 已经有侧栏，或者用户正开着别的 picker（files/grep/...）就别顶掉
	return #snacks().picker.get() == 0
end

local function ensure()
	if pending or not should_open() then
		return
	end

	-- Snacks.explorer 的注册/布局是异步的：创建后的一小段时间里
	-- Snacks.picker.get() 还看不到它。连着几个 BufEnter（例如
	-- :e x :e y，或者 VimEnter 与 BufEnter 同时触发）就会各自
	-- 建一个侧栏，最后并排出现 2~3 个。这把锁负责去抖。
	pending = true
	local win = vim.api.nvim_get_current_win()

	-- enter = false：别把光标从文件窗口抢到 picker 的输入框
	if not pcall(snacks().explorer, { enter = false }) then
		pending = false
		return
	end

	vim.defer_fn(function()
		pending = false
		-- picker 的布局在打开后才稳定，等一会儿再确认焦点位置
		if win ~= vim.api.nvim_get_current_win() and vim.api.nvim_win_is_valid(win) then
			pcall(vim.api.nvim_set_current_win, win)
		end
	end, 300)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("CoreExplorer", { clear = true })

	-- VimEnter：启动；TabEnter：新 tabpage；BufEnter：切文件 / 恢复 session
	vim.api.nvim_create_autocmd({ "VimEnter", "TabEnter", "BufEnter" }, {
		group = group,
		callback = function()
			vim.schedule(ensure)
		end,
	})
end

return M
