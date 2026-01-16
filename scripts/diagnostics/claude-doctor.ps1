# Claude Code - System Diagnostics and Repair Tool
# Checks system configuration and fixes common issues automatically

param(
    [switch]$Verbose,
    [switch]$NoColor,
    [switch]$NoFix
)

# ============================================================================
# SCRIPT EXECUTION POLICY CHECK
# ============================================================================

# Check if script execution is allowed (early check)
$execPolicy = Get-ExecutionPolicy -Scope CurrentUser

if ($execPolicy -eq "Restricted" -or $execPolicy -eq "Undefined") {
    Write-Host ""
    Write-Host "=====================================================================" -ForegroundColor Red
    Write-Host "   WARNUNG: PowerShell Script-Ausfuehrung ist deaktiviert!          " -ForegroundColor Red
    Write-Host "=====================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Aktuelle ExecutionPolicy: $execPolicy" -ForegroundColor Yellow
    Write-Host ""

    if ($NoFix) {
        Write-Host "HINWEIS: -NoFix Parameter erkannt, Diagnose wird fortgesetzt." -ForegroundColor Cyan
        Write-Host "Automatische Reparaturen sind deaktiviert." -ForegroundColor Cyan
        Write-Host ""
    } else {
        Write-Host "Soll die Execution Policy jetzt auf 'RemoteSigned' gesetzt werden?" -ForegroundColor Cyan
        Write-Host "(Empfohlen - erlaubt lokale Scripts sicher)" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Optionen:" -ForegroundColor White
        Write-Host "  [J] Ja - ExecutionPolicy auf RemoteSigned setzen" -ForegroundColor Gray
        Write-Host "  [R] Read-Only - Nur Diagnose ohne Reparaturen" -ForegroundColor Gray
        Write-Host "  [N] Nein - Skript beenden" -ForegroundColor Gray
        Write-Host ""
        $response = Read-Host "Ihre Wahl (J/R/N)"

        if ($response -match '^[Jj]') {
            Write-Host ""
            Write-Host "Aendere Execution Policy..." -ForegroundColor Cyan
            try {
                Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
                Write-Host "Execution Policy wurde erfolgreich auf 'RemoteSigned' gesetzt!" -ForegroundColor Green
                Write-Host ""
            } catch {
                Write-Host ""
                Write-Host "Fehler beim Aendern der Execution Policy: $_" -ForegroundColor Red
                Write-Host ""
                Write-Host "Weiter im Read-Only Modus (keine Reparaturen)..." -ForegroundColor Yellow
                Write-Host ""
                $NoFix = $true
            }
        } elseif ($response -match '^[Rr]') {
            Write-Host ""
            Write-Host "Read-Only Modus aktiviert - nur Diagnose, keine Reparaturen." -ForegroundColor Cyan
            Write-Host ""
            $NoFix = $true
        } else {
            Write-Host ""
            Write-Host "Diagnose abgebrochen." -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Um die Execution Policy manuell zu aendern:" -ForegroundColor Cyan
            Write-Host "  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Gray
            Write-Host ""
            exit 1
        }
    }
}

# ============================================================================
# ADMINISTRATOR PRIVILEGES CHECK
# ============================================================================

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin -and -not $NoFix) {
    Write-Host ""
    Write-Host "=====================================================================" -ForegroundColor Yellow
    Write-Host "   HINWEIS: Nicht als Administrator ausgefuehrt                     " -ForegroundColor Yellow
    Write-Host "=====================================================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Einige Reparaturen benoetigen Administrator-Rechte." -ForegroundColor White
    Write-Host ""
    Write-Host "Optionen:" -ForegroundColor Cyan
    Write-Host "  [A] Als Administrator neu starten (empfohlen fuer Reparaturen)" -ForegroundColor Gray
    Write-Host "  [R] Read-Only Modus (nur Diagnose, keine Reparaturen)" -ForegroundColor Gray
    Write-Host "  [C] Fortfahren ohne Admin (eingeschraenkte Reparaturen)" -ForegroundColor Gray
    Write-Host ""
    $response = Read-Host "Ihre Wahl (A/R/C)"

    if ($response -match '^[Aa]') {
        Write-Host ""
        Write-Host "Starte als Administrator neu..." -ForegroundColor Cyan
        try {
            $scriptPath = $PSCommandPath
            $workingDir = $PSScriptRoot

            # Build arguments with current parameters
            $argList = @(
                "-NoProfile"
                "-ExecutionPolicy", "Bypass"
                "-File", "`"$scriptPath`""
            )

            if ($Verbose) { $argList += "-Verbose" }
            if ($NoColor) { $argList += "-NoColor" }

            # Start elevated process
            Start-Process -FilePath "powershell.exe" `
                         -ArgumentList $argList `
                         -WorkingDirectory $workingDir `
                         -Verb RunAs `
                         -Wait

            exit
        } catch {
            Write-Host ""
            Write-Host "Fehler beim Neustart: $_" -ForegroundColor Red
            Write-Host "Fortfahren im eingeschraenkten Modus..." -ForegroundColor Yellow
            Write-Host ""
        }
    } elseif ($response -match '^[Rr]') {
        Write-Host ""
        Write-Host "Read-Only Modus aktiviert." -ForegroundColor Cyan
        Write-Host ""
        $NoFix = $true
    } else {
        Write-Host ""
        Write-Host "Fortfahren mit eingeschraenkten Reparaturmoeglichkeiten." -ForegroundColor Yellow
        Write-Host ""
    }
}

# Color output functions
function Write-Status {
    param([string]$Message, [string]$Status)

    $statusColor = switch ($Status) {
        "OK"    { "Green" }
        "WARN"  { "Yellow" }
        "FIXED" { "Cyan" }
        "FAIL"  { "Red" }
        default { "White" }
    }

    $icon = switch ($Status) {
        "OK"    { "[+]" }
        "WARN"  { "[!]" }
        "FIXED" { "[*]" }
        "FAIL"  { "[X]" }
        default { "[-]" }
    }

    if ($NoColor) {
        Write-Host "$icon $Status - $Message"
    } else {
        Write-Host "$icon " -ForegroundColor $statusColor -NoNewline
        Write-Host "$Status" -ForegroundColor $statusColor -NoNewline
        Write-Host " - $Message"
    }
}

function Write-Detail {
    param([string]$Message)
    if ($Verbose) {
        Write-Host "    $Message" -ForegroundColor Gray
    }
}

# Results tracking
$script:FailCount = 0
$script:WarnCount = 0
$script:FixCount = 0
$script:OkCount = 0

function Update-Stats {
    param([string]$Status)
    switch ($Status) {
        "OK"    { $script:OkCount++ }
        "WARN"  { $script:WarnCount++ }
        "FIXED" { $script:FixCount++ }
        "FAIL"  { $script:FailCount++ }
    }
}

# ============================================================================
# DIAGNOSTIC CHECKS
# ============================================================================

Write-Host ""
Write-Host "=== Claude Code - System Diagnostics ===" -ForegroundColor Cyan
Write-Host ""

# ----------------------------------------------------------------------------
# 1. Check Claude executable
# ----------------------------------------------------------------------------

Write-Host "Checking Claude Code installation..." -ForegroundColor Yellow
Write-Host ""

# Check if claude command is available
$claudeCmd = Get-Command claude -ErrorAction SilentlyContinue

if ($claudeCmd) {
    Write-Status "Claude command found in PATH" "OK"
    Write-Detail "Location: $($claudeCmd.Source)"
    Update-Stats "OK"

    # Try to get version
    try {
        $version = & claude --version 2>&1 | Select-Object -First 1
        Write-Detail "Version: $version"
    } catch {
        Write-Detail "Could not determine version"
    }
} else {
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
        Write-Status "Claude found but not in PATH" "WARN"
        Write-Detail "Location: $foundPath"
        Update-Stats "WARN"

        if (-not $NoFix) {
            # Try to add to PATH
            $dirPath = Split-Path $foundPath -Parent
            $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

            if ($currentPath -notlike "*$dirPath*") {
                Write-Detail "Attempting to add to PATH..."
                try {
                    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$dirPath", "User")
                    Write-Status "Claude added to PATH (restart terminal to apply)" "FIXED"
                    Update-Stats "FIXED"
                } catch {
                    Write-Status "Failed to add to PATH: $_" "FAIL"
                    Update-Stats "FAIL"
                }
            }
        }
    } else {
        Write-Status "Claude command not found" "FAIL"
        Write-Detail "Install Claude from: https://claude.ai"
        Update-Stats "FAIL"
    }
}

Write-Host ""

# ----------------------------------------------------------------------------
# 2. Check Git installation and find correct bash
# ----------------------------------------------------------------------------

Write-Host "Checking Git installation..." -ForegroundColor Yellow
Write-Host ""

$gitCmd = Get-Command git -ErrorAction SilentlyContinue

if ($gitCmd) {
    Write-Status "Git command found" "OK"
    Write-Detail "Location: $($gitCmd.Source)"
    Update-Stats "OK"

    # Get Git version
    try {
        $gitVersion = & git --version 2>&1
        Write-Detail "Version: $gitVersion"
    } catch {
        Write-Detail "Could not determine version"
    }

    # Find the correct bash.exe (Git\bin\bash.exe, NOT git-bash.exe)
    $gitPath = Split-Path $gitCmd.Source -Parent
    $gitRoot = Split-Path $gitPath -Parent

    # Check for Git\bin\bash.exe
    $bashPath = Join-Path $gitRoot "bin\bash.exe"

    if (Test-Path $bashPath) {
        Write-Status "Git bash found (correct path)" "OK"
        Write-Detail "Location: $bashPath"
        Update-Stats "OK"
    } else {
        # Try alternative locations
        $altBashPaths = @(
            "C:\Program Files\Git\bin\bash.exe",
            "C:\Program Files (x86)\Git\bin\bash.exe",
            "$env:LOCALAPPDATA\Programs\Git\bin\bash.exe"
        )

        $foundBash = $false
        foreach ($altPath in $altBashPaths) {
            if (Test-Path $altPath) {
                Write-Status "Git bash found at alternative location" "WARN"
                Write-Detail "Location: $altPath"
                Write-Detail "Recommended: Use Git\bin\bash.exe, not git-bash.exe"
                Update-Stats "WARN"
                $foundBash = $true
                break
            }
        }

        if (-not $foundBash) {
            Write-Status "Git bash not found (Git\bin\bash.exe)" "WARN"
            Write-Detail "This may cause issues with shell scripts"
            Update-Stats "WARN"
        }
    }
} else {
    Write-Status "Git not found" "FAIL"
    Write-Detail "Install Git from: https://git-scm.com/download/win"
    Update-Stats "FAIL"
}

Write-Host ""

# ----------------------------------------------------------------------------
# 3. Check Windows Terminal
# ----------------------------------------------------------------------------

Write-Host "Checking Windows Terminal..." -ForegroundColor Yellow
Write-Host ""

$wtCmd = Get-Command wt.exe -ErrorAction SilentlyContinue

if ($wtCmd) {
    Write-Status "Windows Terminal found" "OK"
    Update-Stats "OK"

    # Check for settings file
    $wtSettingsPaths = @(
        "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json",
        "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"
    )

    $settingsFound = $false
    foreach ($settingsPath in $wtSettingsPaths) {
        if (Test-Path $settingsPath) {
            Write-Detail "Settings: $settingsPath"
            $settingsFound = $true
            break
        }
    }

    if (-not $settingsFound) {
        Write-Status "Windows Terminal settings not found" "WARN"
        Update-Stats "WARN"
    }
} else {
    Write-Status "Windows Terminal not found" "WARN"
    Write-Detail "Install from Microsoft Store: https://aka.ms/terminal"
    Write-Detail "Claude Code works without it, but WT provides better experience"
    Update-Stats "WARN"
}

Write-Host ""

# ----------------------------------------------------------------------------
# 4. Check Claude Terminal Profile
# ----------------------------------------------------------------------------

Write-Host "Checking Claude Terminal Profile..." -ForegroundColor Yellow
Write-Host ""

$scriptRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$guidFile = Join-Path $scriptRoot "claude-profile-guid.txt"

if (Test-Path $guidFile) {
    $profileGuid = Get-Content $guidFile -Raw
    Write-Status "Claude profile GUID found" "OK"
    Write-Detail "GUID: $profileGuid"
    Update-Stats "OK"

    # Check if profile exists in Windows Terminal settings
    if ($wtCmd -and $settingsFound) {
        try {
            $settings = Get-Content $settingsPath -Raw
            if ($settings -like "*Claude Code*") {
                Write-Status "Claude profile installed in Windows Terminal" "OK"
                Update-Stats "OK"
            } else {
                Write-Status "Claude profile GUID exists but not in WT settings" "WARN"
                Write-Detail "Run install-terminal-profile.ps1 to reinstall"
                Update-Stats "WARN"
            }
        } catch {
            Write-Detail "Could not parse settings file"
        }
    }
} else {
    Write-Status "Claude Terminal profile not installed" "WARN"
    Write-Detail "Run: scripts\terminal\install-terminal-profile.ps1"
    Update-Stats "WARN"
}

Write-Host ""

# ----------------------------------------------------------------------------
# 5. Check Node.js (Optional)
# ----------------------------------------------------------------------------

Write-Host "Checking optional components..." -ForegroundColor Yellow
Write-Host ""

$nodeCmd = Get-Command node -ErrorAction SilentlyContinue

if ($nodeCmd) {
    Write-Status "Node.js found" "OK"
    try {
        $nodeVersion = & node --version 2>&1
        Write-Detail "Version: $nodeVersion"
    } catch {}
    Update-Stats "OK"
} else {
    Write-Status "Node.js not found (optional)" "WARN"
    Write-Detail "Install from: https://nodejs.org (recommended for development)"
    Update-Stats "WARN"
}

# ----------------------------------------------------------------------------
# 6. Check WSL (Optional)
# ----------------------------------------------------------------------------

$wslCmd = Get-Command wsl -ErrorAction SilentlyContinue

if ($wslCmd) {
    Write-Status "WSL found" "OK"
    try {
        $wslVersion = & wsl --version 2>&1 | Select-Object -First 1
        Write-Detail "Version: $wslVersion"
    } catch {}
    Update-Stats "OK"
} else {
    Write-Status "WSL not found (optional)" "WARN"
    Write-Detail "Install with: wsl --install"
    Update-Stats "WARN"
}

# ----------------------------------------------------------------------------
# 7. Check PowerShell Execution Policy
# ----------------------------------------------------------------------------

# Re-check ExecutionPolicy (may have been changed at script start)
$currentExecPolicy = Get-ExecutionPolicy -Scope CurrentUser

if ($currentExecPolicy -eq "Restricted" -or $currentExecPolicy -eq "Undefined") {
    Write-Status "PowerShell execution policy is $currentExecPolicy" "WARN"
    Write-Detail "This may prevent scripts from running"
    Write-Detail "Policy should have been fixed at startup, but requires admin rights"
    Update-Stats "WARN"

    if (-not $NoFix -and $isAdmin) {
        Write-Detail "Attempting to fix (Admin mode)..."
        try {
            Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
            Write-Status "Execution policy set to RemoteSigned" "FIXED"
            Update-Stats "FIXED"
        } catch {
            Write-Status "Failed to change execution policy: $_" "FAIL"
            Write-Detail "Run manually: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
            Update-Stats "FAIL"
        }
    }
} else {
    Write-Status "PowerShell execution policy: $currentExecPolicy" "OK"
    Update-Stats "OK"
}

Write-Host ""

# ============================================================================
# SUMMARY
# ============================================================================

Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "  OK:    $script:OkCount" -ForegroundColor Green
Write-Host "  WARN:  $script:WarnCount" -ForegroundColor Yellow
Write-Host "  FIXED: $script:FixCount" -ForegroundColor Cyan
Write-Host "  FAIL:  $script:FailCount" -ForegroundColor Red
Write-Host ""

if ($script:FailCount -gt 0) {
    Write-Host "Critical issues found. Please resolve FAIL items before using Claude Code." -ForegroundColor Red
    exit 1
} elseif ($script:WarnCount -gt 0) {
    Write-Host "System operational with warnings. Consider resolving WARN items." -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "All checks passed. System ready for Claude Code." -ForegroundColor Green
    exit 0
}
