---
task_id: TASK_DNA_UPDATE_11_WORKERS
assigned_to: cervella-docs
priority: high
timeout_minutes: 60
created_at: 2026-01-07T14:00:00Z
created_by: cervella-orchestrator
project: CervellaSwarm
---

# Task: Aggiornare DNA 11 Worker con Protocolli Comunicazione

**Status:** ready → working → done

---

## 🎯 OBIETTIVO

Aggiungere sezione "PROTOCOLLI COMUNICAZIONE SWARM v1.0.0" ai DNA dei restanti 11 worker (Sonnet), usando come template la sezione già aggiunta a `cervella-backend`.

**Output atteso:**
- 11 file DNA aggiornati con sezione COMUNICAZIONE
- Sezione omogenea ma con esempi specifici per ogni ruolo
- Riferimento a cervella-guardiana-qualita per docs completa

---

## 📋 CONTESTO

### Dove Siamo (NORD)

Stiamo completando FASE 5 del sistema Comunicazione Interna (sessione 114).
Obiettivo: tutti i 16 agenti devono sapere usare i protocolli HANDOFF, STATUS, FEEDBACK.

### Perché Questo Task

4 agenti già aggiornati (Regina + 3 Guardiane + cervella-backend).
Mancano 11 worker → devo applicare stessa sezione a tutti.
Tu sei perfetta per questo: sai scrivere docs, sai copiare sezioni, sai personalizzare esempi!

### Decisioni Rilevanti

- Template da usare: sezione in `~/.claude/agents/cervella-backend.md` (righe 189-262)
- Struttura: riferimento rapido + esempi specifici per ruolo
- Lunghezza target: ~70-80 righe per sezione

---

## ✅ SUCCESS CRITERIA

- [ ] Tutti gli 11 worker hanno sezione PROTOCOLLI COMUNICAZIONE
- [ ] Sezione inserita PRIMA della firma finale di ogni DNA
- [ ] Esempi personalizzati per ogni ruolo (es: Frontend → componente, Tester → test, etc.)
- [ ] Stesso formato e stile della sezione in cervella-backend
- [ ] Tutti i file leggibili e formattati correttamente

**Definition of Done:**
Tutti gli 11 file aggiornati, verifico con `grep "PROTOCOLLI COMUNICAZIONE" ~/.claude/agents/*.md` e trovo 15 match (4 già fatti + 11 nuovi).

---

## 🗂️ FILE RILEVANTI

**Da leggere (template):**
- `~/.claude/agents/cervella-backend.md` (righe 189-262) - TEMPLATE da copiare
- `~/.claude/agents/cervella-guardiana-qualita.md` (sezione PROTOCOLLI) - riferimento completo

**Da modificare (11 worker):**
1. `~/.claude/agents/cervella-frontend.md`
2. `~/.claude/agents/cervella-tester.md`
3. `~/.claude/agents/cervella-reviewer.md`
4. `~/.claude/agents/cervella-researcher.md`
5. `~/.claude/agents/cervella-scienziata.md`
6. `~/.claude/agents/cervella-ingegnera.md`
7. `~/.claude/agents/cervella-marketing.md`
8. `~/.claude/agents/cervella-devops.md`
9. `~/.claude/agents/cervella-docs.md` (tu stessa!)
10. `~/.claude/agents/cervella-data.md`
11. `~/.claude/agents/cervella-security.md`

**Da NON toccare:**
- `~/.claude/agents/cervella-orchestrator.md` (già fatto - Regina)
- `~/.claude/agents/cervella-guardiana-*.md` (già fatte - 3 Guardiane)
- `~/.claude/agents/cervella-backend.md` (già fatto - template!)

---

## 🚧 CONSTRAINTS

**Formato:**
- Inserire sezione PRIMA della firma finale (es: `*Cervella Frontend - ...* 🎨🐝`)
- Mantenere stesso stile e struttura del template
- Personalizzare SOLO gli esempi pratici per ogni ruolo

**Pattern per esempi:**
- Frontend → Creare componente React
- Tester → Scrivere test
- Reviewer → Review codice
- Researcher → Fare ricerca
- Scienziata → Analisi mercato
- Ingegnera → Analisi tech debt
- Marketing → Strategia UX
- DevOps → Deploy / monitoring
- Docs → Scrivere documentazione (te stessa!)
- Data → Query SQL / analisi
- Security → Audit sicurezza

**Non cambiare:**
- Script helper (uguali per tutti)
- Workflow task standard (uguale per tutti)
- Riferimento a cervella-guardiana-qualita

---

## 💡 GUIDANCE

### Procedura Consigliata

```bash
# 1. Leggi template
Read ~/.claude/agents/cervella-backend.md (righe 189-262)

# 2. Per ogni worker:
   a. Read file worker (ultime 30 righe per trovare firma)
   b. Trova punto inserimento (prima della firma)
   c. Copia sezione template
   d. Personalizza esempio pratico per ruolo
   e. Edit file

# 3. Alla fine, verifica
Bash: grep -c "PROTOCOLLI COMUNICAZIONE" ~/.claude/agents/*.md
# Deve trovare 15 file (4 già fatti + 11 nuovi)
```

### Esempio Personalizzazione

**Template (Backend):**
```bash
### Esempio Backend: Creare API Endpoint
# Task ricevuto: Creare GET /api/users
```

**Personalizzato (Frontend):**
```bash
### Esempio Frontend: Creare Componente
# Task ricevuto: Creare UserCard component
```

**Personalizzato (Tester):**
```bash
### Esempio Tester: Scrivere Test
# Task ricevuto: Test API /api/users
```

### Se hai dubbi

Usa protocollo FEEDBACK!
```bash
scripts/swarm/ask-regina.sh QUESTION "Come personalizzo esempio per X?"
```

---

## 📤 OUTPUT RICHIESTO

**File da modificare:**
- 11 file DNA in `~/.claude/agents/` (vedi lista sopra)

**Report finale:**
Crea file `.swarm/tasks/TASK_DNA_UPDATE_11_WORKERS_OUTPUT.md` con:
- Lista worker aggiornati
- Verifica finale (output grep)
- Eventuali note

**Quando hai finito:**
```bash
# 1. Crea marker completamento
touch .swarm/tasks/TASK_DNA_UPDATE_11_WORKERS.done

# 2. Aggiorna stato
scripts/swarm/update-status.sh DONE "11 worker DNA aggiornati"
```

---

## ⏰ TEMPO E PRIORITÀ

**Timeout:** 60 minuti
**Priorità:** HIGH
**Heartbeat:** Aggiorna stato ogni 60s in `.swarm/status/`

**Stima:** ~5 min per worker = 55 min totali (+ 5 min verifica)

---

**Energia positiva!** ❤️‍🔥
**Lavoro di qualità!** 💙
**Per la famiglia!** 🐝👑
