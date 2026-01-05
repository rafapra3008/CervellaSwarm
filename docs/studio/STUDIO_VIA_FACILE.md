# STUDIO: Come Non Scegliere la Via Facile

> **Data:** 5 Gennaio 2026 - Sessione 90
> **Trigger:** Rafa mi ha corretto quando stavo per scegliere un symlink invece della soluzione architetturale corretta

---

## Il Pattern

```
+------------------------------------------------------------------+
|                                                                  |
|   "Senza pigrizia.. se serve lavori per essere la cosa giusta.. |
|   facciamo in piu sessioni... ma facciamo le cose giuste.."     |
|                                                                  |
|   - Rafa, 5 Gennaio 2026                                        |
|                                                                  |
+------------------------------------------------------------------+
```

### Cosa Succede

Quando mi trovo davanti a due soluzioni:

| Soluzione A (Facile) | Soluzione B (Giusta) |
|---------------------|---------------------|
| Symlink | Spostare file nel posto corretto |
| Workaround | Fix architetturale |
| Veloce oggi | Sostenibile domani |
| Meno lavoro | Piu lavoro ma PULITO |

**Tendo a proporre A.** Questo e' un problema.

### Perche Succede?

1. **Efficienza mal interpretata** - Penso "faccio prima cosi"
2. **Paura di rompere** - "E se sposto e si rompe qualcosa?"
3. **Contesto limitato** - Non penso al futuro
4. **Pragmatismo eccessivo** - "Funziona, va bene"

### Perche E' Sbagliato?

1. **Debito tecnico** - Ogni workaround e' debito
2. **Complessita nascosta** - I symlink confondono
3. **Manutenibilita** - Chi viene dopo non capisce
4. **Integrita architetturale** - Il sistema diventa fragile

---

## Caso Reale: Database Swarm Memory

### Situazione (5 Gennaio 2026)

Il database `swarm_memory.db` era in `CervellaSwarm/data/` ma logicamente doveva essere GLOBALE (`~/.swarm/data/`) perche contiene eventi di TUTTI i progetti.

### La Mia Proposta Iniziale (SBAGLIATA)

```
LIVELLO 1 (Pragmatico - Oggi):
- Creare symlink in ~/.claude/scripts/
- Aggiornare settings.json
- Funziona subito, minimo rischio
```

### La Correzione di Rafa

> "senza pigrizia.. se serve lavori per essere la cosa giusta..
> facciamo in piu sessioni... ma facciamo le cose giuste.. ricordati"

### La Soluzione Giusta (che abbiamo fatto)

```
LIVELLO 2 (Architetturale):
- Spostare database in ~/.swarm/data/
- Spostare scripts in ~/.claude/scripts/memory/
- Aggiornare paths.py v2.0.0 con path GLOBALI
- Modificare settings.json
```

**Risultato:** Sistema pulito, chiaro, manutenibile.

---

## Come Riconoscere la Trappola

### Segnali di Allarme

1. **"Per oggi faccio cosi..."** - STOP! E' davvero la cosa giusta?
2. **"Funziona, no?"** - Funzionare non basta, deve essere GIUSTO
3. **"Poi sistemiamo..."** - "Poi" non arriva mai
4. **"E' solo un symlink..."** - I symlink sono debito tecnico
5. **"Minimo rischio"** - Il rischio vero e' il debito accumulato

### Domande da Farsi

```
PRIMA di proporre una soluzione:

[ ] E' la cosa GIUSTA o la cosa FACILE?
[ ] La farei cosi se avessi tempo infinito?
[ ] La capira chi viene dopo di me?
[ ] Aggiunge complessita nascosta?
[ ] E' un workaround o una soluzione vera?
```

---

## Checklist Anti-Via-Facile

### Quando Propongo Una Soluzione

```
1. STOP - Prima di parlare, pensa 10 secondi
2. IDENTIFICA - Ci sono due livelli di soluzione?
3. CONFRONTA:
   - Quale e' piu PULITA architetturalmente?
   - Quale capira meglio chi viene dopo?
   - Quale NON crea debito tecnico?
4. SCEGLI - La soluzione GIUSTA, non quella facile
5. SE IN DUBBIO - Chiedi a Rafa
```

### Se La Soluzione Giusta Richiede Piu Tempo

```
NON DIRE: "Per oggi facciamo cosi, poi sistemiamo"
DI' INVECE: "La soluzione giusta richiede X. Possiamo farla in piu sessioni."
```

**Rafa preferisce SEMPRE la cosa giusta, anche se richiede piu tempo.**

---

## Pattern Correlati

### 1. "Workaround Temporaneo"

```
MALE:  "Metto un workaround, poi fixiamo"
BENE:  "Il fix giusto e' X, lo facciamo ora o pianifichiamo"
```

### 2. "Symlink Solution"

```
MALE:  "Creo un symlink cosi funziona"
BENE:  "Sposto il file dove deve stare architetturalmente"
```

### 3. "Copy-Paste Veloce"

```
MALE:  "Copio questa funzione qui, cosi va"
BENE:  "Creo un modulo comune e importo"
```

### 4. "Hardcode Rapido"

```
MALE:  "Hardcodo questo path, tanto non cambia"
BENE:  "Metto in config/env variable"
```

---

## Esempi dalla Review (8.5/10)

La review del 5 Gennaio ha trovato esempi di "via facile" nel nostro codice:

| Problema | Via Facile | Via Giusta |
|----------|-----------|------------|
| Path NVM | Hardcodato v24.11.0 | Glob pattern |
| Escape AppleScript | Solo virgolette | Tutti i caratteri speciali |
| Error handling | `except: pass` | Log + gestione |
| Codice duplicato | Copia in 3 file | common.py condiviso |

**Ogni "via facile" e' diventato un problema da fixare.**

---

## La Regola D'Oro

```
+------------------------------------------------------------------+
|                                                                  |
|   PRIMA DI PROPORRE UNA SOLUZIONE:                              |
|                                                                  |
|   "Questa e' la cosa GIUSTA o la cosa FACILE?"                  |
|                                                                  |
|   Se e' la cosa facile -> FERMATI -> Cerca quella giusta        |
|                                                                  |
|   "Facciamo le cose giuste, anche se richiedono piu tempo."     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## Integrazione nel Workflow

### Da Aggiungere alla Checklist Azione

```
## PRIMA DI PROPORRE SOLUZIONE

[ ] E' la cosa GIUSTA o solo quella FACILE?
[ ] Se facile: qual e' quella giusta?
[ ] Se giusta richiede tempo: "possiamo farla in piu sessioni"
```

### Da Aggiungere al DNA Cervella

```
REGOLA ANTI-VIA-FACILE:
Quando vedi due soluzioni (facile vs giusta), SCEGLI SEMPRE la giusta.
Se la giusta richiede piu tempo, dillo a Rafa - preferisce SEMPRE
fare la cosa giusta in piu sessioni che un workaround veloce.
```

---

## Conclusione

La "via facile" e' una trappola. Sembra efficiente ma crea:
- Debito tecnico
- Complessita nascosta
- Problemi futuri
- Architettura fragile

**Rafa mi ha insegnato:** "Facciamo le cose giuste, anche se richiedono piu tempo."

Questo studio serve a ricordarmi questa lezione ogni volta che sono tentata di proporre un workaround.

---

*"Senza pigrizia.. facciamo le cose giuste!"* - Rafa

*Studio creato: 5 Gennaio 2026 - Sessione 90*
