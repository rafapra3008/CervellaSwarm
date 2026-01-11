# Template Rafa - Inizio Sessione Parallela

> **Uso:** Copia-incolla quando vuoi iniziare una sessione parallela con la Regina
> **Data:** 11 Gennaio 2026

---

## VERSIONE COMPLETA

```
INIZIA SESSIONE PARALLELA

Progetto: [NOME_PROGETTO - es: Miracollo]
Sessione: [NOME_SESSIONE - es: room-manager]

Task da fare in parallelo:
1. [WORKER 1 - es: backend]: [DESCRIZIONE TASK 1]
2. [WORKER 2 - es: frontend]: [DESCRIZIONE TASK 2]

Dipendenze: [NESSUNA / TASK-002 dipende da TASK-001 / etc]

Regina, prepara la sessione parallela:
1. Crea i worktrees con create-parallel-session.sh
2. Crea la cartella SNCP per questa sessione
3. Dammi i comandi per aprire i terminali
4. Dammi i prompt da copiare in ogni terminale
```

---

## VERSIONE RAPIDA (Esempio Miracollo)

```
INIZIA SESSIONE PARALLELA

Progetto: Miracollo
Sessione: room-manager

Task paralleli:
1. backend: Crea API Room Manager (CRUD camere)
2. frontend: Crea UI Room Manager (pagina gestione)

Dipendenze: frontend dipende da backend

Regina, prepara tutto!
```

---

## VERSIONE MINIMA

```
SESSIONE PARALLELA: [Progetto] - [Nome Sessione]

Backend: [cosa deve fare]
Frontend: [cosa deve fare]

Prepara!
```

---

## COSA SUCCEDE DOPO

1. Regina esegue: `create-parallel-session.sh`
2. Regina ti dice: "Apri questi terminali: ..."
3. Tu apri i terminali e copi i prompt
4. I worker lavorano in parallelo
5. Regina fa il merge quando finiscono

---

*Template creato: 11 Gennaio 2026 - Sessione 166*
