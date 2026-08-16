# Neovim 配置

基于 lazy.nvim 的模块化 Neovim 配置，支持 Go / Python / Rust / 前端（JS/TS/Vue/Svelte）。

## 要求

- Neovim >= 0.11（使用内置 `vim.lsp.config` / `vim.lsp.enable`）

## 目录结构

```
init.lua            入口，按顺序 require
lua/core/           语言无关核心（options/keymaps/lsp/dap/runner/terminal/root/langs/…）
lua/lsp/            每个 LSP server 一个 settings 配置文件
lua/lang/<lang>/    按语言组织的 tasks / dap / keymap
lua/plugins/        插件声明，按用途拆分（git/search/lsp/format/lint/…）
```

## 语言工具链

### Go

```sh
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install mvdan.cc/gofumpt@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest
```

### Rust

```sh
rustup component add rustfmt clippy
rustup component add rust-analyzer
# 调试（codelldb）
brew install codelldb   # macOS；Linux 见 https://github.com/vadimcn/codelldb
```

### Python

```sh
# basedpyright（LSP）+ ruff（format / lint）
uv tool install basedpyright ruff    # 或使用 pipx
```

### 前端

```sh
npm i -g typescript typescript-language-server   # ts_ls
npm i -g prettier                                  # 格式化
npm i -g eslint_d                                  # lint（js/ts/vue）
npm i -g stylelint                                 # lint（css/scss）
npm i -g @vue/language-server                       # vue（volar，可选）
```

## 常用快捷键

- `<leader>pr` / `<leader>pt` — 运行 / 测试当前语言项目（按 filetype 分发）
- `<leader>rr` / `<leader>rb` / `<leader>tt` 等 — 各语言任务（buffer-local，随 filetype 生效）
- `<leader>cf` — 格式化（conform）
- `<leader>cl` — lint（nvim-lint）
- `<leader>gg` / `<leader>gd` / `<leader>gh` — Git（lazygit / diffview）
- `<leader>dc` / `<leader>db` / `<leader>do` 等 — DAP 调试

## Git 相关插件

- `gitsigns.nvim` — 当前行作者/时间/commit、变更标记、hunk 操作
- `lazygit.nvim` — 完整的 git TUI
- `diffview.nvim` — 类似 IDE 的变更对比 / 文件历史
- `git-conflict.nvim` — 合并冲突标记与解决

## 如何新增一个语言

1. `lua/lsp/<name>.lua` — server settings
2. `lua/plugins/lsp.lua` — `vim.lsp.config` + `vim.lsp.enable`
3. `lua/lang/<lang>/tasks.lua` — 运行/测试任务，注册 `<lang>:run` / `<lang>:test`
4. `lua/lang/<lang>/init.lua` — buffer-local keymap（可复用 `<leader>rr` / `<leader>tt` 前缀）
5. `lua/core/root.lua` — 项目根 finder（如 `Cargo.toml` / `package.json`）
6. `lua/core/langs.lua` — filetype -> 模块映射（惰性加载）
7. `lua/plugins/format.lua` / `lint.lua` / `treesitter.lua` — formatter / linter / parser
