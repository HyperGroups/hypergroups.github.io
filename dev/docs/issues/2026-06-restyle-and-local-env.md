# Issues 记录：Wolfram 风格改版 & 本地环境搭建（2026-06）

本文档记录在「克隆仓库 → 删除 CNAME → Wolfram Mathematica 风格改版 → 搭建本地 Jekyll 环境」过程中遇到的问题、原因与解决办法，供后续排查参考。

---

## 1. 首页正文过窄、右侧大片空白

- **现象**：首页正文实际只占约 56% 宽，右侧空出一大块，整体「空太多」。
- **原因**：`_layouts/default.html` 已用 `<div class="row"><div class="col-md-9">` 包裹 `{{ content }}`，而 `index.html` 内部又嵌套了一层 `row > col-md-9`，导致 75% × 75% ≈ 56% 的双重收窄；同时缺少 `col-md-3` 侧栏，剩余 25% 永远空置。
- **解决**：去掉嵌套栅格，layout 改用居中的 `.page-main` 阅读容器（`max-width: 820px` 居中卡片），`index.html` / `post.html` 不再各自包 bootstrap 栅格。
- **状态**：已修复（master `67fa8e3`）。

## 2. 删除 CNAME 后的自定义域名影响

- **现象**：删除根目录 `CNAME`（内容 `hypergroups.top`）。
- **影响**：GitHub Pages 重建后站点不再绑定 `hypergroups.top`，回到默认 `hypergroups.github.io`。
- **注意**：若仓库 Settings → Pages 仍显式配置了自定义域名，可能被重新写回 `CNAME`，需一并在设置里清除。
- **状态**：已提交（master `5f04e18`）。

## 3. `git push` 偶发 TLS 握手失败

- **现象**：`fatal: unable to access ... schannel: failed to receive handshake, SSL/TLS connection failed`；`git fetch` 也偶发同样错误。
- **原因**：本地代理 `127.0.0.1:7897`（Clash/mihomo）对 github.com 的连接偶发抖动。
- **解决**：直接重试一次即可成功（已多次验证）。必要时检查代理节点 / 切换节点。
- **状态**：可重试规避。

## 4. `bundle install` 拉国内 gem 源 SSL 失败 ⭐ 关键

- **现象**：
  - `Bundler::Fetcher::CertificateFailureError ... Could not verify the SSL certificate for https://gems.ruby-china.com/...`
  - `SSL_connect ... peeraddr=127.0.0.1:7897 ... unexpected eof while reading`
- **原因**：进程继承了 `HTTP(S)_PROXY`，导致对**国内** gem 镜像（ruby-china）的请求也走本地代理 `127.0.0.1:7897`，被代理拦截 / 中断，触发证书校验失败与 EOF。
- **解决**（PowerShell 内，安装前执行）：
  ```powershell
  Remove-Item Env:\HTTP_PROXY,Env:\HTTPS_PROXY,Env:\http_proxy,Env:\https_proxy -ErrorAction SilentlyContinue
  $env:NO_PROXY = "gems.ruby-china.com,rubygems.org,127.0.0.1,localhost"
  bundle config set --local mirror.https://rubygems.org https://gems.ruby-china.com
  bundle install
  ```
  即「国内源直连、绕过本地代理」。30 个 gem 全部安装成功（含 eventmachine / http_parser.rb / ffi 原生扩展）。
- **状态**：已解决。原则上凡 CN-hosted 源都应绕过本地代理。

## 5. `winget search` 输出乱码 / 退出码异常

- **现象**：`winget search` 的旋转进度符（`- \ | /`）刷屏，偶发 `Exit code 255`。
- **解决**：加 `--disable-interactivity --accept-source-agreements`，并对结果做截取。
- **状态**：已规避。

## 6. Ruby 3.4 弃用警告（构建时）

- **现象**：`bundle exec jekyll build` 输出 `warning: base64 ... will no longer be part of the default gems starting from Ruby 3.4.0`、`bigdecimal ...`。
- **原因**：safe_yaml / liquid 依赖将来从 Ruby 默认 gem 移除的标准库。
- **影响**：当前 Ruby 3.3 下无害，构建正常（`EXITCODE=0`）。
- **可选消除**：在 `Gemfile` 显式加 `gem "base64"`、`gem "bigdecimal"`。
- **状态**：暂忽略。

## 7. `git checkout dev` 歧义

- **现象**：`fatal: 'dev' could be both a local file and a tracking branch.`
- **原因**：仓库里既有 `dev/` 目录又有 `dev` 分支，`git checkout dev` 无法判定。
- **解决**：用 `git switch dev`（明确按分支），或 `git checkout dev --`。
- **状态**：已解决。

## 8. `dev/` 在 master 分支仍被跟踪（约定不一致，待清理）

- **现象**：`dev/README.md` 与 `.gitignore` 声称「`dev/` 仅在 dev 分支提交」，但 `git ls-files dev/` 显示 master 上仍跟踪 4 个文件（`dev/README.md`、`dev/docs/local-setup.md`、`dev/scripts/setup-ruby-env.ps1`、`dev/skills/README.md`）。
- **原因**：这些文件在加入 `.gitignore` 之前已被跟踪；`.gitignore` 只能阻止**新增未跟踪**文件。
- **建议**：若要彻底贯彻约定，在 master 上 `git rm --cached -r dev/` 后提交，使 master 不再含 `dev/`（dev 分支保留）。
- **状态**：待决定（本次未改动）。

---

## 环境速查

- Ruby：`C:\Ruby33-x64`（3.3.11 + DevKit，winget `RubyInstallerTeam.RubyWithDevKit.3.3`）。
- PATH（PowerShell 临时）：`$env:Path = "C:\Ruby33-x64\bin;C:\Ruby33-x64\msys64\usr\bin;" + $env:Path`
- 构建：`bundle exec jekyll build`；预览：`bundle exec jekyll serve --host 127.0.0.1 --port 4000` → http://127.0.0.1:4000/
