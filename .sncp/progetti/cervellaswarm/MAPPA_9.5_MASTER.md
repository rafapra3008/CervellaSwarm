# MAPPA MASTER - CervellaSwarm verso 9.5

> **Data:** 14 Gennaio 2026 - Sessione 192
> **Obiettivo:** Portare TUTTI gli score a 9.5 minimo
> **Filosofia:** "Se documentiamo = facciamo!"

---

## DASHBOARD SCORE

```
+================================================================+
|                                                                |
|   CERVELLASWARM - STATO ATTUALE vs TARGET                      |
|                                                                |
|   SNCP (Memoria)      [#######---]  7.0/10  -->  9.5          |
|   SISTEMA LOG         [######----]  6.0/10  -->  9.5          |
|   AGENTI (Cervelle)   [########--]  7.8/10  -->  9.5          |
|   INFRASTRUTTURA      [########--]  8.0/10  -->  9.5          |
|                                                                |
|   MEDIA ATTUALE:      7.2/10                                   |
|   TARGET:             9.5/10                                   |
|   GAP:                2.3 punti                                |
|                                                                |
+================================================================+
```

---

## 1. SNCP (MEMORIA) - 7.0 --> 9.5

### Stato Attuale
- **Struttura:** OTTIMA (progetti separati, archivio mensile)
- **Formato:** PERFETTO (Markdown + YAML frontmatter)
- **Pattern:** ALLINEATI con industry standard

### Problemi Critici
| Problema | Impatto | Fix |
|----------|---------|-----|
| `oggi.md` = 950 righe | CRITICO | Compaction automatica |
| 80% file obsoleti | ALTO | Automazione updates |
| Worker non usano SNCP | ALTO | Integrazione spawn |
| Zero visibility | MEDIO | Dashboard health |

### Roadmap 9.5 (5 Sprint = 30h)
```
Sprint 1: File Size Control     4h   --> 8.5
Sprint 2: Automazione Base      8h   --> 9.0
Sprint 3: Adoption/Integration  6h   --> 9.2
Sprint 4: Dashboard/Monitoring  6h   --> 9.4
Sprint 5: Polish/Documentation  6h   --> 9.5
```

### Quick Win (OGGI)
- [ ] Pulire `oggi.md` (rimuovere 35 checkpoint duplicati)
- [ ] Merge `miracallook/` + `miracollook/` (typo cartella)

### Report Dettagliato
`.sncp/progetti/cervellaswarm/reports/STUDIO_SNCP_9.5.md`

---

## 2. SISTEMA LOG - 6.0 --> 9.5

### Stato Attuale
- **SwarmLogger:** ECCELLENTE (8/10) - NON toccare
- **Database:** BUONA base (4.6MB, 4158 eventi)
- **Heartbeat:** FUNZIONANTE

### Problemi Critici
| Problema | Impatto | Fix |
|----------|---------|-----|
| NO distributed tracing | CRITICO | trace_id, span_id |
| NO alerting system | CRITICO | Pattern detector + Slack |
| Retention non definita | ALTO | ILM automation |
| Dashboard statico | ALTO | Real-time SSE |

### Roadmap 9.5 (4 Sprint = 12 giorni)
```
Sprint 1: Tracing + Alerting    3d   --> 7.5  CRITICAL
Sprint 2: Retention + Dashboard 4d   --> 8.5
Sprint 3: Error types + PII     3d   --> 9.0
Sprint 4: Cost tracking + OTel  2d   --> 9.5
```

### Quick Win
- [ ] Aggiungere trace_id a SwarmLogger (1 giorno)
- [ ] Setup log-rotate.sh in cron (heartbeat = 120k!)

### Report Dettagliato
```
STUDIO_LOGGING_9.5_INDEX.md
STUDIO_LOGGING_9.5_PARTE1_STATO_ATTUALE.md
STUDIO_LOGGING_9.5_PARTE2_BEST_PRACTICES.md
STUDIO_LOGGING_9.5_PARTE3_ROADMAP.md
```

---

## 3. AGENTI (CERVELLE) - 7.8 --> 9.5

### Stato Attuale
- **16 agenti** tutti operativi
- **Formato YAML:** ECCELLENTE (parseable, versionato)
- **Gerarchia Regina/Guardiane/Worker:** SOLIDA
- **SNCP integration:** OTTIMA (siamo avanti!)

### Problemi Critici
| Problema | Impatto | Fix |
|----------|---------|-----|
| Researcher vs Scienziata | ALTO | Rename + chiarire ruoli |
| Output testo libero | MEDIO | JSON schema validato |
| Solo sequential | MEDIO | Orchestrazione parallela |
| Protocolli duplicati | BASSO | Refactor condiviso |

### Roadmap 9.5 (4 FASI = 8-12 settimane)
```
FASE 1: Ruoli Cristallini       1 sprint  --> 8.5
FASE 2: Comunicazione JSON      2 sprint  --> 9.0
FASE 3: Orchestrazione Avanzata 3 sprint  --> 9.3
FASE 4: Validazione Automatica  2 sprint  --> 9.5
```

### Quick Win (1 settimana)
- [ ] Rename: `Researcher` --> `Tech-Researcher`
- [ ] Rename: `Scienziata` --> `Market-Analyst`
- [ ] Creare `RUOLI_CHEAT_SHEET.md` (chi fa cosa)
- [ ] JSON manifests per top 5 agenti

### Report Dettagliato
```
STUDIO_AGENTI_9.5_INDEX.md
STUDIO_AGENTI_9.5_PARTE1.md (stato + gap)
STUDIO_AGENTI_9.5_PARTE2.md (roadmap)
STUDIO_AGENTI_9.5_PARTE3.md (implementation)
```

---

## 4. INFRASTRUTTURA - 8.0 --> 9.5

### Stato Attuale
- **Scripts:** 40+ tutti funzionanti
- **Database:** Attivo (4.6MB, 4158 eventi)
- **Test Suite:** 12/12 PASS
- **Task System:** 170+ task gestiti
- **Handoff:** 91 file attivi

### Problemi Critici
| Problema | Impatto | Fix |
|----------|---------|-----|
| hooks/ directory mancante | BASSO | Decidere se serve |
| Cron non installato | MEDIO | Setup weekly_retro |
| RAG non configurato | BASSO | Valutare Qdrant |
| Heartbeat log grande | BASSO | Schedule log-rotate |

### Quick Win
- [ ] Installare cron per weekly_retro.py
- [ ] Schedulare log-rotate.sh
- [ ] Cleanup .stale files (5 task)

### Report Dettagliato
`AUDIT_INFRA_20260114.md`

---

## PRIORITA GLOBALE

### P0 - CRITICO (fare SUBITO)
1. **SNCP:** Pulire oggi.md (950-->300 righe)
2. **LOG:** Aggiungere trace_id
3. **AGENTI:** Chiarire Researcher vs Scienziata

### P1 - ALTO (prossime 2 settimane)
4. **SNCP:** Automazione updates
5. **LOG:** Basic alerting (Slack)
6. **AGENTI:** RUOLI_CHEAT_SHEET.md

### P2 - MEDIO (prossimo mese)
7. **SNCP:** Dashboard health
8. **LOG:** Real-time dashboard
9. **AGENTI:** JSON schema output
10. **INFRA:** Cron setup

### P3 - BASSO (quando c'e tempo)
11. **SNCP:** Semantic search (ChromaDB)
12. **LOG:** Cost tracking
13. **AGENTI:** Orchestrazione parallela
14. **INFRA:** RAG Qdrant

---

## EFFORT TOTALE STIMATO

```
+================================================================+
|                                                                |
|   SNCP:      30h  (5 sprint x 6h)                              |
|   LOG:       12d  (4 sprint)                                   |
|   AGENTI:    8-12 settimane (4 fasi)                           |
|   INFRA:     4h   (quick fixes)                                |
|                                                                |
|   TOTALE:    ~80-100 ore lavoro                                |
|              (distribuito su 2-3 mesi)                          |
|                                                                |
+================================================================+
```

---

## BEST PRACTICES SCOPERTE

### Dai Big Player (CrewAI, LangChain, Microsoft)
1. **Markdown-first** - Meglio di JSON/DB per noi
2. **File-based memory** - Git version control built-in
3. **Tri-memory system** - Short/Long/Episodic (GIA abbiamo!)
4. **OpenTelemetry** - Standard 2026 per logging AI
5. **Scoped Intelligence** - Agenti con ruoli PRECISI
6. **Deterministic Flow** - Orchestrazione prevedibile

### Le Nostre Scoperte
1. **SNCP pattern GIUSTO** - Solo serve automazione
2. **SwarmLogger OTTIMO** - Solo aggiungere trace_id
3. **Gerarchia funziona** - Solo chiarire overlap ruoli
4. **Test suite 100%** - Infrastruttura solida

---

## FILE GENERATI OGGI

```
.sncp/progetti/cervellaswarm/
+-- MAPPA_9.5_MASTER.md            <-- QUESTO FILE
+-- reports/
    +-- STUDIO_SNCP_9.5.md             (1037 righe)
    +-- STUDIO_LOGGING_9.5_INDEX.md    (451 righe)
    +-- STUDIO_LOGGING_9.5_PARTE1_*.md
    +-- STUDIO_LOGGING_9.5_PARTE2_*.md
    +-- STUDIO_LOGGING_9.5_PARTE3_*.md
    +-- STUDIO_AGENTI_9.5_INDEX.md     (165 righe)
    +-- STUDIO_AGENTI_9.5_PARTE1.md
    +-- STUDIO_AGENTI_9.5_PARTE2.md
    +-- STUDIO_AGENTI_9.5_PARTE3.md
    +-- AUDIT_INFRA_20260114.md        (384 righe)
```

**Totale righe documentazione:** ~3500+ righe di analisi

---

## NEXT STEP

**Rafa, tu decidi:**

```
[ ] START QUICK WINS OGGI
    - Pulire oggi.md
    - Merge cartelle miracallook
    - RUOLI_CHEAT_SHEET.md

[ ] START SPRINT COMPLETI
    - SNCP Sprint 1 questa settimana
    - LOG Sprint 1 prossima settimana

[ ] WAIT
    - Priorita Miracollo ora
    - Tornare su CervellaSwarm dopo

[ ] ALTRO
    - Cosa vuoi modificare/approfondire?
```

---

*"Il nostro sistema e la nostra anima, cuore, cervello"*
*"Se documentiamo = facciamo!"*
*"Studiare prima di agire - sempre!"*

**Sessione 192 - 14 Gennaio 2026**
