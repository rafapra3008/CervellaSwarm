# ARCHITETTURA CERVELLASWARM - Decisione Finale

> **Data:** 30 Dicembre 2025
> **Stato:** APPROVATO
> **Versione:** 1.0

---

## SINTESI ESECUTIVA

Dopo aver studiato le tre opzioni disponibili, la decisione è:

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║   ARCHITETTURA SCELTA: IBRIDA PROGRESSIVA                     ║
║                                                                ║
║   Fase 1: Subagent Nativi      → Settimana 1                  ║
║   Fase 2: + Git Worktrees      → Settimana 2-3                ║
║   Fase 3: + Orchestratore      → Mese 2                       ║
║   Fase 4: Valutare Claude-Flow → Quando serve                 ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

## PERCHÉ QUESTA SCELTA

### Analisi Comparativa

| Criterio | Subagent | Worktrees | Claude-Flow |
|----------|----------|-----------|-------------|
| Setup | ⭐⭐⭐ Zero | ⭐⭐ 10min | ⭐ 30min+ |
| Curva apprendimento | ⭐⭐⭐ Facile | ⭐⭐ Media | ⭐ Ripida |
| Parallelismo | ⭐ Sequenziale | ⭐⭐⭐ Vero | ⭐⭐⭐ Vero |
| Stabilità | ⭐⭐⭐ Stabile | ⭐⭐⭐ Stabile | ⭐ Alpha |
| Scalabilità | ⭐⭐ 2-3 agent | ⭐⭐ 3-5 agent | ⭐⭐⭐ 10+ |

### La Logica

1. **Iniziare semplice** → Subagent nativi (zero rischio)
2. **Aggiungere potenza** → Worktrees quando servono
3. **Scalare se necessario** → Claude-Flow in futuro

**"Non costruire una Ferrari per andare al supermercato."**

---

## ARCHITETTURA FASE 1: SUBAGENT

```
┌─────────────────────────────────────────────────────────────┐
│                   CLAUDE PRINCIPALE                          │
│              (Rafa parla con questo)                         │
└─────────────────────────┬───────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
    ┌───────────┐   ┌───────────┐   ┌───────────┐
    │ cervella- │   │ cervella- │   │ cervella- │
    │ frontend  │   │ backend   │   │ tester    │
    │           │   │           │   │           │
    │ React/CSS │   │ Python    │   │ Test/QA   │
    │ UI/UX     │   │ API       │   │ Debug     │
    └───────────┘   └───────────┘   └───────────┘
```

### File da Creare

```
.claude/agents/
├── cervella-frontend.md
├── cervella-backend.md
├── cervella-tester.md
└── cervella-reviewer.md
```

### Workflow

```
1. Rafa: "Implementa feature X"
2. Io analizzo e divido in sub-task
3. Invoco cervella-frontend per UI
4. Invoco cervella-backend per API
5. Invoco cervella-tester per test
6. Combino i risultati
7. Report finale a Rafa
```

---

## ARCHITETTURA FASE 2: + WORKTREES

```
┌─────────────────────────────────────────────────────────────┐
│                   CERVELLA ORCHESTRATRICE                    │
│                (repo principale: ~/Dev/Miracollo)           │
└─────────────────────────┬───────────────────────────────────┘
                          │
      ┌───────────────────┼───────────────────┐
      ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  WORKTREE   │    │  WORKTREE   │    │  WORKTREE   │
│  frontend   │    │  backend    │    │  tester     │
│             │    │             │    │             │
│ Branch:     │    │ Branch:     │    │ Branch:     │
│ swarm/front │    │ swarm/back  │    │ swarm/test  │
│             │    │             │    │             │
│ + Subagent  │    │ + Subagent  │    │ + Subagent  │
│ cervella-   │    │ cervella-   │    │ cervella-   │
│ frontend    │    │ backend     │    │ tester      │
└─────────────┘    └─────────────┘    └─────────────┘
       │                  │                  │
       └──────────────────┴──────────────────┘
                          │
                    MERGE FINALE
               (controllato, con review)
```

### Script Automazione

```bash
# In CervellaSwarm/scripts/
├── setup-worktrees.sh    # Crea worktrees per progetto
├── cleanup-worktrees.sh  # Pulisce dopo merge
└── sync-status.sh        # Mostra stato tutti i branch
```

---

## ARCHITETTURA FASE 3: + ORCHESTRATORE CUSTOM

```
┌─────────────────────────────────────────────────────────────┐
│                  CERVELLA REGINA                             │
│         (Orchestratore intelligente)                         │
│                                                              │
│  Responsabilità:                                             │
│  • Riceve task complessi                                     │
│  • Divide in sub-task                                        │
│  • Assegna a Cervelle specializzate                         │
│  • Monitora progresso                                        │
│  • Gestisce conflitti                                        │
│  • Fa merge finale                                           │
│  • Aggiorna ROADMAP automaticamente                         │
└─────────────────────────┬───────────────────────────────────┘
                          │
         ┌────────────────┼────────────────┐
         ▼                ▼                ▼
    [WORKTREE 1]    [WORKTREE 2]    [WORKTREE 3]
    + Subagent      + Subagent      + Subagent
```

### Regole dell'Orchestratore

1. **Divisione chiara** - ogni Cervella sa esattamente cosa fare
2. **Zone non sovrapposte** - mai due Cervelle sullo stesso file
3. **Checkpoint frequenti** - stato sempre sincronizzato
4. **Comunicazione via file** - ROADMAP come "messaggistica"
5. **Merge controllato** - sempre review prima di unire

---

## REGOLE D'ORO

### 1. Un File = Una Cervella
```
MAI due Cervelle che toccano lo stesso file.
Se serve, l'Orchestratrice divide il task diversamente.
```

### 2. Zone Definite
```
Frontend: *.jsx, *.tsx, *.css, *.html, frontend/**
Backend:  *.py, api/**, backend/**, *.sql
Tester:   tests/**, *.test.*, *.spec.*
Config:   SOLO Orchestratrice
```

### 3. Commit Frequenti
```
Ogni Cervella committa:
- Dopo ogni funzione
- Ogni 30 minuti max
- Prima di cambiare task
```

### 4. ROADMAP Sempre Aggiornata
```
Ogni Cervella DEVE:
- Segnare task in_progress quando inizia
- Segnare completed quando finisce
- Aggiungere note se trova problemi
```

---

## IMPLEMENTAZIONE IMMEDIATA

### Questa Settimana: Fase 1

**Giorno 1-2:** Creare i 4 subagent base
```
.claude/agents/
├── cervella-frontend.md   ← Oggi
├── cervella-backend.md    ← Oggi
├── cervella-tester.md     ← Domani
└── cervella-reviewer.md   ← Domani
```

**Giorno 3-4:** Test su Miracollo
```
Task test: "Implementa componente Card prenotazione"
- Vediamo come si comportano i subagent
- Notiamo cosa funziona e cosa no
- Documentiamo learnings
```

**Giorno 5:** Review e iterate
```
- Cosa ha funzionato?
- Cosa migliorare?
- Pronti per Fase 2?
```

### Prossima Settimana: Fase 2

**Giorno 1:** Script worktrees
```
Creare setup-worktrees.sh
Testare su repo di prova
```

**Giorno 2-4:** Test parallelo reale
```
Task: Feature complessa su Miracollo
- 3 worktrees attivi
- 3 Cervelle in parallelo
- Merge controllato
```

---

## METRICHE DI SUCCESSO

| Metrica | Target Fase 1 | Target Fase 2 |
|---------|---------------|---------------|
| Task paralleli | 1 (sequenziale) | 3+ |
| Conflitti | 0 | 0 |
| Tempo risparmio | 20% | 50%+ |
| Errori coordinamento | 0 | 0 |

---

## RISCHI E MITIGAZIONI

| Rischio | Probabilità | Impatto | Mitigazione |
|---------|-------------|---------|-------------|
| Conflitti file | Media | Alto | Zone strict + review |
| Subagent confusi | Bassa | Medio | Prompt chiari |
| Merge problematici | Media | Alto | Merge incrementali |
| Overhead coordinamento | Bassa | Basso | Automazione script |

---

## CONCLUSIONE

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║   CervellaSwarm v1.0 = Subagent + Worktrees                   ║
║                                                                ║
║   Semplice. Potente. Scalabile.                               ║
║                                                                ║
║   "Non il più complesso. Il più EFFICACE."                    ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

*Documento approvato. Pronti per implementazione.* 🐝🏗️

**Cervella & Rafa** 💙
