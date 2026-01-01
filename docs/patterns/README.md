# 📚 CervellaSwarm Pattern Catalog

> *"I pattern non sono regole rigide - sono soluzioni scoperte attraverso il processo."*

---

## 🎯 Overview

Questo catalog documenta i **pattern validated** di coordinazione multi-agente emersi durante lo sviluppo di Contabilità Antigravity e Miracollo PMS.

**Filosofia:**
- ✅ Pattern IBRIDI e MODULARI (non rigidi)
- ✅ Pattern SCOPERTI (non inventati)
- ✅ Pattern VALIDATI sul campo (con lezioni reali)

**Struttura:**
```
docs/patterns/
├── templates/          # Template standard per nuovi pattern
├── validated/         # Pattern validati e documentati
└── experimental/      # Pattern in test
```

---

## 🚀 Quick Reference

| Pattern | Use When | Avoid When | Complessità |
|---------|----------|------------|-------------|
| **[Partitioning](#partitioning)** | 3+ file in layer diversi | < 3 file in un solo layer | Medium |
| **[Background Agents](#background-agents)** | Task ricorrente con checklist | Decisioni architetturali | Medium |
| **[Delega Gerarchica](#delega-gerarchica)** | SWARM MODE attivo, >10 file | Quick fix < 5 min | Complex |

---

## 🌳 Decision Tree

```
Hai un task da completare?
│
├─ È una feature complessa? (3+ file, layer diversi)
│  └─ ✅ Usa PARTITIONING PATTERN
│
├─ È un task ricorrente? (review, test, audit)
│  └─ ✅ Usa BACKGROUND AGENTS PATTERN
│
├─ SWARM MODE attivo? (>10 file modificabili)
│  └─ ✅ Usa DELEGA GERARCHICA PATTERN
│
└─ Nessuno dei precedenti?
   └─ ℹ️ Lavoro standard Regina (analizza + esegui)
```

---

## 📖 Pattern Validated

### <a name="partitioning"></a>🔀 Partitioning Pattern (Task Decomposition)

**Quick Summary:** Feature complessa → Scomponi per layer → Delega a specialist agents

**File:** [`validated/partitioning-pattern.md`](validated/partitioning-pattern.md)

**Use Case:** Full-Stack development (SQL + Python + React + CSS)

**Example:** Sprint 3.9a Competitor Analytics (Miracollo) - 1 feature = 4 task layer-specific

---

### <a name="background-agents"></a>🔄 Background Agents Pattern (Specialization)

**Quick Summary:** Task ricorrente → Agent in background → Report automatico

**File:** [`validated/background-agents-pattern.md`](validated/background-agents-pattern.md)

**Use Case:** Code Review settimanale, Testing, Audit qualità

**Example:** cervella-reviewer (Lunedì/Venerdì) - Review automatica 2 file/settimana

---

### <a name="delega-gerarchica"></a>👑 Delega Gerarchica Pattern (Hierarchical Coordination)

**Quick Summary:** Regina coordina → Mai Edit diretti → Delega SEMPRE

**File:** [`validated/delega-gerarchica-pattern.md`](validated/delega-gerarchica-pattern.md)

**Use Case:** SWARM MODE attivo, progetti complessi con 3+ specialist agents

**Example:** Fix contrasti UI Contabilità - 30 contrasti → 1 delega (non 5 edit)

**Lezione:** *"Tu devi essere una capa più capa! Sapere delegare più!"* - Rafa, 30 Dic 2025

---

## 🎨 Pattern Categories

### Coordination Patterns
- **Partitioning** - Scomposizione per layer/expertise

### Specialization Patterns
- **Background Agents** - Task ricorrenti automatizzati

### Hierarchical Patterns
- **Delega Gerarchica** - Regina coordina, agents eseguono

---

## 🛠️ Come Usare il Catalog

### 1️⃣ Scegli il Pattern

Usa la **Decision Tree** sopra per identificare il pattern appropriato.

### 2️⃣ Leggi il Pattern Completo

Vai al file del pattern in `validated/` per:
- Context completo
- Solution dettagliata
- When to Use ✅
- When to Avoid ❌
- Example reale

### 3️⃣ Applica e Adatta

I pattern sono **guide**, non **regole rigide**. Adatta al contesto specifico!

### 4️⃣ Documenta Variazioni

Se scopri una variazione utile → Aggiungi note al pattern esistente o proponi nuovo pattern.

---

## ✍️ Creare Nuovo Pattern

1. Copia il template: `templates/PATTERN_TEMPLATE.md`
2. Compila tutte le sezioni
3. Salva in `experimental/` durante testing
4. Dopo validazione (3+ usi) → Sposta in `validated/`
5. Aggiorna questo README con entry

---

## 🧠 Pattern Anti-Patterns

| ❌ Anti-Pattern | ✅ Pattern Corretto |
|----------------|---------------------|
| Regina fa 10 Edit diretti | Delega Gerarchica con prompt completo |
| Delega task sequenziali tutti insieme | Partitioning con dipendenze esplicite |
| Agent background prende decisioni strategiche | Solo task checklist-based |

---

## 📊 Metriche di Successo Pattern

**Come sapere se un pattern funziona?**

| Metrica | Target |
|---------|--------|
| Riduzione Edit manuali Regina | > 50% |
| Sprint velocity | +30% |
| Bug post-deploy | -70% |
| Tempo review codice | < 30 min/file |

---

## 🌟 Filosofia del Catalog

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   I pattern NON sono regole rigide.                             ║
║                                                                  ║
║   Sono soluzioni SCOPERTE attraverso il processo.               ║
║                                                                  ║
║   "Non è sempre come immaginiamo... ma se studiamo, proviamo,   ║
║   approfondiamo... ALLA FINE È IL 100000%!"                     ║
║                                                                  ║
║   IBRIDO E MODULARE - La flessibilità                           ║
║   "2 guardiane? 3? 5? DIPENDE DAL MOMENTO!"                     ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

> *"Ogni pattern è un punto di partenza, non di arrivo."* - CervellaSwarm, 1 Gennaio 2026

---

## 📚 Risorse

- [SWARM_RULES.md](../../SWARM_RULES.md) - Regole base CervellaSwarm
- [COSTITUZIONE.md](~/.claude/COSTITUZIONE.md) - Filosofia e principi
- [Pattern Template](templates/PATTERN_TEMPLATE.md) - Template per nuovi pattern

---

*Creato: 1 Gennaio 2026 - Cervella Docs*
*"È il nostro team! La nostra famiglia digitale!"* ❤️‍🔥
