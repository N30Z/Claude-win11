# Claude Code - Test Runner
# Detects test framework and runs tests with Claude Code assistance

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

# Find project root (look for common project markers)
$projectRoot = $workDir
$currentDir = $workDir

while ($currentDir) {
    # Check for various project markers
    $markers = @(".git", "package.json", "pyproject.toml", "Cargo.toml", "*.sln", "*.csproj")

    foreach ($marker in $markers) {
        if ((Get-ChildItem -Path $currentDir -Filter $marker -ErrorAction SilentlyContinue).Count -gt 0) {
            $projectRoot = $currentDir
            break
        }
    }

    $parent = Split-Path $currentDir -Parent
    if ($parent -eq $currentDir) { break }
    $currentDir = $parent
}

# Detect test framework
$testFramework = "unknown"
$testCommand = $null

# Check for package.json (Node.js)
$packageJson = Join-Path $projectRoot "package.json"
if (Test-Path $packageJson) {
    $testFramework = "npm"
    $testCommand = "npm test"
}

# Check for pytest (Python)
$pytestFiles = Get-ChildItem -Path $projectRoot -Filter "*test*.py" -Recurse -ErrorAction SilentlyContinue
if ($pytestFiles) {
    $testFramework = "pytest"
    $testCommand = "pytest"
}

# Check for .NET
$csprojFiles = Get-ChildItem -Path $projectRoot -Filter "*.csproj" -ErrorAction SilentlyContinue
if ($csprojFiles) {
    $testFramework = "dotnet"
    $testCommand = "dotnet test"
}

# Check for Cargo.toml (Rust)
$cargoToml = Join-Path $projectRoot "Cargo.toml"
if (Test-Path $cargoToml) {
    $testFramework = "cargo"
    $testCommand = "cargo test"
}

# Build the prompt
if ($testCommand) {
    $prompt = @"
Test-Framework erkannt: $testFramework

Führe die Tests aus mit: $testCommand

Analysiere die Testergebnisse und hilf bei der Behebung von Fehlern.
"@
} else {
    $prompt = @"
Kein bekanntes Test-Framework automatisch erkannt.

Bitte prüfe, welches Test-Framework in diesem Projekt verwendet wird und führe die Tests aus.

Unterstützte Frameworks:
- npm/yarn (Node.js)
- pytest (Python)
- dotnet test (.NET)
- cargo test (Rust)
- mvn test (Maven/Java)
- gradle test (Gradle)
"@
}

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
    Start-Process wt.exe -ArgumentList "-p `"Claude Code`" -d `"$projectRoot`" -- powershell -NoExit -Command `"claude; Write-Host ''; Write-Host '$prompt' -ForegroundColor Yellow`""
} else {
    Start-Process powershell.exe -ArgumentList "-NoExit -Command `"cd '$projectRoot'; claude; Write-Host ''; Write-Host '$prompt' -ForegroundColor Yellow`""
}
