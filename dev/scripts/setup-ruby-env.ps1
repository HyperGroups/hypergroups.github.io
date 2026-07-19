# 鍦ㄥ畨瑁呭ソ Ruby 鍚庯紝浜庨」鐩牴鐩綍杩愯姝よ剼鏈互瀹夎 Bundler 鍜?Jekyll 渚濊禆銆?# 鐢ㄦ硶锛氬湪鏂扮粓绔腑 cd 鍒版湰椤圭洰锛屾墽琛?.\dev\scripts\setup-ruby-env.ps1

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
