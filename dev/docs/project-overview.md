# 项目概览：hypergroups.github.io

## 定位

| 项 | 说明 |
|----|------|
| 仓库 | https://github.com/HyperGroups/hypergroups.github.io |
| 线上 | https://hypergroups.github.io/ |
| 角色 | **用户站 / 个人门户**（根域名） |
| 技术 | Jekyll 3.10 + GitHub Pages（与 Pages 依赖版本对齐） |

姊妹仓库 [HyperGroups/hypergroups](https://github.com/HyperGroups/hypergroups) 是**项目站**（`/hypergroups/`），偏研究领域与项目卡片；主站以入口与当下线索为主，早期笔记降为归档。

## 信息架构（当前）

```text
首页（门户）
  ├─ 当下线索 → 项目站 / 关于 / Wolfram …
  ├─ 搜索 / RSS / Sitemap（爬虫与站内检索）
  └─ 早期笔记（归档、旧分类）
关于 · Wolfram 分入口 · 博文（阅读栏 / 宽栏）
```

- 首页不承载全部旧文列表。
- Wolfram 是独立线索页，不是全站品牌。
- 博文默认「阅读栏」；图文密集文可切「宽栏」（`localStorage: hg-reading-mode`）。

## 关键目录（站点）

| 路径 | 作用 |
|------|------|
| `_posts/` | 已发布博文（含早期笔记 + 近年新文） |
| `_post_renovated/` | 旧文润色副本（collection，注意与 posts 可能撞 permalink） |
| `_layouts/` / `_includes/` | 布局与导航 |
| `css/theme.css` | 主题（字号根缩放、门户与阅读模式） |
| `js/search.js` / `js/reading-mode.js` | 站内搜索、阅读宽度 |
| `robots.txt` / `sitemap.xml` / `feed.xml` / `search.json` | 爬虫与索引 |
| `wolfram/` | Wolfram 脚本与配套说明（如 random-walk-3d） |
| `assets/posts/` | 博文静态资源 |

## 本地命令

见 [local-setup.md](local-setup.md)。排障见 [issues/](issues/README.md)。
