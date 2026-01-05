# Task: Creare ~/.claude/hooks/common.py (DRY)

**Assegnato a:** cervella-backend
**Stato:** ready
**Priorita:** MEDIA
**Data:** 5 Gennaio 2026

---

## Contesto

La code review (8.5/10) ha trovato codice duplicato tra gli hooks Python.

Le seguenti funzioni sono IDENTICHE o quasi in 3+ file:
- `detect_project()` - 3 implementazioni
- `get_git_info()` - 2 implementazioni
- `send_notification()` - 2 implementazioni
- `KNOWN_PROJECTS` dict - 3 copie

---

## Obiettivo

Creare `~/.claude/hooks/common.py` con funzioni condivise.

---

## File da Analizzare

- `~/.claude/hooks/context_check.py`
- `~/.claude/hooks/pre_compact_save.py`
- `~/.claude/hooks/session_end_save.py`
- `~/.claude/hooks/update_prompt_ripresa.py`

---

## Output Atteso

### 1. Nuovo file: ~/.claude/hooks/common.py

```python
"""
CervellaSwarm - Hook Common Functions
=====================================
Funzioni condivise tra tutti gli hooks.
Evita duplicazione (DRY!).

Versione: 1.0.0
Data: 5 Gennaio 2026
"""

# KNOWN_PROJECTS - dizionario progetti
KNOWN_PROJECTS = {
    "miracollogeminifocus": {...},
    "ContabilitaAntigravity": {...},
    "CervellaSwarm": {...},
}

def detect_project(cwd: str) -> dict:
    """Rileva il progetto dalla directory corrente"""
    ...

def get_git_info(project_path: str) -> dict:
    """Ottiene info git (branch, ultimo commit, status)"""
    ...

def send_notification(title: str, message: str, sound: str = "default") -> bool:
    """Invia notifica macOS"""
    ...

def escape_applescript(text: str) -> str:
    """Escape completo per AppleScript (fix sicurezza!)"""
    ...
```

### 2. Aggiornare gli hooks esistenti

Ogni hook deve:
1. Importare da common: `from common import detect_project, get_git_info, ...`
2. Rimuovere le funzioni duplicate
3. Usare le funzioni da common

---

## Checklist Verifica

- [ ] common.py creato con tutte le funzioni condivise
- [ ] context_check.py aggiornato (importa da common)
- [ ] pre_compact_save.py aggiornato
- [ ] session_end_save.py aggiornato
- [ ] update_prompt_ripresa.py aggiornato
- [ ] Test: hooks funzionano ancora dopo refactoring

---

## Note

- Mantenere backward compatibility
- Se un hook ha versione speciale di una funzione, valutare se unificare o tenere separata
- Aggiungere docstrings chiare

---

*Task creato da Cervella Regina - Sessione 90*
