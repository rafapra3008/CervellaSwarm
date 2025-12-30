# GUIDA: Sistema di Comunicazione CervellaSwarm

> **Data:** 30 Dicembre 2025
> **Versione:** 1.0

---

## PRINCIPIO FONDAMENTALE

```
Le Cervelle NON parlano direttamente tra loro.
TUTTO passa attraverso la Regina (Orchestratrice).
```

**Perche?**
- Evita conflitti
- Mantiene ordine
- Traccia tutto
- Facile debug

---

## ARCHITETTURA COMUNICAZIONE

```
                    ┌─────────────────────┐
                    │  CERVELLA REGINA    │
                    │   (Orchestratrice)  │
                    └─────────┬───────────┘
                              │
           ┌──────────────────┼──────────────────┐
           │                  │                  │
           ▼                  ▼                  ▼
    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
    │  Frontend   │    │  Backend    │    │  Tester     │
    └─────────────┘    └─────────────┘    └─────────────┘

    ────────────────────────────────────────────────────
                     NESSUN CONTATTO DIRETTO
    ────────────────────────────────────────────────────
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

*"La comunicazione chiara e il segreto dello sciame efficiente."* 🐝📡

**CervellaSwarm Team** 💙
