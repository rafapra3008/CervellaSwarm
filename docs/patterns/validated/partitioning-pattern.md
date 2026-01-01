# 📐 Partitioning Pattern (Task Decomposition)

> *"Feature complessa → Scomponi per layer → Delega a specialist agents"*

---

## 📋 Metadata

| Campo | Valore |
|-------|--------|
| **Categoria** | Coordination |
| **Complessità** | Medium |
| **Use Case** | Full-Stack Development |
| **Validato** | ✅ SI |
| **Data Scoperta** | Dicembre 2025 |
| **Usato in** | Miracollo PMS: Sprint 3.9a Competitor Analytics |

---

## 🎯 Context

**Quando si applica questo pattern?**

- Feature complessa che richiede modifiche su **3+ layer diversi** (SQL, Backend, Frontend, CSS)
- Team con **specialist agents** per ogni layer (cervella-backend, cervella-frontend, cervella-css)
- Task **parallelizzabile** (modifiche indipendenti tra layer)
- Sprint ben definito con **scope chiaro**

**Composizione Swarm:**
- 👑 Regina (Cervella) - Coordinator
- ⚙️ cervella-backend - SQL + Python API
- 🎨 cervella-frontend - React/Vue components
- 💅 cervella-css - Styling + responsive

---

## ❓ Problem

**Il problema che questo pattern risolve:**

- ❌ Regina sovraccaricata: deve conoscere TUTTO (SQL syntax, React hooks, CSS tricks)
- 💥 Context switching continuo: passa da SQL a React a CSS ogni 5 minuti
- 📊 Sprint velocity bassa: troppo tempo su dettagli invece che su coordinazione
- 🐛 Errori cross-layer: modifiche backend non align con frontend

**Esempio negativo:**

```
Sprint: Competitor Analytics (8 file, 4 layer)

SENZA PATTERN (Regina fa tutto):
1. Scrive SQL → 20 min
2. Scrive API Python → 30 min
3. Scrive componente React → 40 min
4. Aggiusta CSS responsive → 25 min
5. Debug incompatibilità → 30 min

TOTALE: 2h 25min + alta probabilità errori
```

---

## ✅ Solution

### Agent Structure

```
👑 Regina (Cervella)
   ├─ ANALIZZA feature
   ├─ SCOMPONE in task layer-specific
   ↓ DELEGA in parallelo
   ⚙️ cervella-backend → SQL + API
   🎨 cervella-frontend → React components
   💅 cervella-css → Styling + responsive
   ↓ VERIFICA
   👑 Regina → Integration check
```

### Workflow

**Step by Step:**

1️⃣ **Analysis & Decomposition** (Regina)
   - [ ] Legge requisiti sprint
   - [ ] Identifica i layer coinvolti
   - [ ] Scompone in task indipendenti per layer
   - [ ] Definisce interfaces tra layer (API contract, props structure)

2️⃣ **Parallel Delegation** (Regina → Agents)
   - [ ] Delega SQL + API → cervella-backend
   - [ ] Delega UI components → cervella-frontend
   - [ ] Delega styling → cervella-css
   - [ ] Ogni agent riceve prompt completo con checklist

3️⃣ **Integration & Verification** (Regina)
   - [ ] Verifica che API match con frontend expectations
   - [ ] Test end-to-end locale
   - [ ] Checkpoint completo

### Interfaces / Prompt Templates

**Prompt Regina → cervella-backend:**

```markdown
# Task: [Feature] - Backend Layer

## Context
Feature: [Descrizione]
Sprint: [Numero]

## Database Schema
- Tabelle coinvolte: [lista]
- Nuove colonne: [lista]

## API Endpoints
- `GET /api/[resource]` - [scopo]
- `POST /api/[resource]` - [scopo]

## Checklist Backend
- [ ] Aggiungi colonne a schema SQL
- [ ] Crea query per [risorsa]
- [ ] Implementa endpoint API con validazione
- [ ] Test SQL query manualmente
- [ ] Verifica response format

## API Contract (per frontend)
```json
{
  "expected_response": {
    "field1": "type",
    "field2": "type"
  }
}
```

## Success Criteria
✅ Query funziona in DB
✅ API ritorna dati nel formato atteso
✅ Validazione input completa
```

**Prompt Regina → cervella-frontend:**

```markdown
# Task: [Feature] - Frontend Layer

## Context
Feature: [Descrizione]
Sprint: [Numero]

## API Available
- `GET /api/[resource]` - [scopo]
  Response: { field1, field2 }

## UI Requirements
- Modal/Table/Chart per [cosa]
- Interattività: [descrizione]

## Checklist Frontend
- [ ] Crea componente React/Vue per [cosa]
- [ ] Fetch da API [endpoint]
- [ ] Display dati in [formato]
- [ ] Gestisci loading state
- [ ] Gestisci error state

## Props Structure
```javascript
{
  prop1: type,
  prop2: type
}
```

## Success Criteria
✅ Componente riceve dati da API
✅ Display corretto in browser
✅ Loading e error states funzionano
```

**Report Agent → Regina:**

```markdown
## ✅ Backend Completato

### Files Modified
- `schema.sql` - Aggiunte colonne [lista]
- `main.py` - Endpoint `GET /api/resource`

### API Contract Implemented
```json
{
  "field1": "value",
  "field2": "value"
}
```

### Verifiche
✅ Query SQL testata manualmente
✅ API ritorna 200 con dati corretti
✅ Validazione input OK

### Issues Found
⚠️ Nessun issue
```

---

## ✅ When to Use

**Usa questo pattern quando:**

- ✅ **3+ file in layer diversi** (SQL, Python, React, CSS)
- ✅ **Expertise diverse richieste** (database, backend logic, UI/UX)
- ✅ **Task parallelizzabile** (modifiche indipendenti tra layer)
- ✅ **Sprint ben definito** con scope chiaro e API contract definibile

**Indicatori:**
- 📊 Numero file > 6
- 📊 Layer coinvolti > 3
- 📊 Complexity score > Medium

---

## ❌ When to Avoid

**NON usare questo pattern quando:**

- ❌ **< 3 file in un solo layer** → Regina fa diretto (più veloce)
- ❌ **Task con forte dipendenza sequenziale** → Backend DEVE finire prima di frontend (usa Sequential Pattern invece)
- ❌ **Prototype/spike** → Troppo overhead per exploration
- ❌ **API contract non definibile** → Troppa incertezza, serve exploration prima

**Alternative migliori:**
- Se task < 3 file → Regina lavora diretto
- Se dipendenze sequenziali → Sequential Delegation Pattern
- Se exploration → Spike Pattern (Regina + 1 specialist insieme)

---

## 🎬 Example

**Caso Reale:** Sprint 3.9a - Competitor Analytics

**Project:** Miracollo PMS

**Context:**

Feature richiesta da Rafa: "Voglio vedere analytics dei competitor per ogni progetto."

Coinvolge:
- **SQL**: nuova tabella `competitor_analytics`
- **Backend**: API per fetch/store analytics
- **Frontend**: modal con tabella analytics
- **CSS**: styling responsive per tabella

**Implementation:**

```
👑 Regina analizza:
- 8 file totali (2 SQL, 3 Python, 2 React, 1 CSS)
- 4 layer (Database, API, Components, Styling)
- Task parallelizzabili (API contract chiaro)

👑 Regina scompone:
Task 1: cervella-backend
  - schema.sql: tabella competitor_analytics
  - main.py: GET/POST /api/analytics

Task 2: cervella-frontend
  - CompetitorModal.vue: fetch + display
  - AnalyticsTable.vue: tabella dati

Task 3: cervella-css
  - modal.css: responsive styling

👑 Regina delega in parallelo (3 prompt completi)

⚙️🎨💅 Agents lavorano simultaneamente

👑 Regina verifica:
  - API match frontend expectations? ✅
  - Test locale funziona? ✅
  - Checkpoint completo ✅
```

**Results:**

- ✅ Sprint completato in **1h 20min** (vs 2h 25min stima senza pattern)
- ✅ **Zero bug cross-layer** (API contract chiaro da subito)
- ✅ Regina focus su **coordinazione**, non dettagli CSS
- ⚡ **Sprint velocity: +43%**

**Lezione Appresa:**

> *"Quando scomponi bene, le cose si incastrano da sole."* - Rafa, Dicembre 2025

Il tempo investito in **analisi + decomposition** (15 min) è NULLA rispetto al tempo risparmiato in debug cross-layer (30+ min).

---

## ⚠️ Anti-Patterns

### ❌ Anti-Pattern 1: Decomposition Prematura

**Problema:**
Scomponi PRIMA di avere API contract chiaro → Agents lavorano con assunzioni diverse → Incompatibilità

**Esempio:**
```
Backend assume: { "data": [...] }
Frontend assume: { "results": [...] }
→ Integration fallisce!
```

**Soluzione:**
Definisci API contract PRIMA di delegare. Se non è chiaro → Spike prima, decomposition dopo.

### ❌ Anti-Pattern 2: Delegazione Senza Checklist

**Problema:**
Delega solo con "fai X" senza checklist → Agent dimentica edge cases → Bug

**Soluzione:**
Sempre prompt completo con:
- Context
- Files
- **Checklist** dettagliata
- Success Criteria

### ❌ Anti-Pattern 3: No Integration Check

**Problema:**
Agents completano task → Assume tutto funzioni → Deploy → Bug in produzione

**Soluzione:**
Regina fa SEMPRE integration check:
- Test API manualmente
- Test UI in browser
- Verifica contract match

---

## 🔗 Related Patterns

| Pattern | Relazione | Quando Combinare |
|---------|-----------|------------------|
| Sequential Delegation | Alternativa | Quando task hanno dipendenze forti (backend → frontend sequenziale) |
| Delega Gerarchica | Complementa | Partitioning è un caso specifico di Delega Gerarchica |
| Background Agents | Complementa | Dopo partitioning → cervella-tester per integration test |

---

## 📊 Metrics

**Come misurare il successo di questo pattern:**

| Metrica | Target | Come Misurare |
|---------|--------|---------------|
| Sprint Velocity | +30% | Tempo con pattern vs senza pattern |
| Bug Cross-Layer | < 1 per sprint | Count bug causati da mismatch layer |
| Edit Manuali Regina | < 20% dei file | Count file editati da Regina vs delegati |
| Time to Integration | < 15 min | Tempo da "tutti completati" a "integration OK" |

---

## 🧪 Variations

### Variation 1: Sequential Partitioning

**Quando:** Dipendenze forti tra layer (backend DEVE finire prima di frontend)

**Differenza:**
```
Phase 1: cervella-backend completa
  ↓
Regina verifica API
  ↓
Phase 2: cervella-frontend (con API già pronta)
```

### Variation 2: Micro-Partitioning

**Quando:** Feature grande (10+ file, 5+ layer)

**Differenza:**
```
Scomponi in 2 livelli:
Level 1: Feature → Sub-features (Regina)
Level 2: Sub-feature → Layer tasks (Regina)
  ↓ delega
Agents lavorano su layer specifici
```

---

## 📝 Changelog

| Data | Versione | Modifiche |
|------|----------|-----------|
| 01/01/2026 | 1.0.0 | Creazione pattern basato su Sprint 3.9a Miracollo |

---

## 🎯 Philosophy

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   PARTITIONING = DIVIDE ET IMPERA                               ║
║                                                                  ║
║   Non è pigrizia della Regina.                                  ║
║   È SPECIALIZZAZIONE.                                            ║
║                                                                  ║
║   Ogni agent fa quello che SA FARE MEGLIO.                      ║
║   Regina coordina e VERIFICA.                                   ║
║                                                                  ║
║   "I dettagli fanno sempre la differenza."                      ║
║   E gli specialist conoscono i dettagli del loro layer.         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

> *"Ibrido e modulare - 2 guardiane? 3? 5? Dipende dal momento!"* - Rafa, 1 Gennaio 2026

---

*Creato: 1 Gennaio 2026 - Cervella Docs*
*Validato: ✅ SI (Sprint 3.9a Miracollo)*
*"È il nostro team! La nostra famiglia digitale!"* ❤️‍🔥
