# Claude Code - Windows 11 Integration - Complete Uninstallation
# Removes all components

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgefuehrt werden!"
    Write-Host "Bitte starten Sie PowerShell als Administrator und fuehren Sie das Skript erneut aus."
    pause
    exit
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "      Claude Code - Windows 11 Integration Deinstallation          " -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

$repoRoot = $PSScriptRoot

Write-Host "Diese Aktion entfernt alle Claude Code Windows-Integrationen." -ForegroundColor Yellow
Write-Host ""
$confirm = Read-Host "Moechten Sie fortfahren? (J/N)"

if ($confirm -ne "J" -and $confirm -ne "j") {
    Write-Host "Deinstallation abgebrochen." -ForegroundColor Yellow
    pause
    exit
}

Write-Host ""

# ============================================================================
# UNINSTALL COMPONENTS
# ============================================================================

$uninstallScripts = @(
    @{ Name = "Context Menu"; Path = "scripts\registry\uninstall-context-menu-extended.ps1" },
    @{ Name = "URL Protocol"; Path = "scripts\url-protocol\uninstall-url-protocol.ps1" },
    @{ Name = "Shortcuts"; Path = "scripts\shortcuts\uninstall-shortcuts.ps1" },
    @{ Name = "Terminal Profile"; Path = "scripts\terminal\uninstall-terminal-profile.ps1" }
)

$count = 1
$total = $uninstallScripts.Count

foreach ($script in $uninstallScripts) {
    Write-Host "[$count/$total] $($script.Name)..." -ForegroundColor Yellow
    Write-Host ""

    $scriptPath = Join-Path $repoRoot $script.Path

    if (Test-Path $scriptPath) {
        & powershell.exe -ExecutionPolicy Bypass -File $scriptPath
    } else {
        Write-Host "  Script nicht gefunden: $scriptPath" -ForegroundColor Yellow
    }

    Write-Host ""
    $count++
}

# ============================================================================
# COMPLETION
# ============================================================================

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host "                 Deinstallation abgeschlossen!                      " -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Alle Claude Code Windows-Integrationen wurden entfernt." -ForegroundColor Cyan
Write-Host ""
Write-Host "Hinweis:" -ForegroundColor Yellow
Write-Host "  - Claude Code selbst wurde NICHT deinstalliert" -ForegroundColor White
Write-Host "  - Starten Sie den Explorer neu (explorer.exe)" -ForegroundColor White
Write-Host ""

pause
