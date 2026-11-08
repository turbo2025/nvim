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

## AI 助手（DeepSeek）

聊天/改代码用 [avante.nvim](https://github.com/yetone/avante.nvim)，provider 固定为 `deepseek`：

- `<leader>ac` — 打开/聚焦 AI chat 侧栏
- `<leader>aa` — 显示侧栏
- `<leader>at` — 显示/隐藏侧栏
- `<leader>ae` — 编辑选中的代码块
- 侧栏内 `<Tab>` / `<S-Tab>` 切换窗口，`q` 关闭

API key 从环境变量 `DEEPSEEK_API_KEY` 读取；确保启动 Neovim 的 shell 已导出它。
当前 API 提供 `deepseek-flash` 和 `deepseek-v4-pro` 两个模型；配置里默认用 `deepseek-flash`，
要换更强的模型，把 `lua/plugins/avante.lua` 里的 `providers.deepseek.model` 改成
`deepseek-v4-pro`。

`providers.deepseek.extra_request_body.max_tokens` 不能省略：avante 的 openai provider 默认
会给请求体塞 `max_completion_tokens`，而 DeepSeek 只接受 `max_tokens`，多余字段会返回 400。
设置 `max_tokens` 后 avante 会自动移除前者。同一位置设置了 `thinking = { type = "enabled" }`，
开启 DeepSeek 的 thinking 模式（effort=high）以提升工具调用参数的正确性；追求响应速度时改成
`"disabled"`。

除了内置工具，`custom_tools` 还注册了固定命令工具，cwd 自动取项目根目录、
输出超长会自动截断：

| 工具 | 等价命令 |
|---|---|
| `run_go_test` | `go test <target>`（默认 `./...`） |
| `run_pytest` | 优先 `.venv/bin/pytest` / `uv run pytest` / `pytest`，回退 `python -m pytest` |
| `run_npm_test` | `npm test`（可选参数经 `--` 传入） |
| `run_python_script` | 用项目解释器运行 `.py` 文件或内联代码 |
| `git_status` | `git status --short --branch` |
| `git_log` | `git log --oneline --decorate -n <count>` |
| `git_branch` | `git branch -vv` |
| `git_show` | `git show --stat <ref>` |

`git diff` 和 `git commit` 用 avante 内置的 `git_diff` / `git_commit`（后者执行前会弹确认）。

行内补全仍由 `minuet-ai.nvim` + 本地 Ollama 提供（见 `lua/plugins/minuet.lua`），avante 的
`auto_suggestions` 默认关闭以免高频计费；需要时把 `behaviour.auto_suggestions` 设为 `true`。

首次启动会执行 `make` 编译 avante 原生依赖，需要 `make` / `cargo` / C 编译器 /
`curl`（`:AvanteBuild` 下载预编译产物时还需要 `tar`）。用发行版包管理器安装即可，例如：

```sh
# Debian / Ubuntu
sudo apt install build-essential cargo curl
# Fedora
sudo dnf install gcc make cargo curl
# Arch
sudo pacman -S base-devel rust curl
```

编译失败时可在 Neovim 里执行 `:AvanteBuild source=true` 重试，或执行 `:AvanteBuild`
下载预编译产物。

## 常用快捷键

- `<leader>rr` / `<leader>rb` / `<leader>tt` 等 — 各语言任务（buffer-local，随 filetype 生效）
- `<leader>cf` — 格式化（conform）
- `<leader>cl` — lint（nvim-lint）
- `<leader>gg` / `<leader>gd` / `<leader>gD` / `<leader>gh` — Git（lazygit / codediff）
- `<leader>dc` / `<leader>db` / `<leader>do` 等 — DAP 调试

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
