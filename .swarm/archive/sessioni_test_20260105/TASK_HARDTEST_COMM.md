# TASK: HARDTEST Comunicazione Bidirezionale

**ID:** HARDTEST_COMM
**Assegnato a:** cervella-backend
**Priorità:** ALTA
**Tipo:** HARDTEST

---

## Obiettivo

Testare la comunicazione bidirezionale Worker → Regina.

## Cosa Devi Fare

1. **Leggi questo task** e conferma di averlo capito

2. **Scrivi un messaggio per la Regina** in `.swarm/handoff/`:
   - Crea file: `.swarm/handoff/MSG_FROM_BACKEND.md`
   - Contenuto: Un messaggio che conferma che hai ricevuto il task
   - Includi: timestamp, il tuo "nome" (cervella-backend), e un saluto

3. **Crea un file di output** semplice:
   - File: `test-orchestrazione/api/hardtest_comm.py`
   - Contenuto: Una funzione `ping()` che ritorna "pong from backend"

4. **Marca il task come .done**

## Criteri di Successo

- [ ] File MSG_FROM_BACKEND.md esiste in .swarm/handoff/
- [ ] Il messaggio contiene timestamp e saluto
- [ ] hardtest_comm.py esiste e ha la funzione ping()
- [ ] Task marcato come .done

## Note

Questo è un HARDTEST per verificare che la comunicazione funziona!
La Regina leggerà il tuo messaggio in .swarm/handoff/

---

**Creato:** 4 Gennaio 2026
**Da:** La Regina
