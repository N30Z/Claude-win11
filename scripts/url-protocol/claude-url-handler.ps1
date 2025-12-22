# Claude Code - URL Protocol Handler
# Handles claude:// URLs

param(
    [Parameter(Mandatory=$true)]
    [string]$Url
)

# Parse the URL
# Expected formats:
# claude://open?path=C:\some\project
# claude://file?path=C:\some\file.txt
# claude://analyze?path=C:\some\folder
# claude://commit?path=C:\some\repo
# claude://test?path=C:\some\project

Write-Host "Claude URL Handler: $Url" -ForegroundColor Cyan

# Remove protocol
$urlWithoutProtocol = $Url -replace '^claude://', ''

# Split into action and query
$parts = $urlWithoutProtocol -split '\?', 2

$action = $parts[0]
$query = if ($parts.Length -gt 1) { $parts[1] } else { "" }

# Parse query string
$params = @{}
if ($query) {
    $query -split '&' | ForEach-Object {
        $kvp = $_ -split '=', 2
        if ($kvp.Length -eq 2) {
            $key = [System.Web.HttpUtility]::UrlDecode($kvp[0])
            $value = [System.Web.HttpUtility]::UrlDecode($kvp[1])
            $params[$key] = $value
        }
    }
}

# Get the path parameter
$path = $params["path"]

if (-not $path) {
    Write-Host "Error: No path parameter provided" -ForegroundColor Red
    Write-Host "Usage: claude://ACTION?path=PATH" -ForegroundColor Yellow
    Write-Host "Actions: open, file, analyze, commit, test" -ForegroundColor Yellow
    pause
    exit 1
}

# Normalize path (handle forward slashes from URLs)
$path = $path -replace '/', '\'

if (-not (Test-Path $path)) {
    Write-Host "Error: Path does not exist: $path" -ForegroundColor Red
    pause
    exit 1
}

# Determine repository root
$repoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$wrappersPath = Join-Path $repoRoot "scripts\wrappers"

# Execute action
switch ($action.ToLower()) {
    "open" {
        $wrapper = Join-Path $wrappersPath "claude-open.ps1"
        & powershell.exe -ExecutionPolicy Bypass -File $wrapper -Paths $path
    }
    "file" {
        $wrapper = Join-Path $wrappersPath "claude-open.ps1"
        & powershell.exe -ExecutionPolicy Bypass -File $wrapper -Paths $path
    }
    "analyze" {
        $wrapper = Join-Path $wrappersPath "claude-analyze.ps1"
        & powershell.exe -ExecutionPolicy Bypass -File $wrapper -Paths $path
    }
    "commit" {
        $wrapper = Join-Path $wrappersPath "claude-commit.ps1"
        & powershell.exe -ExecutionPolicy Bypass -File $wrapper -Path $path
    }
    "test" {
        $wrapper = Join-Path $wrappersPath "claude-test.ps1"
        & powershell.exe -ExecutionPolicy Bypass -File $wrapper -Path $path
    }
    default {
        Write-Host "Error: Unknown action: $action" -ForegroundColor Red
        Write-Host "Supported actions: open, file, analyze, commit, test" -ForegroundColor Yellow
        pause
        exit 1
    }
}
