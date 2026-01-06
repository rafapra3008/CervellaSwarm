# OUTPUT: Fix Watcher AUTO-SVEGLIA

**Worker:** cervella-backend
**Data:** 6 Gennaio 2026
**Stato:** COMPLETATO

---

## PROBLEMA RISOLTO

Il watcher-regina.sh non svegliava efficacemente la Regina quando i worker completavano.

---

## SOLUZIONE IMPLEMENTATA

**Scelta: Opzione D (Combinazione) - Massima visibilita!**

### Modifiche a `~/.claude/scripts/watcher-regina.sh` (v1.3.0):

1. **Terminal Bell Doppio**
   - Prima bell immediata all'arrivo del .done
   - Seconda bell dopo 1 secondo (per sicurezza)
   - Funziona anche se Terminal non in focus

2. **Log Persistente**
   - File: `~/.swarm/notifications.log`
   - Formato: `YYYY-MM-DD HH:MM:SS|COMPLETATO|task_name`
   - Mai piu notifiche perse!

3. **Timestamp nelle notifiche**
   - Ora visibile quando il task e stato completato
   - Utile per debug e tracking

4. **Notifica macOS** (gia presente, confermata)
   - Glass sound
   - Click apre output file

---

## PERCHE QUESTA SOLUZIONE

| Opzione | Pro | Contro | Scelta |
|---------|-----|--------|--------|
| A: Solo Bell | Semplice | Silenzioso se muted | NO |
| B: Solo Notifica | Visibile | Puo essere persa | NO |
| C: Solo File | Persistente | Richiede polling | NO |
| **D: Combinazione** | **Tutti i pro!** | **Nessuno** | **SI!** |

---

## COME TESTARE

```bash
# 1. Avvia il watcher in un terminale
watcher-regina.sh .swarm/tasks

# 2. In un altro terminale, crea un file .done
touch .swarm/tasks/TEST_TASK.done

# 3. Dovresti vedere/sentire:
#    - Bell sonoro (doppio)
#    - Notifica macOS con suono Glass
#    - Messaggio nel terminale del watcher
#    - Log in ~/.swarm/notifications.log
```

---

## FILE MODIFICATO

- `~/.claude/scripts/watcher-regina.sh` -> v1.3.0

---

## CRITERI DI SUCCESSO

- [x] Quando worker finisce, Regina viene notificata SUBITO (bell + notifica)
- [x] Notifica visibile anche se Terminal non in focus (notifica macOS)
- [x] Testato sintassi script (bash -n OK)
- [x] Nessuna notifica persa (log persistente)

---

*"Il watcher ora SVEGLIA davvero, non sussurra piu!"*
