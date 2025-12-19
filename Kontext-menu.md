# Claude Code - Windows 11 Kontextmen\u00fc-Integration

Diese Integration f\u00fcgt Claude Code zum Windows 11 Kontextmen\u00fc hinzu, sodass Sie Claude Code direkt aus dem Datei-Explorer heraus \u00f6ffnen k\u00f6nnen.

## Features

Die Integration f\u00fcgt zwei Kontextmen\u00fc-Eintr\u00e4ge hinzu:

1. **"in Claude Code \u00f6ffnen"** - Erscheint beim Rechtsklick auf einen Ordner
2. **"Claude Code hier \u00f6ffnen"** - Erscheint beim Rechtsklick im Hintergrund (leerer Bereich im Explorer)

Beide Optionen \u00f6ffnen ein PowerShell-Fenster und starten Claude Code im ausgew\u00e4hlten Verzeichnis.

## Voraussetzungen

- Windows 11 (oder Windows 10)
- Claude Code muss installiert sein (via npm: `npm install -g @claude/code` oder verf\u00fcgbar via npx)
- Administratorrechte f\u00fcr die Installation

## Installation

Es gibt zwei Methoden zur Installation:

### Methode 1: PowerShell-Skript (Empfohlen)

1. \u00d6ffnen Sie PowerShell als Administrator:
   - Dr\u00fccken Sie `Win + X`
   - W\u00e4hlen Sie "Windows PowerShell (Administrator)" oder "Terminal (Administrator)"

2. Navigieren Sie zum Verzeichnis mit den Skripten

3. F\u00fchren Sie das Installationsskript aus:
   ```powershell
   .\install-context-menu.ps1
   ```

### Methode 2: Registry-Datei

1. Doppelklicken Sie auf `install-context-menu.reg`
2. Best\u00e4tigen Sie die Sicherheitsabfrage
3. Klicken Sie auf "Ja" um die Registry-\u00c4nderungen zu best\u00e4tigen

## Deinstallation

### Methode 1: PowerShell-Skript (Empfohlen)

1. \u00d6ffnen Sie PowerShell als Administrator
2. F\u00fchren Sie aus:
   ```powershell
   .\uninstall-context-menu.ps1
   ```

### Methode 2: Registry-Datei

1. Doppelklicken Sie auf `uninstall-context-menu.reg`
2. Best\u00e4tigen Sie die \u00c4nderungen

## Verwendung

Nach der Installation:

1. \u00d6ffnen Sie den Windows Explorer
2. Navigieren Sie zu einem beliebigen Ordner
3. **Option 1**: Rechtsklick auf einen Ordner \u2192 W\u00e4hlen Sie "in Claude Code \u00f6ffnen"
4. **Option 2**: Rechtsklick in einen leeren Bereich \u2192 W\u00e4hlen Sie "Claude Code hier \u00f6ffnen"

Ein PowerShell-Fenster wird ge\u00f6ffnet und Claude Code startet im ausgew\u00e4hlten Verzeichnis.

## Technische Details

### Registry-Pfade

Die Integration verwendet folgende Registry-Schl\u00fcssel:

- **Ordner-Kontextmen\u00fc**: `HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode`
- **Hintergrund-Kontextmen\u00fc**: `HKEY_CLASSES_ROOT\Directory\Background\shell\ClaudeCode`

### Ausgef\u00fchrter Befehl

```powershell
powershell.exe -NoExit -Command "cd \"%V\"; npx @claude/code"
```

- `%V` wird durch Windows mit dem ausgew\u00e4hlten Verzeichnispfad ersetzt
- `-NoExit` h\u00e4lt das PowerShell-Fenster offen
- `npx @claude/code` startet Claude Code (verwendet npx, falls Claude Code nicht global installiert ist)

### Icon

Aktuell verwendet die Integration das PowerShell-Icon (`powershell.exe,0`). Dies kann angepasst werden, indem Sie den `Icon`-Wert in den Skripten oder Registry-Dateien \u00e4ndern.

## Anpassungen

### Claude Code Befehl \u00e4ndern

Falls Claude Code anders aufgerufen werden muss (z.B. `claude-code` statt `npx @claude/code`), \u00e4ndern Sie die Befehle in:

- `install-context-menu.ps1`: Zeilen mit `$commandDirectory` und `$commandBackground`
- `install-context-menu.reg`: Die Zeilen mit `@="powershell.exe..."`

### Benutzerdefiniertes Icon

Um ein benutzerdefiniertes Icon zu verwenden:

1. Bearbeiten Sie die Dateien
2. \u00c4ndern Sie `"Icon"="powershell.exe,0"` zu Ihrem gew\u00fcnschten Icon-Pfad
3. Beispiel: `"Icon"="C:\\Pfad\\zu\\icon.ico"`

### Text anpassen

Sie k\u00f6nnen die Textbezeichnungen in den Skripten und Registry-Dateien anpassen:

- "in Claude Code \u00f6ffnen" \u2192 Ihr gew\u00fcnschter Text f\u00fcr Ordner
- "Claude Code hier \u00f6ffnen" \u2192 Ihr gew\u00fcnschter Text f\u00fcr Hintergrund

## Probleml\u00f6sung

### Kontextmen\u00fc-Eintrag erscheint nicht

1. Starten Sie den Windows Explorer neu:
   - \u00d6ffnen Sie den Task-Manager (`Ctrl + Shift + Esc`)
   - Finden Sie "Windows Explorer"
   - Rechtsklick \u2192 "Neu starten"

2. \u00dcberpr\u00fcfen Sie, ob die Installation als Administrator ausgef\u00fchrt wurde

3. \u00dcberpr\u00fcfen Sie die Registry-Eintr\u00e4ge mit `regedit`:
   - \u00d6ffnen Sie `regedit` als Administrator
   - Navigieren Sie zu `HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode`
   - Pr\u00fcfen Sie, ob die Eintr\u00e4ge vorhanden sind

### Claude Code startet nicht

1. \u00dcberpr\u00fcfen Sie, ob Claude Code installiert ist:
   ```powershell
   npx @claude/code --version
   ```

2. Falls Claude Code global installiert ist, k\u00f6nnen Sie den Befehl zu `claude-code` \u00e4ndern

3. \u00dcberpr\u00fcfen Sie die PATH-Umgebungsvariable

### PowerShell-Skript kann nicht ausgef\u00fchrt werden

Falls Sie eine Fehlermeldung zu Ausf\u00fchrungsrichtlinien erhalten:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Oder f\u00fchren Sie das Skript mit:
```powershell
powershell -ExecutionPolicy Bypass -File .\install-context-menu.ps1
```

## Sicherheit

- Die Skripte ben\u00f6tigen Administratorrechte, da sie die System-Registry (\u00e4ndern (HKEY_CLASSES_ROOT)
- Alle \u00c4nderungen werden nur lokal auf Ihrem System vorgenommen
- Es werden keine Dateien au\u00dferhalb der Registry ge\u00e4ndert
- Die Skripte k\u00f6nnen jederzeit mit dem Deinstallationsskript r\u00fcckg\u00e4ngig gemacht werden

## Lizenz

Dieses Projekt steht unter der gleichen Lizenz wie das Hauptrepository.

## Beitr\u00e4ge

Beitr\u00e4ge, Verbesserungsvorschl\u00e4ge und Bug-Reports sind willkommen!

## Support

Bei Problemen oder Fragen erstellen Sie bitte ein Issue im Repository.
