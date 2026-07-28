$b = 'https://joeromance84.github.io/nourishology/'
Write-Output 'Waiting for first Pages build...'
for ($i = 1; $i -le 20; $i++) {
    try {
        $r = Invoke-WebRequest -Uri $b -UseBasicParsing -TimeoutSec 20
        if ($r.StatusCode -eq 200) { break }
    } catch { }
    Start-Sleep -Seconds 15
}

Write-Output ''
Write-Output '=== LIVE ==='
foreach ($t in @('', 'assets/qr-code.png', 'assets/qr-code.svg')) {
    try {
        $r = Invoke-WebRequest -Uri ($b + $t) -UseBasicParsing -TimeoutSec 25
        $lbl = if ($t -eq '') { '(page)' } else { $t }
        Write-Output ("  [{0}] {1,-22} {2} bytes" -f $r.StatusCode, $lbl, $r.RawContentLength)
    } catch { Write-Output ("  [FAIL] " + $t) }
}

$c = (Invoke-WebRequest -Uri $b -UseBasicParsing -TimeoutSec 25).Content
Write-Output ''
Write-Output '=== CONTENT ==='
Write-Output ("  Claire removed      : " + (-not ($c -match 'Claire')))
Write-Output ("  real names present  : " + ($c -match 'Stacia King and Andrea King'))
Write-Output ("  no chemist claim    : " + (-not ($c -match "chemist")))
Write-Output ("  no nurse claim      : " + (-not ($c -match "nurse")))
Write-Output ("  no price            : " + (-not ($c -match '\$48')))
Write-Output ("  not-for-sale stated : " + ($c -match "isn't a business yet"))
Write-Output ("  email correct       : " + ($c -match 'nourishologytopicalsupplement@gmail\.com'))
Write-Output ("  FDA disclaimer      : " + ($c -match 'Not evaluated by the Food'))
Write-Output ("  patch test          : " + ($c -match 'Patch test first'))
Write-Output '--- COMPLETE ---'
