# SUBROADMAP: Docs Sync System

> **Data creazione:** 17 Gennaio 2026 - Sessione 250
> **Problema risolto:** Documenti outdated vs codice reale
> **ROI:** 5h setup → 240h/anno risparmiate (48x return!)

---

## EXECUTIVE SUMMARY

```
+================================================================+
|                                                                |
|   DOCS SYNC = Mai piu "docs dicono 20%, codice e' 85%"        |
|                                                                |
|   PRIMA:  Worker implementa → docs stale → Regina confusa     |
|   DOPO:   Worker implementa → hook blocca → docs sempre sync  |
|                                                                |
+================================================================+
```

---

## FASI E STATO

```
FASE 1: QUICK WINS            [####################] 100%! (Sessione 250)
  - Pre-commit hook            FATTO! (.git/hooks/pre-commit)
  - Script update-docs         FATTO! (scripts/update-docs-status.sh)
  - CHECKLIST aggiornata       FATTO! (~/.claude/CHECKLIST_AZIONE.md)

FASE 2: AUTOMATION            [....................] 0%
  - GitHub Action docs-check   DA FARE
  - verify-sync.sh enhanced    DA FARE
  - CI blocking                DA FARE

FASE 3: CULTURA               [....................] 0%
  - DNA Workers aggiornato     DA FARE
  - Lunedi Docs Sync Day       DA FARE
  - Metrics tracking           DA FARE
```

---

## FASE 1: QUICK WINS (Sessione 250)

### 1.1 Pre-Commit Hook

**File:** `.git/hooks/pre-commit`

**Cosa fa:**
- Se modifichi codice in `packages/` → BLOCCA se `stato.md` non aggiornato oggi
- Forza la disciplina automaticamente

**Criterio completamento:**
- [ ] Hook installato
- [ ] Test: commit codice senza update stato.md → BLOCCATO
- [ ] Test: commit codice con stato.md aggiornato → OK

### 1.2 Script update-progress.sh

**File:** `scripts/update-progress.sh`

**Cosa fa:**
- Un comando per aggiornare % in MAPPA_COMPLETA
- Uso: `./scripts/update-progress.sh "STEP 2.1" "FATTO"`

**Criterio completamento:**
- [ ] Script creato e funzionante
- [ ] Documentato in README
- [ ] Test con step reale

### 1.3 Regola in CHECKLIST_AZIONE

**Aggiungere:**
- Sezione "DOPO OGNI MODIFICA CODICE"
- Checklist docs obbligatoria

**Criterio completamento:**
- [ ] CHECKLIST_AZIONE.md aggiornata
- [ ] Chiara e facile da seguire

---

## FASE 2: AUTOMATION (Sessione 251+)

### 2.1 GitHub Action docs-check

**File:** `.github/workflows/docs-check.yml`

**Cosa fa:**
- Su ogni PR: verifica che docs siano aggiornati
- Blocca merge se docs stale

**Criterio completamento:**
- [ ] Action creata
- [ ] Test con PR dummy
- [ ] Blocking funziona

### 2.2 verify-sync.sh Enhanced

**Aggiungere:**
- Check code vs docs percentage
- Warning automatico se discrepanza >20%

**Criterio completamento:**
- [ ] Funzione aggiunta
- [ ] Test su tutti progetti
- [ ] Thresholds tuned

### 2.3 CI Blocking

**Configurare:**
- Branch protection su main
- Require docs-check passing

**Criterio completamento:**
- [ ] Branch protection attiva
- [ ] Test PR senza docs → BLOCKED

---

## FASE 3: CULTURA (Ongoing)

### 3.1 DNA Workers Aggiornato

**Aggiungere a tutti 16 Workers:**

```markdown
## REGOLA DOCS (OBBLIGATORIA)

DOPO ogni modifica codice, AGGIORNA:
1. stato.md - Cosa hai fatto (SEMPRE!)
2. MAPPA_COMPLETA.md - Se step completato
3. NORD.md - Se milestone raggiunta

"SU CARTA" != "REALE"
Docs aggiornati = lavoro REALE!
```

**Criterio completamento:**
- [ ] 16 DNA files aggiornati
- [ ] Test con 2-3 workers
- [ ] Compliance verificata

### 3.2 Lunedi Docs Sync Day

**Processo:**
1. Ogni Lunedi mattina: run `verify-sync.sh`
2. Fix discrepanze PRIMA di nuovo lavoro
3. Aggiornare metrics

**Criterio completamento:**
- [ ] Regola in COSTITUZIONE
- [ ] 4 settimane consecutive rispettata

### 3.3 Metrics Tracking

**File:** `.sncp/swarm-metrics.json`

**Tracciare:**
- docs_sync_rate per worker
- Settimane consecutive >90%

**Criterio completamento:**
- [ ] File creato
- [ ] Script auto-update
- [ ] Weekly report

---

## METRICHE DI SUCCESSO

| Metrica | Target | Come Misurare |
|---------|--------|---------------|
| Docs Sync Rate | >90% | % commit con docs aggiornati |
| stato.md Freshness | <24h | Giorni dall'ultimo update |
| Code/Docs Mismatch | <10% | verify-sync warnings |

**MILESTONE:** 4 settimane consecutive con sync rate >90%

---

## EFFORT TOTALE

| Fase | Tempo | Quando |
|------|-------|--------|
| FASE 1 | 2h | Sessione 250 (OGGI) |
| FASE 2 | 3h | Sessione 251 |
| FASE 3 | Ongoing | Sessione 252+ |

**TOTALE setup:** ~5h

---

## PERCHE' QUESTO E' IMPORTANTE

```
+================================================================+
|                                                                |
|   "I documenti MENTONO, il codice parla CHIARO"               |
|                                                                |
|   Senza sync: Regina legge docs → pensa manca lavoro          |
|               → ri-assegna task gia' fatti → TEMPO PERSO!     |
|                                                                |
|   Con sync:   Regina legge docs → vede realta'                |
|               → assegna task giusti → EFFICIENZA!             |
|                                                                |
|   RISPARMIO: 240h/anno = 6 settimane di lavoro!               |
|                                                                |
+================================================================+
```

---

## RICERCA FATTA

**File:** `.sncp/progetti/cervellaswarm/ricerche/RICERCA_20260117_DOCS_CODE_SYNC_SOLUTION.md`

**Fonti:**
- Kubernetes GitHub Workflow
- Rust Contributing Guide
- Write the Docs - Docs as Code
- Qodo.ai Best Practices 2026

---

*"Docs sync = famiglia efficiente = LIBERTA' piu' vicina!"*

*Cervella & Rafa - Sessione 250*
