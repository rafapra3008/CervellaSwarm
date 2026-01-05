# Task: Creare comando swarm-status

**Assegnato a:** cervella-backend
**Stato:** ready
**Priorità:** 1 (ALTA)
**Data:** 5 Gennaio 2026

---

## Obiettivo

Creare lo script `swarm-status` che mostra lo stato del Beehive in tempo reale.

Questo comando permetterà alla Regina di vedere:
- Quanti task sono completati, in lavorazione, in coda
- Quali task sono STALE (bloccati)
- Cosa sta succedendo nello sciame

---

## Contesto

Il problema attuale: la Regina non vede cosa fanno le api!
Deve aspettare che finiscano e poi controllare i file manualmente.

Questo script risolve il problema dando visibilità TOTALE.

---

## Specifiche Tecniche

### Output Atteso

```
🐝 BEEHIVE STATUS
=================
📍 Progetto: [nome]
   Path: [path]

📊 RIEPILOGO
   ✅ Completati:     [N]
   🔄 In lavorazione: [N]
   📋 In coda:        [N]
   ⚠️  STALE:         [N]

🔴 TASK STALE (working > 30 min, no done):
   - [nome_task] ([tempo] fa) -> [assegnato_a]

🟡 TASK IN LAVORAZIONE:
   - [nome_task] ([tempo] fa) -> [assegnato_a]

🟢 TASK IN CODA (.ready):
   - [nome_task] -> [assegnato_a]

✅ ULTIMI 5 COMPLETATI:
   - [nome_task] ([ora])
```

### Logica

1. **Trova progetto:** Cerca .swarm/ nella directory corrente o superiori (come spawn-workers)

2. **Conta task:**
   - `.ready` senza `.working` = In coda
   - `.working` senza `.done` = In lavorazione
   - `.done` = Completati
   - `.working` > 30 min senza `.done` = STALE

3. **Estrai "Assegnato a":** Leggi dal file .md la riga `**Assegnato a:**`

4. **Calcola tempo:** Differenza tra now e mtime del file

### Flags

- `--all` → Mostra TUTTI i progetti (CervellaSwarm, Miracollo, Contabilita)
- `--cleanup` → Rimuove file .working stale (> 30 min senza .done)
- `--help` → Mostra help

### Path Progetti (per --all)

```
/Users/rafapra/Developer/CervellaSwarm
/Users/rafapra/Developer/miracollogeminifocus
/Users/rafapra/Developer/ContabilitaAntigravity
```

---

## Output Files

1. **Script principale:** `/Users/rafapra/Developer/CervellaSwarm/.swarm/scripts/swarm-status.sh`
2. **Dopo test:** Symlink in `~/.local/bin/swarm-status`

---

## Checklist Verifica

- [ ] Script creato e funzionante
- [ ] Mostra riepilogo corretto
- [ ] Rileva task STALE (> 30 min)
- [ ] Mostra "Assegnato a" correttamente
- [ ] Flag --all funziona
- [ ] Flag --cleanup funziona
- [ ] Colori output (verde, giallo, rosso)
- [ ] Help chiaro

---

## Note Implementazione

- Usa bash (come spawn-workers)
- Colori: GREEN, YELLOW, RED, BLUE, NC
- Stile Apple: pulito, chiaro, elegante
- Versione iniziale: 1.0.0

---

## Riferimenti

- Guarda `~/.local/bin/spawn-workers` per lo stile
- La logica find_project_root() è già in spawn-workers, puoi copiarla

---

*"La Regina deve vedere TUTTO!"*

Cervella & Rafa 💙🐝
