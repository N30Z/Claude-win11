# Claude Code - Open Wrapper
# Handles opening files/folders with Claude Code from context menu
# Supports: spaces in paths, multiple files, project root detection

param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Paths
)

# If no paths provided, use current directory
if (-not $Paths -or $Paths.Length -eq 0) {
    $Paths = @(Get-Location)
}

# Clean and normalize paths (handle quotes and spaces)
$cleanPaths = @()
foreach ($path in $Paths) {
    $cleaned = $path.Trim('"').Trim("'")
    if (Test-Path $cleaned) {
        $cleanPaths += $cleaned
    }
}

if ($cleanPaths.Length -eq 0) {
    Write-Host "Error: No valid paths provided" -ForegroundColor Red
    exit 1
}

# Determine the working directory
# If single folder: use it
# If single file: use its parent directory
# If multiple files: use common parent or first file's parent

$workDir = $null

if ($cleanPaths.Length -eq 1) {
    $singlePath = $cleanPaths[0]
    if (Test-Path $singlePath -PathType Container) {
        $workDir = $singlePath
    } else {
        $workDir = Split-Path $singlePath -Parent
    }
} else {
    # Multiple files - find common parent
    $parents = $cleanPaths | ForEach-Object {
        if (Test-Path $_ -PathType Container) { $_ }
        else { Split-Path $_ -Parent }
    }

    # Use the first parent (could be improved to find common ancestor)
    $workDir = $parents[0]
}

# Try to find project root (git repository)
$projectRoot = $workDir
$currentDir = $workDir

while ($currentDir) {
    if (Test-Path (Join-Path $currentDir ".git")) {
        $projectRoot = $currentDir
        break
    }
    $parent = Split-Path $currentDir -Parent
    if ($parent -eq $currentDir) { break }
    $currentDir = $parent
}

# Determine if we should use Windows Terminal
$useWindowsTerminal = $false
$wtCmd = Get-Command wt.exe -ErrorAction SilentlyContinue

if ($wtCmd) {
    # Check if Claude profile exists
    $scriptRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $guidFile = Join-Path $scriptRoot "claude-profile-guid.txt"

    if (Test-Path $guidFile) {
        $useWindowsTerminal = $true
    }
}

# Build the command
if ($useWindowsTerminal) {
    # Use Windows Terminal with Claude Code profile
    $claudeArgs = @()

    # Add file paths as arguments to claude
    foreach ($path in $cleanPaths) {
        $claudeArgs += "`"$path`""
    }

    $argsString = $claudeArgs -join " "

    # Start Windows Terminal
    Start-Process wt.exe -ArgumentList "-p `"Claude Code`" -d `"$projectRoot`" -- claude $argsString"
} else {
    # Use regular PowerShell
    $claudeArgs = @()
    foreach ($path in $cleanPaths) {
        $claudeArgs += "`"$path`""
    }

    $argsString = $claudeArgs -join " "

    # Start PowerShell
    Start-Process powershell.exe -ArgumentList "-NoExit -Command `"cd '$projectRoot'; claude $argsString`""
}
