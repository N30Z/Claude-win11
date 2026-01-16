# Claude Code - Windows 11 Integration - Quick Installer
# One-liner: irm https://raw.githubusercontent.com/N30Z/Claude-win11/main/install-all.ps1 | iex

#Requires -Version 5.1

param(
    [string]$InstallPath = "$env:USERPROFILE\Claude-win11",
    [switch]$SkipClone
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "       Claude Code - Windows 11 Integration - Quick Install        " -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

# ============================================================================
# CHECK GIT
# ============================================================================

Write-Host "Checking prerequisites..." -ForegroundColor Yellow
Write-Host ""

$gitCmd = Get-Command git -ErrorAction SilentlyContinue

if (-not $gitCmd) {
    Write-Host "Git not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Git is required to download the repository." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please install Git from: https://git-scm.com/download/win" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "After installing Git, run this command again:" -ForegroundColor White
    Write-Host "  irm https://raw.githubusercontent.com/N30Z/Claude-win11/main/install-all.ps1 | iex" -ForegroundColor Gray
    Write-Host ""
    exit 1
}

Write-Host "Git found: $($gitCmd.Source)" -ForegroundColor Green
Write-Host ""

# ============================================================================
# CLONE OR UPDATE REPOSITORY
# ============================================================================

if (-not $SkipClone) {
    if (Test-Path $InstallPath) {
        Write-Host "Repository already exists at: $InstallPath" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Options:" -ForegroundColor Cyan
        Write-Host "  [U] Update - Pull latest changes (recommended)" -ForegroundColor White
        Write-Host "  [R] Remove and re-clone - Fresh installation" -ForegroundColor White
        Write-Host "  [C] Continue - Use existing installation" -ForegroundColor White
        Write-Host "  [Q] Quit - Cancel installation" -ForegroundColor White
        Write-Host ""
        $response = Read-Host "Your choice (U/R/C/Q)"

        if ($response -match '^[Uu]') {
            Write-Host ""
            Write-Host "Updating repository..." -ForegroundColor Cyan
            try {
                Push-Location $InstallPath
                & git pull origin main
                Pop-Location
                Write-Host "Repository updated successfully!" -ForegroundColor Green
                Write-Host ""
            } catch {
                Pop-Location
                Write-Host "Failed to update repository: $_" -ForegroundColor Red
                Write-Host "Continuing with existing installation..." -ForegroundColor Yellow
                Write-Host ""
            }
        } elseif ($response -match '^[Rr]') {
            Write-Host ""
            Write-Host "Removing existing installation..." -ForegroundColor Yellow
            try {
                Remove-Item -Path $InstallPath -Recurse -Force
                Write-Host "Removed successfully!" -ForegroundColor Green
                Write-Host ""
            } catch {
                Write-Host "Failed to remove existing installation: $_" -ForegroundColor Red
                Write-Host ""
                exit 1
            }

            Write-Host "Cloning repository..." -ForegroundColor Cyan
            try {
                & git clone https://github.com/N30Z/Claude-win11.git $InstallPath
                Write-Host "Repository cloned successfully!" -ForegroundColor Green
                Write-Host ""
            } catch {
                Write-Host "Failed to clone repository: $_" -ForegroundColor Red
                Write-Host ""
                exit 1
            }
        } elseif ($response -match '^[Cc]') {
            Write-Host ""
            Write-Host "Continuing with existing installation..." -ForegroundColor Cyan
            Write-Host ""
        } else {
            Write-Host ""
            Write-Host "Installation cancelled." -ForegroundColor Yellow
            Write-Host ""
            exit 0
        }
    } else {
        Write-Host "Cloning repository to: $InstallPath" -ForegroundColor Cyan
        Write-Host ""
        try {
            & git clone https://github.com/N30Z/Claude-win11.git $InstallPath
            Write-Host ""
            Write-Host "Repository cloned successfully!" -ForegroundColor Green
            Write-Host ""
        } catch {
            Write-Host ""
            Write-Host "Failed to clone repository: $_" -ForegroundColor Red
            Write-Host ""
            Write-Host "Please check:" -ForegroundColor Yellow
            Write-Host "  - Internet connection" -ForegroundColor White
            Write-Host "  - Repository URL is correct" -ForegroundColor White
            Write-Host "  - Git is properly configured" -ForegroundColor White
            Write-Host ""
            exit 1
        }
    }
}

# ============================================================================
# RUN MAIN INSTALLER
# ============================================================================

Write-Host "Starting main installation..." -ForegroundColor Yellow
Write-Host ""

$mainInstaller = Join-Path $InstallPath "install.ps1"

if (-not (Test-Path $mainInstaller)) {
    Write-Host "Main installer not found: $mainInstaller" -ForegroundColor Red
    Write-Host ""
    Write-Host "The repository may be corrupted. Please try:" -ForegroundColor Yellow
    Write-Host "  Remove-Item -Path '$InstallPath' -Recurse -Force" -ForegroundColor White
    Write-Host "  irm https://raw.githubusercontent.com/N30Z/Claude-win11/main/install-all.ps1 | iex" -ForegroundColor White
    Write-Host ""
    exit 1
}

# Execute main installer
try {
    Write-Host "Launching install.ps1..." -ForegroundColor Cyan
    Write-Host "This will handle ExecutionPolicy and Administrator privileges automatically." -ForegroundColor Gray
    Write-Host ""
    Start-Sleep -Seconds 2

    # Use call operator to run in current session
    & powershell.exe -ExecutionPolicy Bypass -File $mainInstaller

    Write-Host ""
    Write-Host "Installation process completed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repository location: $InstallPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To reinstall or update in the future, run:" -ForegroundColor Yellow
    Write-Host "  irm https://raw.githubusercontent.com/N30Z/Claude-win11/main/install-all.ps1 | iex" -ForegroundColor Gray
    Write-Host ""

} catch {
    Write-Host ""
    Write-Host "Installation failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "For manual installation:" -ForegroundColor Yellow
    Write-Host "  cd '$InstallPath'" -ForegroundColor White
    Write-Host "  .\install.ps1" -ForegroundColor White
    Write-Host ""
    exit 1
}
