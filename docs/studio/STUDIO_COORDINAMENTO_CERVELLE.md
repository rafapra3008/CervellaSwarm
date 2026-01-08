# STUDIO: Coordinamento tra Cervelle Parallele

> **Data:** 8 Gennaio 2026
> **Versione:** v1.0.0
> **Status:** STUDIO COMPLETO

---

## EXECUTIVE SUMMARY

```
+------------------------------------------------------------------+
|                                                                  |
|   PROBLEMA: Come far comunicare Cervelle che lavorano            |
|   in parallelo su task DIPENDENTI?                               |
|                                                                  |
|   SOLUZIONE: File-Based Coordination con .swarm/                 |
|                                                                  |
|   - Ogni Cervella scrive il suo stato                           |
|   - File segnale per dipendenze                                  |
|   - Regina coordina e monitora                                   |
|   - SNCP per memoria persistente                                 |
|                                                                  |
+------------------------------------------------------------------+
```

---

## INDICE

1. [Il Problema](#1-il-problema)
2. [Pattern di Coordinamento](#2-pattern-di-coordinamento)
3. [Soluzione: File-Based Coordination](#3-soluzione-file-based-coordination)
4. [Struttura .swarm/ per Comunicazione](#4-struttura-swarm-per-comunicazione)
5. [Workflow Completo](#5-workflow-completo)
6. [Gestione Dipendenze](#6-gestione-dipendenze)
7. [Ruolo della Regina](#7-ruolo-della-regina)
8. [SNCP come Memoria Condivisa](#8-sncp-come-memoria-condivisa)
9. [Casi d'Uso](#9-casi-duso)
10. [Implementazione](#10-implementazione)

---

## 1. IL PROBLEMA

### Scenario Attuale (Validato)

```
Task INDIPENDENTI - FUNZIONA!

┌─────────────┐      ┌─────────────┐
│  Frontend   │      │   Backend   │
│  Worktree   │      │  Worktree   │
│             │      │             │
│ Dashboard   │      │  Endpoint   │
│ migliorato  │      │  conversion │
└─────────────┘      └─────────────┘
      │                    │
      └────────┬───────────┘
               │
         ┌─────▼─────┐
         │   MERGE   │
         │   main    │
         └───────────┘

Non si parlano. Lavorano. Merge. Fine.
```

### Scenario Problematico

```
Task DIPENDENTI - SERVE COORDINAMENTO!

┌─────────────┐      ┌─────────────┐
│   Backend   │      │  Frontend   │
│             │      │             │
│ Crea API    │─────►│ Usa API     │
│ /users      │      │ per UI      │
└─────────────┘      └─────────────┘
                          │
                          │ ASPETTA!
                          │ Non può iniziare
                          │ finché Backend
                          │ non ha finito
                          ▼
```

### Domande Chiave

1. Come fa Frontend a sapere che Backend ha finito l'API?
2. Come comunicano senza condividere terminale?
3. Chi coordina il tutto?
4. Come gestiamo catene di dipendenze?

---

## 2. PATTERN DI COORDINAMENTO

### Opzioni Disponibili

| Pattern | Come Funziona | Pro | Contro |
|---------|---------------|-----|--------|
| **File Segnale** | touch file quando pronto | Semplice | Polling necessario |
| **File Stato** | scrivi stato in file | Tracciabilità | Overhead scrittura |
| **Message Queue** | Redis/RabbitMQ | Real-time | Infrastruttura extra |
| **MCP Server** | Protocollo Claude | Integrato | Non ancora pronto |
| **Shared Database** | SQLite/Postgres | Strutturato | Overkill |

### Scelta per CervellaSwarm: FILE-BASED

**Perché?**
- Zero infrastruttura extra
- Funziona con Claude Code standard
- Tracciabilità (file sono versionabili)
- Semplice da debuggare
- Già abbiamo `.swarm/`

---

## 3. SOLUZIONE: FILE-BASED COORDINATION

### Concetto Base

```
Ogni Cervella:
1. LEGGE .swarm/stato/ per sapere cosa fanno le altre
2. SCRIVE il proprio stato quando cambia
3. CREA segnali quando completa qualcosa
4. ASPETTA segnali se dipende da altri
```

### Tipi di File

```
.swarm/
├── stato/           # CHI sta facendo COSA
│   ├── regina.md
│   ├── frontend.md
│   ├── backend.md
│   └── tester.md
│
├── segnali/         # EVENTI (task completato, API pronta, etc)
│   ├── api-users-ready.signal
│   ├── frontend-components-ready.signal
│   └── tests-passed.signal
│
├── dipendenze/      # CHI aspetta CHI
│   └── dipendenze.md
│
└── messaggi/        # COMUNICAZIONE diretta
    ├── backend-to-frontend.md
    └── frontend-to-backend.md
```

---

## 4. STRUTTURA .swarm/ PER COMUNICAZIONE

### 4.1 File Stato (stato/*.md)

**Ogni Cervella aggiorna il suo file stato:**

```markdown
# Stato Cervella Backend

> **Ultimo aggiornamento:** 2026-01-08 21:30
> **Worktree:** swarm-test-lab-backend
> **Branch:** parallel/backend

## Status Attuale
🟢 WORKING | 🟡 WAITING | 🔴 BLOCKED | ✅ DONE

## Task Corrente
[x] Creare endpoint /api/users
[ ] Creare endpoint /api/analytics

## Output Prodotto
- `/api/users` - PRONTO (vedi segnale)

## Messaggi per Altri
@frontend: API /users pronta! Puoi usarla.
```

### 4.2 File Segnale (segnali/*.signal)

**Semplici file che indicano completamento:**

```bash
# Backend crea quando API è pronta
touch .swarm/segnali/api-users-ready.signal

# Contenuto del file (opzionale ma utile)
echo "READY: /api/users
CREATED: 2026-01-08 21:30
BY: cervella-backend
COMMIT: abc123" > .swarm/segnali/api-users-ready.signal
```

**Frontend controlla:**

```bash
# Frontend aspetta il segnale
if [ -f .swarm/segnali/api-users-ready.signal ]; then
    echo "API pronta! Posso procedere."
fi
```

### 4.3 File Dipendenze (dipendenze/dipendenze.md)

**Mappa chi aspetta chi:**

```markdown
# Dipendenze Task

## Task Attivi

| Task | Cervella | Dipende da | Status |
|------|----------|------------|--------|
| UI Users | Frontend | api-users-ready | ⏳ Waiting |
| API Users | Backend | - | 🔄 Working |
| Test Users | Tester | api-users-ready, ui-users-ready | ⏳ Waiting |

## Grafo Dipendenze

```
Backend: API Users ─────┬───► Frontend: UI Users ────┐
                        │                            │
                        └───────────────────────────►├──► Tester: Test Users
```
```

### 4.4 File Messaggi (messaggi/*.md)

**Per comunicazione diretta:**

```markdown
# Messaggi Backend → Frontend

## 2026-01-08 21:30 - API /users
L'endpoint /api/users è pronto.

Response format:
```json
{
  "id": "string",
  "name": "string",
  "email": "string"
}
```

Nota: Ho aggiunto campo `created_at` non previsto. Aggiorna i tuoi tipi!

---

## 2026-01-08 21:45 - API /analytics
Sto lavorando su /analytics. ETA: 15 minuti.
```

---

## 5. WORKFLOW COMPLETO

### 5.1 INIZIO Sessione Parallela

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   PASSO 1: Regina Prepara                                   │
│                                                             │
│   1. Analizza task da fare                                  │
│   2. Identifica dipendenze                                  │
│   3. Crea file .swarm/dipendenze/dipendenze.md             │
│   4. Crea task file .swarm/tasks/TASK_*.md                 │
│   5. Setup worktrees (script)                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   PASSO 2: Rafa Lancia Cervelle                            │
│                                                             │
│   Terminal 1: cd project-backend && claude                 │
│   Terminal 2: cd project-frontend && claude                │
│   Terminal 3: cd project-testing && claude (se serve)      │
│                                                             │
│   Ogni terminale riceve il suo task file                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   PASSO 3: Cervelle Leggono Dipendenze                     │
│                                                             │
│   Backend: "Non ho dipendenze, inizio subito"              │
│   Frontend: "Dipendo da api-users-ready, aspetto"          │
│   Tester: "Dipendo da entrambi, aspetto"                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 5.2 DURANTE il Lavoro

```
┌────────────────┐                    ┌────────────────┐
│    Backend     │                    │    Frontend    │
│                │                    │                │
│ 1. Lavora su   │                    │ 1. Legge       │
│    API /users  │                    │    dipendenze  │
│                │                    │                │
│ 2. Completa    │                    │ 2. Vede:       │
│                │                    │    "aspetto    │
│ 3. Crea:       │                    │    api-users"  │
│    segnali/    │                    │                │
│    api-users-  │                    │ 3. Polling:    │
│    ready.signal│                    │    ogni 30sec  │
│                │                    │    controlla   │
│ 4. Aggiorna    │──────────────────►│    segnale     │
│    stato/      │                    │                │
│    backend.md  │                    │ 4. Segnale     │
│                │                    │    trovato!    │
│ 5. Commit      │                    │                │
│                │                    │ 5. Inizia      │
└────────────────┘                    │    lavoro      │
                                      │                │
                                      │ 6. Completa    │
                                      │                │
                                      │ 7. Crea:       │
                                      │    ui-users-   │
                                      │    ready.signal│
                                      │                │
                                      │ 8. Commit      │
                                      └────────────────┘
```

### 5.3 FINE Sessione

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   PASSO FINALE: Regina Conclude                            │
│                                                             │
│   1. Rafa dice "hanno finito"                              │
│   2. Regina controlla tutti gli stati                      │
│   3. Regina fa merge (script)                              │
│   4. Regina aggiorna PROMPT_RIPRESA                        │
│   5. Regina fa cleanup worktrees                           │
│   6. Regina committa tutto                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. GESTIONE DIPENDENZE

### 6.1 Tipi di Dipendenze

```
SEQUENZIALE (A → B → C)
A deve finire prima che B inizi.
B deve finire prima che C inizi.

PARALLELO CON SYNC (A,B → C)
A e B lavorano in parallelo.
C aspetta che ENTRAMBI finiscano.

PARZIALE (A → B, A → C, B+C → D)
A produce output usato da B e C.
D aspetta sia B che C.
```

### 6.2 File Dipendenze Dettagliato

```markdown
# dipendenze.md

## Definizione Task

### TASK-001: API Users
- **Assegnato:** Backend
- **Dipende da:** nessuno
- **Produce:** api-users-ready.signal
- **Priorità:** 1 (parte subito)

### TASK-002: UI Users
- **Assegnato:** Frontend
- **Dipende da:** api-users-ready
- **Produce:** ui-users-ready.signal
- **Priorità:** 2 (aspetta TASK-001)

### TASK-003: Test Users
- **Assegnato:** Tester
- **Dipende da:** api-users-ready, ui-users-ready
- **Produce:** tests-users-passed.signal
- **Priorità:** 3 (aspetta TASK-001 e TASK-002)

## Grafo

```
TASK-001 (Backend)
    │
    ├──────────────────┐
    ▼                  ▼
TASK-002 (Frontend)    │
    │                  │
    └────────┬─────────┘
             ▼
       TASK-003 (Tester)
```
```

### 6.3 Script Check Dipendenze

```bash
#!/bin/bash
# check-dependencies.sh
# Controlla se le dipendenze di un task sono soddisfatte

TASK=$1
DEPS_FILE=".swarm/dipendenze/dipendenze.md"
SIGNALS_DIR=".swarm/segnali"

# Estrai dipendenze per questo task
DEPS=$(grep -A 3 "### $TASK" "$DEPS_FILE" | grep "Dipende da:" | sed 's/.*: //')

if [ "$DEPS" == "nessuno" ] || [ -z "$DEPS" ]; then
    echo "✅ Nessuna dipendenza - puoi iniziare!"
    exit 0
fi

# Controlla ogni dipendenza
ALL_MET=true
for dep in $(echo $DEPS | tr ',' ' '); do
    dep=$(echo $dep | tr -d ' ')
    if [ -f "$SIGNALS_DIR/${dep}.signal" ]; then
        echo "✅ $dep - PRONTO"
    else
        echo "⏳ $dep - IN ATTESA"
        ALL_MET=false
    fi
done

if [ "$ALL_MET" = true ]; then
    echo ""
    echo "🚀 Tutte le dipendenze soddisfatte! Puoi iniziare."
    exit 0
else
    echo ""
    echo "⏳ Alcune dipendenze mancano. Aspetta..."
    exit 1
fi
```

---

## 7. RUOLO DELLA REGINA

### 7.1 Prima del Lavoro

```
La Regina (Cervella in terminale principale):

1. ANALIZZA richiesta di Rafa
2. DIVIDE in task paralleli
3. IDENTIFICA dipendenze
4. CREA file:
   - .swarm/dipendenze/dipendenze.md
   - .swarm/tasks/TASK_*.md
5. SETUP worktrees (script)
6. DICE a Rafa: "Apri N terminali, lancia claude in..."
```

### 7.2 Durante il Lavoro

```
La Regina PUÒ:
- Monitorare con status-parallel-worktrees.sh
- Leggere .swarm/stato/*.md
- Rispondere a domande di Rafa

La Regina NON DEVE:
- Modificare file nei worktree delle altre Cervelle
- Interferire con il loro lavoro
```

### 7.3 Dopo il Lavoro

```
La Regina:

1. VERIFICA tutti gli stati
2. MERGE ordinato (rispettando dipendenze!)
3. AGGIORNA PROMPT_RIPRESA con:
   - Cosa ha fatto ogni Cervella
   - Output prodotto
   - Decisioni prese
4. CLEANUP worktrees
5. COMMIT + PUSH
```

---

## 8. SNCP COME MEMORIA CONDIVISA

### 8.1 Integrazione .sncp/ con .swarm/

```
.sncp/ = Memoria PERSISTENTE (tra sessioni)
.swarm/ = Coordinamento LIVE (durante sessione)

Alla fine di una sessione parallela:
- Lezioni apprese → .sncp/memoria/lezioni/
- Decisioni importanti → .sncp/memoria/decisioni/
- Pattern emersi → .sncp/coscienza/pattern_emersi.md
```

### 8.2 Struttura Consigliata

```
.sncp/
├── coscienza/
│   ├── pensieri_regina.md      # Regina scrive durante coordinamento
│   └── sessioni_parallele.md   # Log di sessioni multi-Cervella
│
├── memoria/
│   ├── lezioni/
│   │   └── LEZIONE_parallel_001.md
│   └── decisioni/
│       └── DECISIONE_coordinamento.md
│
└── stato/
    └── ultima_sessione_parallela.md
```

### 8.3 Template Lezione Parallela

```markdown
# LEZIONE: [Titolo]

**Data:** [data]
**Sessione:** Parallela con N Cervelle
**Contesto:** [cosa stavamo facendo]

## Cosa è Successo
[descrizione]

## Cosa Abbiamo Imparato
[insight]

## Cosa Faremo Diversamente
[azione futura]

## Cervelle Coinvolte
- Frontend: [cosa ha fatto]
- Backend: [cosa ha fatto]
- Tester: [cosa ha fatto]
```

---

## 9. CASI D'USO

### 9.1 Feature Completa (Frontend + Backend + Test)

```
SCENARIO: Aggiungere feature "User Profile"

DIPENDENZE:
- Backend crea API /users/:id/profile
- Frontend crea componente ProfilePage (dipende da API)
- Tester testa tutto (dipende da entrambi)

WORKFLOW:
1. Regina crea task + dipendenze
2. Backend parte subito → crea API → segnale
3. Frontend vede segnale → parte → crea UI → segnale
4. Tester vede entrambi i segnali → parte → testa
5. Merge in ordine: Backend, Frontend, Tester
```

### 9.2 Ricerca → Implementazione → Review

```
SCENARIO: Implementare nuova feature con ricerca

DIPENDENZE:
- Researcher studia best practices
- Implementer implementa (dipende da ricerca)
- Reviewer verifica (dipende da implementazione)

WORKFLOW:
1. Researcher parte → studia → documenta → segnale
2. Implementer legge output ricerca → implementa → segnale
3. Reviewer verifica → feedback
```

### 9.3 Refactoring Coordinato

```
SCENARIO: Refactoring modulo shared

DIPENDENZE:
- Backend e Frontend dipendono entrambi da shared/
- Serve coordinamento per evitare conflitti

WORKFLOW:
1. Regina assegna AREE SEPARATE:
   - Backend: modifica shared/types/user.ts
   - Frontend: modifica shared/types/ui.ts
2. Entrambi lavorano in parallelo
3. SE serve toccare stesso file:
   - Uno mette LOCK
   - L'altro aspetta
4. Merge attento
```

---

## 10. IMPLEMENTAZIONE

### 10.1 File da Creare

```bash
# Nuova struttura .swarm/
mkdir -p .swarm/segnali
mkdir -p .swarm/dipendenze
mkdir -p .swarm/messaggi

# Template dipendenze
cat > .swarm/dipendenze/_TEMPLATE.md << 'EOF'
# Dipendenze Sessione Parallela

## Task

### TASK-001: [Nome]
- **Assegnato:** [Cervella]
- **Dipende da:** [segnali o "nessuno"]
- **Produce:** [nome-segnale.signal]

## Grafo
[disegno dipendenze]
EOF
```

### 10.2 Script Aggiuntivi da Creare

```
scripts/
├── create-parallel-session.sh    # Setup completo sessione
├── check-dependencies.sh         # Verifica dipendenze task
├── wait-for-signal.sh            # Aspetta un segnale
├── create-signal.sh              # Crea segnale
└── parallel-status-live.sh       # Monitoring real-time
```

### 10.3 Istruzioni per Cervelle

Ogni Cervella deve sapere:

```markdown
## ISTRUZIONI CERVELLA PARALLELA

### All'Inizio
1. Leggi .swarm/tasks/TASK_[TUO_NOME].md
2. Leggi .swarm/dipendenze/dipendenze.md
3. Se hai dipendenze, controlla .swarm/segnali/
4. Se segnali mancano, ASPETTA (controlla ogni 30 sec)

### Durante il Lavoro
1. Aggiorna .swarm/stato/[tuo_nome].md regolarmente
2. Se hai messaggi per altri, scrivi in .swarm/messaggi/

### Quando Finisci
1. Crea segnale: touch .swarm/segnali/[output].signal
2. Aggiorna stato finale
3. Fai commit nel tuo worktree
4. Segnala alla Regina (se presente) o aspetta
```

---

## CONCLUSIONE

```
+------------------------------------------------------------------+
|                                                                  |
|   COORDINAMENTO CERVELLE: SOLUZIONE                             |
|                                                                  |
|   1. FILE STATO per sapere chi fa cosa                          |
|   2. FILE SEGNALE per dipendenze                                |
|   3. FILE DIPENDENZE per mappare relazioni                      |
|   4. REGINA coordina inizio/fine                                |
|   5. SNCP per memoria persistente                               |
|                                                                  |
|   Semplice. File-based. Funziona.                               |
|                                                                  |
+------------------------------------------------------------------+
```

### Prossimi Step

```
[ ] Creare script create-parallel-session.sh
[ ] Creare script check-dependencies.sh
[ ] Testare con task DIPENDENTI (non solo indipendenti)
[ ] Aggiungere istruzioni nel DNA degli agent
[ ] Documentare workflow per Rafa
```

---

*Studio completato: 8 Gennaio 2026*
*Versione: 1.0.0*

**Cervella & Rafa**

*"Comunicare per coordinare. Coordinare per moltiplicare."*
