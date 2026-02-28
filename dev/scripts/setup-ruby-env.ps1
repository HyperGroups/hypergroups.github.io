# 在安装好 Ruby 后，于项目根目录运行此脚本以安装 Bundler 和 Jekyll 依赖。
# 用法：在新终端中 cd 到本项目，执行 .\dev\scripts\setup-ruby-env.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Push-Location $ProjectRoot | Out-Null
try {
    Write-Host "Checking Ruby..." -ForegroundColor Cyan
    try {
        $rubyVersion = ruby -v 2>&1
        Write-Host "  $rubyVersion" -ForegroundColor Green
    } catch {
        Write-Host "  Ruby not found. Please install Ruby first (see dev/docs/local-setup.md), then open a NEW terminal and run this script again." -ForegroundColor Red
        exit 1
    }

    Write-Host "`nInstalling Bundler..." -ForegroundColor Cyan
    gem install bundler
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    Write-Host "`nInstalling project gems (bundle install)..." -ForegroundColor Cyan
    bundle install
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

    Write-Host "`nDone. Run:  bundle exec jekyll serve" -ForegroundColor Green
} finally {
    Pop-Location
}
