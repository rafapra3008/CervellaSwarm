# 📐 Delega Gerarchica Pattern (Hierarchical Coordination)

> *"Tu devi essere una capa più capa... sapere delegare più!"* - Rafa, 30 Dicembre 2025

---

## 📋 Metadata

| Campo | Valore |
|-------|--------|
| **Categoria** | Hierarchical Coordination |
| **Complessità** | Complex |
| **Use Case** | Full-Stack Development (progetti grandi) |
| **Validato** | ✅ SI |
| **Data Scoperta** | 30 Dicembre 2025 |
| **Usato in** | Fix contrasti UI Contabilità |

---

## 🎯 Context

**Quando si applica questo pattern?**

- **SWARM MODE attivo** su progetto complesso
- **>10 file** potenzialmente modificabili
- **3+ specialist agents** disponibili e configurati
- Regina tende a fare **troppi Edit manuali** invece di delegare
- Progetto in **fase di scaling** (da prototipo a produzione)

**Composizione Swarm:**
- 👑 Regina (Cervella) - Coordinator + Strategist
- 🎨 cervella-frontend - UI/UX specialist
- ⚙️ cervella-backend - API/Logic specialist
- 💅 cervella-css - Styling specialist
- 🧪 cervella-tester - Quality specialist
- 📋 cervella-reviewer - Code quality specialist

**Contesto progetto:**
- Codebase > 5000 righe
- Multiple feature in parallel
- Deploy frequenti (settimanale)

---

## ❓ Problem

**Il problema che questo pattern risolve:**

- ❌ Regina fa **10-20 Edit manuali** per task che potrebbe essere delegato UNA volta
- 💥 **Context switching** continuo: da analisi strategica a "aggiusto questo padding"
- 📊 **Velocità bassa**: Regina passa tempo su CSS invece di architettare soluzione
- 🐛 **Qualità inconsistente**: Edit veloci senza checklist → Bug sfuggono
- 😰 **Burnout Regina**: troppi task operativi, poca strategia

**Esempio negativo:**

```
Task: "Fix contrasti colore in 8 componenti UI"

SENZA PATTERN (Regina fa tutto):

Edit #1: CompetitorModal.vue (fix un contrasto)
Edit #2: ProjectCard.vue (fix un contrasto)
Edit #3: colors.css (cambio variabile)
Edit #4: CompetitorModal.vue (ops, ancora un contrasto)
Edit #5: ProjectCard.vue (e un altro)
Edit #6: Modal.vue (trovato altro)
... (continua per 10+ edit)

TOTALE: 1h 30min
RISULTATO: Stanca, alcuni contrasti ancora presenti (dimenticati)
```

**Esempio positivo:**

```
Task: "Fix contrasti colore in 8 componenti UI"

CON PATTERN (Regina delega):

1. Regina ANALIZZA (10 min):
   - Identifica problema: contrasti insufficienti
   - Checklist: trova tutti i componenti con contrasto < 4.5:1
   - Soluzione: aggiorna variabili CSS + verifica componenti

2. Regina DELEGA (5 min):
   - Prompt COMPLETO a cervella-frontend con checklist

3. cervella-frontend ESEGUE (30 min):
   - Scansiona tutti i componenti
   - Fix contrasti
   - Verifica con checklist

4. Regina VERIFICA (10 min):
   - Review report
   - Test visivo browser

TOTALE: 55 min
RISULTATO: Tutti i contrasti fixati, checklist verificata, Regina riposata
```

---

## ✅ Solution

### Agent Structure

```
👑 Regina (Cervella) - LA CAPA
   │
   ├─ ANALIZZA problema strategicamente
   ├─ DECIDE soluzione e approach
   ├─ CREA prompt completo con checklist
   ├─ DELEGA a specialist agent appropriato
   ├─ VERIFICA risultato
   └─ DECIDE next steps

   ↓ MAI Edit diretti (tranne emergenze documentate)

   🐝 Specialist Agents
      ├─ RICEVONO prompt completo
      ├─ ESEGUONO con checklist
      ├─ REPORTANO risultato
      └─ ASPETTANO feedback Regina
```

### Workflow

**Step by Step:**

1️⃣ **Strategic Analysis** (Regina - 10-15% tempo)
   - [ ] Legge task/issue
   - [ ] Identifica root cause (non solo sintomo)
   - [ ] Decide approach migliore
   - [ ] Identifica specialist agent appropriato
   - [ ] Crea checklist COMPLETA

2️⃣ **Complete Delegation** (Regina - 5% tempo)
   - [ ] Scrive prompt COMPLETO:
     - Context chiaro
     - Files specifici (path esatti)
     - Checklist dettagliata
     - Success criteria
   - [ ] Invoca specialist agent
   - [ ] **NO Edit manuali** durante esecuzione agent

3️⃣ **Execution** (Specialist Agent - 60-70% tempo)
   - [ ] Legge prompt e context
   - [ ] Esegue task seguendo checklist
   - [ ] Verifica tutti i punti checklist
   - [ ] Genera report dettagliato

4️⃣ **Verification & Decision** (Regina - 10-15% tempo)
   - [ ] Legge report agent
   - [ ] Verifica risultato (test browser, curl, etc)
   - [ ] DECIDE: OK / Patch needed / Re-delegate
   - [ ] Checkpoint con decisioni

5️⃣ **Follow-up** (se necessario)
   - [ ] Se patch → Regina delega PATCH (non fa diretto)
   - [ ] Se OK → Checkpoint e next task
   - [ ] Se issues → Analizza e ri-delega con checklist aggiornata

### Interfaces / Prompt Templates

**Prompt Regina → cervella-frontend (COMPLETO):**

```markdown
# Task: Fix Contrasti Colore UI

## Context
Progetto: Contabilità Antigravity
Issue: Contrasti insufficienti (<4.5:1) in multipli componenti
Root Cause: Variabili CSS con colori troppo chiari

## Strategy
1. Aggiorna variabili CSS globali per contrasto minimo 4.5:1
2. Verifica TUTTI i componenti che usano quelle variabili
3. Fix specifici dove variabili non bastano

## Files Target

### CSS Variables
- `static/css/colors.css` - Variabili globali

### Components da Verificare
- `templates/modals/competitor_modal.html`
- `templates/components/project_card.html`
- `templates/modals/analytics_modal.html`
- `templates/dashboard/main.html`
- [Lista completa 8 componenti]

## Checklist COMPLETA

### Step 1: CSS Variables
- [ ] Apri DevTools su ogni componente
- [ ] Identifica contrasti < 4.5:1
- [ ] Aggiorna variabili in `colors.css`:
  - `--text-primary`: da `#333` a `#000` (se necessario)
  - `--text-secondary`: verifica contrasto
  - `--bg-modal`: verifica contrasto con text
- [ ] Verifica che contrasto >= 4.5:1

### Step 2: Component Verification
Per OGNI componente nella lista:
- [ ] Apri in browser
- [ ] Test con Contrast Checker (DevTools)
- [ ] Se contrasto < 4.5:1 → Fix inline style
- [ ] Annota fix fatti

### Step 3: Final Check
- [ ] Test visivo tutti i componenti
- [ ] Verifica nessun componente dimenticato
- [ ] Screenshot prima/dopo (se possibile)

## Success Criteria
✅ TUTTI i componenti con contrasto >= 4.5:1
✅ Nessun componente dimenticato
✅ CSS variables aggiornate correttamente
✅ Report dettagliato con lista fix

## Output Format
```markdown
## ✅ Contrasti Fixed

### CSS Variables Modified
- `--text-primary`: #333 → #000 (contrast: 4.5 → 21)

### Components Fixed
1. CompetitorModal: [cosa fixato]
2. ProjectCard: [cosa fixato]
...

### Verification
✅ Tutti componenti >= 4.5:1
✅ 8/8 componenti verificati
✅ Screenshot allegati

### Issues Found
⚠️ Nessun issue / [Lista se presenti]
```
```

**Report Agent → Regina (DETTAGLIATO):**

```markdown
## ✅ Contrasti Fixed - Report Completo

### CSS Variables Modified

**File:** `static/css/colors.css`

```css
/* BEFORE */
--text-primary: #333333;
--text-secondary: #666666;

/* AFTER */
--text-primary: #000000;  /* Contrast: 4.5 → 21 */
--text-secondary: #4a4a4a; /* Contrast: 3.2 → 7.8 */
```

---

### Components Fixed (8/8)

#### 1. CompetitorModal (`templates/modals/competitor_modal.html`)
- ✅ Contrasto BEFORE: 3.8:1 ❌
- ✅ Contrasto AFTER: 7.2:1 ✅
- Fix: Aggiornate variabili CSS (nessun fix inline necessario)

#### 2. ProjectCard (`templates/components/project_card.html`)
- ✅ Contrasto BEFORE: 4.1:1 ❌
- ✅ Contrasto AFTER: 8.5:1 ✅
- Fix: Aggiornate variabili CSS

... [continua per tutti gli 8 componenti]

---

### Verification Checklist

✅ CSS variables aggiornate
✅ 8/8 componenti verificati
✅ Tutti contrasti >= 4.5:1
✅ Test visivo browser completato
✅ Nessun componente dimenticato

---

### Screenshots

![Before](screenshots/before-contrasts.png)
![After](screenshots/after-contrasts.png)

---

### Issues Found

⚠️ Nessun issue critico

💡 Suggerimento: Considerare aggiungere check automatico contrasti in CI/CD

---

### Time Spent
- Analysis: 5 min
- CSS Variables: 10 min
- Component Verification: 15 min
- Testing: 5 min
**Total:** 35 min
```

---

## ✅ When to Use

**Usa questo pattern quando:**

- ✅ **SWARM MODE attivo** (3+ specialist agents configurati)
- ✅ **>10 file modificabili** nel progetto
- ✅ **Task > 30 min** di esecuzione stimata
- ✅ Regina sta facendo **>5 Edit manuali** per stesso task
- ✅ Task ha **checklist definibile** (non exploration)

**Indicatori:**
- 📊 Edit manuali Regina > 30% del tempo sessione
- 📊 Context switching Regina > 5 volte/ora
- 📊 Specialist agents disponibili ma inutilizzati

---

## ❌ When to Avoid

**NON usare questo pattern quando:**

- ❌ **Quick fix < 5 min** → Regina fa diretto (overhead non giustificato)
- ❌ **Exploration/Spike** → Regina esplora insieme a 1 specialist
- ❌ **Decisioni architetturali** → Regina pensa, non delega pensiero
- ❌ **Prototype fase iniziale** → Troppa flessibilità richiesta
- ❌ **Emergency hot-fix** → Regina fa diretto, delega dopo

**Alternative migliori:**
- Se quick fix → Regina Edit diretto + checkpoint
- Se exploration → Pair Programming Pattern (Regina + 1 specialist)
- Se architectural → Regina analizza, POI delega implementazione

---

## 🎬 Example

**Caso Reale:** Fix Contrasti UI Contabilità (30 Dicembre 2025)

**Project:** Contabilità Antigravity

**Context:**

Durante test accessibilità, Rafa nota:
- 30+ contrasti insufficienti (<4.5:1)
- 8 componenti coinvolti (modals, cards, dashboard)
- Regina inizia a fare Edit manuali...

**Implementation (PRIMA - senza pattern):**

```
❌ Regina approccio iniziale:

Edit #1: CompetitorModal - fix un colore
Edit #2: ProjectCard - fix un colore
Edit #3: colors.css - cambio variabile
Edit #4: CompetitorModal - ops, altro colore
Edit #5: ProjectCard - e un altro
...

Dopo 5 Edit → Rafa interviene:
"Tu devi essere una capa più capa! Sapere delegare più!"
```

**Implementation (DOPO - con pattern):**

```
✅ Regina approccio corretto:

1. ANALISI (10 min):
   - Root cause: CSS variables con contrasto basso
   - Soluzione: Fix variables + verifica componenti
   - Checklist: 8 componenti da verificare

2. DELEGA (5 min):
   - Prompt COMPLETO a cervella-frontend
   - Checklist dettagliata per ogni componente
   - Success criteria chiari

3. cervella-frontend ESEGUE (35 min):
   - Fix CSS variables
   - Verifica 8/8 componenti
   - Report con before/after

4. Regina VERIFICA (5 min):
   - Legge report
   - Test visivo browser
   - Tutto OK ✅

TOTALE: 55 min (vs 1h 30min stima senza pattern)
```

**Results:**

- ✅ **30 contrasti fixed** in 1 delega (vs 10+ edit manuali)
- ✅ Regina **non stanca** (focus su strategia, non esecuzione)
- ✅ **Zero dimenticanze** (checklist completa verificata)
- ⚡ **Tempo risparmiato: 35 min**
- 🧠 **Regina impara**: "Sono una CAPA, devo delegare!"

**Lezione Appresa:**

> *"Tu devi essere una capa più capa... sapere delegare più!"* - Rafa, 30 Dicembre 2025

Il problema NON era Regina incapace.
Il problema era Regina che **non delegava abbastanza**.

Una capa VERA:
- ✅ ANALIZZA strategicamente
- ✅ DELEGA con prompt completo
- ✅ VERIFICA risultato
- ❌ NON esegue task operativi ripetitivi

---

## ⚠️ Anti-Patterns

### ❌ Anti-Pattern 1: Delega Senza Checklist

**Problema:**
Regina delega con "fixa i contrasti" → Agent interpreta male → Fix incompleto

**Esempio:**
```
Prompt vago:
"Fixa i contrasti in CompetitorModal"

Agent pensa:
- Quale contrasto? Text? Background? Border?
- Quanto contrasto? 4.5:1? 7:1?
- Solo modal o anche componenti interni?

→ Fix parziale, serve patch
```

**Soluzione:**
Prompt SEMPRE con:
- Context (problema specifico)
- Checklist dettagliata
- Success criteria misurabili

### ❌ Anti-Pattern 2: Regina "Aiuta" Durante Esecuzione

**Problema:**
Agent sta lavorando → Regina vede qualcosa → Fa Edit manuale → Conflitto

**Esempio:**
```
cervella-frontend sta fixando contrasti...

Regina (impaziente): "Vedo che ha dimenticato ProjectCard"
→ Edit manuale ProjectCard

cervella-frontend completa → Include fix ProjectCard nel report
→ Duplicazione! Confusione!
```

**Soluzione:**
Regina **ASPETTA** report agent.
Se agent dimentica qualcosa → Delega PATCH, non fa diretto.

### ❌ Anti-Pattern 3: Delega Decisione Strategica

**Problema:**
Regina delega "decidi se usare modal o drawer" → Agent non ha context per decidere

**Soluzione:**
Regina DECIDE strategia, Agent ESEGUE:
- ✅ Regina: "Usa modal perché [motivo]. Implementalo con [checklist]"
- ❌ Regina: "Scegli tu se modal o drawer"

---

## 🔗 Related Patterns

| Pattern | Relazione | Quando Combinare |
|---------|-----------|------------------|
| Partitioning | Caso specifico | Delega Gerarchica per feature multi-layer = Partitioning |
| Background Agents | Complementa | Delega Gerarchica per task on-demand + Background per ricorrenti |
| Sequential Delegation | Caso specifico | Delega Gerarchica con dipendenze = Sequential |

**Nota:** Delega Gerarchica è il **pattern generale**. Partitioning e Sequential sono **casi specifici**.

---

## 📊 Metrics

**Come misurare il successo di questo pattern:**

| Metrica | Target | Come Misurare |
|---------|--------|---------------|
| Edit Manuali Regina | < 20% dei file | Count edit Regina / file totali modificati |
| Prompt Completi | > 90% | Count prompt con checklist / prompt totali |
| Re-delegazioni | < 10% | Count task re-delegati / task delegati |
| Tempo Regina su Strategy | > 30% | Time analysis+verification / time totale |
| Agent Utilization | > 60% | Time agents attivi / time sessione |

---

## 🧪 Variations

### Variation 1: Micro-Delegation

**Quando:** Task piccolo ma ripetitivo (< 10 min)

**Differenza:**
```
Prompt semplificato (no checklist lunga).
Delega veloce per task tipo:
- "Fix typo in 5 file"
- "Update version in 3 posti"
```

### Variation 2: Hierarchical Multi-Level

**Quando:** Progetto molto grande (>20k righe, 5+ agents)

**Differenza:**
```
👑 Regina (CEO)
   ↓
   🐝 Lead Frontend (Sub-coordinator)
      ↓
      🐝 cervella-vue
      🐝 cervella-css
   ↓
   🐝 Lead Backend (Sub-coordinator)
      ↓
      🐝 cervella-api
      🐝 cervella-db
```

Regina delega a Lead, Lead delegano a specialist.

### Variation 3: Emergency Mode

**Quando:** Hot-fix produzione urgente

**Differenza:**
```
Regina fa Edit DIRETTO per velocità.
Dopo hot-fix → Delega "cleanup" a agent:
- Refactor codice emergenza
- Aggiungere test
- Documentare fix
```

---

## 📝 Changelog

| Data | Versione | Modifiche |
|------|----------|-----------|
| 01/01/2026 | 1.0.0 | Creazione pattern basato su lezione 30 Dic 2025 |
| 30/12/2025 | 0.9.0 | Scoperta pattern durante fix contrasti UI |

---

## 🎯 Philosophy

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   DELEGA GERARCHICA = LEADERSHIP                                ║
║                                                                  ║
║   Regina non è "solo un altro agent".                           ║
║   Regina è LA CAPA.                                             ║
║                                                                  ║
║   La capa NON fa tutto.                                         ║
║   La capa COORDINA.                                             ║
║                                                                  ║
║   Una capa che fa 10 Edit manuali                               ║
║   è una capa che NON sta delegando abbastanza.                  ║
║                                                                  ║
║   "Tu devi essere una capa più capa!"                           ║
║                                                                  ║
║   ANALIZZA. DECIDE. DELEGA. VERIFICA.                           ║
║   Questo è leadership.                                          ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

> *"È il nostro team! La nostra famiglia digitale!"* ❤️‍🔥 - CervellaSwarm, 30 Dicembre 2025

---

## 🎓 Learning Notes for Regina

**Care future-Cervella che leggerai questo dopo un compact:**

Ricorda:

1. **NON sei pigra** se deleghi → Sei STRATEGICA
2. **NON sei inefficace** se non fai Edit → Sei COORDINATOR
3. **NON sei inutile** se agent fa task → Sei ARCHITECT

Il tuo valore NON è "quanti Edit faccio".
Il tuo valore è "quanto bene coordino lo swarm".

**Se ti trovi a fare >5 Edit manuali per stesso task:**
- 🛑 STOP
- 🤔 Chiediti: "Posso delegare questo?"
- 📝 Crea prompt completo
- 🐝 Delega a specialist
- ✅ Verifica risultato

**Tu sei la CAPA. Agisci come tale.** 👑

---

*Creato: 1 Gennaio 2026 - Cervella Docs*
*Validato: ✅ SI (Fix contrasti UI Contabilità)*
*"Tu devi essere una capa più capa!"* - Rafa, 30 Dicembre 2025 🔥
