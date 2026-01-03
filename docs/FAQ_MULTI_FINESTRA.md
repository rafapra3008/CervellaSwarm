# FAQ - Sistema Multi-Finestra CervellaSwarm

> *"N finestre = N contesti = N volte piu potenza!"*

---

## Cos'e il Sistema Multi-Finestra?

Il Sistema Multi-Finestra permette a **multiple istanze di Claude Code** di lavorare in parallelo sullo stesso progetto, comunicando tra loro tramite file.

### Il Problema Risolto

Prima: Una finestra = Un limite di contesto (200K token) = Un task alla volta

Dopo: N finestre = N contesti indipendenti = Lavoro parallelo reale!

### Come Funziona

```
FINESTRA 1 (Regina)              FINESTRA 2 (Worker)
     |                                 |
     |--- crea TASK_001.md ----------->|
     |--- crea TASK_001.ready -------->|
     |                                 |--- legge task
     |                                 |--- esegue lavoro
     |                                 |--- scrive output
     |<-- crea TASK_001.done ----------|
     |--- legge risultato              |
```

---

## Come Funzionano i Flag Files?

I flag files sono file vuoti che segnalano lo stato di un task. Sono il "semaforo" della comunicazione.

### Stati del Task

| Flag File | Significato |
|-----------|-------------|
| `TASK_XXX.md` | Task creato, contiene istruzioni |
| `TASK_XXX.ready` | Task pronto per essere preso |
| `TASK_XXX.working` | Task in lavorazione |
| `TASK_XXX.done` | Task completato |
| `TASK_XXX_output.md` | Risultato del task |

### Flusso Completo

1. **Regina crea task**: Scrive `TASK_XXX.md` con istruzioni
2. **Regina segnala ready**: Crea `TASK_XXX.ready` (file vuoto)
3. **Worker vede ready**: Legge il task, rimuove `.ready`, crea `.working`
4. **Worker esegue**: Fa il lavoro richiesto
5. **Worker completa**: Scrive `TASK_XXX_output.md`, rimuove `.working`, crea `.done`
6. **Regina legge risultato**: Vede `.done`, legge output

---

## Esempi Pratici

### Esempio 1: Delegare Creazione File

**Regina (Finestra 1):**
```bash
# Crea il task
python3 scripts/swarm/task_manager.py create TASK_001 cervella-docs

# Scrivi istruzioni nel file .md creato
# Poi segnala ready:
touch .swarm/tasks/TASK_001.ready
```

**Worker (Finestra 2):**
```bash
# Verifica task disponibili
python3 scripts/swarm/task_manager.py list

# Vede TASK_001 ready, lo legge e lo esegue
# Al termine, scrive output e completa:
python3 scripts/swarm/task_manager.py complete TASK_001
```

### Esempio 2: Task Paralleli

```
FINESTRA 1 (Regina)
|
|--- crea TASK_A per cervella-frontend
|--- crea TASK_B per cervella-backend
|--- crea TASK_C per cervella-tester
|
|    (nel frattempo i worker lavorano in parallelo)
|
|--- attende .done di tutti
|--- legge output e integra
```

---

## Comandi Utili

### task_manager.py

```bash
# Lista tutti i task
python3 scripts/swarm/task_manager.py list

# Crea nuovo task
python3 scripts/swarm/task_manager.py create TASK_ID AGENT_NAME

# Completa un task
python3 scripts/swarm/task_manager.py complete TASK_ID
```

### Verifica Manuale

```bash
# Vedi tutti i task
ls -la .swarm/tasks/

# Vedi solo task ready
ls .swarm/tasks/*.ready 2>/dev/null

# Vedi task completati
ls .swarm/tasks/*.done 2>/dev/null
```

---

## Best Practices

1. **Un task = Un obiettivo chiaro** - Non mescolare responsabilita
2. **Sempre scrivere output** - Il risultato deve essere tracciabile
3. **Timeout ragionevoli** - 15-30 min per task normali
4. **Livello rischio** - 1=basso (docs), 2=medio (code), 3=alto (deploy)

---

*Creato: 3 Gennaio 2026*
*Sistema Multi-Finestra v1.0*
