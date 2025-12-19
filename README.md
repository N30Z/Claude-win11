# Claude Code - Windows 11 Extensions

Erweiterungen und Integrationen f\u00fcr Claude Code unter Windows 11.

## \u00dcbersicht

Dieses Repository enth\u00e4lt n\u00fctzliche Windows 11 Integrationen f\u00fcr Claude Code, um Ihre Produktivit\u00e4t zu steigern.

## Features

### \u2705 Kontextmen\u00fc-Integration

F\u00fcgt Claude Code direkt in das Windows 11 Kontextmen\u00fc ein:

- **Rechtsklick auf Ordner**: "in Claude Code \u00f6ffnen"
- **Rechtsklick im Hintergrund**: "Claude Code hier \u00f6ffnen"

\u00d6ffnet automatisch ein PowerShell-Fenster und startet Claude Code im ausgew\u00e4hlten Verzeichnis.

## Installation

### Kontextmen\u00fc-Integration

**Schnellinstallation (PowerShell):**

1. \u00d6ffnen Sie PowerShell als Administrator
2. F\u00fchren Sie aus:
   ```powershell
   .\install-context-menu.ps1
   ```

**Alternative (Registry-Datei):**

1. Doppelklicken Sie auf `install-context-menu.reg`
2. Best\u00e4tigen Sie die Sicherheitsabfrage

**Detaillierte Anleitung**: Siehe [Kontext-menu.md](Kontext-menu.md)

## Voraussetzungen

- Windows 11 (oder Windows 10)
- Claude Code installiert (via npm oder npx)
- Administratorrechte f\u00fcr die Installation

## Dateien

- `install-context-menu.ps1` - PowerShell-Installationsskript
- `uninstall-context-menu.ps1` - PowerShell-Deinstallationsskript
- `install-context-menu.reg` - Registry-Installationsdatei
- `uninstall-context-menu.reg` - Registry-Deinstallationsdatei
- `Kontext-menu.md` - Ausf\u00fchrliche Dokumentation zur Kontextmen\u00fc-Integration

## Deinstallation

**PowerShell:**
```powershell
.\uninstall-context-menu.ps1
```

**Registry:**
Doppelklicken Sie auf `uninstall-context-menu.reg`

## Verwendung

Nach der Installation k\u00f6nnen Sie:

1. Im Windows Explorer zu einem beliebigen Ordner navigieren
2. Rechtsklick auf einen Ordner \u2192 "in Claude Code \u00f6ffnen"
3. Oder Rechtsklick im leeren Bereich \u2192 "Claude Code hier \u00f6ffnen"

Claude Code startet automatisch im ausgew\u00e4hlten Verzeichnis.

## Anpassungen

Sie k\u00f6nnen die Skripte und Registry-Dateien anpassen, um:

- Benutzerdefinierte Icons zu verwenden
- Die Textbezeichnungen zu \u00e4ndern
- Den Claude Code-Befehl anzupassen
- Zus\u00e4tzliche Parameter hinzuzuf\u00fcgen

Details finden Sie in [Kontext-menu.md](Kontext-menu.md)

## Probleml\u00f6sung

Bei Problemen konsultieren Sie bitte die [Kontext-menu.md](Kontext-menu.md) Dokumentation oder erstellen Sie ein Issue.

## Lizenz

Siehe [LICENSE](LICENSE) f\u00fcr Details.

## Beitr\u00e4ge

Beitr\u00e4ge, Verbesserungsvorschl\u00e4ge und Bug-Reports sind willkommen!

## Support

F\u00fcr Fragen oder Probleme erstellen Sie bitte ein Issue im Repository.
