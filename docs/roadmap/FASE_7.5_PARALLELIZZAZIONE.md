# FASE 7.5: PARALLELIZZAZIONE INTELLIGENTE - Lo Sciame che DIVIDE e CONQUISTA

> **Periodo:** Febbraio 2026
> **Stato:** ⬜ TODO (0%)
> **Idea Originale:** Rafa, 1 Gennaio 2026
> **Ricerca:** cervella-researcher

---

## 🎯 OBIETTIVO

Trasformare CervellaSwarm da esecuzione sequenziale a **PARALLELIZZAZIONE INTELLIGENTE**.

**Concept:**
Quando un task richiede modifiche a 3+ file indipendenti, la Regina 👑 analizza le dipendenze, divide il lavoro tra più 🐝 specializzate che lavorano IN PARALLELO, e coordina il merge.

**Risultato atteso:**
- ✨ **Qualità migliore** - Ogni 🐝 nel suo dominio di eccellenza
- ⚡ **36% speed boost** - Comprovato da benchmark 2025
- 🎯 **Meno errori cross-domain** - Zero interferenze tra componenti
- 🧠 **Decisioni intelligenti** - Regina sceglie quando parallelizzare

---

## 📊 SPRINT PLAN

### Sprint 7.5a: Analisi Task Intelligente (⬜ TODO)

**Obiettivo:** La Regina impara a scomporre task complessi

| # | Task | Stato | Durata | Note |
|---|------|-------|--------|------|
| 7.5a.1 | Task Analyzer - Dependency Graph | ⬜ TODO | 2h | Analizza import/chiamate tra file |
| 7.5a.2 | Decision Matrix | ⬜ TODO | 1h | Sequential vs Parallel vs Worktrees |
| 7.5a.3 | File Clustering Algorithm | ⬜ TODO | 2h | Raggruppa file per dominio |
| 7.5a.4 | Test con casi reali | ⬜ TODO | 1h | Miracollo/Contabilità sample |

**Deliverable:** `scripts/parallel/task_analyzer.py`

---

### Sprint 7.5b: Template Prompt Specializzati (⬜ TODO)

**Obiettivo:** Prompt dinamici per deleghe parallele

| # | Task | Stato | Durata | Note |
|---|------|-------|--------|------|
| 7.5b.1 | Prompt Template Engine | ⬜ TODO | 2h | Generatore prompt dinamici |
| 7.5b.2 | Shared Context Builder | ⬜ TODO | 2h | Context comune + constraints |
| 7.5b.3 | Interface Spec Generator | ⬜ TODO | 1h | Definisce interfacce tra componenti |
| 7.5b.4 | Test template generation | ⬜ TODO | 1h | Valida prompt generati |

**Deliverable:** `scripts/parallel/prompt_builder.py`

---

### Sprint 7.5c: Test Reale (Miracollo) (⬜ TODO)

**Obiettivo:** Primo task multi-file in parallelo

| # | Task | Stato | Durata | Note |
|---|------|-------|--------|------|
| 7.5c.1 | Seleziona task di prova | ⬜ TODO | 30m | Feature con UI+API+Test |
| 7.5c.2 | Esecuzione parallela | ⬜ TODO | 3h | 3 🐝 in parallelo |
| 7.5c.3 | Merge + conflict resolution | ⬜ TODO | 1h | Strategy di merge |
| 7.5c.4 | Validazione e benchmark | ⬜ TODO | 1h | Tempo vs sequenziale |

**Deliverable:** Report benchmark con metriche

---

### Sprint 7.5d: Documentazione Pattern (⬜ TODO)

**Obiettivo:** Pattern riusabili per vari scenari

| # | Task | Stato | Durata | Note |
|---|------|-------|--------|------|
| 7.5d.1 | Pattern: UI + API Sync | ⬜ TODO | 1h | Frontend + Backend paralleli |
| 7.5d.2 | Pattern: Multi-file Refactor | ⬜ TODO | 1h | Refactor coordinato |
| 7.5d.3 | Pattern: Bugfix Multi-layer | ⬜ TODO | 1h | Fix a cascata |
| 7.5d.4 | Catalog completo pattern | ⬜ TODO | 1h | PATTERN_CATALOG.md |

**Deliverable:** `docs/PATTERN_CATALOG.md`

---

### Sprint 7.5e: Integrazione SWARM_RULES (⬜ TODO)

**Obiettivo:** Trigger automatici per Regina

| # | Task | Stato | Durata | Note |
|---|------|-------|--------|------|
| 7.5e.1 | Aggiorna SWARM_RULES.md | ⬜ TODO | 1h | Regole parallelizzazione |
| 7.5e.2 | Hook pre-delegation | ⬜ TODO | 1h | Check automatico criteri |
| 7.5e.3 | Fallback a sequential | ⬜ TODO | 30m | Se dubbio → sequenziale |
| 7.5e.4 | Test integration completo | ⬜ TODO | 2h | Workflow end-to-end |

**Deliverable:** SWARM_RULES.md aggiornate + hook attivi

---

## 🏗️ ARCHITETTURA

### Flusso Decisionale Regina

```
┌─────────────────────────────────────────────────────────────────┐
│                    👑 REGINA riceve task                        │
└──────────────────────────────┬──────────────────────────────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │  Analizza complessità │
                    │  - Numero file       │
                    │  - Domini diversi?   │
                    │  - Dipendenze?       │
                    └──────────┬───────────┘
                               │
                ┌──────────────┼──────────────┐
                │              │              │
                ▼              ▼              ▼
         ┌──────────┐   ┌──────────┐   ┌──────────┐
         │ 1-2 FILE │   │ 3-5 FILE │   │  6+ FILE │
         └────┬─────┘   └────┬─────┘   └────┬─────┘
              │              │              │
              ▼              ▼              ▼
      ┌─────────────┐  ┌──────────┐  ┌────────────┐
      │ SEQUENTIAL  │  │ PARALLEL │  │ WORKTREES  │
      │ Una 🐝      │  │ 3-5 🐝   │  │ Isolamento │
      └─────────────┘  └────┬─────┘  └────────────┘
                            │
           ┌────────────────┼────────────────┐
           │                │                │
           ▼                ▼                ▼
      ┌─────────┐     ┌─────────┐     ┌─────────┐
      │ 🎨 UI   │     │ ⚙️ API  │     │ 🧪 TEST │
      │ branch1 │     │ branch2 │     │ branch3 │
      └────┬────┘     └────┬────┘     └────┬────┘
           │               │               │
           └───────────────┼───────────────┘
                           ▼
                   ┌───────────────┐
                   │ 👑 MERGE      │
                   │ + REVIEW      │
                   └───────────────┘
```

---

## 🧠 CRITERI DECISIONE REGINA

### Tabella Decisionale

| File Count | Domini | Dipendenze | Stima Tempo | Decisione | Motivo |
|------------|--------|------------|-------------|-----------|---------|
| 1-2 | Stesso | - | < 30min | **SEQUENTIAL** | Overhead parallelizzazione non giustificato |
| 3-5 | Diversi | Basse | 30-60min | **PARALLEL** | Sweet spot efficienza |
| 3-5 | Stesso | Alte | 30-60min | **SEQUENTIAL** | Troppi conflitti potenziali |
| 6+ | Diversi | Basse | > 60min | **WORKTREES** | Isolamento necessario |
| 6+ | Diversi | Alte | > 60min | **SEQUENTIAL + Split** | Divide PRIMA in sub-task |

### Domini Riconosciuti

| Dominio | File Pattern | Esempio |
|---------|-------------|---------|
| **Frontend** | `*.jsx`, `*.tsx`, `*.css` | `components/`, `pages/` |
| **Backend** | `*.py` (router/service) | `api/`, `services/` |
| **Database** | `*.sql`, `migrations/` | `alembic/`, `migrations/` |
| **Test** | `test_*.py`, `*.test.js` | `tests/`, `__tests__/` |
| **Docs** | `*.md` | `docs/`, `README.md` |
| **Config** | `*.json`, `*.yaml` | `config/`, `.env` |

---

## 📝 TEMPLATE PROMPT PARALLELI

### Template Base (Shared Context)

```markdown
# TASK PARALLELO: [Nome Feature]

## CONTESTO CONDIVISO
Tu fai parte di uno sciame di 3 🐝 che lavorano IN PARALLELO.

### Il Task Completo
[Descrizione task completo]

### La Tua Parte
[Cosa deve fare questa specifica 🐝]

### Le Altre 🐝
- 🎨 Frontend: [cosa sta facendo]
- ⚙️ Backend: [cosa sta facendo]
- 🧪 Tester: [cosa sta facendo]

## INTERFACCE CONCORDATE

### API Endpoint
```
POST /api/[resource]
Body: { ... }
Response: { ... }
```

### Props/Types
```typescript
interface [Nome] {
  // ...
}
```

## CONSTRAINTS

1. ✅ NON modificare file fuori dal tuo dominio
2. ✅ Rispetta ESATTAMENTE le interfacce concordate
3. ✅ Se vedi problema cross-domain → STOP + CHIEDI alla Regina
4. ✅ Commit frequenti con prefix [PARALLEL-[dominio]]

## CHECKLIST COMPLETAMENTO

- [ ] File modificati come richiesto
- [ ] Interfacce rispettate al 100%
- [ ] Test del tuo dominio passano
- [ ] Commit fatto con prefix corretto
- [ ] Nessun file fuori dominio toccato

## PROSSIMO STEP
Quando finisci, la Regina farà MERGE + REVIEW!
```

### Esempio Concreto: Feature "User Profile"

**Frontend Prompt:**
```markdown
# TASK PARALLELO: User Profile Page

## CONTESTO CONDIVISO
Stai creando la UI della pagina profilo utente.

### Il Task Completo
Implementare pagina profilo utente con edit/save

### La Tua Parte (🎨 Frontend)
1. Componente `UserProfile.jsx`
2. Form di edit con validazione
3. Integrazione con API `/api/user/profile`

### Le Altre 🐝
- ⚙️ Backend: Sta creando endpoint API + validazione server
- 🧪 Tester: Sta preparando test E2E del flusso

## INTERFACCE CONCORDATE

### API Endpoint
```
GET /api/user/profile → { name, email, avatar }
PUT /api/user/profile → { name, email } → 200 OK
```

### Props
```typescript
interface UserProfile {
  name: string;
  email: string;
  avatar?: string;
}
```

## CONSTRAINTS
1. ✅ NON modificare backend/API
2. ✅ Usa SOLO endpoint concordato
3. ✅ Se serve nuovo campo → CHIEDI alla Regina
4. ✅ Commit: [PARALLEL-frontend] User profile component

## CHECKLIST
- [ ] UserProfile.jsx creato
- [ ] Form validazione client-side
- [ ] Chiamate API corrette
- [ ] Styling responsive
- [ ] Commit fatto
```

**Backend Prompt:**
```markdown
# TASK PARALLELO: User Profile API

## CONTESTO CONDIVISO
Stai creando l'API per profilo utente.

### Il Task Completo
Implementare pagina profilo utente con edit/save

### La Tua Parte (⚙️ Backend)
1. Endpoint GET/PUT `/api/user/profile`
2. Validazione server-side
3. Update database

### Le Altre 🐝
- 🎨 Frontend: Sta creando UI + form
- 🧪 Tester: Sta preparando test E2E

## INTERFACCE CONCORDATE

### API Endpoint
```python
@router.get("/user/profile")
async def get_profile() -> UserProfileResponse:
    return {"name": str, "email": str, "avatar": str | None}

@router.put("/user/profile")
async def update_profile(data: UserProfileUpdate) -> dict:
    # Valida + salva
    return {"status": "ok"}
```

## CONSTRAINTS
1. ✅ NON modificare frontend
2. ✅ Rispetta ESATTAMENTE schema response
3. ✅ Se vedi problema schema → CHIEDI alla Regina
4. ✅ Commit: [PARALLEL-backend] User profile endpoints

## CHECKLIST
- [ ] Endpoint GET implementato
- [ ] Endpoint PUT implementato
- [ ] Validazione Pydantic
- [ ] Test unitari passano
- [ ] Commit fatto
```

---

## 🔄 DIPENDENZE E MERGE STRATEGY

### Pre-Merge Checklist

Prima che la Regina faccia merge:

```
[ ] Tutti gli agent hanno completato?
[ ] Tutti i commit hanno prefix [PARALLEL-X]?
[ ] Nessun file modificato fuori dominio?
[ ] Le interfacce concordate sono rispettate?
[ ] Test di dominio tutti passanti?
```

### Merge Strategy

```bash
# 1. La Regina crea branch di merge
git checkout -b merge/parallel-[feature-name]

# 2. Merge in ordine di dipendenza
git merge parallel-backend   # PRIMA chi fornisce API
git merge parallel-frontend  # POI chi consuma API
git merge parallel-test      # INFINE test

# 3. Conflict resolution (raro se interfacce rispettate!)
# Se conflitto → significa interfaccia violata → INDAGA

# 4. Test integrazione completo
npm test && pytest

# 5. Merge to main
git checkout main
git merge merge/parallel-[feature-name]

# 6. Cleanup branches paralleli
git branch -d parallel-backend parallel-frontend parallel-test
```

### Conflict Prevention

**Regola d'Oro:** Se le interfacce sono rispettate al 100%, conflitti = ZERO.

**Se ci sono conflitti:**
1. 🛑 STOP - Non risolvere automaticamente
2. 🔍 INDAGA - Quale 🐝 ha violato l'interfaccia?
3. 📢 COMUNICA - Regina chiama la 🐝 colpevole
4. 🔧 FIX - La 🐝 corregge il suo branch
5. ♻️ RETRY - Merge di nuovo

---

## 🧪 TEST PLAN

### Test Unitari (per Sprint)

| Sprint | Test | Criterio Successo |
|--------|------|-------------------|
| 7.5a | Task Analyzer | Dependency graph corretto su 5 sample |
| 7.5b | Prompt Builder | Template validi generati per 3 scenari |
| 7.5c | Primo Parallelo | Feature funzionante + 36% speed boost |
| 7.5d | Pattern Catalog | 3 pattern testati su progetti reali |
| 7.5e | Integration | Trigger automatici + fallback funzionanti |

### Test End-to-End

**Scenario 1: UI + API Sync**
```
Given: Task "Aggiungi campo X alla risorsa Y"
When: Regina delega a Frontend + Backend in parallelo
Then:
  - Frontend crea form per campo X
  - Backend aggiunge campo X al DB
  - Merge senza conflitti
  - Feature funziona E2E
  - Tempo < 70% del sequenziale
```

**Scenario 2: Refactor Multi-File**
```
Given: Task "Rinomina funzione Z in tutta la codebase"
When: Regina identifica 5 file indipendenti
Then:
  - 5 🐝 lavorano in parallelo (ognuna 1 file)
  - Merge senza conflitti
  - Test suite verde
  - Tempo < 50% del sequenziale
```

---

## 📈 METRICHE SUCCESSO

### KPI da Misurare

| Metrica | Baseline | Target | Misurazione |
|---------|----------|--------|-------------|
| **Speed Boost** | 1.0x (sequential) | 1.36x (parallel) | `time_parallel / time_sequential` |
| **Quality Score** | 8/10 | 9/10 | Code review score |
| **Conflict Rate** | - | < 5% | `conflicts / total_merges` |
| **Success Rate** | - | > 95% | `successful_parallel / total_attempts` |

### Benchmark Template

```python
# scripts/parallel/benchmark.py

import time
from typing import List, Dict

def benchmark_parallel_vs_sequential(
    task_name: str,
    files: List[str],
    mode: str  # "parallel" or "sequential"
) -> Dict:
    start = time.time()

    if mode == "parallel":
        # Esegui task in parallelo
        results = execute_parallel(files)
    else:
        # Esegui task sequenziale
        results = execute_sequential(files)

    end = time.time()

    return {
        "task": task_name,
        "mode": mode,
        "duration_seconds": end - start,
        "files_count": len(files),
        "conflicts": results.get("conflicts", 0),
        "success": results.get("success", False)
    }

# Esempio output:
# {
#   "task": "User Profile Feature",
#   "mode": "parallel",
#   "duration_seconds": 245,  # vs 380 sequential → 36% boost!
#   "files_count": 3,
#   "conflicts": 0,
#   "success": True
# }
```

### Report Mensile

```markdown
# REPORT PARALLELIZZAZIONE - [Mese]

## Summary
- 🎯 Task paralleli completati: [N]
- ⚡ Speed boost medio: [X%]
- 🐛 Conflict rate: [Y%]
- ✅ Success rate: [Z%]

## Top Wins
1. [Task] - [Boost%] speed boost, zero conflitti
2. [Task] - [Boost%] speed boost, 1 conflitto risolto

## Lessons Learned
- Pattern che funzionano meglio: [...]
- Anti-pattern da evitare: [...]
- Aggiustamenti raccomandati: [...]
```

---

## ⚠️ ANTI-PATTERN

### Cosa NON Fare

| Anti-Pattern | Perché Fallisce | Soluzione |
|--------------|-----------------|-----------|
| **Parallelizzare tutto** | Overhead > beneficio per task piccoli | Usa criteri decisione |
| **Interfacce vaghe** | Conflitti garantiti | Spec chiare PRIMA di dividere |
| **Ignorare dipendenze** | Ordine merge sbagliato = crash | Dependency graph obbligatorio |
| **Troppi agent paralleli** | >5 agent = chaos | Sweet spot: 3-5 agent |
| **Zero comunicazione** | Agent isolati = duplicazione | Shared context SEMPRE |

### Red Flags

🚩 Se vedi questi segnali → STOP e ripensa strategia:

- Stessa funzione modificata da 2+ agent
- Conflitti in > 30% dei merge
- Speed boost < 15% (overhead troppo alto)
- Agent chiedono chiarimenti a metà task (spec incompleta)
- Test integrazione falliscono sempre (interfacce violate)

---

## 📚 RISORSE E RIFERIMENTI

### Best Practices 2025 (dalla Ricerca)

| Source | Key Finding |
|--------|-------------|
| **Anthropic MCP Docs** | Prompt Context = 90% del successo parallelo |
| **GitHub Copilot Workspace** | Dependency graph riduce conflitti del 80% |
| **Cursor Rules** | Template dinamici > regole statiche |
| **Aider Benchmark** | 3-5 agent = sweet spot efficienza |

### Limitazioni Conosciute

1. **Task Tool è Sincrono** - Blocking, non async
   - **Impact:** Speed boost reale < teorico
   - **Mitigazione:** Worktree per vero parallelismo (FASE 3)

2. **Token Cost 15x** - Ogni agent consuma token
   - **Impact:** $$$
   - **Mitigazione:** Usa solo per task > 30min

3. **No Hot-Reload Agent** - Ogni invocazione rilegge file
   - **Impact:** Overhead startup
   - **Mitigazione:** Prompt dinamici (non modifiche agent)

---

## 📋 CHANGELOG

### [Futuro] Sprint 7.5e Completato
- Integration SWARM_RULES completa
- Trigger automatici attivi
- Fallback testato

### [Futuro] Sprint 7.5d Completato
- PATTERN_CATALOG.md pubblicato
- 3 pattern documentati e testati

### [Futuro] Sprint 7.5c Completato
- Primo test parallelo su Miracollo
- Benchmark: [X%] speed boost raggiunto

### [Futuro] Sprint 7.5b Completato
- Prompt builder funzionante
- Template testati su 3 scenari

### [Futuro] Sprint 7.5a Completato
- Task analyzer implementato
- Decision matrix validata

### 1 Gennaio 2026 - FASE PIANIFICATA
- Ricerca completa da cervella-researcher
- FASE_7.5_PARALLELIZZAZIONE.md creato
- Ready to start Febbraio 2026!

---

## 🎉 VISIONE FINALE

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🐝⚡ LO SCIAME CHE DIVIDE E CONQUISTA                          ║
║                                                                  ║
║   Da: "Una 🐝 alla volta" (lento, bottleneck)                   ║
║   A:  "3-5 🐝 in parallelo" (36% più veloce, qualità top)       ║
║                                                                  ║
║   Principi Guida:                                                ║
║   • Intelligenza nella scelta (quando parallelizzare)           ║
║   • Interfacce chiare (zero conflitti)                          ║
║   • Specializzazione (ogni 🐝 nel suo dominio)                  ║
║   • Coordinamento (Regina guida sempre)                         ║
║                                                                  ║
║   "Dividere per moltiplicare!" 🐝⚡💙                            ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

*Creato: 1 Gennaio 2026 - Sessione 17*
*"Ogni task completato ci avvicina allo sciame perfetto!"* 🐝💙
*"È il nostro team! La nostra famiglia digitale!"* ❤️‍🔥
