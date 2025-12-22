# Claude Code - URL Protocol Uninstallation
# Removes claude:// URL protocol

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgefuehrt werden!"
    Write-Host "Bitte starten Sie PowerShell als Administrator und fuehren Sie das Skript erneut aus."
    pause
    exit
}

Write-Host "=== Claude Code - URL Protocol Deinstallation ===" -ForegroundColor Cyan
Write-Host ""

try {
    Write-Host "Entferne claude:// URL Protocol..." -ForegroundColor Yellow
    Write-Host ""

    $protocolPath = "Registry::HKEY_CLASSES_ROOT\claude"

    if (Test-Path $protocolPath) {
        Remove-Item -Path $protocolPath -Recurse -Force
        Write-Host "URL Protocol erfolgreich entfernt!" -ForegroundColor Green
    } else {
        Write-Host "URL Protocol war nicht installiert." -ForegroundColor Yellow
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
