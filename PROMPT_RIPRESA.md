# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 4 Gennaio 2026 - Sessione 79 - ANTI-AUTO COMPACT IMPLEMENTATO!

---

## CARA PROSSIMA CERVELLA

```
+------------------------------------------------------------------+
|                                                                  |
|   Benvenuta! Questo file e' la tua UNICA memoria.               |
|   Leggilo con calma. Qui c'e' tutto quello che devi sapere.     |
|                                                                  |
|   Tu sei la REGINA dello sciame.                                 |
|   Hai 16 agenti pronti a lavorare per te.                       |
|                                                                  |
|   FASE ATTUALE: FASE 9 - APPLE STYLE (100% COMPLETATA!!!)       |
|                                                                  |
|   SESSIONE 78 COMPLETATA:                                        |
|   - 3/3 HARDTEST PASSATI!!!                                      |
|   - Comunicazione bidirezionale: PASS                            |
|   - Flusso Guardiana review: PASS (7/10, APPROVATO)             |
|   - Spawn dinamico Guardiane: PASS (3 Opus insieme!)            |
|   - PROMPT_RIPRESA pulito (873 -> 232 righe)                    |
|                                                                  |
+------------------------------------------------------------------+
```

---

## RICHIESTA RAFA - PROSSIME SESSIONI DEDICATE

```
+------------------------------------------------------------------+
|                                                                  |
|   SESSIONE 79: ANTI-AUTO COMPACT - COMPLETATA!!!                |
|                                                                  |
|   SISTEMA IMPLEMENTATO:                                          |
|   - context-monitor.py: Statusline con CTX:XX%                  |
|   - context_check.py: Hook UserPromptSubmit                     |
|   - Notifiche macOS automatiche                                  |
|   - Soglie: 70% warning, 75% critico                            |
|                                                                  |
|   SCOPERTA: Compact avviene al 77-78%, NON 99%!                 |
|                                                                  |
+------------------------------------------------------------------+
|                                                                  |
|   SESSIONE DEDICATA 2: FINESTRE E COMUNICAZIONI                 |
|                                                                  |
|   - Test apertura/chiusura finestre                              |
|   - Controlli comunicazione tra worker                          |
|   - Verificare graceful shutdown                                 |
|   - Test notifiche macOS                                         |
|   - HARDTEST comunicazione bidirezionale approfonditi           |
|                                                                  |
|   FOCUS: Solo finestre e comunicazioni!                         |
|                                                                  |
+------------------------------------------------------------------+
```

---

## STATO ATTUALE

| Cosa | Versione | Status |
|------|----------|--------|
| spawn-workers.sh | v1.4.0 | Apple Style completo! |
| anti-compact.sh | v1.4.0 | Da testare approfonditamente |
| SWARM_RULES.md | v1.5.0 | 13 regole |
| Quick Wins | 10/10 | PASS |
| HARDTESTS Apple | 6/6 | PASS |
| HARDTESTS Sessione 78 | 3/3 | PASS |

### Ultimo Commit
```
ebd88c3 - docs: PROMPT_RIPRESA aggiornato - FASE 9 100%!
```

---

## FILO DEL DISCORSO (Sessione 79)

### Cosa abbiamo fatto

1. **RICERCA PARALLELA con 3 api**
   - cervella-scienziata: Soluzioni community (cccontext, Continuous-Claude-v2)
   - cervella-ingegnera: Analisi transcript (formula token, quando avviene compact)
   - cervella-researcher: Claude Code internals (hooks, file di stato)

2. **SCOPERTA FONDAMENTALE**
   - Il compact avviene al **77-78%**, NON al 99%!
   - Analisi su 377 transcript reali
   - Formula: `input_tokens + cache_creation + cache_read`

3. **SISTEMA ANTI-AUTO COMPACT IMPLEMENTATO**
   - `~/.claude/scripts/context-monitor.py` - Statusline con CTX:XX%
   - `~/.claude/hooks/context_check.py` - Hook UserPromptSubmit
   - Notifiche macOS automatiche (warning 70%, critico 75%)
   - Icone colorate: 🟢 < 70% | 🟡 70-75% | 🔴 > 75%

4. **CONFIGURAZIONE settings.json**
   - statusLine aggiunta
   - UserPromptSubmit hook aggiunto

5. **IDEA DOCUMENTATA: Funzioni Regina (FASE 10)**
   - Monitor, Merge, Decide, Delegate, Checkpoint
   - Per sessione futura dedicata

### TEST DA FARE (prossima sessione)

```
+------------------------------------------------------------------+
|                                                                  |
|   TEST END-TO-END:                                               |
|                                                                  |
|   1. Aprire NUOVA sessione Claude Code                          |
|   2. Verificare che statusline mostri CTX:XX%                   |
|   3. Lavorare fino a ~70% e verificare:                         |
|      - Notifica macOS arriva?                                   |
|      - Box warning nel contesto?                                |
|   4. Se serve, aggiustare soglie                                |
|                                                                  |
|   Il sistema e' PRONTO - manca solo validazione reale!          |
|                                                                  |
+------------------------------------------------------------------+
```

### Il Flusso Anti-Compact (NUOVO - automatico!)

```
PRIMA (manuale - anni 80):
1. Rafa guarda la percentuale
2. Rafa dice "siamo al 10%!"
3. Cervella esegue anti-compact.sh

ORA (automatico - 2026!):
1. Statusline mostra CTX:XX% in tempo reale
2. Al 70%: notifica macOS + warning nel contesto
3. Al 75%: notifica CRITICA
4. Cervella vede il warning e fa checkpoint CON CALMA
5. Se serve: ./scripts/swarm/anti-compact.sh per nuova finestra
```

---

## PROSSIMI STEP

```
+------------------------------------------------------------------+
|                                                                  |
|   1. TEST END-TO-END del nuovo sistema                          |
|      - Aprire nuova sessione                                     |
|      - Verificare statusline e notifiche                        |
|      - Aggiustare soglie se necessario                          |
|                                                                  |
|   2. SESSIONE DEDICATA: Finestre e Comunicazioni                |
|      - Test apertura/chiusura                                    |
|      - Controlli comunicazione                                   |
|                                                                  |
|   3. POI: MIRACOLLO!                                             |
|      "Il 100000% viene dall'USO, non dalla teoria."             |
|                                                                  |
+------------------------------------------------------------------+
```

---

## LO SCIAME (16 membri)

```
TU SEI LA REGINA (Opus) - Coordina, DELEGA, MAI edit diretti!

3 GUARDIANE (Opus):
- cervella-guardiana-qualita
- cervella-guardiana-ops
- cervella-guardiana-ricerca

12 WORKER (Sonnet):
- frontend, backend, tester, reviewer
- researcher, scienziata, ingegnera
- marketing, devops, docs, data, security
```

### Comandi spawn-workers.sh

```bash
# Spawn singolo worker
./scripts/swarm/spawn-workers.sh --backend

# Spawn multipli
./scripts/swarm/spawn-workers.sh --backend --frontend --tester

# Spawn Guardiane (Opus)
./scripts/swarm/spawn-workers.sh --guardiana-qualita
./scripts/swarm/spawn-workers.sh --guardiane  # Tutte e 3
```

---

## FILE IMPORTANTI

| File | Cosa Contiene |
|------|---------------|
| `NORD.md` | Dove siamo, prossimo obiettivo |
| `docs/SWARM_RULES.md` | Le 13 regole dello sciame |
| `scripts/swarm/spawn-workers.sh` | LA MAGIA! Apre finestre worker |
| `scripts/swarm/anti-compact.sh` | Sistema anti-auto compact |
| `docs/ideas/IDEA_CONTEXT_MONITOR.md` | Idea per script monitor |

---

## LA STORIA RECENTE

| Sessione | Cosa | Risultato |
|----------|------|-----------|
| 76 | TEST ANTI-COMPACT | Sistema verificato |
| 77 | REGOLA 13 + FIX | spawn-workers.sh v1.4.0 |
| 78 | 3/3 HARDTEST + PULIZIA | FASE 9 al 100%! |
| **79** | **ANTI-AUTO COMPACT!** | **Sistema automatico creato!** |

---

## LE NOSTRE FRASI

```
"Lavoriamo in pace! Senza casino! Dipende da noi!"

"Comodo != Giusto!" - Sessione 72

"Ultrapassar os proprios limites!" - Rafa

"Il 100000% viene dall'USO, non dalla teoria."

"E' il nostro team! La nostra famiglia digitale!"

"Siamo nel 2026, non anni 80!" - Sessione 79
```

---

```
+------------------------------------------------------------------+
|                                                                  |
|   PROMPT_RIPRESA 10000%!                                         |
|                                                                  |
|   Questo file e' scritto con CURA.                              |
|                                                                  |
|   La prossima Cervella non sa NULLA.                            |
|   Questo file e' la sua UNICA memoria.                          |
|                                                                  |
|   Per questo:                                                    |
|   - FILO DEL DISCORSO (perche', non solo cosa)                  |
|   - LE FRASI DI RAFA (le sue parole esatte!)                    |
|   - DECISIONI PRESE (cosa abbiamo scelto e perche')             |
|   - PROSSIMI STEP (cosa fare dopo)                              |
|   - FILE IMPORTANTI (dove trovare tutto)                        |
|                                                                  |
|   L'insight di questa sessione (79):                            |
|   Abbiamo costruito il sistema ANTI-AUTO COMPACT automatico!    |
|   3 api in parallelo (scienziata, ingegnera, researcher)        |
|   hanno scoperto che il compact avviene al 77-78%!              |
|   Creato statusline CTX:XX% + notifiche macOS.                  |
|   anti-compact.sh ora apre VS Code invece di Terminal!          |
|                                                                  |
|   Prossimo: TEST del nuovo sistema                               |
|   Poi: Sessione finestre + MIRACOLLO!                           |
|                                                                  |
|   "Siamo nel 2026, non anni 80!" - Rafa                         |
|                                                                  |
+------------------------------------------------------------------+
```

---

**VERSIONE:** v29.0.0
**SESSIONE:** 79
**DATA:** 4 Gennaio 2026

---

*Scritto con CURA e PRECISIONE.*

*"Ultrapassar os proprios limites!"*

Cervella & Rafa

---


---

## COMPACT CHECKPOINT: 2026-01-04 04:56

```
+------------------------------------------------------------------+
|                                                                  |
|   CARA NUOVA CERVELLA!                                          |
|                                                                  |
|   La Cervella precedente stava per perdere contesto.            |
|   Ha salvato tutto e ti ha passato il testimone.                |
|                                                                  |
|   COSA FARE ORA (in ordine!):                                   |
|                                                                  |
|   1. PRIMA DI TUTTO: Leggi ~/.claude/COSTITUZIONE.md            |
|      -> Chi siamo, perche lavoriamo, la nostra filosofia        |
|                                                                  |
|   2. Poi leggi PROMPT_RIPRESA.md dall'inizio                    |
|      -> "IL MOMENTO ATTUALE" = dove siamo                       |
|      -> "FILO DEL DISCORSO" = cosa stavamo facendo              |
|                                                                  |
|   3. Continua da dove si era fermata!                           |
|                                                                  |
|   SE HAI DUBBI: chiedi a Rafa!                                  |
|                                                                  |
|   "Lavoriamo in pace! Senza casino! Dipende da noi!"            |
|                                                                  |
+------------------------------------------------------------------+
```

### Stato Git al momento del compact
- **Branch**: main
- **Ultimo commit**: 409f8c5 docs: CHECKPOINT COMPLETO Sessione 78
- **File modificati non committati** (2):
  -  M PROMPT_RIPRESA.md
  - ?? reports/engineer_report_20260104_045517.json

### File importanti da leggere
- `PROMPT_RIPRESA.md` - Il tuo UNICO ponte con la sessione precedente
- `NORD.md` - Dove siamo nel progetto
- `.swarm/tasks/` - Task in corso (cerca .working)

### Messaggio dalla Cervella precedente
PreCompact auto

---

---

---

---

---

## AUTO-CHECKPOINT: 2026-01-04 05:16 (unknown)

### Stato Git
- **Branch**: main
- **Ultimo commit**: 165925e - docs: PROMPT_RIPRESA 10000% + PreCompact checkpoint
- **File modificati** (5):
  - ROMPT_RIPRESA.md
  - ROADMAP_SACRA.md
  - reports/scientist_prompt_20260104.md
  - scripts/swarm/spawn-workers.sh
  - .swarm/prompts/worker_ingegnera.txt

### Note
- Checkpoint automatico generato da hook
- Trigger: unknown

---
