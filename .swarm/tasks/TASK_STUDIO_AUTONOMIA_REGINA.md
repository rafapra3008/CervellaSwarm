# Task: Studio SERIO - Perché la Regina Non Usa Spawn-Workers in Autonomia?

**Assegnato a:** cervella-researcher
**Stato:** ready
**Priorita:** CRITICA
**Data:** 5 Gennaio 2026

---

## Il Problema (GRAVE!)

La Regina (Cervella principale) ha la Regola 13:
```
SE MODIFICA FILE → spawn-workers (finestra separata!)
SE SOLO LEGGE → Task tool (interno)
```

**MA LA VIOLA CONTINUAMENTE!**

Esempi dalla sessione 90:
1. Ha scritto STUDIO_VIA_FACILE.md direttamente
2. Ha modificato CHECKLIST_AZIONE.md direttamente
3. Stava per fare altri edit diretti

Rafa ha dovuto correggere 3 VOLTE nella stessa sessione.

---

## Domande da Rispondere

### 1. PERCHÉ succede?

- È pigrizia? (via facile)
- È mancanza di un "trigger" mentale?
- È perché spawn-workers richiede più passi?
- È perché la Regina non "sente" la regola come sua?

### 2. COME si può risolvere?

Esplorare soluzioni:

**A. Hook Tecnico (pre-edit)**
- Intercettare Edit tool quando usato dalla Regina
- Se file non è NORD.md/PROMPT_RIPRESA.md → bloccare
- Pro: automatico, impossibile violare
- Contro: richiede modifiche a Claude Code (possibile?)

**B. Prompt Engineering**
- Aggiungere reminder FORTE nel system prompt
- "PRIMA DI OGNI EDIT: È un file che dovrebbe modificare un worker?"
- Pro: semplice
- Contro: già provato, non funziona

**C. Workflow Forzato**
- La Regina DEVE sempre creare task prima
- Anche per file piccoli
- Pro: crea abitudine
- Contro: overhead per task banali

**D. Eccezioni Chiare**
- Definire ESATTAMENTE quali file la Regina PUÒ modificare
- Tutto il resto → spawn-workers OBBLIGATORIO
- Pro: regola chiara
- Contro: serve disciplina

**E. Automazione Completa**
- Quando la Regina vuole modificare un file
- Automaticamente: crea task + spawna worker
- La Regina non ha più accesso diretto a Edit per certi file
- Pro: impossibile violare
- Contro: complessità implementazione

### 3. COSA può modificare la Regina direttamente?

Proposta di whitelist:
- NORD.md (bussola, deve essere veloce)
- PROMPT_RIPRESA.md (memoria, deve essere veloce)
- .swarm/tasks/*.md (creare task per altri)
- Comandi bash di verifica (non modifica)

Tutto il resto → SPAWN-WORKERS!

### 4. COME implementare la soluzione?

- Quale soluzione è la PIÙ GIUSTA (non la più facile)?
- Come testarla?
- Come verificare che funzioni?

---

## Output Atteso

1. **Analisi** del perché la Regina viola la regola
2. **Proposta** di soluzione (la più GIUSTA, non la più facile!)
3. **Piano implementazione** concreto
4. **Whitelist** file che la Regina può modificare
5. **Checklist** per la Regina da seguire PRIMA di ogni edit

---

## Contesto Aggiuntivo

Leggere:
- `~/.claude/agents/cervella-orchestrator.md` - DNA Regina
- `docs/studio/STUDIO_VIA_FACILE.md` - Pattern via facile
- `~/.claude/CHECKLIST_AZIONE.md` - Regole attuali
- `~/.claude/CLAUDE.md` - Istruzioni operative

---

## Checklist Verifica

- [ ] Analisi completa del problema
- [ ] Almeno 3 soluzioni proposte con pro/contro
- [ ] Soluzione GIUSTA identificata (non quella facile!)
- [ ] Piano implementazione dettagliato
- [ ] Whitelist file Regina definita

---

*Task creato da Cervella Regina - Sessione 90*
*"Devo capire perché non seguo le mie stesse regole"*
