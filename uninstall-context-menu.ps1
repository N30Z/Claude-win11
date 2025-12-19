# Claude Code - Windows 11 Context Menu Integration
# Uninstallation Script

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgeführt werden!"
    Write-Host "Bitte starten Sie PowerShell als Administrator und führen Sie das Skript erneut aus."
    pause
    exit
}

Write-Host "=== Claude Code - Windows 11 Kontextmenü Deinstallation ===" -ForegroundColor Cyan
Write-Host ""

# Registry paths
$directoryShell = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode"
$backgroundShell = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\ClaudeCode"

Write-Host "Entferne Kontextmenü-Einträge..." -ForegroundColor Yellow

try {
    $removed = $false

    # Remove context menu for folders
    if (Test-Path $directoryShell) {
        Write-Host "- Entferne 'in Claude Code öffnen' für Ordner..." -ForegroundColor Gray
        Remove-Item -Path $directoryShell -Recurse -Force
        $removed = $true
    }

    # Remove context menu for background
    if (Test-Path $backgroundShell) {
        Write-Host "- Entferne 'Claude Code hier öffnen' für Hintergrund..." -ForegroundColor Gray
        Remove-Item -Path $backgroundShell -Recurse -Force
        $removed = $true
    }

    Write-Host ""
    if ($removed) {
        Write-Host "Deinstallation erfolgreich abgeschlossen!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Alle Claude Code Kontextmenü-Einträge wurden entfernt." -ForegroundColor White
        Write-Host ""
        Write-Host "Hinweis: Möglicherweise müssen Sie den Explorer neu starten," -ForegroundColor Yellow
        Write-Host "         damit die Änderungen sichtbar werden." -ForegroundColor Yellow
    } else {
        Write-Host "Keine Kontextmenü-Einträge gefunden." -ForegroundColor Yellow
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
