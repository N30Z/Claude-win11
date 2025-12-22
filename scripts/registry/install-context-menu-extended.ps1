# Claude Code - Extended Context Menu Installation
# Installs comprehensive context menu entries for folders, background, and files

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgefuehrt werden!"
    Write-Host "Bitte starten Sie PowerShell als Administrator und fuehren Sie das Skript erneut aus."
    pause
    exit
}

Write-Host "=== Claude Code - Erweiterte Kontextmenue Installation ===" -ForegroundColor Cyan
Write-Host ""

# Determine script root (repository root)
$repoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$wrappersPath = Join-Path $repoRoot "scripts\wrappers"

# Icon path
$claudeIcon = "$env:USERPROFILE\.local\bin\claude.exe,0"

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

function New-RegistryKey {
    param([string]$Path)
    if (!(Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
}

function Set-MenuEntry {
    param(
        [string]$BasePath,
        [string]$MenuText,
        [string]$WrapperScript,
        [string]$Arguments = ""
    )

    $shellPath = "$BasePath\shell\ClaudeCode_$WrapperScript"
    $commandPath = "$shellPath\command"

    New-RegistryKey $shellPath
    Set-ItemProperty -Path $shellPath -Name "(Default)" -Value $MenuText
    Set-ItemProperty -Path $shellPath -Name "Icon" -Value $claudeIcon

    New-RegistryKey $commandPath

    $wrapperFullPath = Join-Path $wrappersPath "$WrapperScript.ps1"
    $command = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$wrapperFullPath`" $Arguments"

    Set-ItemProperty -Path $commandPath -Name "(Default)" -Value $command
}

function Set-SubMenu {
    param(
        [string]$BasePath,
        [string]$MenuText,
        [hashtable[]]$SubItems
    )

    $mainPath = "$BasePath\shell\ClaudeCode"
    $commandPath = "$mainPath\command"

    New-RegistryKey $mainPath
    Set-ItemProperty -Path $mainPath -Name "MUIVerb" -Value $MenuText
    Set-ItemProperty -Path $mainPath -Name "Icon" -Value $claudeIcon
    Set-ItemProperty -Path $mainPath -Name "SubCommands" -Value ""

    # Create sub-items
    foreach ($item in $SubItems) {
        $subPath = "$mainPath\shell\$($item.Id)"
        $subCommandPath = "$subPath\command"

        New-RegistryKey $subPath
        Set-ItemProperty -Path $subPath -Name "(Default)" -Value $item.Text
        if ($item.Icon) {
            Set-ItemProperty -Path $subPath -Name "Icon" -Value $item.Icon
        }

        New-RegistryKey $subCommandPath
        Set-ItemProperty -Path $subCommandPath -Name "(Default)" -Value $item.Command
    }
}

# ============================================================================
# INSTALLATION
# ============================================================================

Write-Host "Installiere Kontextmenue-Eintraege..." -ForegroundColor Yellow
Write-Host ""

try {
    # ------------------------------------------------------------------------
    # 1. FOLDER CONTEXT MENU (Right-click on folder)
    # ------------------------------------------------------------------------

    Write-Host "[1/3] Kontextmenue fuer Ordner..." -ForegroundColor Cyan

    $folderBase = "Registry::HKEY_CLASSES_ROOT\Directory"

    # Main menu entry
    $folderShell = "$folderBase\shell\ClaudeCode"
    $folderCommand = "$folderShell\command"

    New-RegistryKey $folderShell
    Set-ItemProperty -Path $folderShell -Name "MUIVerb" -Value "Claude Code"
    Set-ItemProperty -Path $folderShell -Name "Icon" -Value $claudeIcon
    Set-ItemProperty -Path $folderShell -Name "SubCommands" -Value ""

    # Sub-menu: Open
    $openPath = "$folderShell\shell\open"
    $openCommand = "$openPath\command"
    New-RegistryKey $openPath
    Set-ItemProperty -Path $openPath -Name "(Default)" -Value "Hier oeffnen"
    New-RegistryKey $openCommand
    $openWrapper = Join-Path $wrappersPath "claude-open.ps1"
    Set-ItemProperty -Path $openCommand -Name "(Default)" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$openWrapper`" `"%V`""

    # Sub-menu: Analyze
    $analyzePath = "$folderShell\shell\analyze"
    $analyzeCommand = "$analyzePath\command"
    New-RegistryKey $analyzePath
    Set-ItemProperty -Path $analyzePath -Name "(Default)" -Value "Analysieren"
    New-RegistryKey $analyzeCommand
    $analyzeWrapper = Join-Path $wrappersPath "claude-analyze.ps1"
    Set-ItemProperty -Path $analyzeCommand -Name "(Default)" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$analyzeWrapper`" `"%V`""

    # Sub-menu: Commit Message
    $commitPath = "$folderShell\shell\commit"
    $commitCommand = "$commitPath\command"
    New-RegistryKey $commitPath
    Set-ItemProperty -Path $commitPath -Name "(Default)" -Value "Commit Message generieren"
    New-RegistryKey $commitCommand
    $commitWrapper = Join-Path $wrappersPath "claude-commit.ps1"
    Set-ItemProperty -Path $commitCommand -Name "(Default)" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$commitWrapper`" `"%V`""

    # Sub-menu: Run Tests
    $testPath = "$folderShell\shell\test"
    $testCommand = "$testPath\command"
    New-RegistryKey $testPath
    Set-ItemProperty -Path $testPath -Name "(Default)" -Value "Tests ausfuehren"
    New-RegistryKey $testCommand
    $testWrapper = Join-Path $wrappersPath "claude-test.ps1"
    Set-ItemProperty -Path $testCommand -Name "(Default)" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$testWrapper`" `"%V`""

    Write-Host "  OK - Ordner-Kontextmenue installiert" -ForegroundColor Green

    # ------------------------------------------------------------------------
    # 2. BACKGROUND CONTEXT MENU (Right-click in empty space)
    # ------------------------------------------------------------------------

    Write-Host "[2/3] Kontextmenue fuer Hintergrund..." -ForegroundColor Cyan

    $bgBase = "Registry::HKEY_CLASSES_ROOT\Directory\Background"

    $bgShell = "$bgBase\shell\ClaudeCode"
    $bgCommand = "$bgShell\command"

    New-RegistryKey $bgShell
    Set-ItemProperty -Path $bgShell -Name "MUIVerb" -Value "Claude Code"
    Set-ItemProperty -Path $bgShell -Name "Icon" -Value $claudeIcon
    Set-ItemProperty -Path $bgShell -Name "SubCommands" -Value ""

    # Sub-menu: Open Here
    $bgOpenPath = "$bgShell\shell\open"
    $bgOpenCommand = "$bgOpenPath\command"
    New-RegistryKey $bgOpenPath
    Set-ItemProperty -Path $bgOpenPath -Name "(Default)" -Value "Hier oeffnen"
    New-RegistryKey $bgOpenCommand
    Set-ItemProperty -Path $bgOpenCommand -Name "(Default)" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$openWrapper`" `"%V`""

    # Sub-menu: Commit Message
    $bgCommitPath = "$bgShell\shell\commit"
    $bgCommitCommand = "$bgCommitPath\command"
    New-RegistryKey $bgCommitPath
    Set-ItemProperty -Path $bgCommitPath -Name "(Default)" -Value "Commit Message generieren"
    New-RegistryKey $bgCommitCommand
    Set-ItemProperty -Path $bgCommitCommand -Name "(Default)" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$commitWrapper`" `"%V`""

    # Sub-menu: Run Tests
    $bgTestPath = "$bgShell\shell\test"
    $bgTestCommand = "$bgTestPath\command"
    New-RegistryKey $bgTestPath
    Set-ItemProperty -Path $bgTestPath -Name "(Default)" -Value "Tests ausfuehren"
    New-RegistryKey $bgTestCommand
    Set-ItemProperty -Path $bgTestCommand -Name "(Default)" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$testWrapper`" `"%V`""

    Write-Host "  OK - Hintergrund-Kontextmenue installiert" -ForegroundColor Green

    # ------------------------------------------------------------------------
    # 3. FILE CONTEXT MENU (Right-click on files)
    # ------------------------------------------------------------------------

    Write-Host "[3/3] Kontextmenue fuer Dateien..." -ForegroundColor Cyan

    $fileBase = "Registry::HKEY_CLASSES_ROOT\*"

    $fileShell = "$fileBase\shell\ClaudeCode"
    $fileCommand = "$fileShell\command"

    New-RegistryKey $fileShell
    Set-ItemProperty -Path $fileShell -Name "MUIVerb" -Value "Claude Code"
    Set-ItemProperty -Path $fileShell -Name "Icon" -Value $claudeIcon
    Set-ItemProperty -Path $fileShell -Name "SubCommands" -Value ""

    # Sub-menu: Open File
    $fileOpenPath = "$fileShell\shell\open"
    $fileOpenCommand = "$fileOpenPath\command"
    New-RegistryKey $fileOpenPath
    Set-ItemProperty -Path $fileOpenPath -Name "(Default)" -Value "Mit Claude oeffnen"
    New-RegistryKey $fileOpenCommand
    Set-ItemProperty -Path $fileOpenCommand -Name "(Default)" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$openWrapper`" `"%1`""

    # Sub-menu: Analyze File
    $fileAnalyzePath = "$fileShell\shell\analyze"
    $fileAnalyzeCommand = "$fileAnalyzePath\command"
    New-RegistryKey $fileAnalyzePath
    Set-ItemProperty -Path $fileAnalyzePath -Name "(Default)" -Value "Analysieren"
    New-RegistryKey $fileAnalyzeCommand
    Set-ItemProperty -Path $fileAnalyzeCommand -Name "(Default)" -Value "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$analyzeWrapper`" `"%1`""

    Write-Host "  OK - Datei-Kontextmenue installiert" -ForegroundColor Green

    # ------------------------------------------------------------------------
    # SUCCESS
    # ------------------------------------------------------------------------

    Write-Host ""
    Write-Host "Installation erfolgreich abgeschlossen!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Verfuegbare Kontextmenue-Aktionen:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Ordner:" -ForegroundColor Yellow
    Write-Host "    - Hier oeffnen" -ForegroundColor White
    Write-Host "    - Analysieren" -ForegroundColor White
    Write-Host "    - Commit Message generieren" -ForegroundColor White
    Write-Host "    - Tests ausfuehren" -ForegroundColor White
    Write-Host ""
    Write-Host "  Hintergrund (leerer Bereich):" -ForegroundColor Yellow
    Write-Host "    - Hier oeffnen" -ForegroundColor White
    Write-Host "    - Commit Message generieren" -ForegroundColor White
    Write-Host "    - Tests ausfuehren" -ForegroundColor White
    Write-Host ""
    Write-Host "  Dateien:" -ForegroundColor Yellow
    Write-Host "    - Mit Claude oeffnen" -ForegroundColor White
    Write-Host "    - Analysieren" -ForegroundColor White
    Write-Host ""
    Write-Host "Hinweis:" -ForegroundColor Yellow
    Write-Host "  - Mehrere Dateien koennen gleichzeitig ausgewaehlt werden" -ForegroundColor Gray
    Write-Host "  - Leerzeichen in Pfaden werden korrekt behandelt" -ForegroundColor Gray
    Write-Host "  - Das Projekt-Root wird automatisch erkannt (.git)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Moeglicherweise muessen Sie den Explorer neu starten (explorer.exe)," -ForegroundColor Yellow
    Write-Host "damit die Aenderungen sichtbar werden." -ForegroundColor Yellow

} catch {
    Write-Host ""
    Write-Host "Fehler bei der Installation: $_" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
pause
