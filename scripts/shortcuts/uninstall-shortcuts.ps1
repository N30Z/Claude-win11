# Claude Code - Windows Shortcuts Uninstallation
# Removes Start Menu shortcuts

Write-Host "=== Claude Code - Shortcuts Deinstallation ===" -ForegroundColor Cyan
Write-Host ""

# Start Menu path
$startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Claude Code"

try {
    if (Test-Path $startMenuPath) {
        Write-Host "Entferne Shortcuts..." -ForegroundColor Yellow
        Write-Host ""

        Remove-Item -Path $startMenuPath -Recurse -Force

        Write-Host "Shortcuts erfolgreich entfernt!" -ForegroundColor Green
    } else {
        Write-Host "Keine Shortcuts gefunden." -ForegroundColor Yellow
    }

} catch {
    Write-Host ""
    Write-Host "Fehler bei der Deinstallation: $_" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
pause
