--------------------------------------------------------
-- Mouse
--
-- nvim 默认 mouse=nvi，终端里的拖选是 nvim 自己的 Select 模式选区，
-- 不是终端的原生选区，所以 Ghostty 的 copy-on-select 不会生效；
-- 而 Select 高亮是“活的”编辑器状态，松开鼠标后任何按键/粘贴都会
-- 替换掉它（看起来像“选中即删除”）。
--
-- 处理方式：在 Select/Visual 模式下松开鼠标时，立刻把选区写进系统
-- 剪贴板并退出选择模式。单击（不产生选区）仍然保持 nvim 原生行为。
--
-- 两个坑（都已在本文件里处理）：
--   1. 不能用 expr = true 的映射：expr 求值时处于 textlock，里面执行
--      :normal 会被静默吞掉，复制不会发生。
--   2. Select 模式里 "+y 会忽略寄存器前缀（TextYankPost 的 regname 为空），
--      必须先 CTRL-G 切回 Visual 再 yank，否则只有无名寄存器被写入。
--------------------------------------------------------
local M = {}

---在 Select/Visual 模式中把选区写进系统剪贴板，并回到 Normal 模式。
local function on_release()
    local mode = vim.fn.mode()

    -- Select 模式先 CTRL-G 切回 Visual，yank 才会走 "+ 寄存器
    local keys = (mode == "s" or mode == "S" or mode == "\19") and '\7"+y' or '"+y'
    if pcall(vim.cmd, "normal! " .. keys) then
        return
    end

    -- 退路：没有 clipboard provider 时直接取选区文本写寄存器
    local visual_type = ({ s = "v", S = "V", ["\19"] = "\22" })[mode] or mode
    local ok, text = pcall(vim.fn.getregion, vim.fn.getpos("v"), vim.fn.getpos("."), { type = visual_type })
    if ok and text then
        local regtype = visual_type == "V" and "l" or (visual_type == "\22" and "b" or "c")
        pcall(vim.fn.setreg, "+", text, regtype)
    end

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end

function M.setup()
    -- 显式声明：保留 nvim 接管鼠标（点击定位、双击选词都还在）
    vim.opt.mouse = "nvi"

    -- 拖动、双击选词、三击选行，松手都复制并退出选择模式
    for _, key in ipairs({ "<LeftRelease>", "<2-LeftRelease>", "<3-LeftRelease>" }) do
        vim.keymap.set({ "v", "s" }, key, on_release, { silent = true, desc = "Mouse: copy selection on release" })
    end
end

return M
