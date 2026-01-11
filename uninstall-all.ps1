# Claude Code - Windows 11 Integration - Complete Uninstallation
# Removes all components

# ============================================================================
# SCRIPT EXECUTION POLICY CHECK
# ============================================================================

# Check if script execution is allowed
$execPolicy = Get-ExecutionPolicy -Scope CurrentUser

if ($execPolicy -eq "Restricted" -or $execPolicy -eq "Undefined") {
    Write-Host ""
    Write-Host "=====================================================================" -ForegroundColor Red
    Write-Host "   WARNUNG: PowerShell Script-Ausfuehrung ist deaktiviert!          " -ForegroundColor Red
    Write-Host "=====================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Aktuelle ExecutionPolicy: $execPolicy" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Dieses Skript kann nicht ausgefuehrt werden, solange die" -ForegroundColor White
    Write-Host "Execution Policy auf 'Restricted' oder 'Undefined' steht." -ForegroundColor White
    Write-Host ""
    Write-Host "Soll die Execution Policy jetzt auf 'RemoteSigned' gesetzt werden?" -ForegroundColor Cyan
    Write-Host "(Empfohlen und sicher - erlaubt lokale Scripts)" -ForegroundColor Gray
    Write-Host ""
    $response = Read-Host "Execution Policy aendern? (J/N)"

    if ($response -match '^[Jj]') {
        Write-Host ""
        Write-Host "Aendere Execution Policy..." -ForegroundColor Cyan
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Host "Execution Policy wurde erfolgreich auf 'RemoteSigned' gesetzt!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Bitte fuehren Sie dieses Skript erneut aus." -ForegroundColor Yellow
            Write-Host ""
            pause
            exit 0
        } catch {
            Write-Host ""
            Write-Host "Fehler beim Aendern der Execution Policy: $_" -ForegroundColor Red
            Write-Host ""
            Write-Host "Bitte fuehren Sie folgenden Befehl manuell als Administrator aus:" -ForegroundColor Yellow
            Write-Host "  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor White
            Write-Host ""
            pause
            exit 1
        }
    } else {
        Write-Host ""
        Write-Host "Deinstallation abgebrochen." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Um dieses Skript auszufuehren, haben Sie folgende Optionen:" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Option 1 - Execution Policy aendern (empfohlen):" -ForegroundColor White
        Write-Host "  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Option 2 - Einmalig mit Bypass ausfuehren:" -ForegroundColor White
        Write-Host "  powershell -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -ForegroundColor Gray
        Write-Host ""
        pause
        exit 1
    }
}

# ============================================================================
# ADMINISTRATOR PRIVILEGES CHECK
# ============================================================================

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host ""
    Write-Host "Dieses Skript benoetigt Administrator-Rechte." -ForegroundColor Yellow
    Write-Host "UAC-Dialog wird aufgerufen..." -ForegroundColor Cyan
    Write-Host ""

    # Re-launch the script with Administrator privileges
    try {
        $scriptPath = $PSCommandPath
        $workingDir = $PSScriptRoot

        # Build arguments properly to handle paths with spaces
        $arguments = @(
            "-NoProfile"
            "-ExecutionPolicy", "Bypass"
            "-File", "`"$scriptPath`""
        )

        # Start new elevated process
        $process = Start-Process -FilePath "powershell.exe" `
                                  -ArgumentList $arguments `
                                  -WorkingDirectory $workingDir `
                                  -Verb RunAs `
                                  -PassThru

        # Exit current non-elevated process
        exit
    } catch {
        Write-Host ""
        Write-Host "Fehler beim Aufrufen von UAC: $_" -ForegroundColor Red
        Write-Host ""
        Write-Host "Moegliche Ursachen:" -ForegroundColor Yellow
        Write-Host "  - UAC wurde abgebrochen" -ForegroundColor Gray
        Write-Host "  - Keine Berechtigung zum Erhoehen der Rechte" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Bitte starten Sie PowerShell manuell als Administrator und" -ForegroundColor Yellow
        Write-Host "fuehren Sie das Skript erneut aus:" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  1. Rechtsklick auf PowerShell" -ForegroundColor White
        Write-Host "  2. 'Als Administrator ausfuehren' waehlen" -ForegroundColor White
        Write-Host "  3. Zu diesem Ordner navigieren: $PSScriptRoot" -ForegroundColor White
        Write-Host "  4. Skript ausfuehren: .\uninstall-all.ps1" -ForegroundColor White
        Write-Host ""
        pause
        exit 1
    }
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
