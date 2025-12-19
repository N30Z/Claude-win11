# Claude Code - Windows 11 Extensions

Erweiterungen und Integrationen für Claude Code unter Windows 11.

## Übersicht

Dieses Repository enthält nützliche Windows 11 Integrationen für Claude Code, um Ihre Produktivität zu steigern.

## Features

### ✅ Kontextmenü-Integration

Fügt Claude Code direkt in das Windows 11 Kontextmenü ein:

- **Rechtsklick auf Ordner**: "in Claude Code öffnen"
- **Rechtsklick im Hintergrund**: "Claude Code hier öffnen"

Öffnet automatisch ein Terminal-Fenster und startet Claude Code im ausgewählten Verzeichnis.

### ✅ Einzigartiges Claude Code Fenster (NEU)

Ein speziell gestaltetes Terminal-Profil für Claude Code mit:

- **Claude Dark Theme**: Dunkler Hintergrund mit lila/orange Akzenten
- **Angepasste Schriftart**: Cascadia Code für optimale Lesbarkeit
- **Acryl-Transparenz**: Modernes Windows 11 Design
- **Claude Icon**: Eigenes Icon in der Titelleiste und Taskleiste
- **Dediziertes Profil**: Separates Windows Terminal-Profil für Claude Code

![Claude Dark Theme](https://img.shields.io/badge/Theme-Claude%20Dark-1a1a2e?style=flat&labelColor=7c5cff)

## Installation

### 1. Einzigartiges Claude Code Fenster (Empfohlen)

Installieren Sie zuerst das Windows Terminal-Profil für das beste Erlebnis:

```powershell
.\install-terminal-profile.ps1
```

Dies fügt ein "Claude Code" Profil mit dem Claude Dark Theme zu Windows Terminal hinzu.

### 2. Kontextmenü-Integration

**Schnellinstallation (PowerShell):**

1. Öffnen Sie PowerShell als Administrator
2. Führen Sie aus:
   ```powershell
   .\install-context-menu.ps1
   ```
3. Wählen Sie "Windows Terminal" wenn das Profil installiert ist

**Alternative (Registry-Dateien):**

- `install-context-menu-wt.reg` - Für Windows Terminal (empfohlen)
- `install-context-menu.reg` - Für klassisches PowerShell

**Detaillierte Anleitung**: Siehe [Kontext-menu.md](Kontext-menu.md)

## Voraussetzungen

- Windows 11 (oder Windows 10)
- Claude Code installiert (via npm oder npx)
- Windows Terminal (empfohlen, für das einzigartige Claude Code Fenster)
- Administratorrechte für die Kontextmenü-Installation

## Dateien

### Terminal-Profil
- `install-terminal-profile.ps1` - Installiert das Claude Code Profil in Windows Terminal
- `uninstall-terminal-profile.ps1` - Entfernt das Claude Code Profil
- `claude-terminal-profile.json` - Profil-Konfiguration mit Claude Dark Theme

### Kontextmenü
- `install-context-menu.ps1` - PowerShell-Installationsskript (mit Windows Terminal Support)
- `uninstall-context-menu.ps1` - PowerShell-Deinstallationsskript
- `install-context-menu.reg` - Registry-Datei (PowerShell-Version)
- `install-context-menu-wt.reg` - Registry-Datei (Windows Terminal-Version)
- `uninstall-context-menu.reg` - Registry-Deinstallationsdatei

### Dokumentation
- `Kontext-menu.md` - Ausführliche Dokumentation zur Kontextmenü-Integration

## Deinstallation

### Terminal-Profil entfernen
```powershell
.\uninstall-terminal-profile.ps1
```

### Kontextmenü entfernen

**PowerShell:**
```powershell
.\uninstall-context-menu.ps1
```

**Registry:**
Doppelklicken Sie auf `uninstall-context-menu.reg`

## Verwendung

Nach der Installation können Sie:

1. Im Windows Explorer zu einem beliebigen Ordner navigieren
2. Rechtsklick auf einen Ordner → "in Claude Code öffnen"
3. Oder Rechtsklick im leeren Bereich → "Claude Code hier öffnen"

Claude Code startet automatisch im ausgewählten Verzeichnis.

## Anpassungen

Sie können die Skripte und Registry-Dateien anpassen, um:

- Benutzerdefinierte Icons zu verwenden
- Die Textbezeichnungen zu ändern
- Den Claude Code-Befehl anzupassen
- Zusätzliche Parameter hinzuzufügen

Details finden Sie in [Kontext-menu.md](Kontext-menu.md)

## Problemlösung

Bei Problemen konsultieren Sie bitte die [Kontext-menu.md](Kontext-menu.md) Dokumentation oder erstellen Sie ein Issue.

## Lizenz

Siehe [LICENSE](LICENSE) für Details.

## Beiträge

Beiträge, Verbesserungsvorschläge und Bug-Reports sind willkommen!

## Support

Für Fragen oder Probleme erstellen Sie bitte ein Issue im Repository.
