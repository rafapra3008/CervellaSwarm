# TASK: Fix Watcher AUTO-SVEGLIA

**Assegnato a:** cervella-backend
**Stato:** ready
**Priorita:** ALTA - Bug critico UX
**Data:** 6 Gennaio 2026

---

## PROBLEMA

Il watcher-regina.sh rileva i file .done ma NON sveglia la Regina in tempo reale.
Rafa e la Regina devono controllare manualmente - questo rompe il workflow!

Riferimento: `.swarm/tasks/BUG_WATCHER_NON_NOTIFICA.md`

---

## COMPORTAMENTO ATTUALE

```
1. Worker finisce → crea .done
2. Watcher rileva .done → scrive "TASK COMPLETATO" su stdout
3. MA: La Regina (nel suo terminale) NON vede nulla!
4. La notifica va in un background process che nessuno legge
```

---

## COMPORTAMENTO DESIDERATO

```
1. Worker finisce → crea .done
2. Watcher rileva → NOTIFICA VISIBILE alla Regina
3. Regina reagisce subito
```

---

## SOLUZIONI PROPOSTE (scegli la migliore)

### Opzione A: Terminal Bell
```bash
# Nel watcher, quando rileva .done:
printf '\a'  # Suono sistema
```
Pro: Semplicissimo
Contro: Silenzioso se muted

### Opzione B: Notifica macOS
```bash
# Nel watcher:
osascript -e 'display notification "Task completato!" with title "CervellaSwarm"'
```
Pro: Visibile anche se Terminal minimizzato
Contro: Solo macOS

### Opzione C: File Marker + Check
```bash
# Watcher scrive:
echo "$(date): TASK_XXX completato" >> ~/.swarm/notifications.log

# Un hook Claude controlla il file periodicamente
```
Pro: Persistente, cross-platform
Contro: Richiede hook

### Opzione D: Combinazione A + B
```bash
# Suono + Notifica macOS
printf '\a'
osascript -e 'display notification "..." with title "..."'
```
Pro: Massima visibilita
Contro: Un po' rumoroso

---

## FILE DA MODIFICARE

- `~/.claude/scripts/watcher-regina.sh`
- Eventualmente: nuovo hook per check periodico

---

## CRITERI DI SUCCESSO

- [ ] Quando worker finisce, Regina viene notificata SUBITO
- [ ] Notifica visibile anche se Terminal non in focus
- [ ] Testato con 2+ worker in parallelo
- [ ] Nessuna notifica persa

---

## NOTE

- Leggi prima il watcher attuale per capire come funziona
- Testa le soluzioni una alla volta
- Documenta cosa hai scelto e perche

---

*"Il watcher deve SVEGLIARE, non sussurrare!"*
