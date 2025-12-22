# Claude Code - URL Protocol Installation
# Registers claude:// URL protocol

# Require Administrator privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgefuehrt werden!"
    Write-Host "Bitte starten Sie PowerShell als Administrator und fuehren Sie das Skript erneut aus."
    pause
    exit
}

Write-Host "=== Claude Code - URL Protocol Installation ===" -ForegroundColor Cyan
Write-Host ""

# Determine repository root and handler path
$repoRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$handlerPath = Join-Path $PSScriptRoot "claude-url-handler.ps1"

if (-not (Test-Path $handlerPath)) {
    Write-Host "Error: Handler script not found: $handlerPath" -ForegroundColor Red
    pause
    exit 1
}

# Icon path
$claudeIcon = "$env:USERPROFILE\.local\bin\claude.exe,0"

try {
    Write-Host "Registriere claude:// URL Protocol..." -ForegroundColor Yellow
    Write-Host ""

    # Create registry keys
    $protocolPath = "Registry::HKEY_CLASSES_ROOT\claude"
    $commandPath = "$protocolPath\shell\open\command"

    # Main protocol key
    if (!(Test-Path $protocolPath)) {
        New-Item -Path $protocolPath -Force | Out-Null
    }
    Set-ItemProperty -Path $protocolPath -Name "(Default)" -Value "URL:Claude Code Protocol"
    Set-ItemProperty -Path $protocolPath -Name "URL Protocol" -Value ""
    Set-ItemProperty -Path $protocolPath -Name "DefaultIcon" -Value $claudeIcon

    # Command key
    if (!(Test-Path $commandPath)) {
        New-Item -Path $commandPath -Force | Out-Null
    }

    # Set the command to execute the handler
    $command = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$handlerPath`" `"%1`""
    Set-ItemProperty -Path $commandPath -Name "(Default)" -Value $command

    Write-Host "Installation erfolgreich!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Das claude:// URL Protocol ist jetzt registriert." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Verwendung:" -ForegroundColor Yellow
    Write-Host "  claude://open?path=C:\Users\Username\Projects\MyProject" -ForegroundColor White
    Write-Host "  claude://file?path=C:\path\to\file.txt" -ForegroundColor White
    Write-Host "  claude://analyze?path=C:\path\to\folder" -ForegroundColor White
    Write-Host "  claude://commit?path=C:\path\to\repo" -ForegroundColor White
    Write-Host "  claude://test?path=C:\path\to\project" -ForegroundColor White
    Write-Host ""
    Write-Host "Beispiele:" -ForegroundColor Yellow
    Write-Host "  - In Browser oder Ausfuehren-Dialog eingeben" -ForegroundColor Gray
    Write-Host "  - In HTML-Links verwenden: <a href='claude://open?path=...'>Open in Claude</a>" -ForegroundColor Gray
    Write-Host "  - Per PowerShell starten: Start-Process 'claude://open?path=...'" -ForegroundColor Gray

} catch {
    Write-Host ""
    Write-Host "Fehler bei der Installation: $_" -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
pause
