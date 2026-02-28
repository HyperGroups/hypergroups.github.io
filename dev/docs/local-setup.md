# 本地 Jekyll 环境

本仓库的 `Gemfile` 已锁定为与 [GitHub Pages 版本](https://pages.github.com/versions/) 一致（Jekyll 3.10.0、kramdown-parser-gfm 1.1.0），本地构建与 GitHub 上一致。  
（原根目录 `LOCAL.md`、`setup-ruby-env.ps1` 已迁移到此目录与 `dev/scripts/`，仅 dev 分支保留。）

## Windows 10 安装

### 1. 安装 Ruby

**方式 A：winget（推荐）**

```powershell
winget install RubyInstallerTeam.RubyWithDevKit.3.3 --accept-package-agreements --accept-source-agreements
```

- 若弹出 Ruby 安装向导：一路下一步，结束时若提示 “Run ridk install”，选“是”以安装 MSYS2（编译原生 gem 需要）。
- 安装完成后**务必新开一个终端**，使 `ruby`、`gem` 生效。

**方式 B：手动下载**

- 从 [RubyInstaller](https://rubyinstaller.org/downloads/) 下载 **Ruby+Devkit 3.3.x**。
- 安装时勾选 “MSYS2 and MINGW development toolchain”，完成后按提示执行 `ridk install`。
- 新开一个终端，确认：`ruby -v`、`gem -v`。

### 2. 安装依赖与运行

在项目根目录执行：

```powershell
gem install bundler
bundle install
bundle exec jekyll serve
```

或使用脚本（项目根目录）：

```powershell
.\dev\scripts\setup-ruby-env.ps1
bundle exec jekyll serve
```

浏览器打开 <http://127.0.0.1:4000>。

### 3. 常用命令

| 命令 | 说明 |
|------|------|
| `bundle exec jekyll serve` | 本地预览（热重载） |
| `bundle exec jekyll build` | 仅构建到 `_site` |
| `bundle exec jekyll serve --livereload` | 预览并自动刷新 |

### 备选：WSL / Docker

- **WSL**：在 Ubuntu 下 `sudo apt install ruby-full build-essential`，然后 `gem install jekyll bundler`，在项目目录 `bundle install && bundle exec jekyll serve`。
- **Docker**：`docker run -p 4000:4000 -v ${PWD}:/site bretfisher/jekyll serve`（在项目根目录执行）。
