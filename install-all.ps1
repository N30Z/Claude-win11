# Claude Code - Windows 11 Integration - Complete Installation
# Installs all components: Diagnostics, Context Menu, URL Protocol, Terminal Profile, Shortcuts

# Check for Administrator privileges and auto-elevate if needed
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host ""
    Write-Host "Dieses Skript benoetigt Administrator-Rechte." -ForegroundColor Yellow
    Write-Host "UAC-Dialog wird aufgerufen..." -ForegroundColor Cyan
    Write-Host ""

    # Re-launch the script with Administrator privileges
    try {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    } catch {
        Write-Error "Fehler beim Aufrufen von UAC: $_"
        Write-Host ""
        Write-Host "Bitte starten Sie PowerShell manuell als Administrator und fuehren Sie das Skript erneut aus." -ForegroundColor Yellow
        pause
        exit 1
    }
}

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "       Claude Code - Windows 11 Integration Installation            " -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

$repoRoot = $PSScriptRoot

# ============================================================================
# STEP 0: CHECK CLAUDE CLI INSTALLATION
# ============================================================================

Write-Host "[0/5] Claude CLI Installations-Pruefung..." -ForegroundColor Yellow
Write-Host ""

# Check if claude command is available
$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue

if (-not $claudeCmd) {
    Write-Host "Claude CLI wurde nicht gefunden!" -ForegroundColor Red
    Write-Host ""

    # Check common installation locations
    $commonPaths = @(
        "$env:USERPROFILE\.local\bin\claude.exe",
        "$env:LOCALAPPDATA\Programs\Claude\claude.exe",
        "$env:ProgramFiles\Claude\claude.exe",
        "$env:ProgramFiles(x86)\Claude\claude.exe"
    )

    $foundPath = $null
    foreach ($path in $commonPaths) {
        if (Test-Path $path) {
            $foundPath = $path
            break
        }
    }

    if ($foundPath) {
        Write-Host "Claude CLI gefunden in: $foundPath" -ForegroundColor Yellow
        Write-Host "Aber nicht im PATH verfuegbar." -ForegroundColor Yellow
        Write-Host ""

        # Try to add to PATH
        $dirPath = Split-Path $foundPath -Parent
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

        if ($currentPath -notlike "*$dirPath*") {
            Write-Host "Fuege Claude CLI zum PATH hinzu..." -ForegroundColor Cyan
            try {
                [Environment]::SetEnvironmentVariable("Path", "$currentPath;$dirPath", "User")
                Write-Host "Claude CLI wurde zum PATH hinzugefuegt." -ForegroundColor Green
                Write-Host "WICHTIG: Bitte starten Sie PowerShell neu, damit die Aenderungen wirksam werden." -ForegroundColor Yellow
                Write-Host ""
            } catch {
                Write-Host "Fehler beim Hinzufuegen zum PATH: $_" -ForegroundColor Red
                Write-Host ""
            }
        }
    } else {
        Write-Host "Moechten Sie Claude CLI jetzt installieren? (J/N)" -ForegroundColor Cyan
        $response = Read-Host "Antwort"

        if ($response -match '^[Jj]') {
            Write-Host ""
            Write-Host "Installiere Claude CLI..." -ForegroundColor Cyan
            Write-Host ""

            # Check if npm is available
            $npmCmd = Get-Command npm -ErrorAction SilentlyContinue

            if ($npmCmd) {
                Write-Host "Verwende npm zur Installation..." -ForegroundColor Gray
                try {
                    # Install Claude CLI globally via npm
                    $installResult = npm install -g @anthropics/claude-code 2>&1

                    if ($LASTEXITCODE -eq 0) {
                        Write-Host ""
                        Write-Host "Claude CLI wurde erfolgreich installiert!" -ForegroundColor Green
                        Write-Host ""

                        # Refresh PATH for current session
                        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

                        # Verify installation
                        $claudeCmd = Get-Command claude -ErrorAction SilentlyContinue
                        if ($claudeCmd) {
                            Write-Host "Verifizierung erfolgreich: Claude CLI ist jetzt verfuegbar." -ForegroundColor Green
                            try {
                                $version = & claude --version 2>&1 | Select-Object -First 1
                                Write-Host "Version: $version" -ForegroundColor Gray
                            } catch {}
                        } else {
                            Write-Host "Installation abgeschlossen, aber 'claude' ist noch nicht im PATH." -ForegroundColor Yellow
                            Write-Host "Bitte starten Sie PowerShell neu und fuehren Sie dieses Skript erneut aus." -ForegroundColor Yellow
                        }
                    } else {
                        Write-Host ""
                        Write-Host "Fehler bei der Installation von Claude CLI:" -ForegroundColor Red
                        Write-Host $installResult -ForegroundColor Gray
                        Write-Host ""
                        Write-Host "Bitte installieren Sie Claude CLI manuell:" -ForegroundColor Yellow
                        Write-Host "  npm install -g @anthropics/claude-code" -ForegroundColor Gray
                        Write-Host "oder besuchen Sie: https://github.com/anthropics/claude-code" -ForegroundColor Gray
                        Write-Host ""
                        pause
                        exit 1
                    }
                } catch {
                    Write-Host ""
                    Write-Host "Fehler bei der Installation: $_" -ForegroundColor Red
                    Write-Host ""
                    Write-Host "Bitte installieren Sie Claude CLI manuell:" -ForegroundColor Yellow
                    Write-Host "  npm install -g @anthropics/claude-code" -ForegroundColor Gray
                    Write-Host ""
                    pause
                    exit 1
                }
            } else {
                Write-Host "npm wurde nicht gefunden!" -ForegroundColor Red
                Write-Host ""
                Write-Host "Claude CLI benoetigt Node.js und npm zur Installation." -ForegroundColor Yellow
                Write-Host ""
                Write-Host "Bitte installieren Sie Node.js von: https://nodejs.org" -ForegroundColor Cyan
                Write-Host "Danach fuehren Sie aus: npm install -g @anthropics/claude-code" -ForegroundColor Gray
                Write-Host ""
                Write-Host "Alternativ besuchen Sie:" -ForegroundColor Yellow
                Write-Host "  https://github.com/anthropics/claude-code" -ForegroundColor Gray
                Write-Host ""
                pause
                exit 1
            }
        } else {
            Write-Host ""
            Write-Host "Installation abgebrochen." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Claude CLI wird benoetigt fuer die Windows 11 Integration." -ForegroundColor Yellow
            Write-Host "Bitte installieren Sie Claude CLI manuell und fuehren Sie dieses Skript erneut aus:" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Installation via npm:" -ForegroundColor White
            Write-Host "  npm install -g @anthropics/claude-code" -ForegroundColor Gray
            Write-Host ""
            Write-Host "Weitere Informationen:" -ForegroundColor White
            Write-Host "  https://github.com/anthropics/claude-code" -ForegroundColor Gray
            Write-Host ""
            pause
            exit 1
        }
    }
} else {
    Write-Host "Claude CLI gefunden!" -ForegroundColor Green
    try {
        $version = & claude --version 2>&1 | Select-Object -First 1
        Write-Host "Version: $version" -ForegroundColor Gray
    } catch {
        Write-Host "Claude CLI ist installiert." -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "Weiter mit System-Diagnose..." -ForegroundColor Gray
Start-Sleep -Seconds 2
Write-Host ""

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
