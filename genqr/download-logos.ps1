# Download all 64 distinct bank images listed in the supplied VietQR HTML.
# Run in Windows PowerShell from the genqr folder:
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\download-logos.ps1
# URLs are sourced from logos-manifest.json; HTTPS only.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$manifestPath = Join-Path $root 'logos-manifest.json'
$dest = Join-Path $root 'logos'
if (-not (Test-Path -LiteralPath $manifestPath)) { throw 'Khong tim thay logos-manifest.json' }
New-Item -ItemType Directory -Path $dest -Force | Out-Null
$logos = (Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json).logos
Add-Type -AssemblyName System.Drawing
$success = 0
$failed = [System.Collections.Generic.List[string]]::new()
foreach ($item in $logos) {
    $target = Join-Path $dest ($item.id + '.png')
    if (Test-Path -LiteralPath $target) {
        $success++
        Write-Host ('SKIP: ' + (($item.names) -join ', '))
        continue
    }
    $downloaded = $false
    $candidateUrls = @($item.source, $item.fallback) | Where-Object { $_ -and $_ -match '^https://' } | Select-Object -Unique
    foreach ($url in $candidateUrls) {
        $tmp = Join-Path $dest ($item.id + '.download')
        try {
            Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing -TimeoutSec 9 -ErrorAction Stop
            $bytes = [System.IO.File]::ReadAllBytes($tmp)
            if ($bytes.Length -lt 16) { throw 'Khong phai file anh' }
            $isPNG = ($bytes[0] -eq 137 -and $bytes[1] -eq 80 -and $bytes[2] -eq 78 -and $bytes[3] -eq 71)
            if ($isPNG) {
                Move-Item -LiteralPath $tmp -Destination $target -Force
            } else {
                # JPEG, GIF and BMP are converted to genuine PNG on Windows.
                $bitmap = $null
                try {
                    $bitmap = [System.Drawing.Image]::FromFile($tmp)
                    $bitmap.Save($target, [System.Drawing.Imaging.ImageFormat]::Png)
                } finally {
                    if ($bitmap -ne $null) { $bitmap.Dispose() }
                }
            }
            $success++
            $downloaded = $true
            Write-Host ('OK: ' + (($item.names) -join ', ')) -ForegroundColor Green
            break
        } catch {
            Write-Warning ('Download failed: ' + $url + ' - ' + $_.Exception.Message)
        } finally {
            if (Test-Path -LiteralPath $tmp) { Remove-Item -LiteralPath $tmp -Force }
        }
    }
    if (-not $downloaded) {
        [void]$failed.Add((($item.names) -join ', ') + ' (' + $item.id + ')')
    }
}
Write-Host "`nDa luu: $success/$($logos.Count) logo" -ForegroundColor Cyan
if ($failed.Count -gt 0) {
    Write-Warning ("Co " + $failed.Count + " anh khong tai duoc.")
    $report = Join-Path $root 'failed-logos.txt'
    $failed | Set-Content -LiteralPath $report -Encoding UTF8
    Write-Host ('Danh sach loi: ' + $report)
    Write-Host 'Trang web se tu chuyen sang logo VietQR online hoac ten ngan hang.'
}
Write-Host 'Upload ca thu muc logos/ len GitHub cung voi index.html.'
