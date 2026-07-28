$repo = 'C:\Users\logan\nourishology'
$gh   = 'C:\Program Files\GitHub CLI\gh.exe'
$name = 'nourishology'
$owner= 'Joeromance84'
Set-Location $repo
$ErrorActionPreference = 'Continue'

Write-Output '=== 1. QR ==='
python -X utf8 "$repo\tools\make_qr.py"

Write-Output ''
Write-Output '=== 2. GIT ==='
if (-not (Test-Path "$repo\.git")) { git init -q -b main }
git config user.name  "Logan Royce Lorentz"
git config user.email "104143548+Joeromance84@users.noreply.github.com"
git add -A
git -c core.pager=cat commit -q -m "Nourishology - Batch No. 1 information page" 2>&1 | Select-Object -First 1
Write-Output ("  commit: " + (git rev-parse --short HEAD 2>&1))

Write-Output ''
Write-Output '=== 3. REPO + PUSH ==='
& $gh repo view "$owner/$name" --json name 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    & $gh repo create "$owner/$name" --public --source=. --remote=origin --push --description "Nourishology - Batch No. 1 information page." 2>&1 | Out-String | Write-Output
} else {
    if (-not (git remote | Select-String origin)) { git remote add origin "https://github.com/$owner/$name.git" }
    git push -u origin main 2>&1 | Select-Object -Last 1
}

Write-Output ''
Write-Output '=== 4. PAGES ==='
& $gh api "repos/$owner/$name/pages" 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    & $gh api -X POST "repos/$owner/$name/pages" -f "source[branch]=main" -f "source[path]=/" 2>&1 | Out-String | Write-Output
} else { Write-Output '  already enabled' }

Start-Sleep -Seconds 6
$p = & $gh api "repos/$owner/$name/pages" | ConvertFrom-Json
Write-Output ("  url    : " + $p.html_url)
Write-Output ("  status : " + $p.status)
Write-Output '--- DEPLOY COMPLETE ---'
