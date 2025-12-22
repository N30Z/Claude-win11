# Claude Code - Commit Message Generator
# Analyzes git diff and helps generate commit message

param(
    [string]$Path
)

# Clean path
$workDir = if ($Path) {
    $Path.Trim('"').Trim("'")
} else {
    Get-Location
}

if (-not (Test-Path $workDir)) {
    Write-Host "Error: Invalid path: $workDir" -ForegroundColor Red
    exit 1
}

# If it's a file, use its parent directory
if (-not (Test-Path $workDir -PathType Container)) {
    $workDir = Split-Path $workDir -Parent
}

# Find git repository root
$gitRoot = $workDir
$currentDir = $workDir

while ($currentDir) {
    if (Test-Path (Join-Path $currentDir ".git")) {
        $gitRoot = $currentDir
        break
    }
    $parent = Split-Path $currentDir -Parent
    if ($parent -eq $currentDir) { break }
    $currentDir = $parent
}

# Check if we're in a git repository
if (-not (Test-Path (Join-Path $gitRoot ".git"))) {
    Write-Host "Error: Not in a git repository" -ForegroundColor Red
    pause
    exit 1
}

# Check if git is available
$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCmd) {
    Write-Host "Error: Git not found" -ForegroundColor Red
    pause
    exit 1
}

# Generate the prompt
$prompt = @"
Bitte generiere eine Commit Message für die aktuellen Änderungen.

Führe zunächst 'git status' und 'git diff' aus, um die Änderungen zu sehen.

Die Commit Message sollte:
- Eine präzise Zusammenfassung der Änderungen enthalten
- Im Imperativ geschrieben sein (z.B. "Add feature" nicht "Added feature")
- Optional einen längeren erklärenden Text haben

Wenn du die Message erstellt hast, frag ob du committen sollst.
"@

# Check if Windows Terminal is available
$useWindowsTerminal = $false
$wtCmd = Get-Command wt.exe -ErrorAction SilentlyContinue

if ($wtCmd) {
    $scriptRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $guidFile = Join-Path $scriptRoot "claude-profile-guid.txt"
    if (Test-Path $guidFile) {
        $useWindowsTerminal = $true
    }
}

# Launch Claude Code
if ($useWindowsTerminal) {
    Start-Process wt.exe -ArgumentList "-p `"Claude Code`" -d `"$gitRoot`" -- powershell -NoExit -Command `"claude; Write-Host ''; Write-Host '$prompt' -ForegroundColor Yellow`""
} else {
    Start-Process powershell.exe -ArgumentList "-NoExit -Command `"cd '$gitRoot'; claude; Write-Host ''; Write-Host '$prompt' -ForegroundColor Yellow`""
}
