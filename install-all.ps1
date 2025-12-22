# Claude Code - Windows 11 Integration - Complete Installation
# Installs all components: Diagnostics, Context Menu, URL Protocol, Terminal Profile, Shortcuts

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgefuehrt werden!"
    Write-Host "Bitte starten Sie PowerShell als Administrator und fuehren Sie das Skript erneut aus."
    pause
    exit
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "       Claude Code - Windows 11 Integration Installation            " -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

$repoRoot = $PSScriptRoot

# ============================================================================
# STEP 1: DIAGNOSTICS
# ============================================================================

Write-Host "[1/5] System-Diagnose..." -ForegroundColor Yellow
Write-Host ""

$doctorScript = Join-Path $repoRoot "scripts\diagnostics\claude-doctor.ps1"

if (Test-Path $doctorScript) {
    & powershell.exe -ExecutionPolicy Bypass -File $doctorScript -NoColor

    if ($LASTEXITCODE -eq 1) {
        Write-Host ""
        Write-Host "KRITISCHE FEHLER gefunden!" -ForegroundColor Red
        Write-Host "Bitte beheben Sie die Fehler, bevor Sie fortfahren." -ForegroundColor Yellow
        Write-Host ""
        pause
        exit 1
    }
} else {
    Write-Host "Warning: Diagnostics script not found, skipping..." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Druecken Sie Enter um fortzufahren"
Write-Host ""

# ============================================================================
# STEP 2: WINDOWS TERMINAL PROFILE
# ============================================================================

Write-Host "[2/5] Windows Terminal Profil..." -ForegroundColor Yellow
Write-Host ""

$terminalScript = Join-Path $repoRoot "scripts\terminal\install-terminal-profile.ps1"

if (Test-Path $terminalScript) {
    # Check if Windows Terminal is installed
    $wtCmd = Get-Command wt.exe -ErrorAction SilentlyContinue

    if ($wtCmd) {
        Write-Host "Windows Terminal gefunden. Installiere Profil..." -ForegroundColor Green
        & powershell.exe -ExecutionPolicy Bypass -File $terminalScript
    } else {
        Write-Host "Windows Terminal nicht gefunden - ueberspringe Profil-Installation." -ForegroundColor Yellow
        Write-Host "Sie koennen es spaeter manuell installieren mit:" -ForegroundColor Gray
        Write-Host "  $terminalScript" -ForegroundColor Gray
    }
} else {
    Write-Host "Warning: Terminal profile script not found, skipping..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Weiter zur naechsten Installation..." -ForegroundColor Gray
Start-Sleep -Seconds 2
Write-Host ""

# ============================================================================
# STEP 3: CONTEXT MENU
# ============================================================================

Write-Host "[3/5] Explorer-Kontextmenue..." -ForegroundColor Yellow
Write-Host ""

$contextMenuScript = Join-Path $repoRoot "scripts\registry\install-context-menu-extended.ps1"

if (Test-Path $contextMenuScript) {
    Write-Host "Installiere erweiterte Kontextmenue-Eintraege..." -ForegroundColor Green
    & powershell.exe -ExecutionPolicy Bypass -File $contextMenuScript
} else {
    Write-Host "Warning: Context menu script not found, skipping..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Weiter zur naechsten Installation..." -ForegroundColor Gray
Start-Sleep -Seconds 2
Write-Host ""

# ============================================================================
# STEP 4: URL PROTOCOL
# ============================================================================

Write-Host "[4/5] URL Protocol (claude://)..." -ForegroundColor Yellow
Write-Host ""

$urlProtocolScript = Join-Path $repoRoot "scripts\url-protocol\install-url-protocol.ps1"

if (Test-Path $urlProtocolScript) {
    Write-Host "Installiere claude:// URL Protocol..." -ForegroundColor Green
    & powershell.exe -ExecutionPolicy Bypass -File $urlProtocolScript
} else {
    Write-Host "Warning: URL protocol script not found, skipping..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Weiter zur naechsten Installation..." -ForegroundColor Gray
Start-Sleep -Seconds 2
Write-Host ""

# ============================================================================
# STEP 5: START MENU SHORTCUTS
# ============================================================================

Write-Host "[5/5] Startmenue-Shortcuts..." -ForegroundColor Yellow
Write-Host ""

$shortcutsScript = Join-Path $repoRoot "scripts\shortcuts\install-shortcuts.ps1"

if (Test-Path $shortcutsScript) {
    Write-Host "Installiere Start-Menue Shortcuts..." -ForegroundColor Green
    & powershell.exe -ExecutionPolicy Bypass -File $shortcutsScript
} else {
    Write-Host "Warning: Shortcuts script not found, skipping..." -ForegroundColor Yellow
}

Write-Host ""

# ============================================================================
# COMPLETION
# ============================================================================

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host "                   Installation abgeschlossen!                      " -ForegroundColor Green
Write-Host "=====================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Installierte Komponenten:" -ForegroundColor Cyan
Write-Host "  [✓] Windows Terminal Profil (falls Windows Terminal installiert)" -ForegroundColor White
Write-Host "  [✓] Explorer-Kontextmenue (Ordner, Dateien, Hintergrund)" -ForegroundColor White
Write-Host "  [✓] claude:// URL Protocol" -ForegroundColor White
Write-Host "  [✓] Startmenue-Shortcuts" -ForegroundColor White
Write-Host ""
Write-Host "Naechste Schritte:" -ForegroundColor Yellow
Write-Host "  1. Starten Sie den Explorer neu (explorer.exe beenden/neu starten)" -ForegroundColor White
Write-Host "  2. Testen Sie das Kontextmenue: Rechtsklick auf Ordner -> Claude Code" -ForegroundColor White
Write-Host "  3. Druecken Sie Win-Taste und geben Sie 'Claude' ein" -ForegroundColor White
Write-Host ""
Write-Host "Bei Problemen:" -ForegroundColor Yellow
Write-Host "  Fuehren Sie 'Claude Doctor' aus dem Startmenue aus" -ForegroundColor White
Write-Host "  oder rufen Sie auf:" -ForegroundColor White
Write-Host "  $doctorScript" -ForegroundColor Gray
Write-Host ""

pause
