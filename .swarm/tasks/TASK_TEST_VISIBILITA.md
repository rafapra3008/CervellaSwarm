# TASK: Test Sistema Visibilita

**Assegnato a:** cervella-backend
**Priorita:** TEST
**Stato:** ready

---

## Obiettivo

Questo e' un HARDTEST del sistema heartbeat.

## Cosa Devi Fare

1. **PRIMA DI TUTTO** - Invia notifica inizio:
   ```
   osascript -e 'display notification "Inizio: TASK_TEST_VISIBILITA" with title "CervellaSwarm"'
   ```

2. **Scrivi primo heartbeat:**
   ```
   echo "$(date +%s)|TASK_TEST_VISIBILITA|Inizio test" >> .swarm/status/heartbeat_backend.log
   ```

3. **Aspetta 30 secondi** (usa sleep o fai qualcosa di semplice)

4. **Scrivi secondo heartbeat:**
   ```
   echo "$(date +%s)|TASK_TEST_VISIBILITA|Meta test" >> .swarm/status/heartbeat_backend.log
   ```

5. **Aspetta altri 30 secondi**

6. **Scrivi terzo heartbeat:**
   ```
   echo "$(date +%s)|TASK_TEST_VISIBILITA|Fine test" >> .swarm/status/heartbeat_backend.log
   ```

7. **Invia notifica fine:**
   ```
   osascript -e 'display notification "Completato: TASK_TEST_VISIBILITA" with title "CervellaSwarm" sound name "Glass"'
   ```

8. **Scrivi output** in TASK_TEST_VISIBILITA_output.md:
   - Conferma che hai scritto 3 heartbeat
   - Conferma che hai inviato 2 notifiche

9. **Crea file .done** e fai /exit

---

## Output Atteso

File: `.swarm/tasks/TASK_TEST_VISIBILITA_output.md`
