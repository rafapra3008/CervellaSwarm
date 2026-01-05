# HARDTEST: Sistema Visibilita' v1.0

**Data:** 5 Gennaio 2026
**Obiettivo:** Verificare che FASE 1 Visibilita' funzioni correttamente

---

## COSA TESTIAMO

1. **Heartbeat** - Worker scrive stato ogni 60s
2. **Notifiche** - macOS notifica a inizio task
3. **swarm-heartbeat** - Comando mostra stato live
4. **Dashboard** - Sezione LIVE HEARTBEAT funziona
5. **Istruzioni Cugini** - I worker capiscono cosa fare

---

## TEST 1: Heartbeat Scritto

**Setup:**
```bash
# Pulisci heartbeat vecchi
rm -f .swarm/status/heartbeat_*.log

# Crea task semplice per backend
cat > .swarm/tasks/TASK_TEST_HB1.md << 'EOF'
# TASK: Test Heartbeat - Conta fino a 3

**Assegnato a:** cervella-backend
**Priorita:** TEST
**Stato:** ready

## Obiettivo

Questo e' un test del sistema heartbeat.
Devi:
1. Scrivere heartbeat "Inizio task"
2. Aspettare 30 secondi
3. Scrivere heartbeat "Meta' task"
4. Aspettare 30 secondi
5. Scrivere heartbeat "Fine task"
6. Completare

## Output
Scrivi "Test completato" in TASK_TEST_HB1_output.md
EOF

touch .swarm/tasks/TASK_TEST_HB1.ready
```

**Esecuzione:**
```bash
spawn-workers --backend
```

**Verifica (dopo 2 minuti):**
```bash
# Deve mostrare almeno 3 righe
cat .swarm/status/heartbeat_backend.log

# Deve mostrare ACTIVE
swarm-heartbeat
```

**Risultato Atteso:**
- [ ] heartbeat_backend.log contiene 3+ righe
- [ ] Formato corretto: timestamp|task|azione
- [ ] swarm-heartbeat mostra ACTIVE

---

## TEST 2: Notifica Inizio Task

**Setup:** Usa stesso task di TEST 1

**Verifica:**
- [ ] Notifica macOS "Inizio: TASK_TEST_HB1" appare
- [ ] Notifica macOS "Completato: TASK_TEST_HB1" appare con suono Glass

**Come verificare:**
Guarda Centro Notifiche macOS o aspetta banner.

---

## TEST 3: swarm-heartbeat Command

**Esecuzione:**
```bash
# Mentre worker lavora
swarm-heartbeat

# Watch mode
swarm-heartbeat --watch
```

**Risultato Atteso:**
- [ ] Mostra worker ACTIVE con colore verde
- [ ] Mostra azione corrente
- [ ] Mostra tempo trascorso
- [ ] --watch refresha ogni 2s

---

## TEST 4: Dashboard Heartbeat

**Esecuzione:**
```bash
# Mentre worker lavora
python3 scripts/swarm/dashboard.py
```

**Risultato Atteso:**
- [ ] Sezione "LIVE HEARTBEAT" visibile
- [ ] Mostra worker con stato ACTIVE/STALE
- [ ] Mostra ultima azione

---

## TEST 5: Istruzioni Cugini

**Obiettivo:** Verificare che i worker capiscono le istruzioni heartbeat

**Cosa osservare nella finestra worker:**
1. Il worker legge le istruzioni heartbeat?
2. Scrive heartbeat nel formato corretto?
3. Invia notifiche?
4. Capisce quando fare /exit?

**Problemi possibili:**
- Istruzioni troppo lunghe
- Formato heartbeat confuso
- Worker dimentica di scrivere heartbeat
- Worker non trova il file

---

## CHECKLIST FINALE

| Test | Pass/Fail | Note |
|------|-----------|------|
| Heartbeat scritto | | |
| Formato corretto | | |
| Notifica inizio | | |
| Notifica fine | | |
| swarm-heartbeat | | |
| Dashboard | | |
| Istruzioni chiare | | |

---

## DOPO I TEST

Se tutto passa:
- Commit delle modifiche
- Aggiornare NORD.md
- Procedere con Code Review

Se qualcosa fallisce:
- Documentare problema
- Fix e ri-testare

---

*"HARDTEST = REALE!"*
