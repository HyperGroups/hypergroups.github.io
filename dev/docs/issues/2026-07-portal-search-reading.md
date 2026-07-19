# Issues：个人门户、搜索爬虫与阅读体验（2026-07）

记录主站从「旧博客列表 / Wolfram 全站风」转向「个人门户 + 早期归档」，以及搜索、字号布局、博文阅读模式相关问题。

---

## 1. 站点定位：主站 vs 项目站

- **背景：** 同时存在 `hypergroups.github.io`（用户站）与 `hypergroups`（项目站 Pages）。
- **决策：** 根域名主站做身份与入口；项目垂类与研究卡片留在 `https://hypergroups.github.io/hypergroups/`；Wolfram 仅作分入口，不再主导视觉。
- **状态：** 已落地（首页「当下线索」+ 早期笔记降级）。

## 2. 全站字号偏小 → 放大后留白失控

- **现象：** 默认字号偏小；改为约 2×（`html { font-size: 200% }`）后英雄区、栏宽与 padding 显得空。
- **解决：**
  - 字号最终定为 **1.5×**（`font-size: 150%`）。
  - 收紧英雄区（去掉大 `min-height`）、加宽内容栏、压缩内外边距与导航高度。
- **状态：** 已调整。

## 3. 下拉后出现大块可滚动空白

- **现象：** 首页内容并不长，但能滚出一大段空白。
- **原因：** `.portal-hero-grid` 使用 `perspective + scale` 动画，部分浏览器会把变换溢出算进滚动高度；「当下线索」奇数项末行半格空洞也加重「空」感。
- **解决：** 去掉背景 transform/动画；`overflow-x: clip`；末行奇数项 `grid-column: 1 / -1`；背景改为 `scroll`。
- **状态：** 已修复。

## 4. 图文博文（三维随机游走）在 100% 栏宽下主体过大

- **现象：** 站点 1.5× 字号 + 较宽阅读容器时，图文长文阅读负担大；看图又需要宽版面。
- **解决：** 博文增加 **阅读栏 / 宽栏** 切换（`js/reading-mode.js`，`localStorage: hg-reading-mode`）。
  - 阅读栏（默认）：约 `38rem` 栏宽，正文略收。
  - 宽栏：约 `68rem`，便于三维图与长代码。
- **状态：** 已落地。

## 5. 缺少搜索与爬虫入口

- **现象：** 无站内搜索；无 `robots.txt` / sitemap；`.gitignore` 曾忽略本地 `sitemap.txt`。
- **解决：** 增加纯 Liquid 生成的：
  - `/search.html` + `/search.json` + `js/search.js`
  - `/robots.txt`、`/sitemap.xml`、`/feed.xml`
  - 页头 description / canonical / RSS link
- **状态：** 已落地。

## 6. Liquid 把 Mathematica / 示例里的 `{{` 当模板

- **现象：** 热重载报错：`Variable '{{1,0,0}' was not properly terminated`；serve 中断。
- **原因：** 正文或注释中的 `{{...}}` 被 Liquid 解析。
- **解决：** 正文避免裸 `{{`；示例用 `{% raw %}...{% endraw %}`，或改成不会触发的写法。
- **状态：** 已知限制；写含大括号的代码时需注意。

## 7. `jekyll serve --detach` 在 Windows 不可用

- **现象：** `fork() function is unimplemented`。
- **解决：** 前台运行或另开终端；不要依赖 `--detach`。
- **状态：** 平台限制。

---

## 环境速查（2026-07）

- 预览：`bundle exec jekyll serve --host 127.0.0.1 --port 4000`
- 字号：`css/theme.css` 中 `html { font-size: 150%; }`
- 阅读模式：博文页顶工具条；键名 `hg-reading-mode` = `comfort` | `wide`
