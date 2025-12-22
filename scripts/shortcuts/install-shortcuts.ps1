# Claude Code - Windows Shortcuts Installation
# Creates Start Menu shortcuts for Claude Code

Write-Host "=== Claude Code - Shortcuts Installation ===" -ForegroundColor Cyan
Write-Host ""

# Determine repository root
$repoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent

# Icon and executable paths
$claudeExe = "$env:USERPROFILE\.local\bin\claude.exe"
$claudeIcon = $claudeExe

# Check if claude.exe exists
if (-not (Test-Path $claudeExe)) {
    Write-Host "Warning: Claude executable not found at: $claudeExe" -ForegroundColor Yellow
    Write-Host "Shortcuts will be created but may not work until Claude is installed." -ForegroundColor Yellow
    Write-Host ""
}

# Start Menu path (current user)
$startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Claude Code"

# Create directory if it doesn't exist
if (-not (Test-Path $startMenuPath)) {
    New-Item -Path $startMenuPath -ItemType Directory -Force | Out-Null
    Write-Host "Created Start Menu folder: $startMenuPath" -ForegroundColor Green
}

# Create WScript.Shell COM object for creating shortcuts
$shell = New-Object -ComObject WScript.Shell

try {
    # ========================================================================
    # 1. Claude Code Shortcut
    # ========================================================================

    Write-Host "Creating shortcuts..." -ForegroundColor Yellow
    Write-Host ""

    $claudeShortcut = Join-Path $startMenuPath "Claude Code.lnk"
    $shortcut = $shell.CreateShortcut($claudeShortcut)
    $shortcut.TargetPath = "wt.exe"
    $shortcut.Arguments = "-p `"Claude Code`" -- claude"
    $shortcut.WorkingDirectory = $env:USERPROFILE
    $shortcut.Description = "Start Claude Code in Windows Terminal"
    if (Test-Path $claudeIcon) {
        $shortcut.IconLocation = $claudeIcon
    }
    $shortcut.Save()

    Write-Host "  [1/3] Claude Code - OK" -ForegroundColor Green

    # ========================================================================
    # 2. Claude Doctor Shortcut
    # ========================================================================

    $doctorScript = Join-Path $repoRoot "scripts\diagnostics\claude-doctor.ps1"
    $doctorShortcut = Join-Path $startMenuPath "Claude Doctor.lnk"

    $shortcut = $shell.CreateShortcut($doctorShortcut)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-ExecutionPolicy Bypass -NoExit -File `"$doctorScript`" -Verbose"
    $shortcut.WorkingDirectory = $repoRoot
    $shortcut.Description = "Run Claude Code system diagnostics"
    if (Test-Path $claudeIcon) {
        $shortcut.IconLocation = $claudeIcon
    }
    $shortcut.Save()

    Write-Host "  [2/3] Claude Doctor - OK" -ForegroundColor Green

    # ========================================================================
    # 3. Open Last Project Shortcut (optional)
    # ========================================================================

    # This creates a shortcut that opens Claude in the user's home directory
    # Users can manually edit this to point to their most-used project

    $lastProjectShortcut = Join-Path $startMenuPath "Claude Code (Letztes Projekt).lnk"

    $shortcut = $shell.CreateShortcut($lastProjectShortcut)
    $shortcut.TargetPath = "wt.exe"
    $shortcut.Arguments = "-p `"Claude Code`" -d `"$env:USERPROFILE`" -- claude"
    $shortcut.WorkingDirectory = $env:USERPROFILE
    $shortcut.Description = "Start Claude Code in your last project (edit shortcut to change path)"
    if (Test-Path $claudeIcon) {
        $shortcut.IconLocation = $claudeIcon
    }
    $shortcut.Save()

    Write-Host "  [3/3] Claude Code (Letztes Projekt) - OK" -ForegroundColor Green

    # ========================================================================
    # SUCCESS
    # ========================================================================

    Write-Host ""
    Write-Host "Installation erfolgreich!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Shortcuts erstellt in:" -ForegroundColor Cyan
    Write-Host "  $startMenuPath" -ForegroundColor White
    Write-Host ""
    Write-Host "Verfuegbare Shortcuts:" -ForegroundColor Yellow
    Write-Host "  [1] Claude Code" -ForegroundColor White
    Write-Host "      - Startet Claude Code in Windows Terminal" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [2] Claude Doctor" -ForegroundColor White
    Write-Host "      - System-Diagnose und Reparatur" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  [3] Claude Code (Letztes Projekt)" -ForegroundColor White
    Write-Host "      - Oeffnet Claude im Standard-Verzeichnis" -ForegroundColor Gray
    Write-Host "      - Rechtsklick -> Eigenschaften -> Arbeitsverzeichnis aendern" -ForegroundColor Gray
    Write-Host "        um zu Ihrem bevorzugten Projekt zu wechseln" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Tipp:" -ForegroundColor Yellow
    Write-Host "  Druecken Sie die Windows-Taste und geben Sie 'Claude' ein," -ForegroundColor Gray
    Write-Host "  um die Shortcuts zu finden." -ForegroundColor Gray

} catch {
    Write-Host ""
    Write-Host "Fehler bei der Installation: $_" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
} finally {
    # Release COM object
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($shell) | Out-Null
}

Write-Host ""
pause
