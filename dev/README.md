# 开发辅助目录

本目录存放**不进站点构建**的开发文档、脚本与技能配置。GitHub Pages 构建时由根目录 [`_config.yml`](../_config.yml) 的 `exclude: [dev, ...]` 排除。

## 目录

| 路径 | 说明 |
|------|------|
| [`docs/`](docs/README.md) | 项目说明、本地环境、Issues 记录 |
| [`docs/issues/`](docs/issues/README.md) | 问题 / 决策 / 排障记录（按时间） |
| [`scripts/`](scripts/) | Ruby / Jekyll 辅助脚本 |
| [`skills/`](skills/README.md) | 可选的 Cursor / Agent 技能 |

## 常用入口

- 项目概览：[`docs/project-overview.md`](docs/project-overview.md)
- 本地环境：[`docs/local-setup.md`](docs/local-setup.md)
- Issues 索引：[`docs/issues/README.md`](docs/issues/README.md)
- 安装依赖：`.\dev\scripts\setup-ruby-env.ps1`
- 本地预览（仓库根）：`bundle exec jekyll serve --host 127.0.0.1 --port 4000`

## 分支说明

历史上约定「`dev/` 仅在 `dev` 分支」。当前改为：**文档与脚本可在 `master` 跟踪**（见根目录 `.gitignore` 白名单），避免协作时找不到 Issues。站点内容仍只由根目录 Jekyll 文件构成。

切换到名为 `dev` 的分支时请用 `git switch dev`（目录名与分支名冲突时不要用模糊的 `git checkout dev`）。
