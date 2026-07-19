# Issues：Wolfram 风格改版与本地环境（2026-06）

记录「克隆仓库 → 删除 CNAME → Wolfram 风格改版 → 搭建本地 Jekyll」过程中的问题与处理。

---

## 1. 首页正文过窄、右侧大片空白

- **现象：** 首页正文约只占 56% 宽，右侧空一大块。
- **原因：** `default` 布局已有 `row > col-md-9`，`index.html` 内再嵌一套，形成 75%×75%；又无侧栏填满剩余列。
- **解决：** 去掉嵌套栅格，改用居中 `.page-main` 阅读容器；首页/博文不再各自套 Bootstrap 栅格。
- **状态：** 已修复（当时 master `67fa8e3`）。后续门户改造再次调整了首页结构。

## 2. 删除 CNAME 后的自定义域名

- **现象：** 删除根目录 `CNAME`（原 `hypergroups.top`）。
- **影响：** Pages 回到默认 `https://hypergroups.github.io/`。
- **注意：** 若仓库 Settings → Pages 仍配置自定义域名，可能被重新写出 `CNAME`，需在设置里一并清除。
- **状态：** 已提交（当时 `5f04e18`）。`_config.yml` 的 `url` 现为 `https://hypergroups.github.io`。

## 3. `git push` 偶发 TLS 握手失败

- **现象：** `schannel: failed to receive handshake, SSL/TLS connection failed`。
- **原因：** 本地代理（如 `127.0.0.1:7897`）到 github.com 偶发抖动。
- **解决：** 重试；必要时换节点。
- **状态：** 可重试规避。

## 4. `bundle install` 经国内镜像时 SSL 失败

- **现象：** 访问 `gems.ruby-china.com` 证书失败或 `unexpected eof`；对端常为本地代理。
- **原因：** 进程继承了 `HTTP(S)_PROXY`，国内源请求也走代理被掐断。
- **解决（PowerShell，安装前）：**

```powershell
Remove-Item Env:\HTTP_PROXY,Env:\HTTPS_PROXY,Env:\http_proxy,Env:\https_proxy -ErrorAction SilentlyContinue
$env:NO_PROXY = "gems.ruby-china.com,rubygems.org,127.0.0.1,localhost"
bundle config set --local mirror.https://rubygems.org https://gems.ruby-china.com
bundle install
```

- **状态：** 已解决。CN 托管源建议直连、绕过本地代理。

## 5. `winget search` 乱码 / 退出码异常

- **解决：** 加 `--disable-interactivity --accept-source-agreements`，并截取输出。
- **状态：** 已规避。

## 6. Ruby 3.4 弃用警告

- **现象：** 构建时 `base64` / `bigdecimal` 将不再是默认 gem 的警告。
- **影响：** Ruby 3.3 下构建仍成功。
- **可选：** 在 `Gemfile` 显式声明 `gem "base64"`、`gem "bigdecimal"`。
- **状态：** 暂忽略。

## 7. `git checkout dev` 歧义

- **现象：** `'dev' could be both a local file and a tracking branch.`
- **解决：** 用 `git switch dev`，或 `git checkout dev --`。
- **状态：** 已解决。

## 8. `dev/` 在 master 上的跟踪约定

- **现象：** `.gitignore` 曾写「仅 dev 分支」，但 master 仍跟踪部分 `dev/` 文件。
- **后续：** 2026-07 起改为白名单跟踪 `dev/docs`、`dev/scripts`、`dev/skills` 与 `dev/README.md`，Issues 可随 master 协作。
- **状态：** 已用新约定替代「待清理」。

---

## 环境速查（当时）

- Ruby：`C:\Ruby33-x64`（3.3.x + DevKit）
- 预览：`bundle exec jekyll serve --host 127.0.0.1 --port 4000`
