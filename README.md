# Claude Code - Windows 11 Extensions

Erweiterungen und Integrationen für Claude Code unter Windows 11.

## Übersicht

Dieses Repository enthält nützliche Windows 11 Integrationen für Claude Code, um Ihre Produktivität zu steigern.

## Features

### ✅ Kontextmenü-Integration

Fügt Claude Code direkt in das Windows 11 Kontextmenü ein:

- **Rechtsklick auf Ordner**: "in Claude Code öffnen"
- **Rechtsklick im Hintergrund**: "Claude Code hier öffnen"

Öffnet automatisch ein PowerShell-Fenster und startet Claude Code im ausgewählten Verzeichnis.

## Installation

### Kontextmenü-Integration

**Schnellinstallation (PowerShell):**

1. Öffnen Sie PowerShell als Administrator
2. Führen Sie aus:
   ```powershell
   .\install-context-menu.ps1
   ```

**Alternative (Registry-Datei):**

1. Doppelklicken Sie auf `install-context-menu.reg`
2. Bestätigen Sie die Sicherheitsabfrage

**Detaillierte Anleitung**: Siehe [Kontext-menu.md](Kontext-menu.md)

## Voraussetzungen

- Windows 11 (oder Windows 10)
- Claude Code installiert (via npm oder npx)
- Administratorrechte für die Installation

## Dateien

- `install-context-menu.ps1` - PowerShell-Installationsskript
- `uninstall-context-menu.ps1` - PowerShell-Deinstallationsskript
- `install-context-menu.reg` - Registry-Installationsdatei
- `uninstall-context-menu.reg` - Registry-Deinstallationsdatei
- `Kontext-menu.md` - Ausführliche Dokumentation zur Kontextmenü-Integration

## Deinstallation

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
