# Claude Code - Analyze Wrapper
# Opens Claude Code with analysis prompt for selected files/folders

param(
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$Paths
)

# Clean paths
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

# Determine working directory
$workDir = $null

if ($cleanPaths.Length -eq 1) {
    $singlePath = $cleanPaths[0]
    if (Test-Path $singlePath -PathType Container) {
        $workDir = $singlePath
    } else {
        $workDir = Split-Path $singlePath -Parent
    }
} else {
    $workDir = Split-Path $cleanPaths[0] -Parent
}

# Find project root
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

# Build analysis prompt
$itemList = @()
foreach ($path in $cleanPaths) {
    $relativePath = try {
        (Resolve-Path -Path $path -Relative -RelativeBasePath $projectRoot -ErrorAction Stop).TrimStart(".\")
    } catch {
        Split-Path $path -Leaf
    }
    $itemList += "- $relativePath"
}

$itemsText = $itemList -join "`n"

$prompt = @"
Bitte analysiere die folgenden Dateien/Ordner:

$itemsText

Gib eine Übersicht über:
- Zweck und Funktionalität
- Codequalität und mögliche Verbesserungen
- Potenzielle Probleme oder Bugs
"@

# Escape quotes for command line
$prompt = $prompt -replace '"', '`"'
$prompt = $prompt -replace "'", "''"

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

# Build file arguments
$fileArgs = @()
foreach ($path in $cleanPaths) {
    $fileArgs += "`"$path`""
}
$filesString = $fileArgs -join " "

# Launch Claude Code
if ($useWindowsTerminal) {
    Start-Process wt.exe -ArgumentList "-p `"Claude Code`" -d `"$projectRoot`" -- powershell -NoExit -Command `"claude $filesString; Write-Host ''; Write-Host '$prompt' -ForegroundColor Yellow`""
} else {
    Start-Process powershell.exe -ArgumentList "-NoExit -Command `"cd '$projectRoot'; claude $filesString; Write-Host ''; Write-Host '$prompt' -ForegroundColor Yellow`""
}
