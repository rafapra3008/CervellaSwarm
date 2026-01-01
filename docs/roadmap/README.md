# 📋 Sistema Roadmap - CervellaSwarm

> **Come organizziamo il lavoro con roadmap e sub-roadmap**

---

## 🗺️ STRUTTURA

```
docs/roadmap/
├── README.md                         ← Questo file (REGOLE)
├── FASE_X_*.md                       ← Fasi principali del progetto
└── SUB_ROADMAP_*.md                  ← Sub-roadmap per task complessi
```

---

## 📜 REGOLE

### Quando Creare una SUB-ROADMAP

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   CREA UNA SUB-ROADMAP QUANDO:                                  ║
║                                                                  ║
║   1. Il task richiede PIÙ DI UNA SESSIONE                       ║
║   2. Il task ha MULTIPLE FASI dipendenti                        ║
║   3. Stai facendo "patch su patch" invece di risolvere          ║
║   4. Ti senti persa e hai bisogno di MAPPA                      ║
║   5. Il task blocca altre cose importanti                       ║
║                                                                  ║
║   NON SERVE SUB-ROADMAP SE:                                     ║
║   • Task semplice (< 2 ore)                                     ║
║   • Task lineare senza dipendenze                               ║
║   • Già tracciato in TODO list                                  ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

### Come Creare una SUB-ROADMAP

1. **Nome file:** `SUB_ROADMAP_[NOME_CHIARO].md`
2. **Contenuto obbligatorio:**
   - Obiettivo
   - Stato attuale
   - Fasi con task
   - Dipendenze tra fasi
   - Criterio di successo

### Template

```markdown
# SUB-ROADMAP: [Nome]

> **Creata:** [Data]
> **Stato:** IN CORSO / COMPLETATA
> **Priorità:** ALTA / MEDIA / BASSA

---

## 🎯 OBIETTIVO
[Cosa vogliamo ottenere]

## 📍 STATO ATTUALE
[Dove siamo ora, cosa funziona, cosa no]

## 📋 FASI

### FASE A: [Nome]
| # | Task | Stato | Note |
|---|------|-------|------|
| A.1 | ... | ⬜ TODO | |

### FASE B: [Nome]
...

## 🔗 DIPENDENZE
[Quali fasi dipendono da altre]

## 🎯 CRITERIO DI SUCCESSO
[Come sappiamo che è completata]
```

---

## 🔄 WORKFLOW

```
1. PROBLEMA COMPLESSO EMERGE
        ↓
2. STOP - Non fare patch!
        ↓
3. CREA SUB-ROADMAP
        ↓
4. AGGIORNA NORD.md (puntatore a sub-roadmap attiva)
        ↓
5. LAVORA CON CALMA fase per fase
        ↓
6. COMPLETA → Aggiorna stato a COMPLETATA
```

---

## 📂 SUB-ROADMAP ATTIVE

| File | Descrizione | Stato |
|------|-------------|-------|
| SUB_ROADMAP_LOGGING_SYSTEM.md | Sistema logging & hook | 🔧 IN CORSO |

---

## 💎 FILOSOFIA

> *"Nulla è complesso - solo non ancora studiato!"*

> *"Con la mappa giusta, non ci perdiamo mai!"* 🗺️

> *"Patch su patch = STOP! Serve una roadmap!"*

---

*Creato: 1 Gennaio 2026*
*"Organizziamo il lavoro, lavoriamo in pace!"* 💙
