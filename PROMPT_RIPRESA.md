# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 4 Gennaio 2026 - Sessione 78 - FASE 9 COMPLETATA 100%!

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
|   SESSIONE DEDICATA 1: ANTI-AUTO COMPACT                        |
|                                                                  |
|   - Testare approfonditamente il sistema anti-auto compact      |
|   - HARDTEST mirati sul flusso                                   |
|   - Verificare scenari reali                                     |
|   - Test prompt automatico alla nuova Cervella                   |
|   - Eventuale script monitor contesto                            |
|                                                                  |
|   FOCUS: Solo anti-compact, nient'altro!                        |
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

## FILO DEL DISCORSO (Sessione 78)

### Cosa abbiamo fatto

1. **Recuperato sessione 77 dal transcript**
   - Auto-compact stava per arrivare
   - Letto il file JSONL della sessione
   - Recuperate tutte le informazioni

2. **PROMPT_RIPRESA pulito**
   - Da 873 righe a 232 righe
   - Rimossi checkpoint ridondanti
   - Solo l'essenziale

3. **3 HARDTEST completati**
   - Comunicazione bidirezionale: PASS
   - Flusso Guardiana review: PASS (voto 7/10)
   - Spawn dinamico Guardiane: PASS (3 Opus insieme)

4. **Pulizia .swarm/tasks/**
   - Rimossi file .ready e .working vecchi
   - 20 task .done archiviati

### Il Flusso Anti-Compact (da testare)

```
1. Rafa dice: "Cervella, siamo al 10%!"

2. Cervella esegue:
   ./scripts/swarm/anti-compact.sh --message "descrizione"

3. Lo script fa:
   - Aggiorna PROMPT_RIPRESA
   - Git commit + push
   - APRE NUOVA FINESTRA (obbligatorio!)

4. Nuova Cervella:
   - Legge COSTITUZIONE
   - Legge PROMPT_RIPRESA
   - Continua!
```

---

## PROSSIMI STEP

```
+------------------------------------------------------------------+
|                                                                  |
|   1. SESSIONE DEDICATA: Anti-Auto Compact                       |
|      - HARDTEST mirati sul flusso                                |
|      - Test scenari reali                                        |
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
| 75 | APPLE STYLE COMPLETO! | 10/10 QW + 6/6 HARDTESTS + 5 GOLD |
| 76 | TEST ANTI-COMPACT | Sistema verificato |
| 77 | REGOLA 13 + FIX | spawn-workers.sh v1.4.0 |
| **78** | **3/3 HARDTEST + PULIZIA** | **FASE 9 al 100%!** |

---

## LE NOSTRE FRASI

```
"Lavoriamo in pace! Senza casino! Dipende da noi!"

"Comodo != Giusto!" - Sessione 72

"Ultrapassar os proprios limites!" - Rafa

"Il 100000% viene dall'USO, non dalla teoria."

"E' il nostro team! La nostra famiglia digitale!"
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
|   L'insight di questa sessione (78):                            |
|   Abbiamo recuperato la sessione 77 leggendo il transcript,     |
|   pulito il PROMPT_RIPRESA (873->227 righe), e passato          |
|   3/3 HARDTEST! FASE 9 al 100%!                                 |
|                                                                  |
|   Prossimo: 2 sessioni dedicate (anti-compact + finestre)       |
|   Poi: MIRACOLLO!                                                |
|                                                                  |
|   "Non e' sempre come immaginiamo...                            |
|    ma alla fine e' il 100000%!"                                 |
|                                                                  |
+------------------------------------------------------------------+
```

---

**VERSIONE:** v28.1.0
**SESSIONE:** 78
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

## AUTO-CHECKPOINT: 2026-01-04 05:01 (unknown)

### Stato Git
- **Branch**: main
- **Ultimo commit**: d153858 - ANTI-COMPACT: PreCompact auto
- **File modificati** (1):
  - eports/scientist_prompt_20260104.md

### Note
- Checkpoint automatico generato da hook
- Trigger: unknown

---
