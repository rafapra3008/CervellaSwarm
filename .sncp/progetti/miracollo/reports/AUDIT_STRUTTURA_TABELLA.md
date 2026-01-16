# AUDIT STRUTTURA SNCP - Tabella Riassuntiva

## BRACCI (Standard Nuovo)

| Braccio | Tipo | File | COSTITUZIONE | NORD | PROMPT_RIPRESA | stato.md | decisioni/ | studi/ | reports/ | roadmaps/ | Azione |
|---------|------|------|--------------|------|----------------|----------|------------|--------|----------|-----------|--------|
| **pms-core** | Braccio | 1 | ❌ | ❌ | ❌ | ✅ (37 righe) | ❌ | ❌ | ❌ | ❌ | **Popolare o marcare "stable"** |
| **miracallook** | Braccio | 27 | ✅ | ✅ | ✅ | ✅ (244 righe) | ✅ | ✅ (26) | ✅ (3) | ✅ (3) | ✅ **Ottimo - Standard completo** |
| **room-hardware** | Braccio | 39 | ❌ | ❌ | ✅ | ✅ (37 righe) | ❌ | ✅ (22) | ✅ (5) | ❌ | **Creare COSTITUZIONE + NORD** |

---

## MODULI (Standard Vecchio?)

| Modulo | Tipo | File | COSTITUZIONE | NORD | PROMPT_RIPRESA | stato.md | Sottocartelle | Azione |
|--------|------|------|--------------|------|----------------|----------|---------------|--------|
| **finanziario** | Modulo | 1 | ❌ | ❌ | ❌ | ❌ | - | Decidere se → braccio dedicato |
| **in_room_experience** | Modulo | 1 | ❌ | ❌ | ❌ | ❌ | - | Archiviare o sviluppare |
| **rateboard** | Modulo | ~10 | ❌ | ❌ | ❌ | ❌ | decisioni/, studi/, roadmaps/ | Mantenere (feature-specific) |
| **room_manager** | Modulo | 23 | ❌ | ❌ | ❌ | ❌ | studi/, reports/ | ❌ **DELETE (duplicato room-hardware)** |
| **whatif** | Modulo | 9 | ❌ | ❌ | ❌ | ❌ | Codice Python! | ⚠️ Spostare in codebase? |

---

## DUPLICAZIONI CRITICHE

| Origine | Destinazione | File Duplicati | Azione |
|---------|--------------|----------------|--------|
| `moduli/room_manager/*` | `bracci/room-hardware/*` | **42 file identici** | ❌ DELETE room_manager |
| `idee/20260115_VDA_*.md` | `bracci/room-hardware/studi/` | **8 file identici** | ❌ DELETE da idee/ |
| `reports/rateboard_*.md` | `moduli/rateboard/studi/` | **5 file identici** | ❌ DELETE da reports/ |

**Totale duplicazioni:** 55 file (15% del totale)

---

## FILE GRANDI (Top 10)

| File | Righe | Tipo | Dove | Azione |
|------|-------|------|------|--------|
| `BIG_PLAYERS_EMAIL_RESEARCH.md` | 2129 | Doc | bracci/miracallook/studi/ | Split in 4 parti |
| `big_players_research.md` | 1606 | Doc | moduli/room_manager/studi/ | DELETE (duplicato) |
| `20260114_RICERCA_OPERA_CLOUD.md` | 1588 | Doc | bracci/room-hardware/studi/ | Split in 3 parti |
| `20260115_RICERCA_ROOM_MANAGER_AVANZATO.md` | 1555 | Doc | bracci/room-hardware/studi/ | Split per feature |
| `DESIGN_PATTERNS_EMAIL.md` | 1472 | Doc | bracci/miracallook/studi/ | Split in 3 parti |
| `20260116_RICERCA_PMS_FISCALE_PARTE3.md` | 1441 | Doc | idee/ | OK (già parte 3) |
| `RICERCA_RESIZABLE_PANELS_V4.md` | 1359 | Doc | bracci/miracallook/studi/ | Split in 3 parti |
| `CONTEXT_MENU_UX_STRATEGY.md` | 1315 | Doc | bracci/miracallook/studi/ | Split in 3 parti |
| `20260113_RICERCA_METEO_RMS.md` | 1296 | Doc | idee/ | Split per fonte |
| `20260115_VDA_H155300_RCU_RESEARCH.md` | 1228 | Doc | idee/ + bracci/ | DELETE da idee/ (duplicato) |

**Totale file > 1000 righe:** 25  
**Totale file > 500 righe:** 100

---

## HEALTH SCORE

| Area | Files | Health | Trend | Priorità Fix |
|------|-------|--------|-------|--------------|
| bracci/miracallook | 27 | 8/10 ✅ | Ottimo | Bassa |
| bracci/room-hardware | 39 | 6/10 ⚠️ | Migliorabile | Media |
| bracci/pms-core | 1 | 2/10 ❌ | Vuoto | Alta |
| moduli/* | 43 | 3/10 ❌ | Confuso | **CRITICA** |
| idee/ | 71 | 5/10 ⚠️ | Disorganizzato | Media |
| reports/ | 45 | 7/10 ✅ | OK | Bassa |
| roadmaps/ | 20 | 7/10 ✅ | OK | Bassa |

**GLOBALE:** 4/10 ❌

---

## RACCOMANDAZIONI IMMEDIATE

### 1. CLEANUP DUPLICAZIONI (Oggi)
```bash
# Elimina room_manager (42 file duplicati)
rm -rf .sncp/progetti/miracollo/moduli/room_manager/

# Elimina VDA research da idee (8 file duplicati)
rm .sncp/progetti/miracollo/idee/20260115_VDA_*.md

# Elimina rateboard reports (5 file duplicati)
rm .sncp/progetti/miracollo/reports/rateboard_*.md
rm .sncp/progetti/miracollo/reports/big_players_rms_*.md
```

**Impatto:** -55 file, -85% issues duplicazioni

### 2. STANDARDIZZA BRACCI (Questa settimana)

**room-hardware:**
- Creare `COSTITUZIONE_ROOM_HARDWARE.md`
- Creare `NORD_ROOM_HARDWARE.md`
- Popolare `stato.md` (ora 37 righe → target 200-300)

**pms-core:**
- Decidere: stabile (no work) o attivo?
- Se attivo: creare COSTITUZIONE, NORD, studi
- Se stabile: creare `README.md` con "Stable, manutenzione ordinaria"

### 3. CHIARIRE ARCHITETTURA (Urgente)

**Domande per Rafa:**
1. `bracci/` vs `moduli/` - qual è la differenza esatta?
2. `moduli/whatif` ha codice Python - deve essere in `.sncp/`?
3. `moduli/finanziario` - braccio separato o parte di pms-core?
4. `idee/` - riorganizzare per appartenenza o mantenere flat?

---

## METRICHE PRIMA/DOPO CLEANUP

| Metrica | Prima | Dopo Cleanup | Riduzione |
|---------|-------|--------------|-----------|
| File totali | 352 | 297 | -15% |
| Duplicazioni | 55 | 0 | -100% |
| Issues | 222 | 137 | -38% |
| Health Score | 4/10 | 6.5/10 | +62% |

---

*Report completo: `AUDIT_STRUTTURA_SNCP_20260116.md`*
