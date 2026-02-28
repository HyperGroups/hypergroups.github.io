# 开发辅助目录（仅 dev 分支）

本目录及仓库根下的 `skills/` 仅在 **dev** 分支提交，**master** 分支不包含，便于在开发/协作时保留环境说明、脚本和技能配置，而不影响站点主仓库内容。

## 目录说明

| 路径 | 说明 |
|------|------|
| `dev/docs/` | 开发相关文档（本地环境、项目说明、流程等） |
| `dev/docs/readme-project.md` | 原根目录 README 完整内容（项目与分支说明） |
| `dev/Gemfile` | Gemfile 副本（实际由根目录 Gemfile 供 bundle 使用） |
| `dev/scripts/` | 辅助脚本（Jekyll 本地启动 `serve.ps1`、Ruby 环境安装等） |
| `dev/skills/` | 项目用 Cursor/Agent 技能或规则（可选） |
| `dev/1Plugins/` | 旧插件（prettify、Mathematica 高亮等，非站点构建用） |
| `dev/1stylesheets/` | 旧样式表，非站点主样式 |
| 根目录 `skills/` | 与 dev 同策略，仅 dev 分支提交 |

## 分支约定

- **master**：仅站点与构建相关文件；`.gitignore` 已忽略 `dev/` 与 `skills/`。可选：将 `Gemfile`、`Gemfile.lock` 加入 master 的 `.gitignore`，则仅 dev 分支提交它们。
- **dev**：在 master 基础上增加 `dev/`、`skills/`、根目录 `README.md`/`Gemfile` 等；从 master 合并时若 `.gitignore` 冲突，保留 dev 分支的忽略规则。

## 常用（辅助文档与脚本已迁入 dev/，根目录仅保留最简 README）

- 项目与分支说明：见 [docs/readme-project.md](docs/readme-project.md)（原根目录 `README.md` 完整版）
- 本地 Jekyll 环境：见 [docs/local-setup.md](docs/local-setup.md)（原 `LOCAL.md`）
- 依赖与版本：根目录 `Gemfile` 供 `bundle` 使用；[dev/Gemfile](Gemfile) 为副本
- 一键安装 Ruby 依赖：在项目根执行 `.\dev\scripts\setup-ruby-env.ps1`
- 本地启动 Jekyll：在项目根执行 `.\serve.ps1`（调用 `dev/scripts/serve.ps1`）或 `.\dev\scripts\serve.ps1`
