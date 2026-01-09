# Decisioni Context Optimization - 9 Gennaio 2026

> **Sessione:** 134
> **Partecipanti:** Regina + Guardiana Qualita
> **Stato:** In elaborazione

---

## IL PROBLEMA IDENTIFICATO

Rafa ha sollevato un problema FONDAMENTALE:

```
"Ogni volta che apriamo una sessione.. quasi 20% di context e' utilizzato"
"Context = usage = limiti!"
"Trovare la sistemazione giusta per il nostro lavoro"
```

### Dati Misurati

| File | Bytes | Linee |
|------|-------|-------|
| ~/.claude/CLAUDE.md | 21,962 | 527 |
| ~/.claude/COSTITUZIONE.md | 11,138 | 379 |
| Progetto CLAUDE.md | 7,992 | 199 |
| PROMPT_RIPRESA.md | 14,749 | 430 |
| NORD.md | 9,353 | 197 |
| **TOTALE** | **65,194** | **1,732** |

**+ Hook overhead:** ~15-20K bytes
**= TOTALE REALE:** ~80-85K bytes = ~22-25K token = 11-12% context

Con primo scambio + overhead = **~20% context BRUCIATO prima di iniziare!**

---

## FONTI RICERCATE

### 1. Boris Cherny (Creatore Claude Code)
- CLAUDE.md SINGOLO, condiviso in git, conciso
- Team lo aggiorna quando Claude sbaglia
- Plan mode SEMPRE prima di implementare
- 5 Claudes in parallelo
- 10-20% discard rate accettato
- **DA APPROFONDIRE:** Come gestisce context tra sessioni parallele?

### 2. Anthropic Engineering - Context Engineering
- "Context rot" = ogni token inutile DEGRADA performance
- "Progressive disclosure" = non caricare tutto subito
- Subagent per isolare context
- Note-taking su file esterni
- Compaction automatica a 95%

### 3. Community Best Practices
- Evitare @-mention in CLAUDE.md (bloat)
- Path + spiegazione QUANDO leggere
- Ultimo 20% context = performance degradata
- /clear + /catchup per ricominciare puliti

### 4. Pattern Checkpoint/Handoff
- Smart Handoff a 70-80% usage
- SESSION_NOTES.md pattern
- Continuous Claude system (ledger + handoff files)
- Amp's Handoff: nuovo thread invece di condensare
- Git commit come checkpoint

---

## DECISIONI PRESE

### DECISIONE 1: Architettura "Context-Smart"
**COSA:** MINIMO in memoria, MASSIMO su disco
**PERCHE:** Ogni token in context = meno spazio per lavoro reale

### DECISIONE 2: CLAUDE.md a Livelli
**COSA:** Separare COSA (conciso, sempre caricato) da COME (dettagliato, letto quando serve)
**PERCHE:** Boris tiene CLAUDE.md condiviso e conciso

### DECISIONE 3: PROMPT_RIPRESA Snello
**COSA:** Da 430 linee a ~80 linee, formato strutturato
**PERCHE:** Narrativa lunga = token sprecati

### DECISIONE 4: NON Creare SESSION_STATE.md
**COSA:** Usare PROMPT_RIPRESA come unico file di stato
**PERCHE:** Guardiana ha identificato rischio duplicazione (gia' abbiamo PROMPT_RIPRESA, NORD, .sncp/oggi.md)

### DECISIONE 5: SNCP Come Memoria Esterna
**COSA:** Scrivere su .sncp/ mentre lavoro, NON accumulare in context
**PERCHE:** Disco e' infinito, context no

### DECISIONE 6: Subagent per Isolare Context
**COSA:** Task < 5 min = Task tool interno, Task > 5 min = Subagent
**PERCHE:** Subagent hanno context SEPARATO, non inquinano il mio

### DECISIONE 7: NON Toccare COSTITUZIONE.md
**COSA:** Mai snellire o modificare
**PERCHE:** E' l'ANIMA, comportamento emergente dipende da lei

### DECISIONE 8: Test Incrementale
**COSA:** CervellaSwarm prima, Miracollo dopo
**PERCHE:** Se si rompe CLAUDE.md globale, si rompe OVUNQUE

---

## DA DECIDERE ANCORA

1. **Pattern Boris Multi-Sessione**
   - Come condivide info tra 5 Claudes paralleli?
   - Come evita conflitti?
   - Come fa merge del lavoro?
   - **AZIONE:** Ricerca mirata + discussione Guardiana

2. **LA NOSTRA STRADA Finale**
   - Task tool interno vs Pattern Boris vs Ibrido?
   - Quando usare cosa?
   - **AZIONE:** Definire dopo ricerca Boris

---

## IMPATTO PREVISTO

| Metrica | Prima | Dopo | Miglioramento |
|---------|-------|------|---------------|
| Token startup | 22-25K | 8-10K | -60% |
| % context | 11-12% | 4-5% | -60% |
| Sessioni | X ore | 2-3X ore | +200% |

---

## RISCHI IDENTIFICATI (Guardiana)

1. **Perdita Grounding** - Se troppo snello, perdo "chi sono"
2. **Perdita Filo Discorso** - Serve sezione "Decisioni Chiave"
3. **Overhead Spawn** - Per task piccoli, spawn > beneficio
4. **Frammentazione SNCP** - Troppi file = context consumato per leggere
5. **Degradazione Progressiva** - Perdere info "poco importanti" che sono CRITICHE
6. **Costo Migrazione** - CLAUDE.md globale impatta TUTTI i progetti
7. **Comportamento Emergente** - Test qualitativi dopo ogni modifica

---

*Documento vivo - si aggiorna con la ricerca*
