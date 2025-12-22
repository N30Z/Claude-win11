# Claude Code - Extended Context Menu Uninstallation
# Removes all Claude Code context menu entries

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgefuehrt werden!"
    Write-Host "Bitte starten Sie PowerShell als Administrator und fuehren Sie das Skript erneut aus."
    pause
    exit
}

Write-Host "=== Claude Code - Kontextmenue Deinstallation ===" -ForegroundColor Cyan
Write-Host ""

try {
    Write-Host "Entferne Kontextmenue-Eintraege..." -ForegroundColor Yellow
    Write-Host ""

    # Remove folder context menu
    $folderPath = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode"
    if (Test-Path $folderPath) {
        Remove-Item -Path $folderPath -Recurse -Force
        Write-Host "  - Ordner-Kontextmenue entfernt" -ForegroundColor Green
    }

    # Remove background context menu
    $bgPath = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\ClaudeCode"
    if (Test-Path $bgPath) {
        Remove-Item -Path $bgPath -Recurse -Force
        Write-Host "  - Hintergrund-Kontextmenue entfernt" -ForegroundColor Green
    }

    # Remove file context menu
    $filePath = "Registry::HKEY_CLASSES_ROOT\*\shell\ClaudeCode"
    if (Test-Path $filePath) {
        Remove-Item -Path $filePath -Recurse -Force
        Write-Host "  - Datei-Kontextmenue entfernt" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Deinstallation erfolgreich abgeschlossen!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Hinweis: Moeglicherweise muessen Sie den Explorer neu starten," -ForegroundColor Yellow
    Write-Host "         damit die Aenderungen sichtbar werden." -ForegroundColor Yellow

} catch {
    Write-Host ""
    Write-Host "Fehler bei der Deinstallation: $_" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
pause
