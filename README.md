# Claude Code - Windows 11 Integration

**Produktive Windows 11 Integration für Claude Code**

Verwandeln Sie Claude Code in ein natives Windows 11 Tool mit Explorer-Integration, URL-Protokoll, Shortcuts und System-Diagnostik.

## 🚀 Quick Start

```powershell
irm https://raw.githubusercontent.com/N30Z/Claude-win11/main/install.ps1 | iex
```

Ein Befehl. Fertig.

## ✨ Neueste Verbesserungen (v1.1)

**🔧 PowerShell ExecutionPolicy Fehlerbehandlung:**
- Automatische Erkennung wenn Scripts deaktiviert sind
- Interaktive Behebung mit einem Klick
- Klare Fehlermeldungen und alternative Lösungen

**🔧 Administrator-Neustart behoben:**
- Arbeitsverzeichnis bleibt erhalten beim Neustart
- Robuste Argument-Übergabe
- Bessere Fehlerbehandlung mit detaillierten Anweisungen

**🔧 Claude Doctor Verbesserungen:**
- Smart Administrator-Handling (optional)
- Read-Only Modus für Diagnose ohne Reparaturen
- Flexible ExecutionPolicy-Behandlung

---

## Features

### ✅ Explorer-Kontextmenü

**Ordner:**
- Hier öffnen
- Analysieren
- Commit Message generieren
- Tests ausführen

**Dateien (Single & Multi-Select):**
- Mit Claude öffnen
- Analysieren

**Hintergrund:**
- Hier öffnen
- Commit Message generieren
- Tests ausführen

**Details:**
- Automatische Projekt-Root-Erkennung (.git)
- Leerzeichen in Pfaden werden korrekt behandelt
- Multi-Select für mehrere Dateien gleichzeitig
- Intelligente Test-Framework-Erkennung (npm, pytest, dotnet, cargo)

### ✅ Windows Terminal Profil

Ein dediziertes Claude Code Profil mit:
- **Claude Dark Theme** (dunkler Hintergrund, lila/orange Akzente)
- **Claude Icon** in Titelleiste und Taskleiste
- **Cascadia Code Schriftart** für optimale Lesbarkeit
- **Acryl-Transparenz** für modernes Windows 11 Design

### ✅ URL Protocol

Starten Sie Claude Code von überall via `claude://` URLs:

```
claude://open?path=C:\Users\Username\Projects\MyProject
claude://file?path=C:\path\to\file.txt
claude://analyze?path=C:\path\to\folder
claude://commit?path=C:\path\to\repo
claude://test?path=C:\path\to\project
```

**Verwendung:**
- Im Browser oder Windows-Ausführen-Dialog
- In HTML-Links: `<a href="claude://open?path=...">Open in Claude</a>`
- Per PowerShell: `Start-Process 'claude://open?path=...'`

### ✅ Startmenü-Shortcuts

- **Claude Code** - Startet Claude Code in Windows Terminal
- **Claude Doctor** - System-Diagnose und Reparatur
- **Claude Code (Letztes Projekt)** - Öffnet Ihr bevorzugtes Projekt

### ✅ System-Diagnostik (Claude Doctor)

Automatische Überprüfung und Reparatur:

**Prüfungen:**
- Claude Command verfügbar (PATH, Aufrufbarkeit)
- Git Installation (inkl. korrekter Bash: `Git\bin\bash.exe`)
- Windows Terminal Installation
- Claude Terminal-Profil
- Node.js (optional)
- WSL (optional)
- PowerShell ExecutionPolicy

**Verhalten:**
- Klare Status-Ausgabe: `OK` / `WARN` / `FIXED` / `FAIL`
- Automatische Reparatur einfacher Probleme
- Intelligente ExecutionPolicy-Behandlung (Read-Only Modus verfügbar)
- Optional als Administrator ausführbar für Reparaturen
- Exit-Codes für Automation

**Neue Features:**
- Automatische ExecutionPolicy-Prüfung und -Behebung
- Flexibler Read-Only Modus bei fehlenden Rechten
- Smart Administrator-Neustart mit Parametererhalt

---

## Installation

### 🚀 One-Liner Installation (Direkt aus Terminal)

**PowerShell als Administrator öffnen und ausführen:**

```powershell
irm https://raw.githubusercontent.com/N30Z/Claude-win11/main/install.ps1 | iex
```

Das wars! Der Installer:
- Lädt automatisch das Repository herunter
- Prüft alle Voraussetzungen (Git, Claude CLI)
- Führt die komplette Installation durch
- Behandelt ExecutionPolicy und Administrator-Rechte automatisch

**Vorteile:**
- ✅ Keine manuelle Repository-Kloning nötig
- ✅ Automatische Updates bei erneuter Ausführung
- ✅ Einfache Installation wie Scoop oder andere Tools

---

### Lokale Installation (Repository bereits geklont)

**Als Administrator PowerShell öffnen:**

```powershell
.\install-all.ps1
```

Das Skript führt automatisch folgende Schritte aus:
0. **Claude CLI Installations-Prüfung** - Prüft, ob Claude CLI installiert ist
   - Falls nicht installiert: Fragt nach Installation via npm
   - Falls installiert aber nicht im PATH: Fügt automatisch zum PATH hinzu
1. Windows Terminal Profil (falls Windows Terminal vorhanden)
2. Explorer-Kontextmenü (Ordner, Dateien, Hintergrund)
3. URL Protocol (`claude://`)
4. Startmenü-Shortcuts

Nach der Installation:
1. Explorer neu starten (oder `explorer.exe` beenden)
2. Windows-Taste drücken → "Claude" eingeben
3. Testen: Rechtsklick auf Ordner → Claude Code

---

### Modulare Installation (Einzelne Komponenten)

#### 1. Diagnostics (empfohlen zuerst)

```powershell
.\scripts\diagnostics\claude-doctor.ps1 -Verbose
```

Prüft das System und behebt Probleme automatisch.

#### 2. Windows Terminal Profil

```powershell
.\scripts\terminal\install-terminal-profile.ps1
```

#### 3. Explorer-Kontextmenü

```powershell
# Als Administrator
.\scripts\registry\install-context-menu-extended.ps1
```

#### 4. URL Protocol

```powershell
# Als Administrator
.\scripts\url-protocol\install-url-protocol.ps1
```

#### 5. Startmenü-Shortcuts

```powershell
.\scripts\shortcuts\install-shortcuts.ps1
```

---

## Deinstallation

### Komplett-Deinstallation

```powershell
# Als Administrator
.\uninstall-all.ps1
```

### Einzelne Komponenten

```powershell
# Context Menu
.\scripts\registry\uninstall-context-menu-extended.ps1

# URL Protocol
.\scripts\url-protocol\uninstall-url-protocol.ps1

# Shortcuts
.\scripts\shortcuts\uninstall-shortcuts.ps1

# Terminal Profile
.\scripts\terminal\uninstall-terminal-profile.ps1
```

---

## Repository-Struktur

```
Claude-win11/
│
├── install.ps1                  # One-Liner Remote-Installer
├── install-all.ps1              # Haupt-Installationsskript
├── uninstall-all.ps1            # Haupt-Deinstallationsskript
├── README.md
├── LICENSE
│
└── scripts/
    │
    ├── diagnostics/
    │   └── claude-doctor.ps1    # System-Diagnose und Reparatur
    │
    ├── wrappers/
    │   ├── claude-open.ps1      # Öffnet Claude Code
    │   ├── claude-analyze.ps1   # Analysiert Dateien/Ordner
    │   ├── claude-commit.ps1    # Generiert Commit Messages
    │   └── claude-test.ps1      # Führt Tests aus
    │
    ├── registry/
    │   ├── install-context-menu-extended.ps1
    │   ├── uninstall-context-menu-extended.ps1
    │   └── legacy/              # Alte Registry-Dateien
    │
    ├── url-protocol/
    │   ├── claude-url-handler.ps1
    │   ├── install-url-protocol.ps1
    │   └── uninstall-url-protocol.ps1
    │
    ├── shortcuts/
    │   ├── install-shortcuts.ps1
    │   └── uninstall-shortcuts.ps1
    │
    ├── terminal/
    │   ├── install-terminal-profile.ps1
    │   ├── uninstall-terminal-profile.ps1
    │   └── claude-terminal-profile.json
    │
    └── install/
        └── legacy/              # Alte Installationsskripte
```

---

## Voraussetzungen

**Erforderlich:**
- Windows 11 (oder Windows 10)
- Administratorrechte (für Registry-Änderungen)

**Automatisch installiert (falls nicht vorhanden):**
- Claude Code CLI - wird bei der Installation automatisch angeboten
  - Benötigt Node.js und npm für die Installation

**Empfohlen:**
- Windows Terminal (für bestes Erlebnis)
- Git (für Commit-Message-Generierung)
- Node.js, Python, oder .NET (für Test-Runner)

---

## Verwendung

### Explorer-Kontextmenü

**Ordner:**
1. Rechtsklick auf Ordner → "Claude Code"
2. Wählen Sie: Öffnen, Analysieren, Commit, Tests

**Dateien:**
1. Datei(en) auswählen
2. Rechtsklick → "Claude Code"
3. Wählen Sie: Öffnen, Analysieren

**Hintergrund:**
1. In leerem Bereich rechtsklicken
2. "Claude Code" → gewünschte Aktion

### URL Protocol

**Browser/Ausführen-Dialog:**
```
claude://open?path=C:\Projects\MyApp
```

**HTML:**
```html
<a href="claude://analyze?path=C:\src\components">Analyze Components</a>
```

**PowerShell:**
```powershell
Start-Process "claude://commit?path=$(Get-Location)"
```

### Startmenü

Windows-Taste drücken → "Claude" eingeben → Auswählen:
- Claude Code
- Claude Doctor
- Claude Code (Letztes Projekt)

---

## Problemlösung

### Explorer-Menü erscheint nicht

1. Explorer neu starten:
   ```powershell
   taskkill /F /IM explorer.exe
   start explorer.exe
   ```

2. Registry prüfen:
   ```powershell
   # Als Administrator
   .\scripts\registry\install-context-menu-extended.ps1
   ```

### Claude Doctor verwenden

```powershell
.\scripts\diagnostics\claude-doctor.ps1 -Verbose
```

Zeigt detaillierte Informationen über:
- Claude Installation und PATH
- Git und Bash-Pfad
- Windows Terminal Status
- Fehlende Komponenten

### Häufige Probleme

**"PowerShell Scripts sind deaktiviert" (ExecutionPolicy Restricted):**
- Symptom: `install-all.ps1` oder andere Scripts lassen sich nicht ausführen
- **Lösung 1 (Automatisch):** Einfach `.\install-all.ps1` ausführen - das Script erkennt das Problem und bietet interaktive Behebung an
- **Lösung 2 (Manuell):** `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- **Lösung 3 (Einmalig):** `powershell -ExecutionPolicy Bypass -File .\install-all.ps1`
- Alle Installations-Scripts prüfen jetzt automatisch ExecutionPolicy und bieten Fixes an

**"PowerShell startet nicht als Administrator neu":**
- Problem wurde behoben in v1.1
- Scripts verwenden jetzt `-WorkingDirectory` Parameter
- Arbeitsverzeichnis bleibt beim Administrator-Neustart erhalten
- Unterstützt Pfade mit Leerzeichen korrekt

**"Claude nicht gefunden":**
- Claude Doctor ausführen
- Prüfen: `claude --version` in PowerShell
- PATH-Variable überprüfen

**"Git Bash falsch":**
- Claude Doctor zeigt korrekten Pfad an
- Verwenden Sie `Git\bin\bash.exe`, nicht `git-bash.exe`

**"Leerzeichen in Pfaden":**
- Alle Wrapper-Skripte behandeln Leerzeichen korrekt
- Bei Problemen: Issue erstellen

---

## Windows-Eigenheiten (Pragmatisch)

### Registry-Fragilitäten

**Problem:** Windows Registry ist fragil und inkonsistent.

**Lösung:**
- Installations-Skripte prüfen vorher bestehende Einträge
- Deinstallation entfernt sauber alle Spuren
- Backup wird automatisch erstellt

### Pfad-Handling

**Problem:** Windows verwendet Backslashes, URLs Slashes, PowerShell escaped beides.

**Lösung:**
- Alle Wrapper normalisieren Pfade automatisch
- Quote-Handling ist robust implementiert
- Multi-Select funktioniert auch mit Leerzeichen

### Bash-Pfad-Chaos

**Problem:** Git installiert mehrere Bash-Varianten:
- `git-bash.exe` (GUI-Wrapper, problematisch)
- `Git\bin\bash.exe` (korrekt)
- `Git\usr\bin\bash.exe` (MSYS2, auch ok)

**Lösung:**
- Claude Doctor findet und empfiehlt korrekten Pfad
- Verwendet explizit `Git\bin\bash.exe`

---

## Erweiterbarkeit

### Eigene Kontextmenü-Aktion hinzufügen

1. Wrapper-Skript erstellen:
   ```powershell
   # scripts/wrappers/claude-custom.ps1
   param([string]$Path)
   # Ihre Logik hier
   ```

2. Registry-Eintrag hinzufügen in:
   `scripts/registry/install-context-menu-extended.ps1`

3. Neu installieren:
   ```powershell
   .\scripts\registry\install-context-menu-extended.ps1
   ```

### Eigenes URL-Action hinzufügen

Erweitern Sie `scripts/url-protocol/claude-url-handler.ps1`:

```powershell
switch ($action.ToLower()) {
    # ...
    "custom" {
        $wrapper = Join-Path $wrappersPath "claude-custom.ps1"
        & powershell.exe -ExecutionPolicy Bypass -File $wrapper -Path $path
    }
}
```

---

## Beiträge

Beiträge sind willkommen!

**Fokus:**
- Zuverlässigkeit vor Features
- Pragmatische Lösungen für Windows-Probleme
- Saubere Fehlerbehandlung
- Keine Marketing-Floskeln

**Workflow:**
1. Issue erstellen
2. Fork & Branch
3. Pull Request

---

## Lizenz

Siehe [LICENSE](LICENSE).

---

## Support

**Problem?**
1. Claude Doctor ausführen: `.\scripts\diagnostics\claude-doctor.ps1 -Verbose`
2. Issue erstellen mit Output von Claude Doctor
3. Genaue Fehlermeldung und Windows-Version angeben

**Feature-Request?**
Issue erstellen mit:
- Beschreibung
- Use-Case
- Warum es wichtig ist

---

**Hinweis:** Dieses Repository ist unabhängig und nicht offiziell von Anthropic/Claude.
Es löst echte Workflow-Probleme unter Windows 11 - ohne Schnickschnack.
