# Claude Code - Windows Terminal Profile Deinstallation
# Entfernt das Claude Code Terminal-Profil und Farbschema

Write-Host "=== Claude Code - Windows Terminal Profil Deinstallation ===" -ForegroundColor Cyan
Write-Host ""

# Windows Terminal settings paths
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
    Write-Host "Windows Terminal wurde nicht gefunden!" -ForegroundColor Yellow
    Write-Host "Nichts zu deinstallieren." -ForegroundColor Gray
    Write-Host ""
    pause
    exit 0
}

Write-Host "Windows Terminal gefunden: $wtSettingsPath" -ForegroundColor Green
Write-Host ""

# Backup existing settings
$backupPath = "$wtSettingsPath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item $wtSettingsPath $backupPath
Write-Host "Backup erstellt: $backupPath" -ForegroundColor Gray
Write-Host ""

try {
    # Read current Windows Terminal settings
    $settingsContent = Get-Content $wtSettingsPath -Raw

    # Remove comments from JSON
    $settingsContent = $settingsContent -replace '(?m)^\s*//.*$', ''
    $settingsContent = $settingsContent -replace '/\*[\s\S]*?\*/', ''

    $settings = $settingsContent | ConvertFrom-Json

    Write-Host "Entferne Claude Code Profil..." -ForegroundColor Yellow

    $removed = $false

    # Remove Claude Dark color scheme
    if ($settings.schemes) {
        $originalCount = $settings.schemes.Count
        $settings.schemes = @($settings.schemes | Where-Object { $_.name -ne "Claude Dark" })
        if ($settings.schemes.Count -lt $originalCount) {
            Write-Host "  - Claude Dark Farbschema entfernt" -ForegroundColor Gray
            $removed = $true
        }
    }

    # Remove Claude Code profile
    if ($settings.profiles.list) {
        $originalCount = $settings.profiles.list.Count
        $settings.profiles.list = @($settings.profiles.list | Where-Object { $_.name -ne "Claude Code" })
        if ($settings.profiles.list.Count -lt $originalCount) {
            Write-Host "  - Claude Code Profil entfernt" -ForegroundColor Gray
            $removed = $true
        }
    }

    if ($removed) {
        # Save updated settings
        $settings | ConvertTo-Json -Depth 100 | Set-Content $wtSettingsPath -Encoding UTF8

        Write-Host ""
        Write-Host "Deinstallation erfolgreich abgeschlossen!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "Claude Code Profil war nicht installiert." -ForegroundColor Yellow
    }

    # Remove GUID file if exists
    $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
    $guidFile = Join-Path $scriptPath "claude-profile-guid.txt"
    if (Test-Path $guidFile) {
        Remove-Item $guidFile
        Write-Host "GUID-Datei entfernt" -ForegroundColor Gray
    }

} catch {
    Write-Host ""
    Write-Host "Fehler bei der Deinstallation: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "Backup wiederherstellen mit:" -ForegroundColor Yellow
    Write-Host "  Copy-Item '$backupPath' '$wtSettingsPath'" -ForegroundColor Gray
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
pause
