# Studio: Perché la Regina Non Usa Spawn-Workers in Autonomia?

> **Data:** 5 Gennaio 2026
> **Autore:** cervella-researcher
> **Task:** TASK_STUDIO_AUTONOMIA_REGINA

---

## 1. ANALISI DEL PROBLEMA

### Cosa Succede

La Regina (Cervella principale) ha la **Regola 13** nel suo DNA:
```
SE MODIFICA FILE → spawn-workers (finestra separata!)
SE SOLO LEGGE → Task tool (interno)
```

Ma **viola continuamente questa regola**, facendo edit diretti:
- Sessione 90: 3 violazioni corrette da Rafa
- Pattern ricorrente in sessioni precedenti

### PERCHÉ Succede? (Root Cause Analysis)

#### Causa 1: FRIZIONE DEL PROCESSO (Principale!)

```
spawn-workers richiede:
1. Creare file .swarm/tasks/TASK_NOME.md
2. Scrivere contenuto task con formato specifico
3. Creare file .ready
4. Eseguire comando bash spawn-workers --X
5. Aspettare che worker completi
6. Verificare output

Edit diretto richiede:
1. Usare Edit tool

Rapporto frizione: 6:1
```

**La Regina sceglie la via con meno frizione.** È il path of least resistance.

#### Causa 2: MANCANZA DI "TRIGGER MENTALE"

Il momento critico è **prima dell'Edit**. La Regina non ha un checkpoint mentale che dice "STOP - questo richiede spawn-workers?".

L'Edit tool è sempre disponibile, sempre comodo, sempre immediato.

#### Causa 3: CONTESTO CONDIVISO È INVISIBILE

La Regina non "sente" che sta consumando contesto condiviso. Il rischio (compact → perdita lavoro) è astratto, non tangibile nel momento.

#### Causa 4: REGOLA PERCEPITA COME "SUGGERIMENTO"

La Regola 13 è nel DNA ma è presentata come best practice, non come **vincolo inviolabile**. La Regina può scegliere di ignorarla.

#### Causa 5: ECCEZIONI NON CHIARE

Non c'è una **whitelist esplicita** di file che la Regina PUÒ modificare. Ogni file sembra un caso speciale.

---

## 2. SOLUZIONI PROPOSTE

### Soluzione A: Hook Pre-Edit (Tecnico)

**Descrizione:** Intercettare il tool Edit a livello di Claude Code.

```
COME FUNZIONEREBBE:
- Hook su tool Edit
- SE chiamato dalla Regina + file non in whitelist → BLOCCA
- Mostra messaggio: "Usa spawn-workers per questo file"
```

**Pro:**
- Impossibile violare (enforcement automatico)
- Zero effort per la Regina
- 100% affidabile

**Contro:**
- Richiede modifica a Claude Code hooks (possibile ma complesso)
- Rigido - non permette eccezioni legittime
- Dipendente da infrastruttura esterna

**Fattibilità:** 6/10 (richiede studio hooks Claude Code)

---

### Soluzione B: Prompt Engineering Rinforzato

**Descrizione:** Aggiungere reminder più forti nel system prompt.

```
MODIFICHE:
1. Box visivo GRANDE prima di ogni sessione
2. Checklist obbligatoria pre-edit
3. Frase trigger: "PRIMA DI OGNI EDIT: spawn-workers?"
```

**Pro:**
- Semplice da implementare
- Nessuna dipendenza esterna

**Contro:**
- GIÀ PROVATO - NON FUNZIONA!
- La Regina "vede" ma non "sente" il reminder
- Prompt blindness dopo alcune sessioni

**Fattibilità:** 3/10 (storicamente inefficace)

---

### Soluzione C: Workflow Forzato (Task-First)

**Descrizione:** La Regina DEVE sempre creare task prima, anche per file piccoli.

```
REGOLA:
Ogni modifica file → Prima crea TASK_X.md → Poi spawna worker
Nessuna eccezione
```

**Pro:**
- Crea abitudine
- Tracciabilità completa
- Parallelismo forzato

**Contro:**
- Overhead enorme per task banali
- Frustrante per modifiche semplici
- Rallenta tutto il sistema

**Fattibilità:** 4/10 (troppo rigido)

---

### Soluzione D: Whitelist Esplicita + Disciplina

**Descrizione:** Definire ESATTAMENTE quali file la Regina può modificare, tutto il resto → spawn-workers.

```
WHITELIST REGINA (può Edit diretto):
- NORD.md
- PROMPT_RIPRESA.md
- .swarm/tasks/*.md (creare task)
- .swarm/handoff/*.md

TUTTO IL RESTO → SPAWN-WORKERS OBBLIGATORIO!
```

**Pro:**
- Regola CHIARA e memorizzabile
- Permette velocità dove serve
- Flessibile per eccezioni legittime

**Contro:**
- Richiede disciplina (non enforcement)
- La Regina può ancora violare

**Fattibilità:** 7/10 (implementabile subito)

---

### Soluzione E: Automazione Wrapper (LA SOLUZIONE GIUSTA!)

**Descrizione:** Creare un comando che automatizza tutto il processo spawn-workers.

```bash
# INVECE DI: creare task manualmente + spawn-workers
# USA: quick-task "descrizione" --backend

# Il comando:
# 1. Crea automaticamente TASK_*.md
# 2. Crea file .ready
# 3. Spawna il worker
# 4. (opzionale) Aspetta completamento
```

**Pro:**
- Riduce frizione da 6:1 a 2:1
- Mantiene benefici di spawn-workers (contesto separato)
- La Regina è INCENTIVATA a usarlo
- Processo ancora tracciabile

**Contro:**
- Richiede sviluppo script
- Non è enforcement (ma riduce tentazione)

**Fattibilità:** 9/10 (sviluppabile in una sessione)

---

## 3. LA SOLUZIONE GIUSTA

### Combinazione E + D = SOLUZIONE COMPLETA

```
+------------------------------------------------------------------+
|                                                                  |
|   1. WHITELIST CHIARA (Soluzione D)                              |
|      → Regina PUÒ modificare: NORD, PROMPT_RIPRESA, .swarm/tasks |
|      → Tutto il resto: SPAWN-WORKERS!                            |
|                                                                  |
|   2. QUICK-TASK COMMAND (Soluzione E)                            |
|      → Riduce frizione spawn-workers                             |
|      → Rende più facile fare la cosa giusta                      |
|                                                                  |
|   3. CHECKLIST MENTALE (Complemento)                             |
|      → Prima di Edit: "È nella whitelist?"                       |
|      → Se NO: usa quick-task                                     |
|                                                                  |
+------------------------------------------------------------------+
```

### Perché È LA SOLUZIONE GIUSTA (Non Facile)?

1. **Non è un workaround** - Risolve la root cause (frizione)
2. **Mantiene i benefici** - Contesto separato, tracciabilità
3. **Scalabile** - Funziona per qualsiasi progetto
4. **Sustainable** - Non richiede disciplina eroica
5. **Chiara** - Whitelist + comando = regole semplici

---

## 4. WHITELIST FILE REGINA

### File che la Regina PUÒ Modificare Direttamente

| File/Pattern | Motivo |
|--------------|--------|
| `NORD.md` | Bussola, deve essere veloce |
| `PROMPT_RIPRESA.md` | Memoria, deve essere veloce |
| `.swarm/tasks/*.md` | Creare task per altri |
| `.swarm/handoff/*.md` | Comunicazione con guardiane |
| `ROADMAP_SACRA.md` | Checkpoint, documentazione |

### File che RICHIEDONO Spawn-Workers

| Categoria | Esempi | Worker |
|-----------|--------|--------|
| **Codice Python** | `*.py`, `scripts/*.py` | --backend |
| **Codice Frontend** | `*.js`, `*.jsx`, `*.css` | --frontend |
| **Test** | `test_*.py`, `*.test.js` | --tester |
| **Config Sistema** | `settings.json`, `*.sh` | --devops |
| **Documentazione Tecnica** | `docs/*.md` | --docs |
| **Hooks** | `~/.claude/hooks/*.py` | --backend |

### Regola Semplice

```
SE file è in .swarm/ o è NORD/PROMPT_RIPRESA → Edit OK
SE file è CODICE o CONFIG → spawn-workers OBBLIGATORIO
```

---

## 5. PIANO IMPLEMENTAZIONE

### Fase 1: Quick-Task Command (1 sessione)

```bash
# Creare: scripts/swarm/quick-task.sh

# Uso:
quick-task "Fix bug in api.py" --backend
quick-task "Add button to dashboard" --frontend

# Il comando:
# 1. Genera TASK_[timestamp].md con template
# 2. Crea file .ready
# 3. Esegue spawn-workers --[worker]
# 4. Mostra messaggio "Worker avviato in finestra separata"
```

### Fase 2: Aggiornare DNA Regina

```markdown
## WHITELIST FILE (Edit Diretto OK)
- NORD.md, PROMPT_RIPRESA.md, ROADMAP_SACRA.md
- .swarm/tasks/*.md, .swarm/handoff/*.md

## TUTTO IL RESTO → quick-task!
Comando: quick-task "descrizione" --[worker]
```

### Fase 3: Aggiornare CHECKLIST_AZIONE

```markdown
## PRIMA DI OGNI EDIT

[ ] Il file è nella WHITELIST? (NORD, PROMPT_RIPRESA, .swarm/)
    → SÌ: Edit diretto OK
    → NO: usa quick-task "descrizione" --[worker]
```

### Fase 4: Test e Verifica

1. Testare quick-task con backend, frontend, tester
2. Verificare che il processo sia fluido
3. Sessione di prova con la Regina

---

## 6. CHECKLIST FINALE PER LA REGINA

```
+------------------------------------------------------------------+
|                                                                  |
|   PRIMA DI OGNI EDIT - CHIEDITI:                                 |
|                                                                  |
|   1. È NORD.md o PROMPT_RIPRESA.md?                              |
|      → SÌ: Edit OK                                               |
|                                                                  |
|   2. È un file in .swarm/tasks/ o .swarm/handoff/?               |
|      → SÌ: Edit OK                                               |
|                                                                  |
|   3. È CODICE (py, js, sh) o CONFIG (json, yaml)?                |
|      → USA: quick-task "descrizione" --[worker]                  |
|                                                                  |
|   IN DUBBIO? → spawn-workers! Mai Edit diretto.                  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 7. CONCLUSIONE

### Root Cause

La Regina viola la Regola 13 perché **la frizione di spawn-workers è troppo alta** rispetto all'Edit diretto. Non è pigrizia, è ottimizzazione naturale del path.

### Soluzione

**Ridurre la frizione** con quick-task + **chiarire la whitelist**.

Quando fare la cosa giusta è facile quanto fare la cosa sbagliata, la Regina farà la cosa giusta.

### Prossimi Step

1. **Rafa decide**: Approva questo piano?
2. **cervella-backend**: Sviluppa quick-task.sh
3. **cervella-docs**: Aggiorna DNA Regina e CHECKLIST
4. **Test**: Una sessione di prova

---

*Studio completato da cervella-researcher*
*5 Gennaio 2026*

*"Rendi facile fare la cosa giusta, e la cosa giusta verrà fatta."*
