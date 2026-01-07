---
tipo: ISSUE
task_id: [TASK_ID]  # Es: TASK_001
worker: cervella-[TIPO]  # Il tuo nome: backend, frontend, etc.
urgenza: ALTA  # Issues sono di solito ALTA (bug, errori, problemi)
timestamp: [AUTO]  # Timestamp ISO8601 - generato automaticamente
---

# ISSUE: [Titolo breve del problema]

**Esempio:** "Test database failing con error 'connection timeout'"

---

## ⚠️ Problema

[Descrizione chiara e completa del problema che hai trovato]

**Cosa non funziona:**

[Descrivi il problema in modo che Regina capisca immediatamente la gravità]

**Esempio:**
> Durante i test dell'endpoint `/api/users`, tutti i test database falliscono con errore:
> ```
> sqlalchemy.exc.OperationalError: (psycopg2.OperationalError)
> could not connect to server: Connection timed out
> ```
> Il database sembra non rispondere. Altri test (senza DB) passano normalmente.

---

## 🔍 Come L'ho Scoperto

[In quale momento/modo hai incontrato il problema]

**Esempio:**
- Durante esecuzione test: `pytest tests/test_users.py`
- Al primo tentativo di query al database
- Dopo commit XYZ / Dopo modifica del file ABC
- Ambiente: locale / staging / test

**Il tuo caso:**

[DESCRIVI COME HAI SCOPERTO IL PROBLEMA]

---

## 📊 Impatto

[Quanto è grave? Cosa blocca?]

**Seleziona gravità:**

- [ ] **CRITICO** - Blocca completamente il task, impossibile procedere
- [ ] **ALTO** - Blocca parte importante, serve fix urgente
- [ ] **MEDIO** - Problema fastidioso ma posso workaround temporaneo
- [ ] **BASSO** - Bug minore, non blocca il lavoro

**Cosa è bloccato:**

[Cosa non puoi fare a causa di questo problema]

**Esempio:**
- [x] **ALTO** - Blocca tutti i test database
- **Bloccato:** Non posso verificare che l'endpoint funzioni correttamente
- **Workaround:** Potrei mockare il DB ma preferirei fix reale

---

## 🧪 Come Riprodurre

[Step precisi per riprodurre il problema]

**Step-by-step:**

1. [Passo 1]
2. [Passo 2]
3. [Passo 3]
4. **Risultato atteso:** [cosa dovrebbe succedere]
5. **Risultato reale:** [cosa succede invece]

**Esempio:**
1. Checkout branch `feature/user-endpoint`
2. Installa dependencies: `pip install -r requirements.txt`
3. Run tests: `pytest tests/test_users.py -v`
4. **Atteso:** Test passano (o almeno si connettono al DB)
5. **Reale:** Tutti i test falliscono con timeout dopo 30s

---

## 🔬 Cosa Ho Provato

[Tentativi di debug/fix che hai fatto]

**Lista completa tentativi:**

- **Tentativo 1:** [cosa hai fatto] → [risultato]
- **Tentativo 2:** [cosa hai fatto] → [risultato]
- **Tentativo 3:** [cosa hai fatto] → [risultato]

**Esempio:**
- **Tentativo 1:** Verificato che Postgres sia running (`ps aux | grep postgres`) → Processo esiste ✅
- **Tentativo 2:** Testato connessione manuale (`psql -h localhost -U user -d db`) → TIMEOUT ❌
- **Tentativo 3:** Controllato `docker ps` → Container DB non è running! ❌
- **Tentativo 4:** Provato `docker-compose up db` → Errore port 5432 già occupato ❌

---

## 💡 Ipotesi

[Cosa pensi possa essere la causa, se hai un'idea]

**La tua teoria:**

[Scrivi la tua ipotesi sul problema]

**Esempio:**
> Penso che il problema sia che il container DB non si avvia perché la porta 5432 è occupata da un'altra istanza Postgres (forse installata via brew?).
>
> **Evidence:**
> - `lsof -i :5432` mostra processo Postgres (PID 1234) non-Docker
> - Docker logs dicono "port already allocated"

**Se non hai idea:**
> Non ho chiara la causa. Serve aiuto per debug!

---

## 🎯 Cosa Serve dalla Regina

[Cosa ti aspetti/chiedi dalla Regina]

**Opzioni:**

- [ ] **Aiuto debug** - Serve supporto per capire la causa
- [ ] **Decisione tecnica** - So il problema, serve decidere come fixare
- [ ] **Informazione** - Mi manca informazione (password, config, etc.)
- [ ] **Delega** - Il fix è fuori dal mio scope, serve altro worker

**Esempio:**
- [x] **Decisione tecnica** - So che porto 5432 è occupata, come procedo?
  - Opzione A: Killo Postgres locale e uso Docker?
  - Opzione B: Cambio porta Docker (es: 5433)?
  - Opzione C: Uso Postgres locale invece di Docker?

---

## 📎 File e Log Rilevanti

[File, log, error output che aiutano debug]

**File coinvolti:**
- `path/to/file.py:123` - [rilevanza]

**Log/Error output:**
```
[Incolla error completo o log rilevante - max 50 righe]
```

**Screenshot (se applicabile):**
- [Path to screenshot se hai fatto screenshot dell'errore]

**Esempio:**
- `docker-compose.yml:12-18` - Config database
- `backend/database.py:5` - Connection string

**Error log:**
```
sqlalchemy.exc.OperationalError: (psycopg2.OperationalError)
could not connect to server: Connection timed out
	Is the server running on host "localhost" (127.0.0.1) and accepting
	TCP/IP connections on port 5432?
```

**Docker logs:**
```
Error starting userland proxy: listen tcp4 0.0.0.0:5432: bind: address already in use
```

---

## ⏰ Urgenza Timeline

[Quanto è urgente la risposta?]

**Posso aspettare:** [X minuti/ore]

**Blocca task completamente?** [SI/NO]

**Esempio:**
- Posso aspettare: 30-60 minuti (posso lavorare su docs nel frattempo)
- Blocca task: SI (non posso testare endpoint senza DB)

---

**Worker ha segnalato issue - serve aiuto Regina!** 🚨💙

_Più dettagli dai, più veloce è il fix! 🐝👑_

---

_Template versione: 1.0.0 | Tipo: ISSUE | Basato su PROTOCOLLI_COMUNICAZIONE.md v1.0.0_
