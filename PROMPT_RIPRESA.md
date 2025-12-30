# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 30 Dicembre 2025, ore 10:00

---

## 🎯 STATO ATTUALE

**FASE 2: Primi Subagent** - 83% IN CORSO 🟡

### Cosa abbiamo fatto OGGI:

1. ✅ **Creato 4 subagent GLOBALI** in `~/.claude/agents/`:
   - cervella-frontend.md (React, CSS, UI/UX)
   - cervella-backend.md (Python, FastAPI, API)
   - cervella-tester.md (pytest, Jest, QA)
   - cervella-reviewer.md (Code review, solo lettura)

2. ✅ **Verificato nel terminale** con `/agents` - FUNZIONANO!

3. ✅ **Testato su Miracollo via VS Code** - FUNZIONA! 🎉
   - Dopo riavvio VS Code, i subagent sono visibili
   - cervella-backend ha elencato 100+ file Python

4. ✅ **Scoperta importante:**
   - I subagent in `~/.claude/agents/` sono **GLOBALI**
   - Funzionano su TUTTI i progetti (Miracollo, Contabilità, etc.)
   - NON serve creare agenti per ogni progetto!

### Prossimo step:

1. ⬜ **Documentare risultati** (ultimo task FASE 2)
2. ⬜ **Fare altre prove** su diversi progetti

---

## 📂 SUBAGENT DISPONIBILI (GLOBALI!)

| File | Specializzazione | Funziona su |
|------|------------------|-------------|
| `cervella-frontend.md` | React, CSS, UI/UX | TUTTI i progetti |
| `cervella-backend.md` | Python, FastAPI, API | TUTTI i progetti |
| `cervella-tester.md` | pytest, Jest, QA | TUTTI i progetti |
| `cervella-reviewer.md` | Code review | TUTTI i progetti |

**Location:** `~/.claude/agents/` (GLOBALE!)

**Come invocare:**
```
"Usa cervella-frontend per..."
"Chiedi a cervella-backend di..."
```

---

## 🧠 FILO DEL DISCORSO

### Stavamo ragionando su:
Abbiamo creato lo sciame e l'abbiamo testato! I subagent sono GLOBALI quindi funzionano su tutti i progetti senza dover ricrearli.

### Scoperte della sessione:
- ✅ VS Code Beta: serve riavvio per caricare nuovi agents
- ✅ Terminale: li vede subito con `/agents`
- ✅ `~/.claude/agents/` = GLOBALE (tutti i progetti)
- ✅ `.claude/agents/` = locale (solo quel progetto)

### Il momentum:
🔥🔥🔥 ALTISSIMO! Lo sciame è VIVO e funziona!

### Test completati:
- ✅ cervella-backend su Miracollo → 100+ file Python trovati

### Da testare ancora (opzionale):
- ⬜ cervella-frontend
- ⬜ cervella-tester
- ⬜ cervella-reviewer

---

## ⏭️ QUANDO RIPRENDI

1. I 4 subagent sono pronti e GLOBALI
2. Funzionano su qualsiasi progetto
3. Puoi fare altre prove o chiudere FASE 2

---

## 📊 RIASSUNTO SESSIONE

| Metrica | Valore |
|---------|--------|
| Subagent creati | 4/4 ✅ |
| Test terminale | ✅ |
| Test VS Code | ✅ |
| Test Miracollo | ✅ cervella-backend |
| Scope | GLOBALE (tutti i progetti!) |

---

*"Uno sciame di Cervelle. Ovunque tu vada!"* 🐝💙
