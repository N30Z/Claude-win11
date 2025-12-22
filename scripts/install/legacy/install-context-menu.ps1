# Claude Code - Windows 11 Context Menu Integration
# Installation Script with Windows Terminal Support

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgefuehrt werden!"
    Write-Host "Bitte starten Sie PowerShell als Administrator und fuehren Sie das Skript erneut aus."
    pause
    exit
}

Write-Host "=== Claude Code - Windows 11 Kontextmenue Installation ===" -ForegroundColor Cyan
Write-Host ""

# Check if Windows Terminal is installed
$wtInstalled = Get-Command wt.exe -ErrorAction SilentlyContinue

# Check if Claude Code profile is installed
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$guidFile = Join-Path $scriptPath "claude-profile-guid.txt"
$profileInstalled = Test-Path $guidFile

if ($wtInstalled -and $profileInstalled) {
    Write-Host "Windows Terminal mit Claude Code Profil erkannt!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Waehlen Sie den Startmodus:" -ForegroundColor Yellow
    Write-Host "  [1] Windows Terminal mit Claude Code Profil (empfohlen)" -ForegroundColor Cyan
    Write-Host "  [2] Klassisches PowerShell-Fenster" -ForegroundColor Gray
    Write-Host ""
    $choice = Read-Host "Ihre Wahl (1 oder 2)"
    $useWindowsTerminal = $choice -eq "1"
} elseif ($wtInstalled) {
    Write-Host "Windows Terminal erkannt, aber Claude Code Profil nicht installiert." -ForegroundColor Yellow
    Write-Host "Fuehren Sie zuerst 'install-terminal-profile.ps1' aus fuer das beste Erlebnis." -ForegroundColor Yellow
    Write-Host ""
    $useWindowsTerminal = $false
} else {
    Write-Host "Windows Terminal nicht erkannt. Verwende PowerShell." -ForegroundColor Yellow
    Write-Host ""
    $useWindowsTerminal = $false
}

# Registry paths
$directoryShell = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode"
$directoryCommand = "Registry::HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode\command"
$backgroundShell = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\ClaudeCode"
$backgroundCommand = "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\ClaudeCode\command"

# Command to execute
if ($useWindowsTerminal) {
    # Windows Terminal with Claude Code profile
    $commandDirectory = 'wt.exe -p "Claude Code" -d "%V" -- claude'
    $commandBackground = 'wt.exe -p "Claude Code" -d "%V" -- claude'
    Write-Host "Modus: Windows Terminal mit Claude Code Profil" -ForegroundColor Cyan
} else {
    # Classic PowerShell
    $commandDirectory = 'powershell.exe -NoExit -Command "cd \"%V\"; claude"'
    $commandBackground = 'powershell.exe -NoExit -Command "cd \"%V\"; claude"'
    Write-Host "Modus: Klassisches PowerShell-Fenster" -ForegroundColor Gray
}
Write-Host ""

# Claude icon path
$claudeIcon = "$env:USERPROFILE\.local\bin\claude.exe,0"

Write-Host "Installiere Kontextmenue-Eintraege..." -ForegroundColor Yellow

try {
    # Add context menu for folders (right-click on folder)
    Write-Host "- Fuege Kontextmenue fuer Ordner hinzu..." -ForegroundColor Gray

    if (!(Test-Path $directoryShell)) {
        New-Item -Path $directoryShell -Force | Out-Null
    }
    Set-ItemProperty -Path $directoryShell -Name "(Default)" -Value "in Claude Code oeffnen"
    Set-ItemProperty -Path $directoryShell -Name "Icon" -Value $claudeIcon

    if (!(Test-Path $directoryCommand)) {
        New-Item -Path $directoryCommand -Force | Out-Null
    }
    Set-ItemProperty -Path $directoryCommand -Name "(Default)" -Value $commandDirectory

    # Add context menu for background (right-click in empty space)
    Write-Host "- Fuege Kontextmenue fuer Hintergrund hinzu..." -ForegroundColor Gray

    if (!(Test-Path $backgroundShell)) {
        New-Item -Path $backgroundShell -Force | Out-Null
    }
    Set-ItemProperty -Path $backgroundShell -Name "(Default)" -Value "Claude Code hier oeffnen"
    Set-ItemProperty -Path $backgroundShell -Name "Icon" -Value $claudeIcon

    if (!(Test-Path $backgroundCommand)) {
        New-Item -Path $backgroundCommand -Force | Out-Null
    }
    Set-ItemProperty -Path $backgroundCommand -Name "(Default)" -Value $commandBackground

    Write-Host ""
    Write-Host "Installation erfolgreich abgeschlossen!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Die folgenden Kontextmenue-Eintraege wurden hinzugefuegt:" -ForegroundColor Cyan
    Write-Host "  - Rechtsklick auf Ordner: in Claude Code oeffnen" -ForegroundColor White
    Write-Host "  - Rechtsklick im Hintergrund: Claude Code hier oeffnen" -ForegroundColor White
    Write-Host ""
    Write-Host "Hinweis: Moeglicherweise muessen Sie den Explorer neu starten," -ForegroundColor Yellow
    Write-Host "         damit die Aenderungen sichtbar werden." -ForegroundColor Yellow

} catch {
    Write-Host ""
    Write-Host "Fehler bei der Installation: $_" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
pause
