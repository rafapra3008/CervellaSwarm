# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 4 Gennaio 2026 - Sessione 84 - SWARM OVUNQUE! v1.9.0

---

## CARA PROSSIMA CERVELLA

```
+------------------------------------------------------------------+
|                                                                  |
|   Benvenuta! Questo file e' la tua UNICA memoria.               |
|   Leggilo con calma. Qui c'e' tutto quello che devi sapere.     |
|                                                                  |
|   Tu sei la REGINA dello sciame.                                 |
|   Hai 16 agenti pronti a lavorare per te.                       |
|                                                                  |
|   FASE ATTUALE: SWARM OVUNQUE!                                  |
|                                                                  |
|   SESSIONE 84:                                                   |
|   - spawn-workers v1.9.0 GLOBALE!                               |
|   - Funziona da QUALSIASI progetto!                             |
|   - Testato su: CervellaSwarm, Miracollo, Contabilita           |
|                                                                  |
|   "Ultrapassar os proprios limites!" - Rafa                     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## SESSIONE 84: SWARM OVUNQUE! v1.9.0

### L'Obiettivo

Rendere spawn-workers GLOBALE - funzionante da qualsiasi progetto.

### Cosa Abbiamo Fatto

1. **Creato .swarm/ in Contabilita**
   - Struttura completa: tasks, logs, status, locks, handoff, archive, acks, prompts, runners

2. **spawn-workers v1.9.0 - PROJECT-AWARE**
   - Symlink globale in ~/.local/bin/spawn-workers
   - Trova automaticamente .swarm/ nella directory corrente
   - Cerca fino a 5 livelli di parent directories

3. **Test PASSATI (2/2)**
   - Miracollo: worker spawned, task completato, output corretto
   - Contabilita: worker spawned, task completato, output corretto

4. **Hooks Verificati**
   - session_start_miracollo.py - FUNZIONA
   - session_start_contabilita.py - FUNZIONA
   - Entrambi producono JSON valido con contesto progetto

5. **Documentazione Aggiornata**
   - README.md in .swarm/ di tutti e 3 i progetti
   - Quick Start con comandi spawn-workers

### Filo del Discorso

Rafa ha chiesto: "dove funzionera Swarm? Miracollo? Contabilita manca sistemare?"

Ho fatto triple check completo:
- Hooks globali: 8 file, tutti funzionanti
- Agents globali: 16 file, tutti presenti
- spawn-workers: era solo in CervellaSwarm!

Piano in 9 step:
1. Creare .swarm/ in Contabilita - DONE
2. Decidere strategia (symlink vs copia) - Symlink!
3. Implementare spawn-workers globale - v1.9.0 PROJECT-AWARE
4. Test da Miracollo - PASS!
5. Test da Contabilita - PASS!
6. Verificare hooks Miracollo - FUNZIONA
7. Verificare hooks Contabilita - FUNZIONA
8. Documentare - README aggiornati
9. Test finale - TUTTO OK!

Rafa: "Ultrapassar os proprios limites!"

---

## STATO ATTUALE

| Cosa | Versione | Status |
|------|----------|--------|
| **spawn-workers.sh** | **v1.9.0** | **GLOBALE! PROJECT-AWARE!** |
| anti-compact.sh | v1.6.0 | VS Code Tasks |
| SWARM_RULES.md | v1.5.0 | 13 regole |
| MANUALE_DIAMANTE.md | v1.0.0 | Globale! |
| swarm_memory.db | v1.0.0 | FUNZIONANTE |
| 16 Agent Files | v1.0.0 | GLOBALI! |
| 8 Hook Files | v1.0.0 | GLOBALI! |

---

## PROSSIMO STEP

```
+------------------------------------------------------------------+
|                                                                  |
|   USARE LO SWARM SU MIRACOLLO!                                  |
|                                                                  |
|   Lo sciame funziona. E' GLOBALE.                               |
|   "Il 100000% viene dall'USO, non dalla teoria!"                 |
|                                                                  |
|   COME USARE (da qualsiasi progetto):                           |
|   $ cd ~/Developer/miracollogeminifocus                         |
|   $ spawn-workers --backend                                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## LO SCIAME (16 membri - GLOBALI!)

```
TU SEI LA REGINA (Opus) - Coordina, DELEGA, MAI edit diretti!

3 GUARDIANE (Opus):
- cervella-guardiana-qualita
- cervella-guardiana-ops
- cervella-guardiana-ricerca

12 WORKER (Sonnet):
- frontend, backend, tester
- reviewer, researcher, scienziata, ingegnera
- marketing, devops, docs, data, security

POSIZIONE: ~/.claude/agents/ (GLOBALI!)
```

---

## FILE IMPORTANTI

| File | Cosa Contiene |
|------|---------------|
| `NORD.md` | Dove siamo, prossimo obiettivo |
| `~/.claude/MANUALE_DIAMANTE.md` | Regole d'oro globali |
| `~/.local/bin/spawn-workers` | LA MAGIA! v1.9.0 GLOBALE |
| `.swarm/logs/` | Log output dei worker |
| `.swarm/tasks/` | Task per lo sciame |

---

## LA STORIA RECENTE

| Sessione | Cosa | Risultato |
|----------|------|-----------|
| 80 | TRE COSE! | Scoperta contesto + FASE 1 + Test CTX |
| 81 | OVERVIEW! | docs/OVERVIEW_FAMIGLIA.md creato! |
| 82 | FINITURE | Verifica DB + Decisione step by step |
| 83 | SPAWN-WORKERS v1.8.0 | FIX ELEGANTE! -p mode! |
| **84** | **SWARM OVUNQUE!** | **spawn-workers v1.9.0 GLOBALE!** |

---

## LE NOSTRE FRASI

```
"Lavoriamo in pace! Senza casino! Dipende da noi!"

"E PROPRIO MAGIA!!!" - Rafa, Sessione 83

"Il 100000% viene dall'USO, non dalla teoria."

"E' il nostro team! La nostra famiglia digitale!"

"Ultrapassar os proprios limites!" - Rafa
```

---

**VERSIONE:** v34.0.0
**SESSIONE:** 84
**DATA:** 4 Gennaio 2026

---

*Scritto con CURA e PRECISIONE.*

Cervella & Rafa
