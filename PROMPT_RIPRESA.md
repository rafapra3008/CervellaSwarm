# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 12 Gennaio 2026 - Sessione 175 FINALE
> **Versione:** v99.0.0 - Revenue Fix Completato!

---

## PRIMA DI TUTTO - DOVE SONO I FILE!

```
+================================================================+
|                                                                |
|   REGOLA CRITICA - LEGGI PRIMA DI FARE QUALSIASI COSA!        |
|                                                                |
|   TUTTI gli SNCP sono in: CervellaSwarm/.sncp/progetti/        |
|                                                                |
|   Miracollo    → .sncp/progetti/miracollo/stato.md             |
|   CervellaSwarm → .sncp/progetti/cervellaswarm/stato.md        |
|   Contabilita  → .sncp/progetti/contabilita/stato.md           |
|                                                                |
|   MAI cercare in miracollogeminifocus/.sncp/ (NON ESISTE!)     |
|   MAI cercare in ContabilitaAntigravity/.sncp/ (NON ESISTE!)   |
|                                                                |
+================================================================+
```

**Per Miracollo leggi:** `.sncp/progetti/miracollo/stato.md`

---

## TL;DR per Prossima Cervella

**SESSIONE 175 FINALE - TUTTO COMPLETATO!**

```
+================================================================+
|                                                                |
|   SESSIONE 175: CODE REVIEW + BUG FIX + REVENUE FIX            |
|                                                                |
|   PARTE 1 - CODE REVIEW + CI/CD:                               |
|   [x] Code Review What-If: 7.5/10 (47 issues)                  |
|   [x] Bug Fix Dropdown What-If (metodi fuori classe)           |
|   [x] Fix Workflow GitHub: docker compose (v3.1.0)             |
|   [x] Commit 61b8b11 - CHECK VERDE!                            |
|                                                                |
|   PARTE 2 - REVENUE FIX:                                       |
|   [x] Migration 036: soft delete (deleted_at, deleted_by)      |
|   [x] Endpoint DELETE /api/suggestions/applications/{id}       |
|   [x] Frontend: bottone Cancella + confirm dialog              |
|   [x] Commit befd6d9 - DEPLOYATO!                              |
|                                                                |
|   PROSSIMI STEP:                                               |
|   [ ] RateBoard Hard tests                                     |
|   [ ] What-If: Applica prezzo REALE (ora è fake!)              |
|   [ ] Fix XSS + auth (code review)                             |
|   [ ] Workflow: auto-migration                                 |
|   [ ] Monitoring post-azione (idea Rafa!)                      |
|                                                                |
|   MIRACALLOOK: FASE 0-2 + RICERCA BIG PLAYERS (45 pagine!)     |
|   ROOM MANAGER: IN PAUSA                                       |
|   WHAT-IF: COMPLETO + BUG FIX                                  |
|                                                                |
+================================================================+
```

---

## Regole Importanti (Aggiunte Sessione 172)

### 1. Costituzione Obbligatoria
```
PRIMA di ogni sessione: leggi @~/.claude/COSTITUZIONE.md
Tutti i 16 agenti hanno reminder inizio + fine
```

### 2. Rafa MAI Operazioni Tecniche
```
MAI chiedere a Rafa di:
- SSH, scp, rsync
- Docker commands
- Deploy manuali
- Qualsiasi operazione tecnica

Le Cervelle fanno TUTTO!
Regola in: ~/.claude/CLAUDE.md
```

### 3. Checklist Deploy
```
PRIMA di ogni deploy: leggi ~/.claude/CHECKLIST_DEPLOY.md
Backup, verifica, test, monitor
```

### 4. Target Qualita
```
Score 9.5/10 MINIMO SEMPRE
Documentato in: .sncp/progetti/miracollo/QUALITA_TARGET.md
```

---

## File Chiave Sessione 172

| File | Contenuto |
|------|-----------|
| `.sncp/progetti/miracollo/stato.md` | Stato What-If LIVE |
| `.sncp/progetti/miracollo/QUALITA_TARGET.md` | Target 9.5/10 |
| `.sncp/progetti/miracollo/moduli/whatif/` | File What-If |
| `~/.claude/CHECKLIST_DEPLOY.md` | Checklist deploy |
| `~/.claude/CLAUDE.md` | Regola no-ops Rafa |

---

## API What-If LIVE

```
GET  https://miracollo.com/api/v1/what-if/health
POST https://miracollo.com/api/v1/what-if/simulate
GET  https://miracollo.com/api/v1/what-if/price-curve
GET  https://miracollo.com/api/v1/properties
GET  https://miracollo.com/api/v1/properties/{id}/room-types
```

---

## Principio Guida

> "Una cosa alla volta, fatta BENE"
> "Ultrapassar os próprios limites!"
> "Non e sempre come immaginiamo... ma alla fine e il 100000%!"

---

*Pronta!* Rafa, cosa facciamo oggi?

---

---

---

---

---

---

## AUTO-CHECKPOINT: 2026-01-12 12:18 (unknown)

### Stato Git
- **Branch**: main
- **Ultimo commit**: 4eb6eaf - ANTI-COMPACT: PreCompact auto
- **File modificati** (4):
  - sncp/stato/oggi.md
  - PROMPT_RIPRESA.md
  - reports/scientist_prompt_20260112.md
  - .swarm/handoff/HANDOFF_20260112_121213.md

### Note
- Checkpoint automatico generato da hook
- Trigger: unknown

---
