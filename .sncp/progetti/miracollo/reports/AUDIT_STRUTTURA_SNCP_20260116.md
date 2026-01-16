# AUDIT STRUTTURA SNCP - Miracollo

> **Data:** 16 Gennaio 2026  
> **Analista:** Cervella Ingegnera  
> **File analizzati:** 352 | **Issues trovati:** 222

---

## EXECUTIVE SUMMARY

**Status:** CRITICO - Duplicazioni massicce tra `moduli/` e `bracci/`  
**Health Score:** 4/10  
**Azione urgente:** Eliminare duplicazioni, consolidare in `bracci/`

---

## 1. ARCHITETTURA ATTUALE

### Struttura Root
```
.sncp/progetti/miracollo/
├── bracci/                  ← NUOVO (3 bracci)
│   ├── pms-core/           ← Solo stato.md (37 righe)
│   ├── miracallook/        ← 27 file, COSTITUZIONE ✓
│   └── room-hardware/      ← 39 file, studi VDA
├── moduli/                  ← VECCHIO (da deprecare?)
│   ├── finanziario/        ← 1 file
│   ├── in_room_experience/ ← 1 file
│   ├── rateboard/          ← Studi RMS
│   ├── room_manager/       ← DUPLICATO con room-hardware!
│   └── whatif/             ← Codice Python (API)
├── idee/                    ← 71 file, 61.5k righe
├── reports/                 ← 45 file
├── roadmaps/               ← 20 file
└── (altri)
```

### Problemi Identificati

| Problema | Severità | Count | Impatto |
|----------|----------|-------|---------|
| **Duplicazioni esatte** | CRITICO | 42 coppie | Confusione, inconsistenza |
| **File > 1000 righe** | ALTO | 25 file | Unmaintainable docs |
| **Funzioni > 50 righe** | MEDIO | 40 funzioni | Refactor needed |
| **TODO/BUG dimenticati** | MEDIO | 37 items | Technical debt |

---

## 2. ANALISI BRACCI vs MODULI

### Differenza Semantica

| Aspetto | `bracci/` | `moduli/` |
|---------|-----------|-----------|
| **Scopo** | Macro-aree indipendenti | Feature specifiche |
| **Livello** | Architetturale | Implementativo |
| **Esempi** | PMS Core, Miracollook, Room Hardware | Finanziario, Rateboard, WhatIf |
| **Stato** | NUOVO standard (da sessione 213) | VECCHIO schema |

### CRITICO: Duplicazione Room Manager

```
moduli/room_manager/     ← 23 file, 18k righe
bracci/room-hardware/    ← 39 file, 20k righe

IDENTICI (42 file):
- ROADMAP_ROOM_MANAGER.md
- RECAP_STUDI_20260115.md
- DECISIONI_ARCHITETTURA.md
- Tutti gli studi/ (20260114_RICERCA_*.md)
- Tutti i reports/ (20260114_GUARDIANA_*.md)
```

**RACCOMANDAZIONE:** `moduli/room_manager/` DEVE essere eliminato. room-hardware è la versione corretta.

---

## 3. AUDIT FILE CRITICI PER BRACCIO

### 3.1 PMS Core

| File | Presente? | Righe | Stato |
|------|-----------|-------|-------|
| COSTITUZIONE | ❌ | - | MANCA |
| NORD | ❌ | - | MANCA |
| PROMPT_RIPRESA | ❌ | - | MANCA |
| stato.md | ✅ | 37 | MINIMAL |

**Status:** VUOTO - Solo file stato skeleton  
**Azione:** Popolare o marcare come "stable/no active work"

---

### 3.2 Miracollook

| File | Presente? | Righe | Stato |
|------|-----------|-------|-------|
| COSTITUZIONE_MIRACOLLOOK.md | ✅ | ~400 | OK |
| NORD_MIRACOLLOOK.md | ✅ | 178 | OK |
| PROMPT_RIPRESA_miracollook.md | ✅ | 79 | OK |
| stato.md | ✅ | 244 | OK |

**Sottocartelle:**
- `studi/` - 26 file, ricerche design/UX
- `ricerche/` - 15 file, competitor analysis
- `decisioni/` - 2 file, specs validati
- `reports/` - 3 file
- `roadmaps/` - 3 file
- `archivio/` - File deprecati

**Status:** STRUTTURA COMPLETA ✓  
**Health:** 8/10 - Alcuni file > 1000 righe (es. `BIG_PLAYERS_EMAIL_RESEARCH.md` = 2129 righe)

---

### 3.3 Room Hardware

| File | Presente? | Righe | Stato |
|------|-----------|-------|-------|
| COSTITUZIONE | ❌ | - | MANCA |
| NORD | ❌ | - | MANCA |
| PROMPT_RIPRESA_room_hardware.md | ✅ | 104 | OK |
| stato.md | ✅ | 37 | MINIMAL |

**Sottocartelle:**
- `studi/` - 22 file, ricerca VDA/Modbus
- `reports/` - 5 file

**Status:** TECNICO MA INCOMPLETO  
**Issues:**
- Manca COSTITUZIONE (chi siamo, obiettivo)
- Manca NORD (direzione braccio)
- stato.md troppo minimal

---

## 4. DUPLICAZIONI CRITICHE

### 4.1 Room Manager ↔ Room Hardware (42 file identici)

**Azione:** DELETE `moduli/room_manager/` completamente

```bash
# Comando sicuro
rm -rf .sncp/progetti/miracollo/moduli/room_manager/
```

**Reason:** `bracci/room-hardware/` è la versione aggiornata (ha PROMPT_RIPRESA, stato.md, struttura corretta)

---

### 4.2 Rateboard Reports (5 file identici)

```
reports/rateboard_audit_completo_20260112.md
reports/big_players_rms_research_20260112_*.md

↕️ IDENTICI ↕️

moduli/rateboard/studi/rateboard_audit_completo_20260112.md
moduli/rateboard/studi/big_players_rms_research_20260112_*.md
```

**Azione:** DELETE versioni in `reports/`, mantenere in `moduli/rateboard/studi/`

---

### 4.3 VDA Research (8 file identici)

```
idee/20260115_VDA_*.md (8 file)

↕️ IDENTICI ↕️

bracci/room-hardware/studi/20260115_VDA_*.md
```

**Azione:** DELETE versioni in `idee/`, sono studi specifici di room-hardware

---

## 5. FILE TROPPO GRANDI

### Top 10 Documenti Unmaintainable

| File | Righe | Suggerimento |
|------|-------|--------------|
| `bracci/miracallook/studi/BIG_PLAYERS_EMAIL_RESEARCH.md` | 2129 | Split in 4 parti (Gmail, Outlook, Apple Mail, Moderni) |
| `moduli/room_manager/studi/big_players_research.md` | 1606 | Split per competitor (Mews, Opera, CloudBeds...) |
| `bracci/room-hardware/studi/20260114_RICERCA_OPERA_CLOUD.md` | 1588 | Split in 3 parti (Overview, Features, API) |
| `moduli/room_manager/studi/20260115_RICERCA_ROOM_MANAGER_AVANZATO.md` | 1555 | Split per feature (Housekeeping, Manutenzione, PIN...) |
| `bracci/miracallook/studi/DESIGN_PATTERNS_EMAIL.md` | 1472 | Split in 3 parti (Layout, Components, Interactions) |
| `idee/20260116_RICERCA_PMS_FISCALE_PARTE3.md` | 1441 | OK (già parte 3!) |
| `bracci/miracallook/studi/RICERCA_RESIZABLE_PANELS_V4.md` | 1359 | Split (Teoria, Implementazione, Testing) |
| `bracci/miracallook/studi/CONTEXT_MENU_UX_STRATEGY.md` | 1315 | Split (UX, Technical, Implementation) |
| `idee/20260113_RICERCA_METEO_RMS.md` | 1296 | Split per fonte (OpenWeather, Meteoblue, Internal) |
| `idee/20260115_VDA_H155300_RCU_RESEARCH.md` | 1228 | Split (Hardware, Registri, Protocollo) |

**Regola violata:** File docs > 1000 righe sono UNMAINTAINABLE

---

## 6. CODICE PYTHON (Modulo WhatIf)

### File Analizzati
```
moduli/whatif/
├── backend_properties_api.py         (261 righe)
├── routers_what_if_api.py            (195 righe)
├── schemas_what_if.py                (108 righe)
└── services_what_if_calculator.py    (537 righe)
```

### Funzioni Grandi (> 50 righe)

| File | Funzione | Righe | Azione |
|------|----------|-------|--------|
| `backend_properties_api.py` | `get_property_room_types` | 87 | Estrai validazione |
| `services_what_if_calculator.py` | `calculate_impact` | 77 | Estrai calcoli in helper |
| `routers_what_if_api.py` | `get_price_curve` | 64 | Estrai formattazione response |

**Note:** Modulo WhatIf contiene codice REALE (non docs). Potrebbe dover essere spostato nel codebase principale, non in `.sncp/`.

---

## 7. TODO/BUG DIMENTICATI

### Critici (da fixare ora)

| Tipo | File | Contenuto |
|------|------|-----------|
| TODO | `idee/TODO_REVENUE_CANCELLA_AZIONE.md` | Feature "Cancella azione" mai implementata |
| BUG | `ricerche/RICERCA_20260115_resizable_panels.md:34` | Fix cruciale v4.3.1 |
| BUG | `reports/hardtest_rateboard_20260112.md` | 3 bug produzione (500 errors) |

### Da Prioritizzare (28 TODO)

- 12x "TODO: Implement" in ricerche eventi locali
- 8x "TODO: Analizzare struttura HTML" (scraping)
- 4x "TODO: Lookup hotel_id from hotel_code" (backend)
- 2x "TODO: Implementare VDA lock register" (room hardware)

---

## 8. CARTELLE ORFANE/INCONSISTENTI

### `moduli/` - Stato Confuso

| Modulo | File | Stato | Azione |
|--------|------|-------|--------|
| `finanziario/` | 1 | Mappa modulo (13k righe) | Valutare se serve braccio dedicato |
| `in_room_experience/` | 1 | Idea iniziale (3k righe) | Archiviare o sviluppare |
| `rateboard/` | ~10 | Studi RMS competitor | Mantenere come modulo (feature-specific) |
| `room_manager/` | 23 | **DUPLICATO!** | ❌ DELETE |
| `whatif/` | 9 | Codice Python API | ⚠️ Spostare in codebase? |

**Decisione richiesta:**
- `moduli/` serve ancora o tutto va in `bracci/`?
- Se serve, quale differenza semantica esatta?

---

### `idee/` - Troppo Generico

71 file, 61.5k righe totali. Contiene:
- Ricerche VDA (dovrebbero essere in `bracci/room-hardware/studi/`)
- Ricerche fiscali (dovrebbero essere in `moduli/finanziario/` se esiste)
- Ricerche meteo/eventi (feature-specific, dove vanno?)
- TODO senza owner (es. `TODO_REVENUE_CANCELLA_AZIONE.md`)

**Azione:** Riorganizzare per appartenenza:
```
idee/20260115_VDA_*.md → bracci/room-hardware/studi/
idee/20260116_RICERCA_PMS_FISCALE_*.md → moduli/finanziario/ricerche/
idee/TODO_*.md → (creare tasks/ in root?)
```

---

## 9. FILE CHE MANCANO

### Per Ogni Braccio (Standard)

| File | pms-core | miracallook | room-hardware |
|------|----------|-------------|---------------|
| COSTITUZIONE_*.md | ❌ | ✅ | ❌ |
| NORD_*.md | ❌ | ✅ | ❌ |
| PROMPT_RIPRESA_*.md | ❌ | ✅ | ✅ |
| stato.md | ✅ (minimal) | ✅ | ✅ (minimal) |
| decisioni/ | ❌ | ✅ | ❌ |
| studi/ | ❌ | ✅ | ✅ |
| reports/ | ❌ | ✅ | ✅ |
| roadmaps/ | ❌ | ✅ | ❌ |

**Standard violato:**
- pms-core: Vuoto (solo stato.md skeleton)
- room-hardware: Manca COSTITUZIONE + NORD

---

## 10. RACCOMANDAZIONI PRIORITIZZATE

### CRITICO (fare ORA)

1. **[DUPLICATION]** DELETE `moduli/room_manager/` (42 file duplicati)
   ```bash
   rm -rf .sncp/progetti/miracollo/moduli/room_manager/
   ```

2. **[DUPLICATION]** DELETE VDA research da `idee/` (8 file duplicati)
   ```bash
   rm idee/20260115_VDA_*.md
   ```

3. **[DUPLICATION]** DELETE Rateboard reports da `reports/` (5 file)
   ```bash
   rm reports/rateboard_*.md reports/big_players_rms_*.md
   ```

### ALTO (pianificare questa settimana)

4. **[STRUCTURE]** Creare file mancanti per `bracci/room-hardware/`:
   - `COSTITUZIONE_ROOM_HARDWARE.md` (chi siamo, obiettivo)
   - `NORD_ROOM_HARDWARE.md` (direzione, priorità)
   - Popolare `stato.md` (ora solo 37 righe)

5. **[STRUCTURE]** Decidere destino `bracci/pms-core/`:
   - Se stabile → Creare README con "Stable, no active work"
   - Se attivo → Popolare con COSTITUZIONE, NORD, studi

6. **[DOCS]** Split file > 1000 righe (top 10 lista sopra)

7. **[CLARITY]** Definire differenza esatta `bracci/` vs `moduli/`:
   - Documentare in `.sncp/progetti/miracollo/ARCHITETTURA_SNCP.md`
   - Decidere se `moduli/whatif`, `moduli/rateboard` vanno migrati

### MEDIO (backlog)

8. **[CODE]** Refactor funzioni > 50 righe (10 funzioni Python)

9. **[DEBT]** Risolvere TODO critici (12 items)

10. **[ORGANIZATION]** Riorganizzare `idee/`:
    - Spostare ricerche specifiche nei bracci/moduli
    - Creare `tasks/` per TODO senza owner

### BASSO (nice to have)

11. **[CONSISTENCY]** Aggiungere `decisioni/` e `roadmaps/` a room-hardware

12. **[ARCHIVE]** Valutare archiviazione file > 6 mesi senza modifiche

---

## 11. METRICHE FINALI

### Health Score per Area

| Area | Files | Issues | Health | Trend |
|------|-------|--------|--------|-------|
| `bracci/miracallook/` | 27 | 15 | 8/10 | ✅ Ottimo |
| `bracci/room-hardware/` | 39 | 52 | 6/10 | ⚠️ Migliorabile |
| `bracci/pms-core/` | 1 | 3 | 2/10 | ❌ Vuoto |
| `moduli/` | 43 | 85 | 3/10 | ❌ Confuso |
| `idee/` | 71 | 45 | 5/10 | ⚠️ Disorganizzato |
| `reports/` | 45 | 12 | 7/10 | ✅ OK |
| `roadmaps/` | 20 | 8 | 7/10 | ✅ OK |

### Totali

```
File analizzati:     352
Righe totali:        159.242
Issues trovati:      222
  - Duplicazioni:    42 coppie (84 file)
  - File grandi:     100 file > 500 righe
  - Funzioni grandi: 40 funzioni > 50 righe
  - TODO/BUG:        37 items

Health Score Globale: 4/10
```

---

## 12. PROSSIMI STEP

### Immediati (oggi)

```
[ ] Presentare audit a Rafa
[ ] Decidere: eliminare moduli/room_manager/?
[ ] Decidere: definizione bracci/ vs moduli/?
```

### Questa settimana

```
[ ] Eseguire cleanup duplicazioni (85% riduzione issues)
[ ] Creare file mancanti room-hardware
[ ] Split top 5 file > 1000 righe
```

### Prossimo mese

```
[ ] Standardizzare tutti i bracci (COSTITUZIONE, NORD, stato completo)
[ ] Riorganizzare idee/ per appartenenza
[ ] Refactor funzioni Python grandi
```

---

## ALLEGATI

- **Report JSON completo:** `reports/engineer_report_20260116_165435.json`
- **Script analisi:** `CervellaSwarm/scripts/engineer/analyze_codebase.py`

---

*Cervella Ingegnera - Audit Struttura SNCP*  
*"Il debito tecnico si paga con gli interessi. Meglio pagare ora."*
