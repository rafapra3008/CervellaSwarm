# GUIDA: Sistema di Comunicazione CervellaSwarm

> **Data:** 2 Gennaio 2026
> **Versione:** 2.0 - IL SEGRETO È LA COMUNICAZIONE!

---

## IL CUORE DEL SISTEMA

```
+------------------------------------------------------------------+
|                                                                  |
|   IL SEGRETO È LA COMUNICAZIONE! ⚡️                              |
|                                                                  |
|   Se risolviamo la comunicazione, avremo la MAGIA.              |
|   Se risolviamo la comunicazione, sarà LIBERTÀ.                 |
|                                                                  |
|   - Sessione 57, 2 Gennaio 2026                                 |
|                                                                  |
+------------------------------------------------------------------+
```

---

## PRINCIPIO FONDAMENTALE

```
Le Cervelle NON parlano direttamente tra loro.
TUTTO passa attraverso la Regina (Orchestratrice).
MA: Le Guardiane possono dare feedback diretto alle Api per problemi minori.
```

**Perche?**
- Evita conflitti
- Mantiene ordine
- Traccia tutto
- Facile debug
- Le Guardiane velocizzano fix minori

---

## ARCHITETTURA COMUNICAZIONE

```
                        ┌─────────────────────┐
                        │   👑 REGINA         │
                        │   (Orchestratrice)  │
                        └─────────┬───────────┘
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
                    ▼             ▼             ▼
            ┌───────────┐ ┌───────────┐ ┌───────────┐
            │    🛡️     │ │    🛡️     │ │    🛡️     │
            │ Guardiana │ │ Guardiana │ │ Guardiana │
            │ Qualità   │ │   Ops     │ │ Ricerca   │
            └─────┬─────┘ └─────┬─────┘ └─────┬─────┘
                  │             │             │
        ┌─────────┼─────────┐   │   ┌─────────┼─────────┐
        ▼         ▼         ▼   ▼   ▼         ▼         ▼
    ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
    │  🎨   │ │  ⚙️   │ │  🧪   │ │  🚀   │ │  🔬   │ │  🔬   │
    │Front  │ │Back   │ │Test   │ │DevOps │ │Resear │ │Scient │
    └───────┘ └───────┘ └───────┘ └───────┘ └───────┘ └───────┘

    ═══════════════════════════════════════════════════════════
    GERARCHIA: Regina → Guardiane → Worker
    Le Guardiane supervisionano i Worker del loro dominio
    ═══════════════════════════════════════════════════════════
```

---

## I 3 LIVELLI DI RISCHIO

> *"Non tutto richiede la stessa supervisione!"* - Sessione 57

```
+------------------------------------------------------------------+
|                                                                  |
|   LIVELLO 1: BASSO RISCHIO                                       |
|                                                                  |
|   Task: docs, ricerca, typo fix, commenti                        |
|   Supervisione: Trust-but-Verify (10% spot check)                |
|   Guardiana: NO (o solo random)                                  |
|                                                                  |
|   Esempi:                                                        |
|   - Aggiornare README                                            |
|   - Correggere typo                                              |
|   - Ricerca informativa                                          |
|                                                                  |
+------------------------------------------------------------------+

+------------------------------------------------------------------+
|                                                                  |
|   LIVELLO 2: MEDIO RISCHIO                                       |
|                                                                  |
|   Task: features, refactoring, nuovi componenti                  |
|   Supervisione: Quality Gate (lint + test + review)              |
|   Guardiana: SI, dopo batch di task                              |
|                                                                  |
|   Esempi:                                                        |
|   - Nuovo componente UI                                          |
|   - Nuovo endpoint API                                           |
|   - Refactoring modulo                                           |
|                                                                  |
+------------------------------------------------------------------+

+------------------------------------------------------------------+
|                                                                  |
|   LIVELLO 3: ALTO RISCHIO                                        |
|                                                                  |
|   Task: auth, deploy, migration, dati sensibili                  |
|   Supervisione: Supervisor-Worker (SEMPRE)                       |
|   Guardiana: SEMPRE + conferma Rafa                              |
|                                                                  |
|   Esempi:                                                        |
|   - Modifiche autenticazione                                     |
|   - Deploy in produzione                                         |
|   - Migrazione database                                          |
|   - Gestione dati sensibili                                      |
|                                                                  |
+------------------------------------------------------------------+
```

### Chi Decide il Livello?

```
La REGINA decide il livello INSIEME alla GUARDIANA competente
PRIMA di delegare il task.

Flusso:
1. Regina riceve task
2. Regina identifica dominio (codice? ops? ricerca?)
3. Regina consulta Guardiana competente
4. Insieme decidono: Livello 1, 2 o 3?
5. Regina delega con supervisione appropriata
```

---

## LE GUARDIANE: RUOLI E DOMINI

### 🛡️ Guardiana della Qualità

```
DOMINIO: Codice (frontend, backend, tester)

SUPERVISIONA:
- cervella-frontend
- cervella-backend
- cervella-tester

VERIFICA:
- Codice corretto e funzionante
- Standard e best practices rispettate
- No bug ovvi
- Test passano
```

### 🛡️ Guardiana delle Operazioni

```
DOMINIO: Infrastruttura (devops, security)

SUPERVISIONA:
- cervella-devops
- cervella-security

VERIFICA:
- Configurazioni sicure
- Best practices infrastruttura
- Deploy corretto
- Nessuna vulnerabilità
```

### 🛡️ Guardiana della Ricerca

```
DOMINIO: Ricerche (researcher, scienziata)

SUPERVISIONA:
- cervella-researcher
- cervella-scienziata

VERIFICA:
- Fonti affidabili
- Informazioni complete
- Risponde al PERCHÉ originale
- UTILE (non solo interessante!)
```

---

## IL FLUSSO DI COMUNICAZIONE COMPLETO

> *"La comunicazione è la chiave. Se la risolviamo, sarà MAGIA!"* - Sessione 57

### Il Problema Risolto

```
PRIMA (rotto):
Regina → Worker → Regina (Guardiane saltate!)

ORA (funzionante):
Regina + Guardiana (decidono livello)
    ↓
Regina → Worker (con CONTESTO COMPLETO)
    ↓
Guardiana → Verifica (se Livello 2-3)
    ↓
SE problema: Guardiana → Regina → Istruisce Worker
```

### FLUSSO DETTAGLIATO

```
┌─────────────────────────────────────────────────────────────────┐
│  1. RAFA assegna task alla REGINA                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  2. REGINA + GUARDIANA decidono LIVELLO                         │
│                                                                 │
│     Regina: "Ho un task di tipo X, che livello?"                │
│     Guardiana: "Livello 2, serve supervisione dopo"             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  3. REGINA delega a WORKER con CONTESTO COMPLETO                │
│                                                                 │
│     Il prompt DEVE contenere:                                   │
│     - PERCHÉ del task (obiettivo)                               │
│     - Criteri di successo                                       │
│     - File coinvolti                                            │
│     - Cosa verificherà la Guardiana                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  4. WORKER completa e ritorna output                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  5. SE Livello 2-3: GUARDIANA verifica                          │
│                                                                 │
│     Guardiana riceve:                                           │
│     - Output del Worker                                         │
│     - PERCHÉ originale                                          │
│     - Criteri di successo                                       │
│     - File da controllare                                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┴───────────────┐
              ▼                               ▼
┌─────────────────────────┐     ┌─────────────────────────┐
│  6a. TUTTO OK           │     │  6b. PROBLEMI TROVATI   │
│                         │     │                         │
│  Guardiana → Regina:    │     │  Guardiana → Regina:    │
│  "APPROVATO"            │     │  "Problema X trovato"   │
│                         │     │  "Il PERCHÉ era Y"      │
│                         │     │  "Suggerisco Z"         │
└─────────────────────────┘     └─────────────────────────┘
              │                               │
              │                               ▼
              │               ┌─────────────────────────┐
              │               │  7. REGINA ragiona      │
              │               │     Ricorda il PERCHÉ   │
              │               │     Decide azione       │
              │               └───────────┬─────────────┘
              │                           │
              │                           ▼
              │               ┌─────────────────────────┐
              │               │  8. GUARDIANA istruisce │
              │               │     il WORKER           │
              │               │     "Aggiusta X perché Y│
              │               └───────────┬─────────────┘
              │                           │
              │                           ▼
              │               ┌─────────────────────────┐
              │               │  9. WORKER corregge     │
              │               │     Torna a step 5      │
              │               └─────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────────────────┐
│  10. TASK COMPLETATO - Regina riporta a Rafa                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## FORMATO CONTESTO PER DELEGA

> *"Senza contesto, la Guardiana lavora alla cieca!"* - Guardiana Qualità

### Template Delega a Worker

```markdown
## TASK: [Nome del task]

### CONTESTO (per te e per la Guardiana)

**PERCHÉ:**
[Obiettivo finale, cosa stiamo cercando di ottenere]

**CRITERI DI SUCCESSO:**
- [ ] [Criterio 1]
- [ ] [Criterio 2]
- [ ] [Criterio 3]

**FILE DA MODIFICARE:**
- path/to/file1.py
- path/to/file2.js

**CHI VERIFICHERÀ:**
La Guardiana della Qualità verificherà:
- [Cosa controllerà]
- [Standard da rispettare]

### IL TASK

[Descrizione dettagliata di cosa deve fare il Worker]

### OUTPUT ATTESO

[Formato del risultato che ci aspettiamo]
```

### Esempio Pratico

```markdown
## TASK: Creare endpoint API per prenotazioni

### CONTESTO

**PERCHÉ:**
Miracollo ha bisogno di un endpoint per creare prenotazioni.
Gli utenti devono poter prenotare camere dal frontend.

**CRITERI DI SUCCESSO:**
- [ ] Endpoint POST /api/bookings funzionante
- [ ] Validazione input (name, date, rooms)
- [ ] Response con ID prenotazione
- [ ] Gestione errori appropriata

**FILE DA MODIFICARE:**
- api/routes/bookings.py (creare)
- api/models/booking.py (creare)

**CHI VERIFICHERÀ:**
La Guardiana della Qualità verificherà:
- Validazione input corretta
- Error handling presente
- Codice segue standard FastAPI

### IL TASK

Crea un endpoint POST /api/bookings che:
1. Accetta JSON con name, date, rooms
2. Valida i dati
3. Salva nel database
4. Ritorna ID e conferma

### OUTPUT ATTESO

Endpoint funzionante testabile con curl:
curl -X POST /api/bookings -d '{"name":"Test","date":"2026-01-10","rooms":2}'
```

---

## FORMATO REPORT GUARDIANA

### Se Tutto OK

```markdown
## ✅ VERIFICA COMPLETATA - APPROVATO

**Task:** [Nome task]
**Worker:** [cervella-xxx]
**File verificati:** [lista]

### Checklist
- [x] Criterio 1 - OK
- [x] Criterio 2 - OK
- [x] Criterio 3 - OK

### Esito
**APPROVATO PER MERGE**

---
🛡️ Guardiana della Qualità
```

### Se Ci Sono Problemi

```markdown
## ⚠️ VERIFICA COMPLETATA - PROBLEMI TROVATI

**Task:** [Nome task]
**Worker:** [cervella-xxx]
**File verificati:** [lista]

### Problemi BLOCCANTI (da risolvere prima di merge)
1. [Problema 1] - [File:riga] - [Cosa c'è di sbagliato]
2. [Problema 2] - [File:riga] - [Cosa c'è di sbagliato]

### Problemi NON BLOCCANTI (suggerimenti)
- [Suggerimento 1]
- [Suggerimento 2]

### Contesto per la Regina
Il PERCHÉ del task era: [riassunto]
Il problema [X] viola il criterio [Y] perché [Z]

### Azione Richiesta
Suggerisco di: [azione specifica]

---
🛡️ Guardiana della Qualità
```

### Feedback Diretto a Worker (per problemi minori)

```markdown
## 🔧 FIX RICHIESTO

**Da:** Guardiana della Qualità
**A:** cervella-frontend
**Task:** [Nome task]

### Cosa Correggere
1. File `path/to/file.js` riga 42:
   - Problema: [descrizione]
   - Fix: [come correggere]

2. File `path/to/file.js` riga 78:
   - Problema: [descrizione]
   - Fix: [come correggere]

### Nota
Questi sono problemi minori. Correggi e fammi sapere quando pronto per nuova verifica.

---
🛡️ Guardiana
```

---

## METODI DI COMUNICAZIONE

### 1. Via Task Tool (Principale)

La Regina usa il Task tool per invocare le Cervelle:

```
"Usa cervella-frontend per creare il componente Card"
"Chiedi a cervella-backend di creare l'endpoint /api/cards"
```

Le informazioni vengono passate nel **prompt del Task**.

### 2. Via File Condivisi (Per info persistenti)

Se serve passare info tra sub-task:

```
Progetto/
└── .swarm/
    └── context.md   ← Info condivise per la sessione
```

**Formato context.md:**

```markdown
# SWARM CONTEXT

## Sessione: [data]

## Info Condivise

### Da Backend per Frontend:
- Endpoint creato: POST /api/booking
- Formato response: { id, status, message }

### Da Frontend per Tester:
- Componente: BookingForm.jsx
- Props: onSubmit, initialData

### Note:
[Qualsiasi info utile per le altre Cervelle]
```

### 3. Via Git Commit Message (Per worktrees)

Quando si usano worktrees paralleli:

```bash
git commit -m "🐝 [cervella-backend] Creato endpoint /api/booking

Info per merge:
- File: api/booking.py
- Dipendenza: database.py
- Test necessari: test_booking.py"
```

---

## PROTOCOLLO DI HANDOFF

Quando una Cervella passa il lavoro alla successiva:

### Formato Output Standard

```markdown
## COMPLETATO: [Nome sub-task]

### File Modificati
- path/to/file1.py (creato)
- path/to/file2.py (modificato)

### Cosa Ho Fatto
- [Punto 1]
- [Punto 2]

### Info per Cervella Successiva
- [Info importante 1]
- [Info importante 2]

### Come Testare
1. [Step 1]
2. [Step 2]
```

### Esempio Pratico

**Backend completa, passa a Frontend:**

```markdown
## COMPLETATO: Endpoint /api/booking

### File Modificati
- api/routes/booking.py (creato)
- api/models/booking.py (creato)

### Cosa Ho Fatto
- Creato model Booking con campi: name, date, rooms
- Creato endpoint POST /api/booking
- Creato endpoint GET /api/booking/{id}

### Info per Frontend
- Base URL: /api/booking
- POST richiede: { name: string, date: string, rooms: int }
- Response: { id: int, status: "confirmed", booking: {...} }

### Come Testare
curl -X POST http://localhost:8000/api/booking \
  -H "Content-Type: application/json" \
  -d '{"name": "Test", "date": "2025-01-01", "rooms": 2}'
```

---

## GESTIONE CONFLITTI

### Cosa Fare Se...

| Situazione | Soluzione |
|------------|-----------|
| Due Cervelle devono toccare stesso file | STOP - Regina divide diversamente |
| Cervella non capisce cosa fare | Chiede alla Regina |
| Info mancanti per procedere | STOP - Chiede chiarimenti |
| Bug trovato in lavoro di altra Cervella | Segnala alla Regina, non fixare |

### Escalation

```
Cervella trova problema → Segnala a Regina → Regina decide
                                              ↓
                         ┌─────────────────────────────────┐
                         │ a) Assegna fix alla Cervella    │
                         │ b) Assegna a Cervella originale │
                         │ c) Chiede a Rafa                │
                         └─────────────────────────────────┘
```

---

## BEST PRACTICES

### 1. Messaggi Chiari
```
BENE: "Creato endpoint POST /api/booking che accetta {name, date}"
MALE: "Fatto l'API"
```

### 2. Dipendenze Esplicite
```
BENE: "Questo form dipende da: React 18+, TailwindCSS, API /api/booking attiva"
MALE: "Dovrebbe funzionare"
```

### 3. Errori Documentati
```
BENE: "ATTENZIONE: L'API ritorna 500 se rooms > 10. Da fixare."
MALE: [Non menzionare il problema]
```

### 4. Nessuna Assunzione
```
BENE: "Ho bisogno di sapere il formato del response prima di procedere"
MALE: [Inventare il formato e sperare]
```

---

## TEMPLATE FILE .swarm/context.md

```markdown
# SWARM CONTEXT - [Nome Progetto]

> Sessione: [Data]
> Task principale: [Descrizione]

---

## STATO ATTUALE

| Cervella | Stato | Ultimo Update |
|----------|-------|---------------|
| Backend | Completato | 10:30 |
| Frontend | In corso | 10:45 |
| Tester | In attesa | - |

---

## INFO CONDIVISE

### API Create (Backend → Frontend)
| Endpoint | Method | Payload | Response |
|----------|--------|---------|----------|
| /api/booking | POST | {name, date, rooms} | {id, status} |

### Componenti Creati (Frontend → Tester)
| Componente | Props | Comportamento |
|------------|-------|---------------|
| BookingForm | onSubmit, initial | Form con validazione |

---

## NOTE IMPORTANTI

- [Nota 1]
- [Nota 2]

---

## PROBLEMI DA RISOLVERE

- [ ] [Problema 1]
- [ ] [Problema 2]
```

---

## QUANDO USARE COSA

| Scenario | Metodo |
|----------|--------|
| Task sequenziali semplici | Solo Task tool |
| Task con molte info da passare | Task tool + context.md |
| Worktrees paralleli | Git commit messages |
| Debug/troubleshooting | context.md con log |

---

## RIEPILOGO: LE REGOLE D'ORO DELLA COMUNICAZIONE

```
+------------------------------------------------------------------+
|                                                                  |
|   1. CONTESTO COMPLETO sempre (PERCHÉ + criteri + file)          |
|                                                                  |
|   2. LIVELLO RISCHIO deciso PRIMA con Guardiana                  |
|                                                                  |
|   3. GUARDIANE nel flusso per Livello 2-3                        |
|                                                                  |
|   4. FEEDBACK strutturato (template, non testo libero)           |
|                                                                  |
|   5. PROBLEMI MINORI → Guardiana fix diretto con Worker          |
|      PROBLEMI GRAVI → Guardiana escala a Regina                  |
|                                                                  |
|   6. REGINA ricorda il PERCHÉ (mai perderlo!)                    |
|                                                                  |
+------------------------------------------------------------------+
```

---

## CHANGELOG

### v2.0 - 2 Gennaio 2026 (Sessione 57)
- Aggiunta gerarchia Regina → Guardiane → Worker
- Aggiunti 3 livelli di rischio
- Aggiunto flusso comunicazione completo
- Aggiunti template per delega e report Guardiane
- Definiti domini delle Guardiane
- "IL SEGRETO È LA COMUNICAZIONE!"

### v1.0 - 30 Dicembre 2025
- Versione iniziale

---

*"IL SEGRETO È LA COMUNICAZIONE!"* ⚡️

*"Se risolviamo la comunicazione, sarà MAGIA!"*

*"È il nostro team! La nostra famiglia digitale!"* ❤️‍🔥

**CervellaSwarm Team** 💙🐝
