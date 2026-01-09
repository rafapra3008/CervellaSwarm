# HANDOFF - Sessione 134

> **Data:** 9 Gennaio 2026
> **Per:** Prossima sessione

---

## STATO ATTUALE

### FASE 1: COMPLETATA!
- CLAUDE.md: 199 -> 47 linee (-86%)
- PROMPT_RIPRESA: 555 -> 65 linee (-92%)
- Risparmio: ~5,900 token per sessione

### FASE 2: IN CORSO
- Backup DNA fatto: `~/.claude/agents_backup_20260109`
- Sezione context-smart pronta: `templates/DNA_CONTEXT_SMART_SECTION.md`
- Script creato ma non testato: `scripts/update-dna-context-smart.sh`
- **DA FARE:** Aggiungere sezione a 16 DNA

---

## COSA FARE NELLA PROSSIMA SESSIONE

### 1. Completare FASE 2.2: Aggiornare i 16 DNA

Ogni file in `~/.claude/agents/cervella-*.md` deve avere questa sezione aggiunta PRIMA di "## Le Mie Specializzazioni":

```markdown
## REGOLE CONTEXT-SMART

> "MINIMO in memoria, MASSIMO su disco"

### 1. Non Sprecare Token
- Output CONCISO e strutturato
- Max 500 token per risposta normale
- No narrativa lunga, vai al punto

### 2. Usa SNCP (Memoria Esterna)
Se il progetto ha `.sncp/`:
- Scrivi idee in `.sncp/idee/`
- Scrivi decisioni in `.sncp/memoria/decisioni/`
- NON accumulare tutto nel context

### 3. Regola dei 5 Minuti
- Se il task richiede > 5 minuti, AVVISA
- Potrebbe servire un clone separato
- La Regina decidera come procedere

### 4. Output Strutturato
Formato per risposte:
FATTO: [completato]
DA FARE: [prossimi step]
NOTE: [info importanti]
```

### 2. Poi FASE 2.3: CLAUDE.md globale snello

Target: da 527 linee a ~180 linee

---

## FILE IMPORTANTI CREATI

| File | Descrizione |
|------|-------------|
| `CLAUDE.md` | Versione snella (47 linee) |
| `PROMPT_RIPRESA.md` | Versione snella (65 linee) |
| `templates/CLAUDE_MD_PROGETTO_TEMPLATE.md` | Template riutilizzabile |
| `templates/PROMPT_RIPRESA_TEMPLATE.md` | Template riutilizzabile |
| `docs/guide/GUIDA_GIT_CLONES_REGINA.md` | Guida completa git clones |
| `scripts/swarm/create-worker-clone.sh` | Script per creare clones |
| `.sncp/idee/LA_NOSTRA_STRADA_ROADMAP_FINALE.md` | Roadmap completa |

---

## DECISIONI CHIAVE (da ricordare)

| Decisione | Perche |
|-----------|--------|
| Task < 5 min = Task tool | Veloce |
| Task > 5 min = Git clone | Preserva context |
| 2-3 worker max | Stabilizzare prima |
| SNCP = memoria esterna | Disco infinito |
| Tutti 16 DNA insieme | Evita confusione |

---

## COMANDI UTILI

```bash
# Vedere backup DNA
ls ~/.claude/agents_backup_20260109/

# Verificare se sezione gia presente
grep -l "REGOLE CONTEXT-SMART" ~/.claude/agents/*.md

# Pattern per trovare dove inserire
grep -n "## Le Mie Specializzazioni" ~/.claude/agents/cervella-*.md
```

---

*"MINIMO in memoria, MASSIMO su disco"*
