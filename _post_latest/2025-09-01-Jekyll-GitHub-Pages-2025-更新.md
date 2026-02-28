---
layout: post
title: "Jekyll 与 GitHub Pages 2025：最新变化与部署实践"
category: Jekyll
date: 2025-09-01
tags:
  - Jekyll
  - GitHub Pages
  - GitHub Actions
---

自 2024 年 6 月起，GitHub Pages 的构建与部署方式发生了重要变化。本文整理 2024–2026 年间 Jekyll 和 GitHub Pages 的最新进展，方便仍在使用静态博客的读者参考。

## 一、GitHub Actions 成为标准部署方式

从 **2024 年 6 月 30 日**起，GitHub Pages 已全面迁移到 GitHub Actions 进行构建和部署。虽然 `github-pages` gem 仍可使用，但官方推荐采用 Actions 工作流。

### 影响与建议

- 必须在仓库中**启用 GitHub Actions**，否则站点无法构建
- 使用 Actions 可自定义 Ruby 版本、依赖和构建步骤，更灵活
- 本地环境与线上环境的差异可通过 Actions 的 Docker/容器化构建减小

## 二、GitHub Pages Gem v232（2025 版）

最新的 GitHub Pages gem 版本（v232）主要包括：

- **Ruby 3.3+** 支持
- 依赖版本：Jekyll 3.10.0、Kramdown 2.4.0、Liquid 4.0.4、Rouge 3.30.0
- 主题自动转换与性能优化
- 对 Docker 化部署的支持

## 三、发布源与 Markdown 处理器

### 发布源

- **从分支发布**：推送到指定分支（如 `main` 或 `gh-pages`）触发发布
- **GitHub Actions**：通过工作流自定义构建和部署流程

### Markdown 处理器

- **Kramdown**：Jekyll 默认
- **GFM**：GitHub Flavored Markdown，与 GitHub 渲染效果一致

## 四、本地与线上环境一致性

为尽量保证本地构建与 GitHub Pages 结果一致，可以采用：

1. **Bundler**：使用 `bundle exec jekyll serve`，依赖 `Gemfile` 锁定
2. **Docker**：通过官方或自定义 Jekyll 镜像构建，适合 CI/CD

## 五、简要小结

| 项目 | 2024 年前 | 2024–2025 |
|------|----------|-----------|
| 部署方式 | 传统 GitHub Pages 构建 | GitHub Actions 为主 |
| Actions | 可选 | 必需启用 |
| Ruby | 2.7+ | 3.3+ |
| 自定义构建 | 受限 | 更灵活 |

Jekyll 仍是 GitHub Pages 推荐使用的静态站点生成器，适合个人博客和文档站点。若你此前用 Jekyll 建站，建议检查并启用 Actions 工作流，以避免构建失败。

## 参考

- [GitHub Pages 文档](https://docs.github.com/zh/pages)
- [Jekyll 官方文档](https://jekyllrb.com/)
