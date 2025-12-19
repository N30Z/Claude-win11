# Claude Code - Windows Terminal Profile Installation
# Installiert ein einzigartiges Claude Code Terminal-Profil mit Claude Dark Theme

Write-Host "=== Claude Code - Windows Terminal Profil Installation ===" -ForegroundColor Cyan
Write-Host ""

# Windows Terminal settings paths (multiple possible locations)
$wtSettingsPaths = @(
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
    "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
)

$wtSettingsPath = $null
foreach ($path in $wtSettingsPaths) {
    if (Test-Path $path) {
        $wtSettingsPath = $path
        break
    }
}

if (-not $wtSettingsPath) {
    Write-Host "Windows Terminal wurde nicht gefunden!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Bitte installieren Sie Windows Terminal aus dem Microsoft Store:" -ForegroundColor Yellow
    Write-Host "  https://aka.ms/terminal" -ForegroundColor Cyan
    Write-Host ""
    pause
    exit 1
}

Write-Host "Windows Terminal gefunden: $wtSettingsPath" -ForegroundColor Green
Write-Host ""

# Load the Claude profile configuration
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$profileConfigPath = Join-Path $scriptPath "claude-terminal-profile.json"

if (-not (Test-Path $profileConfigPath)) {
    Write-Host "Profil-Konfiguration nicht gefunden: $profileConfigPath" -ForegroundColor Red
    pause
    exit 1
}

$claudeConfig = Get-Content $profileConfigPath -Raw | ConvertFrom-Json
$claudeProfile = $claudeConfig.profile
$claudeScheme = $claudeConfig.scheme

# Backup existing settings
$backupPath = "$wtSettingsPath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item $wtSettingsPath $backupPath
Write-Host "Backup erstellt: $backupPath" -ForegroundColor Gray
Write-Host ""

try {
    # Read current Windows Terminal settings
    $settingsContent = Get-Content $wtSettingsPath -Raw

    # Remove comments from JSON (Windows Terminal allows comments, PowerShell doesn't)
    $settingsContent = $settingsContent -replace '(?m)^\s*//.*$', ''
    $settingsContent = $settingsContent -replace '/\*[\s\S]*?\*/', ''

    $settings = $settingsContent | ConvertFrom-Json

    Write-Host "Installiere Claude Code Profil..." -ForegroundColor Yellow

    # Add color scheme if not exists
    if (-not $settings.schemes) {
        $settings | Add-Member -NotePropertyName "schemes" -NotePropertyValue @()
    }

    # Remove existing Claude Dark scheme if present
    $settings.schemes = @($settings.schemes | Where-Object { $_.name -ne "Claude Dark" })

    # Add Claude Dark scheme
    $settings.schemes += $claudeScheme
    Write-Host "  - Claude Dark Farbschema hinzugefuegt" -ForegroundColor Gray

    # Add profile if not exists
    if (-not $settings.profiles.list) {
        $settings.profiles | Add-Member -NotePropertyName "list" -NotePropertyValue @()
    }

    # Remove existing Claude Code profile if present
    $settings.profiles.list = @($settings.profiles.list | Where-Object { $_.name -ne "Claude Code" })

    # Generate a unique GUID for the profile
    $profileGuid = "{$([guid]::NewGuid().ToString())}"
    $claudeProfile | Add-Member -NotePropertyName "guid" -NotePropertyValue $profileGuid -Force

    # Expand environment variables in icon path
    $claudeProfile.icon = $claudeProfile.icon -replace '%USERPROFILE%', $env:USERPROFILE

    # Add Claude Code profile
    $settings.profiles.list = @($claudeProfile) + $settings.profiles.list
    Write-Host "  - Claude Code Profil hinzugefuegt" -ForegroundColor Gray

    # Save updated settings
    $settings | ConvertTo-Json -Depth 100 | Set-Content $wtSettingsPath -Encoding UTF8

    Write-Host ""
    Write-Host "Installation erfolgreich abgeschlossen!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Das Claude Code Profil ist jetzt in Windows Terminal verfuegbar:" -ForegroundColor Cyan
    Write-Host "  - Oeffnen Sie Windows Terminal" -ForegroundColor White
    Write-Host "  - Klicken Sie auf den Dropdown-Pfeil neben den Tabs" -ForegroundColor White
    Write-Host "  - Waehlen Sie 'Claude Code'" -ForegroundColor White
    Write-Host ""
    Write-Host "Features:" -ForegroundColor Cyan
    Write-Host "  - Claude Dark Farbschema (dunkler Hintergrund mit lila/orange Akzenten)" -ForegroundColor White
    Write-Host "  - Cascadia Code Schriftart" -ForegroundColor White
    Write-Host "  - Transparenter Acryl-Effekt" -ForegroundColor White
    Write-Host "  - Claude Icon in der Titelleiste" -ForegroundColor White
    Write-Host ""
    Write-Host "Profil-GUID: $profileGuid" -ForegroundColor Gray

    # Save the GUID for context menu integration
    $guidFile = Join-Path $scriptPath "claude-profile-guid.txt"
    $profileGuid | Set-Content $guidFile
    Write-Host "GUID gespeichert in: $guidFile" -ForegroundColor Gray

} catch {
    Write-Host ""
    Write-Host "Fehler bei der Installation: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Backup wiederherstellen mit:" -ForegroundColor Yellow
    Write-Host "  Copy-Item '$backupPath' '$wtSettingsPath'" -ForegroundColor Gray
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
pause
