# Claude Code - Windows 11 Kontextmenü-Integration

Diese Integration fügt Claude Code zum Windows 11 Kontextmenü hinzu, sodass Sie Claude Code direkt aus dem Datei-Explorer heraus öffnen können.

## Features

Die Integration fügt zwei Kontextmenü-Einträge hinzu:

1. **"in Claude Code öffnen"** - Erscheint beim Rechtsklick auf einen Ordner
2. **"Claude Code hier öffnen"** - Erscheint beim Rechtsklick im Hintergrund (leerer Bereich im Explorer)

Beide Optionen öffnen ein PowerShell-Fenster und starten Claude Code im ausgewählten Verzeichnis.

## Voraussetzungen

- Windows 11 (oder Windows 10)
- Claude Code muss installiert sein (via npm: `npm install -g @claude/code` oder verfügbar via npx)
- Administratorrechte für die Installation

## Installation

Es gibt zwei Methoden zur Installation:

### Methode 1: PowerShell-Skript (Empfohlen)

1. Öffnen Sie PowerShell als Administrator:
   - Drücken Sie `Win + X`
   - Wählen Sie "Windows PowerShell (Administrator)" oder "Terminal (Administrator)"

2. Navigieren Sie zum Verzeichnis mit den Skripten

3. Führen Sie das Installationsskript aus:
   ```powershell
   .\install-context-menu.ps1
   ```

### Methode 2: Registry-Datei

1. Doppelklicken Sie auf `install-context-menu.reg`
2. Bestätigen Sie die Sicherheitsabfrage
3. Klicken Sie auf "Ja" um die Registry-Änderungen zu bestätigen

## Deinstallation

### Methode 1: PowerShell-Skript (Empfohlen)

1. Öffnen Sie PowerShell als Administrator
2. Führen Sie aus:
   ```powershell
   .\uninstall-context-menu.ps1
   ```

### Methode 2: Registry-Datei

1. Doppelklicken Sie auf `uninstall-context-menu.reg`
2. Bestätigen Sie die Änderungen

## Verwendung

Nach der Installation:

1. Öffnen Sie den Windows Explorer
2. Navigieren Sie zu einem beliebigen Ordner
3. **Option 1**: Rechtsklick auf einen Ordner → Wählen Sie "in Claude Code öffnen"
4. **Option 2**: Rechtsklick in einen leeren Bereich → Wählen Sie "Claude Code hier öffnen"

Ein PowerShell-Fenster wird geöffnet und Claude Code startet im ausgewählten Verzeichnis.

## Technische Details

### Registry-Pfade

Die Integration verwendet folgende Registry-Schlüssel:

- **Ordner-Kontextmenü**: `HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode`
- **Hintergrund-Kontextmenü**: `HKEY_CLASSES_ROOT\Directory\Background\shell\ClaudeCode`

### Ausgeführter Befehl

```powershell
powershell.exe -NoExit -Command "cd \"%V\"; npx @claude/code"
```

- `%V` wird durch Windows mit dem ausgewählten Verzeichnispfad ersetzt
- `-NoExit` hält das PowerShell-Fenster offen
- `npx @claude/code` startet Claude Code (verwendet npx, falls Claude Code nicht global installiert ist)

### Icon

Aktuell verwendet die Integration das PowerShell-Icon (`powershell.exe,0`). Dies kann angepasst werden, indem Sie den `Icon`-Wert in den Skripten oder Registry-Dateien ändern.

## Anpassungen

### Claude Code Befehl ändern

Falls Claude Code anders aufgerufen werden muss (z.B. `claude-code` statt `npx @claude/code`), ändern Sie die Befehle in:

- `install-context-menu.ps1`: Zeilen mit `$commandDirectory` und `$commandBackground`
- `install-context-menu.reg`: Die Zeilen mit `@="powershell.exe..."`

### Benutzerdefiniertes Icon

Um ein benutzerdefiniertes Icon zu verwenden:

1. Bearbeiten Sie die Dateien
2. Ändern Sie `"Icon"="powershell.exe,0"` zu Ihrem gewünschten Icon-Pfad
3. Beispiel: `"Icon"="C:\\Pfad\\zu\\icon.ico"`

### Text anpassen

Sie können die Textbezeichnungen in den Skripten und Registry-Dateien anpassen:

- "in Claude Code öffnen" → Ihr gewünschter Text für Ordner
- "Claude Code hier öffnen" → Ihr gewünschter Text für Hintergrund

## Problemlösung

### Kontextmenü-Eintrag erscheint nicht

1. Starten Sie den Windows Explorer neu:
   - Öffnen Sie den Task-Manager (`Ctrl + Shift + Esc`)
   - Finden Sie "Windows Explorer"
   - Rechtsklick → "Neu starten"

2. Überprüfen Sie, ob die Installation als Administrator ausgeführt wurde

3. Überprüfen Sie die Registry-Einträge mit `regedit`:
   - Öffnen Sie `regedit` als Administrator
   - Navigieren Sie zu `HKEY_CLASSES_ROOT\Directory\shell\ClaudeCode`
   - Prüfen Sie, ob die Einträge vorhanden sind

### Claude Code startet nicht

1. Überprüfen Sie, ob Claude Code installiert ist:
   ```powershell
   npx @claude/code --version
   ```

2. Falls Claude Code global installiert ist, können Sie den Befehl zu `claude-code` ändern

3. Überprüfen Sie die PATH-Umgebungsvariable

### PowerShell-Skript kann nicht ausgeführt werden

Falls Sie eine Fehlermeldung zu Ausführungsrichtlinien erhalten:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Oder führen Sie das Skript mit:
```powershell
powershell -ExecutionPolicy Bypass -File .\install-context-menu.ps1
```

## Sicherheit

- Die Skripte benötigen Administratorrechte, da sie die System-Registry ändern (HKEY_CLASSES_ROOT)
- Alle Änderungen werden nur lokal auf Ihrem System vorgenommen
- Es werden keine Dateien außerhalb der Registry geändert
- Die Skripte können jederzeit mit dem Deinstallationsskript rückgängig gemacht werden

## Lizenz

Dieses Projekt steht unter der gleichen Lizenz wie das Hauptrepository.

## Beiträge

Beiträge, Verbesserungsvorschläge und Bug-Reports sind willkommen!

## Support

Bei Problemen oder Fragen erstellen Sie bitte ein Issue im Repository.
