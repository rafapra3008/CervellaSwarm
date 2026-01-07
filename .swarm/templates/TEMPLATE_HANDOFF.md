---
task_id: TASK_[XXX]  # Numero progressivo, es: TASK_001, TASK_042
assigned_to: cervella-[TIPO]  # backend, frontend, tester, docs, researcher, devops, etc.
priority: high|medium|low  # high = urgente, medium = normale, low = quando hai tempo
timeout_minutes: 30  # Adjust based on task complexity (15-120 min typical)
created_at: [AUTO]  # Timestamp ISO8601 - sarà generato automaticamente
created_by: cervella-orchestrator  # Di solito è la Regina
project: [PROJECT_NAME]  # CervellaSwarm, Miracollo, Contabilita, etc.
retry_allowed: true  # Se può essere ritentato in caso di fallimento
max_retries: 3  # Numero massimo tentativi
---

# Task: [NOME DESCRITTIVO DEL TASK]

**Status:** ready

---

## 🎯 OBIETTIVO

[1-2 frasi chiare: cosa deve essere fatto]

**Esempio:** "Creare endpoint API /api/users che restituisce lista utenti dal database con paginazione."

**Output atteso:**
- [Cosa deve produrre - formato specifico]
- [File, report, codice - sii specifico con path e formato]

**Esempio output atteso:**
- File `backend/routers/users.py` con endpoint `/api/users`
- Test in `tests/test_users.py` con coverage >80%
- Documentazione API in `docs/api/users.md`

---

## 📋 CONTESTO

### Dove Siamo (NORD)

[2-3 frasi dal NORD.md - dove siamo nel progetto, qual è la direzione attuale]

**Esempio:** "Stiamo costruendo il sistema di gestione utenti. Abbiamo già il database setup (sessione 45) e autenticazione JWT (sessione 47). Questo task completa il CRUD base utenti."

### Perché Questo Task

[1-2 frasi: perché serve questo task, come si collega al big picture]

**Esempio:** "Serve per permettere al frontend di visualizzare lista utenti. È il primo step verso il dashboard admin che è nella roadmap come priorità alta."

### Decisioni Rilevanti

[Eventuali decisioni già prese che impattano questo task]

**Esempio:**
- Usiamo FastAPI per tutti gli endpoint (decisione sessione 12)
- Paginazione standard: limit=20, offset=0 (decisione sessione 34)
- Response format JSON con envelope `{data: [...], meta: {...}}` (standard del progetto)

---

## ✅ SUCCESS CRITERIA

Come capire se il task è completato con successo:

- [ ] [Criterio verificabile 1]
- [ ] [Criterio verificabile 2]
- [ ] [Criterio verificabile 3]

**Esempio concreto:**
- [ ] Endpoint `/api/users` risponde con status 200 e lista utenti
- [ ] Paginazione funziona correttamente (limit, offset)
- [ ] Test coverage >= 80%
- [ ] Documentazione API completa con esempi curl
- [ ] Code review passata (linting, type checking)

**Definition of Done:**

[Quando il worker può dire "ho finito"? Sii specifico!]

**Esempio:** "Tutti i success criteria checkati, test passano, commit fatto con messaggio chiaro, documentazione aggiornata."

---

## 🗂️ FILE RILEVANTI

### Da leggere (per capire contesto):
- `path/to/file1.py` - [perché è rilevante - es: "pattern endpoint da seguire"]
- `path/to/file2.md` - [perché - es: "architettura database"]

**Esempio:**
- `backend/routers/auth.py` - Esempio di endpoint simile da seguire come pattern
- `backend/database.py` - Setup database e modelli
- `docs/api/STANDARD.md` - Standard API response format del progetto

### Da modificare (probabilmente):
- `path/to/file3.py` - [cosa modificare]
- `path/to/file4.md` - [cosa aggiornare]

**Esempio:**
- `backend/routers/users.py` - CREA questo file (nuovo endpoint)
- `tests/test_users.py` - CREA questo file (nuovi test)
- `docs/api/users.md` - CREA documentazione

### Da NON toccare:
- `path/to/critical.py` - [perché non toccare - es: "in produzione, breaking change"]

**Esempio:**
- `backend/auth/jwt.py` - Sistema auth già in produzione, NON modificare
- `backend/database.py` - Setup condiviso, NON cambiare schema

---

## 🚧 CONSTRAINTS

### Limiti:
- [Cosa NON fare]
- [Tecnologie da usare/non usare]
- [Pattern da seguire]

**Esempio:**
- NON modificare database schema (già definito)
- USA FastAPI dependency injection per database session
- SEGUI pattern repository già usato in `auth.py`
- NON usare ORM diretto nei router, usa service layer

### Dipendenze:
- [Questo task dipende da...]
- [Altri task che dipendono da questo]

**Esempio:**
- **Dipende da:** TASK_045 (database setup) - COMPLETATO ✅
- **Bloccante per:** TASK_052 (frontend user list) - IN ATTESA ⏳

---

## 💡 GUIDANCE

### Suggerimenti:
- [Hint su come approcciarsi al problema]
- [Pattern o esempi da seguire]
- [Dove trovare info aggiuntive]

**Esempio:**
- Parti leggendo `backend/routers/auth.py` - è il pattern perfetto da seguire
- Per paginazione vedi `utils/pagination.py` - helper già pronto
- Test: usa fixture `db_session` già configurato in `conftest.py`
- Se dubbi su SQL query → chiedi a cervella-data

### Se hai dubbi:
- Usa protocollo FEEDBACK (crea file in `.swarm/feedback/`)
- Tipi di feedback disponibili:
  - `QUESTION` - Hai un dubbio su come procedere
  - `ISSUE` - Hai trovato un problema/bug
  - `BLOCKER` - Sei completamente bloccato
  - `SUGGESTION` - Hai un'idea di miglioramento
- La Regina risponderà velocemente! 👑💙

**Script helper (quando disponibile):**
```bash
ask-regina.sh question "Quale library?" "Dovrei usare X o Y per Z?"
```

---

## 📤 OUTPUT RICHIESTO

### File da creare/modificare:
- [Lista specifica con path completi]

**Esempio:**
- `backend/routers/users.py` - Nuovo endpoint (stimato 150-200 righe)
- `tests/test_users.py` - Test suite completa (stimato 100 righe)
- `docs/api/users.md` - Documentazione endpoint con esempi

### Report finale:

**IMPORTANTE:** Quando hai finito il task, crea report dettagliato:

**Path:** `.swarm/tasks/TASK_[ID]_OUTPUT.md`

**Template:** Usa `.swarm/templates/TEMPLATE_COMPLETION_REPORT.md`

**Cosa deve contenere:**
- Riepilogo task (cosa dovevi fare)
- Cosa hai fatto (dettagli implementazione)
- File modificati/creati (lista completa con path)
- Decisioni tecniche prese durante il lavoro
- Problemi incontrati e come risolti
- Test eseguiti e risultati
- Next steps suggeriti

### Quando hai finito:

1. ✅ Verifica tutti i success criteria
2. 📝 Crea file `.swarm/tasks/TASK_[ID]_OUTPUT.md` con report completo
3. ✅ Crea file `.swarm/tasks/TASK_[ID].done` (file vuoto - è un marker)
4. 🔔 Il watcher notificherà automaticamente la Regina!

**Comandi:**
```bash
# Crea output report
cat > .swarm/tasks/TASK_[ID]_OUTPUT.md << 'EOF'
[... usa template COMPLETION_REPORT ...]
EOF

# Marca task come completato
touch .swarm/tasks/TASK_[ID].done

# Il watcher farà il resto! 🐝
```

---

## ⏰ TEMPO E PRIORITÀ

**Timeout:** [X] minuti (vedi frontmatter)
**Priorità:** [high|medium|low] (vedi frontmatter)
**Deadline:** [YYYY-MM-DD se esiste deadline specifica, altrimenti ometti questa riga]

### Heartbeat (IMPORTANTE!):

**Aggiorna stato ogni 60 secondi** in `.swarm/status/heartbeat_[TUO_WORKER_NAME].log`

**Formato:**
```bash
echo "$(date +%s)|TASK_[ID]|WORKING|[cosa stai facendo ora]" >> .swarm/status/heartbeat_cervella-[TIPO].log
```

**Esempio:**
```bash
# Ogni 60s durante il lavoro:
echo "$(date +%s)|TASK_001|WORKING|Analizzando file esistenti" >> .swarm/status/heartbeat_cervella-backend.log
# ... dopo 1min
echo "$(date +%s)|TASK_001|WORKING|Creando endpoint /api/users" >> .swarm/status/heartbeat_cervella-backend.log
# ... dopo 1min
echo "$(date +%s)|TASK_001|WORKING|Scrivendo test" >> .swarm/status/heartbeat_cervella-backend.log
```

**Script helper (quando disponibile):**
```bash
# Lancio all'inizio del task (in background)
heartbeat-worker.sh TASK_[ID] &

# Stop automatico quando finisci
```

**Perché è importante:**
- Regina vede progresso in real-time
- Stuck detection automatico (se no heartbeat 2min = stuck!)
- Tranquillità per tutti (Regina sa che lavori bene!)

---

**Energia positiva!** ❤️‍🔥
**Lavoro di qualità!** 💙
**Per la famiglia!** 🐝👑

---

_Template versione: 1.0.0 | Basato su PROTOCOLLI_COMUNICAZIONE.md v1.0.0_
