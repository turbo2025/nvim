# Neovim 配置

基于 lazy.nvim 的模块化 Neovim 配置，支持 Go / Python / Rust / 前端（JS/TS/Vue/Svelte）。

## 要求

- Neovim >= 0.11（使用内置 `vim.lsp.config` / `vim.lsp.enable`）
- `direnv` / `mise`（可选）：项目依赖通过 `.envrc` 或 `mise.toml` / `.tool-versions` 管理时自动加载

## 项目环境（direnv / mise）

打开项目文件或切换目录时，配置会加载最近的 `.envrc` 或 mise 配置，同步 `PATH` 等环境变量，让 LSP、formatter、任务使用项目工具链。优先级：`.envrc` > `mise.toml` / `.tool-versions`。

- `direnv` 首次使用需在项目目录执行 `direnv allow`。
- `mise` 首次使用需执行 `mise trust`（配置未受信任时无法导出环境）。
- 切换项目后环境未更新时，执行 `:ProjectEnvReload`（`:DirenvReload` 是兼容别名）。
- 启动 nvim 时的环境作为基线；从项目根启动可继承 shell 已加载的 direnv/mise 环境。
- 已经在运行的 LSP 进程不会因 `PATH` 变化自动重启；切换项目后必要时重启 nvim。
- 项目 devShell / mise 未提供的工具（例如只有 `go` 没有 `gopls`）仍会回退到全局安装。
- macOS 上常用 `mise` 管理 node/python/rust，`uv` 管理 Python 依赖；都会通过项目环境进入 `PATH`。

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
# 调试：debugpy 无需手动安装，由 `uv run --with debugpy` 按需拉起
```

### Lua（编辑本配置）

```vim
:MasonInstall lua-language-server
```

也可以改用发行版包管理器安装 `lua-language-server`。

### 前端

```sh
npm i -g typescript typescript-language-server   # ts_ls（TS/React/TSX）
npm i -g @vtsls/language-server                    # 提供 vtsls（Vue <script lang="ts">）
npm i -g vscode-langservers-extracted             # html / css / eslint LSP
npm i -g svelte-language-server                   # svelte LSP（svelteserver）
npm i -g prettier                                 # 格式化
npm i -g eslint_d                                 # lint（js/ts/vue）
npm i -g stylelint                                # lint（css/scss）
npm i -g @vue/language-server                     # vue（volar）
# Vue TS：vtsls 需要 @vue/typescript-plugin；部分发行版打包的 vue-language-server
# 已自带，npm 安装时需在项目或全局另装该插件。
# Svelte 格式化需要项目安装 prettier-plugin-svelte。
# 调试：js-debug-adapter 由 mason 安装（:MasonInstall js-debug-adapter）
```

## AI 补全

行内补全由 [minuet-ai.nvim](https://github.com/milanglacier/minuet-ai.nvim) + 本地 Ollama 提供
（见 `lua/plugins/minuet.lua`），默认只手动触发：

- `<A-[>` / `<A-]>` — 上一条 / 下一条建议（没有建议时手动发起请求）
- `<A-A>` / `<A-a>` / `<A-z>` — 接受全部 / 接受一行 / 接受 N 行
- `<A-e>` — 关闭建议

模型 `qwen2.5-coder:1.5b`，endpoint `http://localhost:11434/v1/completions`。

## 常用快捷键

- `<leader>rr` / `<leader>rb` / `<leader>tt` 等 — 各语言任务（buffer-local，随 filetype 生效）
- `<leader>cf` — 格式化（conform）
- `<leader>cl` — lint（nvim-lint）
- `<leader>gg` / `<leader>gd` / `<leader>gD` / `<leader>gh` — Git（lazygit / codediff）
- `<leader>dc` / `<leader>db` / `<leader>do` 等 — DAP 调试
- `<leader>e` — 文件浏览侧栏（snacks explorer，常驻左侧，再按一次关闭）
- `<leader>E` — [oil.nvim](https://github.com/stevearc/oil.nvim) 浮动文件管理器，可像编辑文本一样批量重命名/移动/删除，`:w` 生效

## Git 相关插件

- `gitsigns.nvim` — 当前行作者/时间/commit、变更标记、hunk 操作
- `lazygit.nvim` — 完整的 git TUI
- `codediff.nvim` — VSCode 风格 diff / 实时 review / 文件历史 / PR / 冲突解决
- `git-conflict.nvim` — 合并冲突标记与解决

> `codediff.nvim` 首次执行 `:CodeDiff` 会自动下载预编译的 diff 库；如果当前环境需要代理，先在代理 shell 里运行一次 `:CodeDiff install` 预热。

## 如何新增一个语言

1. `lua/lsp/<name>.lua` — server settings
2. `lua/plugins/lsp.lua` — `vim.lsp.config` + `vim.lsp.enable`
3. `lua/lang/<lang>/tasks.lua` — 运行/测试任务，注册 `<lang>:run` / `<lang>:test`
4. `lua/lang/<lang>/init.lua` — buffer-local keymap（可复用 `<leader>rr` / `<leader>tt` 前缀）
5. `lua/core/root.lua` — 项目根 finder（如 `Cargo.toml` / `package.json`）
6. `lua/core/langs.lua` — filetype -> 模块映射（惰性加载）
7. `lua/plugins/format.lua` / `lint.lua` / `treesitter.lua` — formatter / linter / parser
