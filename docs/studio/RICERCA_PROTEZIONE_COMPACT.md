# RICERCA: Protezione Contesto da Compact

> *Ricerca: 2 Gennaio 2026 - Sessione 42*

---

## SINTESI ESECUTIVA

```
SI, ESISTONO SOLUZIONI!

1. NATIVA: /compact con istruzioni custom (SUBITO!)
2. HOOK: PreCompact (BUG attivo #13572)
3. TOOL: c0ntextKeeper (SOLUZIONE COMPLETA!)
4. BEST PRACTICE: Checkpoint + Git (gia facciamo!)
```

---

## 1. SOLUZIONE NATIVA - `/compact` con istruzioni

### COME USARE

```bash
/compact In addition to the default summary, explicitly include these sections at the END:

0) COMPACT NUMBER - This is compact #[N] (increment from previous)
1) IMMEDIATE NEXT ACTION - [Specific imperative with file paths]
2) SETTLED DECISIONS - [a) Decision with rationale]
3) DEAD ENDS - [a) What failed and WHY]
4) TRUST ANCHORS - [a) What's verified working]
5) USER PREFERENCES - [a) Preference (PERMANENT if lasting)]
6) TASK QUEUE - [a) Task (dependencies)]
7) BREAKTHROUGHS - [a) "Key insight" - Why it matters]
```

### ESEMPI SEMPLICI

```bash
/compact preserve the coding patterns we established

/compact only keep the names of the websites we reviewed

/compact Focus on preserving current implementation and decisions
```

### PRO/CONTRO

- **PRO:** Zero setup, funziona SUBITO
- **CONTRO:** Manuale, devi ricordarti di farlo

---

## 2. PRECOMPACT HOOK (BUG ATTIVO!)

### CONFIGURAZIONE

```json
{
  "hooks": {
    "PreCompact": [
      {
        "matcher": "auto",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/backup-transcript.sh"
          }
        ]
      }
    ]
  }
}
```

### PROBLEMA

Issue #13572 - hook NON si esegue su `/compact` manuale!

**RACCOMANDAZIONE:** Aspettare fix prima di usare.

---

## 3. c0ntextKeeper (SOLUZIONE COMPLETA!)

### COS'E'

Tool community che salva TUTTO automaticamente.

**GitHub:** https://github.com/Capnjbrown/c0ntextKeeper

### CARATTERISTICHE

- 7 hook intercettati (PreCompact, Stop, etc.)
- 30 comandi CLI
- 3 MCP tools per Claude
- 483 test, < 10ms
- Archivio locale con ricerca AI

### COMANDI PRINCIPALI

```bash
c0ntextkeeper setup           # Setup iniziale
c0ntextkeeper status          # Verifica stato
c0ntextkeeper search "query"  # Ricerca archivio
c0ntextkeeper doctor          # Diagnostica
```

### PRO/CONTRO

- **PRO:** Automatico, completo, production-ready
- **CONTRO:** Dipendenza esterna, setup richiesto

---

## RACCOMANDAZIONE FINALE

### STRATEGIA HYBRID

```
1. OGGI (immediate):
   - Usare /compact con istruzioni custom
   - Checkpoint ogni 30-45min (gia facciamo!)
   - Git commit frequenti (gia facciamo!)

2. QUESTA SETTIMANA:
   - Studiare c0ntextKeeper
   - Test su CervellaSwarm

3. MONITORARE:
   - Issue #13572 PreCompact hook
```

---

## FONTI

- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Hooks Reference](https://code.claude.com/docs/en/hooks)
- [c0ntextKeeper](https://github.com/Capnjbrown/c0ntextKeeper)
- [Issue #13572](https://github.com/anthropics/claude-code/issues/13572)

---

*"Nulla e complesso - solo non ancora studiato!"*
