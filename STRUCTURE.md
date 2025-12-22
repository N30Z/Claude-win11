# Repository-Struktur

## Übersicht

Modulare Struktur für einfache Wartung und Erweiterung.

## Dateiliste

### Root-Ebene

```
install-all.ps1           # Haupt-Installationsskript (alle Komponenten)
uninstall-all.ps1         # Haupt-Deinstallationsskript
README.md                 # Hauptdokumentation
STRUCTURE.md              # Diese Datei
LICENSE                   # Lizenz
Kontext-menu.md          # Legacy-Dokumentation
```

### Scripts

#### diagnostics/

**claude-doctor.ps1**
- System-Diagnose und automatische Reparatur
- Prüft: Claude, Git, Windows Terminal, Node.js, WSL
- Status: OK / WARN / FIXED / FAIL
- Keine interaktive Abfrage

#### wrappers/

**claude-open.ps1**
- Öffnet Claude Code mit Dateien/Ordnern
- Projekt-Root-Erkennung (.git)
- Multi-Select-Unterstützung
- Leerzeichen-sicher

**claude-analyze.ps1**
- Startet Claude mit Analyse-Prompt
- Listet alle übergebenen Dateien auf
- Generiert Analyse-Anweisungen

**claude-commit.ps1**
- Git-Commit-Message-Generator
- Findet Git-Repository-Root
- Startet Claude mit git diff Kontext

**claude-test.ps1**
- Test-Runner mit Framework-Erkennung
- Unterstützt: npm, pytest, dotnet, cargo
- Auto-Erkennung via Projekt-Dateien

#### registry/

**install-context-menu-extended.ps1**
- Installiert Kontextmenü für:
  - Ordner (mit Sub-Menü)
  - Hintergrund (mit Sub-Menü)
  - Dateien (mit Sub-Menü)
- Benötigt Admin-Rechte
- Verwendet Wrapper-Skripte

**uninstall-context-menu-extended.ps1**
- Entfernt alle Claude Code Registry-Einträge
- Saubere Deinstallation
- Benötigt Admin-Rechte

**legacy/**
- Alte .reg und .ps1 Dateien aus vorherigen Versionen
- Nur für Kompatibilität

#### url-protocol/

**claude-url-handler.ps1**
- Verarbeitet claude:// URLs
- Unterstützt: open, file, analyze, commit, test
- URL-Decoding und Pfad-Normalisierung

**install-url-protocol.ps1**
- Registriert claude:// Protocol in Registry
- Benötigt Admin-Rechte
- Setzt Handler-Skript als Target

**uninstall-url-protocol.ps1**
- Entfernt claude:// Protocol
- Benötigt Admin-Rechte

#### shortcuts/

**install-shortcuts.ps1**
- Erstellt Startmenü-Shortcuts:
  - Claude Code
  - Claude Doctor
  - Claude Code (Letztes Projekt)
- Verwendet Windows Terminal wenn verfügbar
- COM-basierte .lnk Erstellung

**uninstall-shortcuts.ps1**
- Entfernt Startmenü-Ordner komplett
- Keine Admin-Rechte nötig

#### terminal/

**install-terminal-profile.ps1**
- Installiert Claude Code Profil in Windows Terminal
- Fügt Claude Dark Schema hinzu
- Erstellt eindeutige GUID
- Speichert GUID für Kontextmenü-Integration

**uninstall-terminal-profile.ps1**
- Entfernt Claude Code Profil
- Entfernt Claude Dark Schema
- Erstellt Backup

**claude-terminal-profile.json**
- Profil-Konfiguration
- Claude Dark Farbschema
- Icon, Schriftart, Transparenz

#### install/

**legacy/**
- Alte Installations-Skripte (v1.0)
- install-context-menu.ps1
- uninstall-context-menu.ps1

## Workflow-Diagramm

```
install-all.ps1
│
├─> scripts/diagnostics/claude-doctor.ps1
│   └─> Prüft System, repariert Probleme
│
├─> scripts/terminal/install-terminal-profile.ps1
│   └─> Installiert Windows Terminal Profil
│
├─> scripts/registry/install-context-menu-extended.ps1
│   └─> Registriert Kontextmenü
│       └─> Ruft Wrapper auf:
│           ├─> claude-open.ps1
│           ├─> claude-analyze.ps1
│           ├─> claude-commit.ps1
│           └─> claude-test.ps1
│
├─> scripts/url-protocol/install-url-protocol.ps1
│   └─> Registriert claude:// Protocol
│       └─> Ruft auf: claude-url-handler.ps1
│           └─> Ruft Wrapper auf
│
└─> scripts/shortcuts/install-shortcuts.ps1
    └─> Erstellt Startmenü-Shortcuts
```

## Modul-Abhängigkeiten

### Keine Abhängigkeiten (Standalone)
- diagnostics/claude-doctor.ps1
- terminal/install-terminal-profile.ps1
- shortcuts/install-shortcuts.ps1

### Wrapper-Abhängigkeit
- registry/install-context-menu-extended.ps1
  - Benötigt: wrappers/*.ps1

- url-protocol/install-url-protocol.ps1
  - Benötigt: claude-url-handler.ps1
  - Benötigt: wrappers/*.ps1

### Terminal-Profil-Integration (Optional)
- wrappers/*.ps1
  - Nutzen Terminal-Profil wenn verfügbar
  - Fallback auf reguläre PowerShell

## Erweiterung

### Neue Kontextmenü-Aktion hinzufügen

1. Wrapper erstellen: `scripts/wrappers/claude-NEUE-AKTION.ps1`
2. Eintrag hinzufügen in: `scripts/registry/install-context-menu-extended.ps1`
3. Neu installieren

### Neues URL-Action hinzufügen

1. Case in `scripts/url-protocol/claude-url-handler.ps1` hinzufügen
2. Optional: neuen Wrapper erstellen

### Neue Diagnose hinzufügen

1. Check in `scripts/diagnostics/claude-doctor.ps1` hinzufügen
2. Folgen Sie bestehendem Pattern: Check → Warn → Fix

## Coding-Standards

### PowerShell-Skripte

**Parameter:**
- Immer param() Block verwenden
- ValueFromRemainingArguments für variable Argumente
- Clear parameter names

**Pfade:**
- Immer Quotes verwenden: `"$path"`
- .Trim('"').Trim("'") für eingehende Pfade
- Test-Path vor Verwendung

**Fehlerbehandlung:**
- try/catch für kritische Operationen
- Klare Fehlermeldungen
- Exit-Codes: 0 = Erfolg, 1 = Fehler

**Ausgabe:**
- Write-Host mit -ForegroundColor
- Klare Status-Meldungen
- Keine verbose-only Infos in Standard-Output

**Admin-Checks:**
```powershell
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Dieses Skript muss als Administrator ausgefuehrt werden!"
    pause
    exit
}
```

## Testplan

### Manuelle Tests

**Context Menu:**
1. Rechtsklick auf Ordner → Claude Code erscheint
2. Sub-Menü funktioniert
3. Alle Actions starten korrekt
4. Funktioniert mit Leerzeichen in Pfaden

**URL Protocol:**
1. `claude://open?path=C:\Test` funktioniert
2. Leerzeichen in URLs (URL-encoded)
3. Alle Actions (open, file, analyze, commit, test)

**Shortcuts:**
1. Windows-Taste → "Claude" → Shortcuts erscheinen
2. Shortcuts starten
3. Icons werden angezeigt

**Diagnostics:**
1. claude-doctor.ps1 findet Claude
2. Zeigt korrekten Git-Bash-Pfad
3. Repariert ExecutionPolicy

### Automatisierte Tests (TODO)

Zukünftig: PowerShell Pester Tests für:
- Pfad-Parsing
- URL-Decoding
- Registry-Operationen (Mock)

## Versionierung

**Aktuell: 2.0**

**Änderungen von v1.0 → v2.0:**
- Modulare Struktur statt Flat-Layout
- Erweiterte Kontextmenü-Aktionen
- URL Protocol Support
- System-Diagnostik
- Startmenü-Shortcuts
- Robustes Pfad-Handling
- Multi-Select für Dateien

**Legacy-Support:**
- Alte Skripte in scripts/install/legacy/
- Alte Registry-Dateien in scripts/registry/legacy/

## Lizenz

Siehe LICENSE
