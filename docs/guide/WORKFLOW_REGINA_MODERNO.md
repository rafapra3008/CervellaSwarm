# WORKFLOW REGINA MODERNO

> **Validato:** Sessione 133, 9 Gennaio 2026
> **Pattern:** Task tool interno + Magia nascosta

---

## Come Funziona

```
RAFA: "Voglio X"
     ↓
IO (Regina):
├─ Analizzo cosa serve
├─ Lancio Cervelle in parallelo (Task tool)
│  ├─ cervella-backend (lavora nascosta)
│  ├─ cervella-frontend (lavora nascosta)
│  └─ cervella-tester (lavora nascosta)
├─ Ricevo output automaticamente
├─ Coordino e verifico
└─ Riporto: "Fatto! Ecco il risultato"
     ↓
RAFA: supervisiona e approva

ZERO COPIA-INCOLLA! ZERO INTERVENTO MANUALE!
```

---

## Quando Usare Task Tool vs spawn-workers

| Scenario | Tool | Perche |
|----------|------|--------|
| Ricerca veloce | Task tool | Risposta immediata, Rafa non vede finestre |
| Analisi codice | Task tool | Output integrato, nessuna interruzione |
| Lavoro lungo | spawn-workers | Finestra separata, puo durare |
| Modifiche file | spawn-workers | Visibilita chiara, git separato |

**Regola d'Oro:** Task tool per "magia nascosta", spawn-workers per "trasparenza"

---

## Esempio Pratico (Sessione 133)

### Richiesta
Rafa: "Analizza report ingegnera + verifica 1 funzione critica"

### Esecuzione (2 task paralleli)
```python
Task 1: cervella-researcher
- Legge report (134 issues)
- Analizza pattern
- Output: 54 file grandi OK, tech debt non blocca

Task 2: cervella-ingegnera
- Analizza check_dependencies()
- Verifica vulnerabilita
- Output: Funzione solida, 4 best practices seguite
```

### Risultato
- Entrambe rispondono ISTANTANEAMENTE
- Regina coordina output
- Rafa riceve sintesi completa
- Tempo: ~2 minuti totali

---

*Documentato da cervella-docs, Sessione 133*
