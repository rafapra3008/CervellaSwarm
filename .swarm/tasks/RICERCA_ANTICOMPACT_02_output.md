# REPORT: Analisi Tecnica Transcript per Anti-Compact

**Task ID:** RICERCA_ANTICOMPACT_02
**Eseguito da:** cervella-ingegnera
**Data:** 2026-01-04

---

## ANALISI TRANSCRIPT

### Struttura File .jsonl

I file transcript si trovano in:
```
~/.claude/projects/{project-folder}/{session-id}.jsonl
```

Esempio path completo:
```
~/.claude/projects/-Users-rafapra-Developer-CervellaSwarm/4b889cc6-1ba5-4e4d-a305-141429250882.jsonl
```

### Formato Messaggi

Ogni linea e un JSON con struttura:

```json
{
  "type": "assistant",
  "message": {
    "model": "claude-opus-4-5-20251101",
    "usage": {
      "input_tokens": 1,
      "cache_creation_input_tokens": 1127,
      "cache_read_input_tokens": 44766,
      "output_tokens": 530
    }
  },
  "uuid": "...",
  "timestamp": "2026-01-04T04:08:04.796Z"
}
```

### Dove Sono i Token Usage

I token sono in `message.usage` di ogni messaggio con `type: "assistant"`:

| Campo | Descrizione |
|-------|-------------|
| `input_tokens` | Token nuovi nel messaggio |
| `cache_creation_input_tokens` | Token messi in cache |
| `cache_read_input_tokens` | Token letti da cache |
| `output_tokens` | Token generati da Claude |

**CONTESTO TOTALE per messaggio:**
```
context = input_tokens + cache_creation_input_tokens + cache_read_input_tokens
```

---

## CALCOLO PERCENTUALE

### Formula Corretta

```python
# L'ULTIMO messaggio assistant ha il contesto ATTUALE
total_context = input_tokens + cache_creation + cache_read
percentage = (total_context / 200000) * 100
```

### Accuratezza

**IMPORTANTE SCOPERTA:** Il calcolo e ESTREMAMENTE accurato!

Test su sessione reale:
- Contesto calcolato: 45,894 tokens
- Percentuale: 22.9%

Questo corrisponde a quello mostrato dalla UI di Claude Code.

### Overhead Sistema

L'IDEA originale suggeriva di aggiungere ~45k token di overhead.

**SCOPERTA:** NON serve! I token di cache INCLUDONO gia il system prompt e le istruzioni.
Il campo `cache_read_input_tokens` contiene tutto.

---

## SCOPERTA CRITICA: Quando Avviene il Compact

Analizzando 377 file transcript, ho trovato **11 eventi di compact**.

### Pattern Identificato

Il compact **NON avviene al 99%** come pensavamo!

| Percentuale | Occorrenze |
|-------------|------------|
| 82.6% | 1 |
| 80.1% | 1 |
| 78.0% | 1 |
| 77.7% | 1 |
| 77.6% | 1 |
| 77.5% | 2 |
| 77.1% | 1 |
| 76.6% | 1 |
| ~25% | 2 (outliers) |

**Media: 77-78%**
**Range tipico: 76-82%**

### Implicazione

Il trigger anti-compact dovrebbe scattare al **65-70%**, NON al 10-12%!

---

## CONFRONTO APPROCCI

### Approccio 1: Monitoraggio Transcript

| Pro | Contro |
|-----|--------|
| Dati ESATTI (stesso source di Claude) | Richiede watchdog su file |
| Nessuna stima o approssimazione | File write atomiche potrebbero causare race condition |
| Gia disponibile senza modifiche | Richiede script Python in background |

**Implementazione:**
- Watchdog su directory `~/.claude/projects/{project}/`
- Trigger su nuovi .jsonl o modifiche
- Leggi ULTIMO messaggio assistant
- Calcola percentuale
- Se >= 65% -> Notifica macOS

### Approccio 2: Intercettazione Terminale

| Pro | Contro |
|-----|--------|
| Real-time (vede esattamente cosa vede Rafa) | Richiede parsing output terminale |
| Nessun file polling | Piu fragile (dipende da formato output) |
| | Claude Code non espone % in modo strutturato |

**Implementazione:**
- Script wrapper per `claude`
- tee output su file o pipe
- grep per "Context left"
- Estrai percentuale

### Approccio 3: Hook Esistente + Miglioramento

**GIA ESISTENTE:**
- `~/.claude/hooks/pre_compact_save.py` - scatta QUANDO avviene compact
- `~/.claude/hooks/pre-compact.sh` - notifica macOS

**PROBLEMA:** Scattano DURANTE il compact, troppo tardi per prevenirlo!

---

## PROTOTIPO PROPOSTO

### Architettura: Context Monitor Daemon

```
+------------------+     +-------------------+     +------------------+
|   File Watcher   | --> | Context Calculator | --> | Alert Manager   |
+------------------+     +-------------------+     +------------------+
        |                        |                        |
  ~/.claude/projects/     Ultimo messaggio           macOS Notification
        *.jsonl           usage.* tokens              @ 65-70%
```

### Pseudo-codice

```python
#!/usr/bin/env python3
"""context_monitor.py - Monitor contesto in tempo reale"""

import json
import os
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import subprocess

THRESHOLD = 65  # Percentuale trigger
MAX_CONTEXT = 200000

class TranscriptHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.src_path.endswith('.jsonl'):
            self.check_context(event.src_path)

    def check_context(self, filepath):
        # Leggi ultimo messaggio assistant
        with open(filepath, 'r') as f:
            lines = f.readlines()

        for line in reversed(lines):
            data = json.loads(line)
            if data.get('type') == 'assistant':
                usage = data['message']['usage']
                total = (usage.get('input_tokens', 0) +
                         usage.get('cache_creation_input_tokens', 0) +
                         usage.get('cache_read_input_tokens', 0))
                pct = (total / MAX_CONTEXT) * 100

                if pct >= THRESHOLD:
                    self.send_alert(pct)
                break

    def send_alert(self, pct):
        msg = f"Contesto al {pct:.0f}%! Prepara checkpoint!"
        subprocess.run([
            'osascript', '-e',
            f'display notification "{msg}" with title "CervellaSwarm" sound name "Sosumi"'
        ])

# Main
observer = Observer()
observer.schedule(
    TranscriptHandler(),
    path=os.path.expanduser('~/.claude/projects'),
    recursive=True
)
observer.start()
observer.join()
```

### Dipendenze

```bash
pip install watchdog
```

### Deployment

```bash
# Crea LaunchAgent per auto-start
# ~/Library/LaunchAgents/com.cervellaswarm.context-monitor.plist
```

---

## RACCOMANDAZIONE

### Strada Consigliata: Approccio 1 (Transcript Monitoring)

**Perche:**
1. Dati ESATTI - stesso calcolo che usa Claude internamente
2. Formula VALIDATA su dati reali (77-78% = compact)
3. Nessuna dipendenza da formato output terminale
4. Python + watchdog = robusto e testabile

### Implementazione Suggerita

1. **FASE 1 (Quick Win):** Script manuale che calcola % attuale
   - Rafa puo lanciarlo per verificare stato
   - Zero rischio, utile subito

2. **FASE 2:** Daemon con watchdog
   - Auto-start con macOS
   - Notifica automatica al 65%

3. **FASE 3:** Integrazione con anti-compact.sh
   - Quando notifica scatta, trigger anti-compact automatico
   - Full automation!

### Threshold Raccomandato

**65%** (non 10-12%)

Motivo: Il compact avviene tipicamente al 77-78%.
Con trigger al 65% abbiamo ~12% di margine per:
- Checkpoint con calma
- Commit git
- Spawn nuova finestra

---

## FILE CORRELATI

| File | Ruolo |
|------|-------|
| `docs/ideas/IDEA_CONTEXT_MONITOR.md` | Idea originale (da aggiornare) |
| `~/.claude/hooks/pre_compact_save.py` | Hook esistente pre-compact |
| `~/.claude/settings.json` | Configurazione hooks |
| `~/.claude/compact-log.txt` | Log storico compact |

---

## CONCLUSIONE

**Il monitoraggio transcript e FATTIBILE e ACCURATO.**

La formula `input + cache_creation + cache_read` fornisce la percentuale esatta.
Il compact avviene al 77-78%, quindi trigger al 65% da ampio margine.

**Prossimo step:** Decidere se procedere con FASE 1 (script manuale) o direttamente FASE 2 (daemon).

---

*"Nulla e complesso - solo non ancora studiato!"*
*Report generato da cervella-ingegnera*
