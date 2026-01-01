# 📐 Background Agents Pattern (Specialization)

> *"Task ricorrente → Agent in background → Report automatico"*

---

## 📋 Metadata

| Campo | Valore |
|-------|--------|
| **Categoria** | Specialization |
| **Complessità** | Medium |
| **Use Case** | Cross-Domain (Quality, Testing, Review) |
| **Validato** | ✅ SI |
| **Data Scoperta** | 31 Dicembre 2025 |
| **Usato in** | Code Review settimanale (Lunedì/Venerdì) |

---

## 🎯 Context

**Quando si applica questo pattern?**

- Task **ricorrente** con frequenza definita (settimanale, giornaliero, per milestone)
- Task con **checklist standard** che non cambia
- Task che **non richiede decisioni strategiche** (solo esecuzione + report)
- Regina **sovraccaricata** da task ripetitivi che distraggono da sviluppo

**Composizione Swarm:**
- 👑 Regina (Cervella) - Delegator + Decision Maker
- 🐝 Background Agent - Specialist (reviewer, tester, auditor)

**Esempi task adatti:**
- Code Review settimanale
- Test suite automatici
- Audit qualità codice
- Security scan
- Performance check

---

## ❓ Problem

**Il problema che questo pattern risolve:**

- ❌ Regina deve **ricordarsi** di fare review ogni Lunedì/Venerdì
- 💥 Task ripetitivo **distrae** da sviluppo feature
- 📊 **Inconsistenza**: a volte review salta perché "non c'è tempo"
- 🐛 Problemi di qualità **accumulati** invece di risolti incrementalmente

**Esempio negativo:**

```
SENZA PATTERN:

Lunedì mattina:
Regina: "Devo fare review... ma ho questa feature urgente..."
→ Review salta

Venerdì:
Regina: "Devo fare review... ma voglio finire lo sprint..."
→ Review salta

Dopo 2 settimane:
→ 10 file con codice disordinato
→ Bug nascosti
→ Debito tecnico accumulato
→ "Come è successo?!"
```

---

## ✅ Solution

### Agent Structure

```
👑 Regina (Cervella)
   ↓ configura
   📅 Trigger (Lunedì/Venerdì, o manuale)
   ↓ attiva
   🐝 cervella-reviewer (Background Agent)
      ├─ LEGGE file target
      ├─ APPLICA checklist
      ├─ GENERA report
      └─ RITORNA a Regina
   ↑ review
👑 Regina → DECIDE azioni da prendere
```

### Workflow

**Step by Step:**

1️⃣ **Setup** (una volta)
   - [ ] Regina definisce checklist per background agent
   - [ ] Configura trigger (giorno settimana, frequency, manual)
   - [ ] Definisce output format (report template)

2️⃣ **Trigger Automatico** (ogni Lunedì/Venerdì)
   - [ ] Sistema chiede a Rafa: "Oggi è giorno di CODE REVIEW! Vuoi farla?"
   - [ ] Se SÌ → Attiva background agent
   - [ ] Se NO → Skip (logged)

3️⃣ **Execution** (Background Agent)
   - [ ] Legge file target (es: 2 file più modificati settimana)
   - [ ] Applica checklist standard
   - [ ] Identifica issues (complexity, duplicazione, best practices)
   - [ ] Genera report strutturato

4️⃣ **Review & Decision** (Regina)
   - [ ] Legge report da agent
   - [ ] Decide azioni: refactor immediato / backlog / ignore
   - [ ] Se refactor → Delega o fa diretto
   - [ ] Checkpoint con decisioni prese

### Interfaces / Prompt Templates

**Trigger Setup (CLAUDE.md):**

```markdown
### TRIGGER: "INIZIA SESSIONE -> [Progetto]"

2. 📅 CHECK GIORNO SETTIMANA:
   SE oggi è LUNEDÌ o VENERDÌ:
   → "Rafa, oggi è giorno di CODE REVIEW! 🔍
      Vuoi che la facciamo prima di iniziare?"
   → Se SÌ: invoca cervella-reviewer per audit settimanale
   → Se NO: procedi normalmente
```

**Prompt Regina → cervella-reviewer:**

```markdown
# Task: Code Review Settimanale

## Context
Progetto: [Nome]
Settimana: [Data inizio - Data fine]

## Files da Revieware
[Lista 2-3 file più modificati questa settimana]

## Checklist Review
- [ ] File > 500 righe?
- [ ] Funzioni > 50 righe?
- [ ] Codice duplicato? (3+ occorrenze stesso pattern)
- [ ] Commenti obsoleti?
- [ ] TODO/FIXME non risolti?
- [ ] Best practices violate?
- [ ] Magic numbers?
- [ ] Error handling mancante?

## Output Format
Per ogni file:
- ✅ OK / ⚠️ ISSUES
- Lista issues trovati
- Priorità: 🔴 HIGH / 🟡 MEDIUM / 🟢 LOW
- Suggerimenti refactor

## Success Criteria
✅ Report generato per tutti i file
✅ Issues prioritizzati
✅ Suggerimenti concreti (non generici)
```

**Report Agent → Regina:**

```markdown
## 📋 Code Review Report - [Data]

### Files Reviewed
1. `src/main.py` (650 righe)
2. `src/api/endpoints.py` (420 righe)

---

### 🔴 HIGH Priority Issues

**File:** `src/main.py`
- **Issue:** Funzione `process_data()` - 120 righe
  - **Linee:** 45-165
  - **Problema:** Troppo complessa, fa 5 cose diverse
  - **Suggerimento:** Split in `validate_data()`, `transform_data()`, `save_data()`

**File:** `src/api/endpoints.py`
- **Issue:** Codice duplicato (3 occorrenze)
  - **Pattern:** Validazione input identica in 3 endpoint
  - **Suggerimento:** Crea decorator `@validate_input(schema)`

---

### 🟡 MEDIUM Priority Issues

**File:** `src/main.py`
- **Issue:** Magic number `42` usato in 5 posti
  - **Suggerimento:** Costante `MAX_RETRIES = 42`

---

### ✅ GOOD Practices Found

- Error handling completo in `api/endpoints.py`
- Type hints presenti ovunque
- Docstring su tutte le funzioni pubbliche

---

### 📊 Summary

| Metrica | Valore | Status |
|---------|--------|--------|
| Avg File Size | 535 righe | ⚠️ (target < 500) |
| Max Function Size | 120 righe | 🔴 (target < 50) |
| Code Duplication | 3 occorrenze | 🟡 |
| TODO/FIXME | 2 | 🟢 |

---

### 🎯 Recommended Actions

1. **REFACTOR IMMEDIATO** (< 1h):
   - Split `process_data()` in 3 funzioni

2. **BACKLOG** (prossima settimana):
   - Crea decorator `@validate_input`
   - Replace magic numbers

3. **NICE TO HAVE**:
   - Risolvi TODO in `api/endpoints.py:142`
```

---

## ✅ When to Use

**Usa questo pattern quando:**

- ✅ **Task ricorrente** con frequenza >= settimanale
- ✅ **Checklist standard** definibile (non cambia ogni volta)
- ✅ **No decisioni strategiche** richieste dall'agent (solo report)
- ✅ Regina **sovraccaricata** da troppi task diversi

**Indicatori:**
- 📊 Task ripetitivo > 3 volte/mese
- 📊 Checklist stabile (< 20% variazioni)
- 📊 Tempo Regina su task ripetitivi > 20% sessione

---

## ❌ When to Avoid

**NON usare questo pattern quando:**

- ❌ **Task una-tantum** → Overhead non giustificato
- ❌ **Decisioni architetturali richieste** → Regina deve pensare, non solo agent
- ❌ **Checklist cambia ogni volta** → Non standardizzabile
- ❌ **Troppa variabilità** → Agent non può automatizzare

**Alternative migliori:**
- Se task una-tantum → Regina fa diretto o delega puntuale
- Se serve decisione → Regina analizza prima, poi delega esecuzione
- Se checklist instabile → Aspetta che si stabilizzi prima di automatizzare

---

## 🎬 Example

**Caso Reale:** Code Review Settimanale (Lunedì/Venerdì)

**Project:** Contabilità Antigravity + Miracollo PMS

**Context:**

Dopo audit completo (31 Dic 2025), abbiamo scoperto:
- 12 file > 500 righe
- Codice duplicato in 3 posti
- Funzioni troppo complesse

Problema: Come evitare che si accumuli di nuovo?

**Implementation:**

```
👑 Regina configura:
- Trigger: Lunedì e Venerdì mattina
- Files target: 2 file più modificati settimana corrente
- Checklist: CODE_REVIEW.md standard

📅 Lunedì mattina (Sistema):
"Rafa, oggi è giorno di CODE REVIEW! 🔍
Vuoi che la facciamo prima di iniziare?"

Rafa: "Sì!"

🐝 cervella-reviewer (Background):
- Legge `git diff --stat` per trovare file più modificati
- Legge 2 file top
- Applica checklist CODE_REVIEW.md
- Genera report

👑 Regina riceve report:
- 1 file ha funzione 80 righe (🔴 HIGH)
- Codice duplicato trovato (🟡 MEDIUM)

👑 Regina decide:
- Refactor immediato funzione 80 righe → Delega a cervella-backend
- Codice duplicato → Backlog per prossima settimana

📝 Checkpoint:
- Aggiorna ROADMAP_SACRA con "Code Review #1 completata"
- Aggiorna TODO con refactor da fare
```

**Results:**

- ✅ **2 review/settimana** = ~8 file/mese controllati
- ✅ **Incrementale**: problemi trovati PRIMA che diventino gravi
- ✅ Regina non deve **ricordare** → Sistema glielo chiede
- ⚡ **Debito tecnico**: -50% in 1 mese (stima)

**Lezione Appresa:**

> *"La qualità non si controlla dopo - si costruisce durante!"* - Rafa & Cervella, 31 Dic 2025

Il trucco NON è fare mega-audit ogni 3 mesi.
Il trucco è **piccoli check incrementali** ogni settimana.

---

## ⚠️ Anti-Patterns

### ❌ Anti-Pattern 1: Background Agent Decide

**Problema:**
Agent fa refactor AUTOMATICAMENTE senza chiedere a Regina → Modifica codice senza context strategico

**Esempio:**
```
Agent vede: funzione 80 righe
Agent pensa: "Split automaticamente!"
→ Split sbagliato (logica business spezzata male)
```

**Soluzione:**
Agent SOLO reporta. Regina DECIDE azioni.

### ❌ Anti-Pattern 2: Checklist Troppo Generica

**Problema:**
Checklist tipo "codice pulito?" → Report inutile ("Sì, è pulito" / "No, non lo è")

**Soluzione:**
Checklist SPECIFICA e MISURABILE:
- ✅ "File > 500 righe?"
- ✅ "Funzioni > 50 righe?"
- ❌ "Codice ben organizzato?" (troppo vago)

### ❌ Anti-Pattern 3: Review Senza Follow-up

**Problema:**
Agent genera bellissimo report → Regina legge → Niente azioni → Report inutile

**Soluzione:**
Ogni review DEVE finire con:
- Decisioni prese (refactor / backlog / ignore)
- Checkpoint con azioni
- Se refactor → Delegato o schedulato

---

## 🔗 Related Patterns

| Pattern | Relazione | Quando Combinare |
|---------|-----------|------------------|
| Delega Gerarchica | Complementa | Review trova issue → Regina delega refactor a specialist |
| Partitioning | Complementa | Review su feature multi-layer → Delega refactor per layer |
| Sequential Delegation | Complementa | Review → Refactor → Test (sequenza) |

---

## 📊 Metrics

**Come misurare il successo di questo pattern:**

| Metrica | Target | Come Misurare |
|---------|--------|---------------|
| Review Consistency | 80% settimane | Count review fatte / settimane totali |
| Issues Found | > 2 per review | Count issues in report |
| Issues Resolved | > 70% | Count issues risolti / trovati |
| Tempo Regina | < 30 min/review | Time from trigger a checkpoint |
| Debito Tecnico | -30% in 2 mesi | Count file > 500 righe, code duplication |

---

## 🧪 Variations

### Variation 1: On-Demand Background Agent

**Quando:** Task non ha frequenza fissa (milestone-based)

**Differenza:**
```
Niente trigger automatico.
Regina invoca manualmente quando serve:
"cervella-reviewer, fai audit pre-deploy"
```

### Variation 2: Multi-Agent Background

**Quando:** Checklist troppo grande per 1 agent

**Differenza:**
```
Regina delega a 2+ background agents:
- cervella-reviewer → Code quality
- cervella-security → Security scan
- cervella-performance → Performance check

Ogni agent genera report separato.
```

### Variation 3: Continuous Background

**Quando:** Monitoring continuo (non batch)

**Differenza:**
```
Agent gira in background SEMPRE.
Notifica Regina SOLO se trova issue critico:
"🔴 File `main.py` appena superato 600 righe!"
```

---

## 📝 Changelog

| Data | Versione | Modifiche |
|------|----------|-----------|
| 01/01/2026 | 1.0.0 | Creazione pattern basato su Code Review settimanale |
| 31/12/2025 | 0.9.0 | Prototype trigger Lunedì/Venerdì |

---

## 🎯 Philosophy

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   BACKGROUND AGENTS = DELEGARE IL RIPETITIVO                    ║
║                                                                  ║
║   Regina non deve ricordare.                                    ║
║   Regina non deve eseguire task ripetitivi.                     ║
║                                                                  ║
║   Gli agents ricordano.                                         ║
║   Gli agents eseguono.                                          ║
║   Gli agents reportano.                                         ║
║                                                                  ║
║   Regina DECIDE.                                                 ║
║                                                                  ║
║   "Lunedì e Venerdì = giorni di pulizia!                        ║
║   Un po' alla volta, sempre pulito!"                            ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

> *"Tu devi essere una capa più capa... sapere delegare più!"* - Rafa, 30 Dicembre 2025

---

*Creato: 1 Gennaio 2026 - Cervella Docs*
*Validato: ✅ SI (Code Review settimanale)*
*"È il nostro team! La nostra famiglia digitale!"* ❤️‍🔥
