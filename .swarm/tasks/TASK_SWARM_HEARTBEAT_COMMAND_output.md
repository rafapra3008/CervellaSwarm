# Output: TASK_SWARM_HEARTBEAT_COMMAND

**Completato da:** cervella-backend
**Data:** 2026-01-05

---

## Risultato

Creato comando `~/.local/bin/swarm-heartbeat` v1.0.0

### Verifiche Passate

- [x] Script creato in ~/.local/bin/swarm-heartbeat
- [x] Permessi eseguibili (chmod +x)
- [x] Funziona da qualsiasi progetto con .swarm/
- [x] Modalita --watch funziona
- [x] Colori corretti (ACTIVE verde, STALE giallo)

### Test Effettuati

```
$ swarm-heartbeat
[backend] ACTIVE (0s ago) - Test heartbeat
```

### Esempio Output

```
$ swarm-heartbeat
[backend]  ACTIVE (15s ago) - Analizzando file X
[frontend] ACTIVE (8s ago)  - Creando componente Y
[tester]   STALE  (5m ago)  - Ultimo task completato
```

Se nessun heartbeat:
```
$ swarm-heartbeat
Nessun heartbeat trovato. I worker non hanno ancora scritto.
```

---

**Stato:** COMPLETATO
