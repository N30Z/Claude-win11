# Claude Code - Windows 11 Context Menu Integration
# Installation Script

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgef\u00fchrt werden!"
    Write-Host "Bitte starten Sie PowerShell als Administrator und f\u00fchren Sie das Skript erneut aus."
    pause
    exit
}

Write-Host "=== Claude Code - Windows 11 Kontextmen\u00fc Installation ===" -ForegroundColor Cyan
Write-Host ""

# Registry paths
$directoryShell = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode"
$directoryCommand = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode\command"
$backgroundShell = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\ClaudeCode"
$backgroundCommand = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\ClaudeCode\command"

# Command to execute (opens PowerShell and runs Claude Code)
$commandDirectory = 'powershell.exe -NoExit -Command "cd \"%V\"; npx @claude/code"'
$commandBackground = 'powershell.exe -NoExit -Command "cd \"%V\"; npx @claude/code"'

Write-Host "Installiere Kontextmen\u00fc-Eintr\u00e4ge..." -ForegroundColor Yellow

try {
    # Add context menu for folders (right-click on folder)
    Write-Host "- F\u00fcge 'in Claude Code \u00f6ffnen' f\u00fcr Ordner hinzu..." -ForegroundColor Gray

    if (!(Test-Path $directoryShell)) {
        New-Item -Path $directoryShell -Force | Out-Null
    }
    Set-ItemProperty -Path $directoryShell -Name "(Default)" -Value "in Claude Code \u00f6ffnen"
    Set-ItemProperty -Path $directoryShell -Name "Icon" -Value "powershell.exe,0"

    if (!(Test-Path $directoryCommand)) {
        New-Item -Path $directoryCommand -Force | Out-Null
    }
    Set-ItemProperty -Path $directoryCommand -Name "(Default)" -Value $commandDirectory

    # Add context menu for background (right-click in empty space)
    Write-Host "- F\u00fcge 'Claude Code hier \u00f6ffnen' f\u00fcr Hintergrund hinzu..." -ForegroundColor Gray

    if (!(Test-Path $backgroundShell)) {
        New-Item -Path $backgroundShell -Force | Out-Null
    }
    Set-ItemProperty -Path $backgroundShell -Name "(Default)" -Value "Claude Code hier \u00f6ffnen"
    Set-ItemProperty -Path $backgroundShell -Name "Icon" -Value "powershell.exe,0"

    if (!(Test-Path $backgroundCommand)) {
        New-Item -Path $backgroundCommand -Force | Out-Null
    }
    Set-ItemProperty -Path $backgroundCommand -Name "(Default)" -Value $commandBackground

    Write-Host ""
    Write-Host "Installation erfolgreich abgeschlossen!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Die folgenden Kontextmen\u00fc-Eintr\u00e4ge wurden hinzugef\u00fcgt:" -ForegroundColor Cyan
    Write-Host "  - Rechtsklick auf Ordner: 'in Claude Code \u00f6ffnen'" -ForegroundColor White
    Write-Host "  - Rechtsklick im Hintergrund: 'Claude Code hier \u00f6ffnen'" -ForegroundColor White
    Write-Host ""
    Write-Host "Hinweis: M\u00f6glicherweise m\u00fcssen Sie den Explorer neu starten," -ForegroundColor Yellow
    Write-Host "         damit die \u00c4nderungen sichtbar werden." -ForegroundColor Yellow

} catch {
    Write-Host ""
    Write-Host "Fehler bei der Installation: $_" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
pause
