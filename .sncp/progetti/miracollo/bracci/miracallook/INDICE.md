# INDICE - Documentazione Miracollook

> **Come navigare questa cartella**
> **Aggiornato: 19 Gennaio 2026**

---

## FILE PRINCIPALI (sempre aggiornati)

| File | Cosa Contiene | Quando Usarlo |
|------|---------------|---------------|
| **NORD_MIRACOLLOOK.md** | Visione, direzione, prossimi step | Inizio sessione |
| **PROMPT_RIPRESA_miracollook.md** | Checkpoint sessioni | Riprendere lavoro |
| **stato.md** | Stato REALE dal codice | Verifica feature |
| **MAPPA_VERITA_20260119.md** | Analisi codice completa | Reference tecnico |

---

## QUICK START

```bash
# Backend
cd ~/Developer/miracollogeminifocus/miracallook/backend
source venv/bin/activate
uvicorn main:app --port 8002 --reload

# Frontend
cd ~/Developer/miracollogeminifocus/miracallook/frontend
npm run dev
```

---

## STATO ATTUALE (19 Gen 2026)

```
FASE 1: 92% (verificato dal codice!)

FUNZIONA: Resizable, Context Menu, Thread, Drafts, Attachments, etc
MANCA:    Bulk Actions API, Labels CRUD, Contacts, Settings
```

---

## CARTELLE

### `/studi/` - Ricerche tecniche (DIAMANTE!)
Ricerche approfondite prima di implementare. Valore altissimo!

| File | Contenuto |
|------|-----------|
| STUDIO_MACRO_*.md | Studi macro per FASE 2 |
| RICERCA_CONTEXT_MENU*.md | 2000+ righe su context menu |
| RICERCA_PERFORMANCE*.md | Ottimizzazioni |

### `/decisioni/` - Design specs
Specifiche approvate per implementazione.

### `/ricerche/` - Competitor analysis
Analisi Gmail, Superhuman, Shortwave, etc.

### `/reports/` - Audit e review
Report storici delle sessioni.

### `/roadmaps/` - Sprint specifici
Piani dettagliati per feature.

### `/archivio/` - File storici
File obsoleti preservati per riferimento.

---

## GERARCHIA DOCUMENTI

```
1. NORD_MIRACOLLOOK.md        <- Visione (leggi sempre!)
2. stato.md                   <- Stato REALE (feature esistenti)
3. PROMPT_RIPRESA_*.md        <- Checkpoint (ultime sessioni)
4. MAPPA_VERITA_*.md          <- Analisi codice (reference)
5. studi/                     <- Ricerche (prima di implementare)
6. decisioni/                 <- Specs (durante implementazione)
```

---

## REGOLE

```
"SU CARTA" != "REALE"
- stato.md riflette il CODICE, non i piani
- MAI scrivere "FATTO" senza codice committato

SINGLE SOURCE OF TRUTH:
- Percentuali FASE: stato.md
- Prossimi step: NORD
- Checkpoint: PROMPT_RIPRESA
```

---

*"Organizzare per navigare. Navigare per costruire."*
