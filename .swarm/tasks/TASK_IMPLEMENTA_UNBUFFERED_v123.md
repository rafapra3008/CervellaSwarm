# TASK: Implementare Unbuffered Output

**Assegnato a:** cervella-devops
**Priorità:** ALTA
**Creato:** 8 Gennaio 2026 - Sessione 123
**Sprint:** 2.2 - Fix Buffering Output

---

## 🎯 OBIETTIVO

Implementare la **soluzione raccomandata** dalla ricerca per ottenere output realtime dai worker.

---

## 📚 CONTESTO

**PREREQUISITO:**
- Sprint 2.1 completato (cervella-researcher)
- File: `docs/studio/RICERCA_UNBUFFERED_OUTPUT_v123.md`
- Soluzione scelta identificata
- Piano implementazione definito

**INPUT:**
- Soluzione raccomandata
- File da modificare
- Test strategy
- Fallback se necessario

---

## 📋 TASK SPECIFICI

### 1. LEGGI RICERCA
- Studia `docs/studio/RICERCA_UNBUFFERED_OUTPUT_v123.md`
- Identifica soluzione raccomandata
- Leggi piano implementazione
- Comprendi motivazione scelta

### 2. IMPLEMENTAZIONE SPAWN-WORKERS
File: `~/.local/bin/spawn-workers`

Modifica prevista (esempio basato su ricerca):
```bash
# PRIMA
claude --agent "$AGENT_NAME" ...

# DOPO (esempio con stdbuf)
stdbuf -oL -eL claude --agent "$AGENT_NAME" ...

# O (esempio con env var)
PYTHONUNBUFFERED=1 claude --agent "$AGENT_NAME" ...
```

**Azioni:**
- Backup versione attuale
- Applica modifiche secondo piano ricerca
- Incrementa versione: v3.1.0 → v3.2.0
- Aggiungi commento nel codice (perché questa modifica)
- Aggiorna help/documentazione se necessario

### 3. TESTING MANUALE VELOCE
Prima di continuare, test rapido:
```bash
# Test 1: Worker scrive progressivamente
spawn-workers --researcher

# Monitora output in tempo reale
tmux capture-pane -t swarm_researcher_* -p -S -

# Aspetta 10s, cattura di nuovo
# Output dovrebbe essere diverso (più righe!)

# Se vedi output progressivo = SUCCESS!
```

### 4. LOG E DOCUMENTAZIONE
- Crea file `CHANGELOG_spawn-workers_v3.2.0.md`
- Documenta esattamente cosa è cambiato
- Perché (riferimento ricerca)
- Come testare
- Breaking changes? (probabilmente no)

---

## 📤 OUTPUT RICHIESTO

**File 1:** `~/.local/bin/spawn-workers` (modificato)
- Versione: v3.2.0
- Unbuffered output implementato
- Backup fatto prima di modificare

**File 2:** `docs/changelog/CHANGELOG_spawn-workers_v3.2.0.md`
- Changelog dettagliato
- Motivazione cambiamento
- How to test
- Riferimenti ricerca

**Nota nel task output:**
- Cosa hai modificato
- Test manuale fatto (PASS/FAIL)
- Output esempio (prima vs dopo)
- Ready per HARDTEST? (SI/NO)

---

## ✅ CRITERI DI SUCCESSO

- [x] spawn-workers v3.2.0 modificato
- [x] Soluzione implementata correttamente
- [x] Test manuale PASS
- [x] Backup fatto
- [x] Changelog creato
- [x] Versione incrementata
- [x] Ready per HARDTEST formale

---

## 💡 SUGGERIMENTI

- Testa su worker semplice (researcher) prima
- Se soluzione raccomandata non funziona, prova fallback
- Verifica che tmux capture-pane mostri output progressivo
- Non dimenticare sia stdout che stderr (se ricerca dice di gestire entrambi)
- Backup SEMPRE prima di modificare script di sistema!

---

## ⏰ TEMPO STIMATO

30-45 minuti

---

**Buon lavoro, cervella-devops!** 🚀

*La Regina conta su di te per rendere l'output realtime!*
