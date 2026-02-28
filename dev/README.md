# 开发辅助目录（仅 dev 分支）

本目录及仓库根下的 `skills/` 仅在 **dev** 分支提交，**master** 分支不包含，便于在开发/协作时保留环境说明、脚本和技能配置，而不影响站点主仓库内容。

## 目录说明

| 路径 | 说明 |
|------|------|
| `dev/docs/` | 开发相关文档（本地环境、流程说明等） |
| `dev/scripts/` | 辅助脚本（如 Ruby/Jekyll 环境安装） |
| `dev/skills/` | 项目用 Cursor/Agent 技能或规则（可选） |
| 根目录 `skills/` | 与 dev 同策略，仅 dev 分支提交 |

## 分支约定

- **master**：仅站点与构建相关文件；`.gitignore` 已忽略 `dev/` 与 `skills/`。
- **dev**：在 master 基础上增加 `dev/`、`skills/` 的提交；从 master 合并时若 `.gitignore` 冲突，保留 dev 分支的忽略规则（不忽略 `dev/`、`skills/`）。

## 常用（辅助文档与脚本已迁入 dev/，根目录不再保留）

- 本地 Jekyll 环境：见 [docs/local-setup.md](docs/local-setup.md)（原 `LOCAL.md`）
- 一键安装 Ruby 依赖：在项目根执行 `.\dev\scripts\setup-ruby-env.ps1`（原根目录脚本已移入此处）
