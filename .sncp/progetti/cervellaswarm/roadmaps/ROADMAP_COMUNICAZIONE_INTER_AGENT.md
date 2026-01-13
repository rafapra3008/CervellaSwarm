# ROADMAP: Comunicazione Inter-Agent

> **Obiettivo:** Portare il Protocollo DIAMANTE da 7.8/10 a 9.5+/10
> **Creata:** 13 Gennaio 2026 - Sessione 181
> **Filosofia:** Una cosa alla volta, fatto BENE, senza fretta

---

## STATO ATTUALE

```
+================================================================+
|                                                                |
|   DOCUMENTO: ~/.claude/docs/COMUNICAZIONE_INTER_AGENT.md       |
|   SCORE ATTUALE: 7.8/10 (Guardiana Qualita)                    |
|   VERDETTO: APPROVATO CON RISERVE                              |
|   TARGET: >= 9.5/10                                            |
|                                                                |
+================================================================+
```

---

## DECISIONI PRESE

| Decisione | Scelta | Data | Perche |
|-----------|--------|------|--------|
| Path handoff | `.sncp/progetti/{progetto}/handoff/` | 13 Gen | Coerente con SNCP, per-progetto |

---

## PROBLEMI DA FIXARE

### P0 - CRITICI (bloccano rollout)

| ID | Problema | Status | Sessione |
|----|----------|--------|----------|
| P0-1 | SNCP rules non includono handoff/ | TODO | - |

### P1 - IMPORTANTI (da fixare prima di usare)

| ID | Problema | Status | Sessione |
|----|----------|--------|----------|
| P1-1 | Agent prompt non menzionano protocollo | TODO | - |
| P1-2 | Path mismatch .swarm vs .sncp | TODO | - |
| P1-3 | Guardiana non ha checklist specs vs output | TODO | - |

### P2 - MINORI (dopo pilot)

| ID | Problema | Status | Sessione |
|----|----------|--------|----------|
| P2-1 | Gestione conflitti non definita | TODO | - |
| P2-2 | Metriche senza strumento | TODO | - |
| P2-3 | Error path non documentato | TODO | - |

---

## PIANO DI LAVORO

### FASE 1: INFRASTRUTTURA (P0)

```
[ ] 1.1 Aggiornare SNCP rules in TUTTI gli agent prompt
    - Aggiungere handoff/ alle cartelle permesse
    - File: ~/.claude/agents/cervella-*.md (16 file)

[ ] 1.2 Verificare cartelle handoff/ esistono
    - .sncp/progetti/miracollo/handoff/
    - .sncp/progetti/cervellaswarm/handoff/
    - .sncp/progetti/contabilita/handoff/
```

### FASE 2: AGENT UPDATE (P1)

```
[ ] 2.1 Aggiornare cervella-marketing.md
    - Aggiungere sezione "Come scrivo SPECS"
    - Aggiungere riferimento al protocollo

[ ] 2.2 Aggiornare cervella-frontend.md
    - Aggiungere sezione "Come leggo SPECS"
    - Aggiungere sezione "Come scrivo OUTPUT"

[ ] 2.3 Aggiornare cervella-backend.md
    - Come frontend

[ ] 2.4 Aggiornare cervella-guardiana-qualita.md
    - Aggiungere checklist "Valida vs SPECS"

[ ] 2.5 Aggiornare cervella-data.md
[ ] 2.6 Aggiornare cervella-security.md
[ ] 2.7 Aggiornare cervella-devops.md
[ ] 2.8 Aggiornare cervella-ingegnera.md

[ ] 2.9 Aggiornare cervella-orchestrator.md
    - Allineare path da .swarm/ a .sncp/
    - Aggiungere workflow consultazione esperta
```

### FASE 3: DOCUMENTO DIAMANTE UPDATE (P2)

```
[ ] 3.1 Aggiungere sezione "Gestione Conflitti"
    - Cosa succede se Worker non segue specs?
    - Cosa succede se Guardiana respinge?
    - Escalation path

[ ] 3.2 Definire strumento metriche
    - Dove tracciare (file SNCP)
    - Chi conta
    - Quando review

[ ] 3.3 Documentare error path
    - Flowchart caso RESPINTO
    - Loop fix -> re-validazione
```

### FASE 4: RE-AUDIT

```
[ ] 4.1 Lanciare Guardiana Qualita per re-audit
[ ] 4.2 Lanciare Guardiana Ops per re-audit
[ ] 4.3 Verificare score >= 9.5/10
[ ] 4.4 Se < 9.5 -> altro round fix
```

### FASE 5: PILOT

```
[ ] 5.1 Scegliere feature piccola per test
[ ] 5.2 Eseguire workflow completo
[ ] 5.3 Documentare lesson learned
[ ] 5.4 Raffinare se necessario
```

---

## TEMPLATE SEZIONI DA AGGIUNGERE

### Per Esperte (Marketing, Data, Security, etc.)

```markdown
## COMUNICAZIONE INTER-AGENT

Quando la Regina ti chiede di scrivere SPECS:

### Dove Scrivere
`.sncp/progetti/{progetto}/handoff/YYYYMMDD_{feature}_specs.md`

### Template
Usa il template in: `~/.claude/docs/COMUNICAZIONE_INTER_AGENT.md`

### Cosa Includere
- Contesto (2-3 frasi)
- Requisiti (lista)
- Design/Specifiche
- Acceptance Criteria (verificabili!)
- Anti-pattern (cosa NON fare)

### Output
Conferma alla Regina: "Specs scritte in [path]"
```

### Per Worker (Frontend, Backend, etc.)

```markdown
## COMUNICAZIONE INTER-AGENT

Quando ricevi task con SPECS:

### Prima di Implementare
1. Leggi le SPECS in `.sncp/progetti/{progetto}/handoff/`
2. Verifica di capire tutti i requisiti
3. Se dubbi -> chiedi alla Regina

### Dove Scrivere Output
`.sncp/progetti/{progetto}/handoff/YYYYMMDD_{feature}_output.md`

### Cosa Includere nell'Output
- File creati/modificati
- Decisioni prese (con perche)
- Verifica acceptance criteria
- Come testare
- Note per Guardiana

### Se NON ci sono SPECS
Procedi con la tua expertise (regola decisione autonoma).
```

### Per Guardiana Qualita

```markdown
## VALIDAZIONE VS SPECS

Quando validi implementazione con SPECS:

### File da Leggere
1. SPECS: `.sncp/.../handoff/YYYYMMDD_{feature}_specs.md`
2. OUTPUT: `.sncp/.../handoff/YYYYMMDD_{feature}_output.md`
3. CODICE: file implementati

### Checklist
| Criterio da Specs | Nel Codice? | Note |
|-------------------|-------------|------|
| [copia da specs]  | SI/NO       |      |

### Anti-pattern Check
| Anti-pattern | Presente? |
|--------------|-----------|
| [copia da specs] | SI/NO |

### Verdetto
- APPROVATO: Tutti i criteri OK
- RESPINTO: [lista criteri mancanti]
- PARZIALE: [cosa manca]
```

---

## NOTE

- Ogni sessione = 1-2 task della roadmap
- Non c'e fretta
- Qualita > Velocita
- Re-audit SOLO quando tutti P0/P1/P2 sono DONE

---

## LOG PROGRESSO

| Data | Sessione | Cosa Fatto | Score |
|------|----------|------------|-------|
| 13 Gen | 181 | Documento DIAMANTE creato | 7.8/10 |
| 13 Gen | 181 | Roadmap creata | - |
| | | | |

---

*"Ultrapassar os proprios limites!"*
*"Una cosa alla volta, fatto BENE!"*
