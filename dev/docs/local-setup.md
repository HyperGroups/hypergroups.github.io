# 本地 Jekyll 环境

`Gemfile` 锁定为与 [GitHub Pages 版本](https://pages.github.com/versions/) 一致（Jekyll 3.10.0、kramdown-parser-gfm 1.1.0）。

## Windows：安装 Ruby

**方式 A：winget（推荐）**

```powershell
winget install RubyInstallerTeam.RubyWithDevKit.3.3 --accept-package-agreements --accept-source-agreements --disable-interactivity
```

安装结束后**新开终端**。若安装程序提示 `ridk install`，选是以装好 MSYS2（编译原生 gem 需要）。

**方式 B：** 从 [RubyInstaller](https://rubyinstaller.org/downloads/) 下载 Ruby+Devkit 3.3.x，勾选 MSYS2/MINGW，完成后 `ridk install`。

确认：`ruby -v`、`gem -v`。

## 安装依赖与预览

在仓库根目录：

```powershell
# 若走国内镜像且本机开了代理，先清掉代理再装（详见 issues）
Remove-Item Env:\HTTP_PROXY,Env:\HTTPS_PROXY,Env:\http_proxy,Env:\https_proxy -ErrorAction SilentlyContinue

gem install bundler
bundle install
bundle exec jekyll serve --host 127.0.0.1 --port 4000
```

或：

```powershell
.\dev\scripts\setup-ruby-env.ps1
bundle exec jekyll serve --host 127.0.0.1 --port 4000
```

浏览器打开 <http://127.0.0.1:4000>。

临时补 PATH（PowerShell）：

```powershell
$env:Path = "C:\Ruby33-x64\bin;C:\Ruby33-x64\msys64\usr\bin;" + $env:Path
```

## 常用命令

| 命令 | 说明 |
|------|------|
| `bundle exec jekyll serve` | 本地预览（可加 `--host 127.0.0.1 --port 4000`） |
| `bundle exec jekyll build` | 构建到 `_site/` |
| `bundle exec jekyll serve --livereload` | 预览并自动刷新 |

修改 `_config.yml` 后通常需要**重启** serve。

## 备选

- **WSL：** `sudo apt install ruby-full build-essential`，再 `gem install bundler` → `bundle install && bundle exec jekyll serve`
- **Docker：** 在仓库根 `docker run -p 4000:4000 -v ${PWD}:/site bretfisher/jekyll serve`

## 相关 Issues

- 代理 / gem SSL：[issues/2026-06-restyle-and-local-env.md](issues/2026-06-restyle-and-local-env.md) §4  
- Liquid 与热重载中断：[issues/2026-07-portal-search-reading.md](issues/2026-07-portal-search-reading.md) §Liquid  
