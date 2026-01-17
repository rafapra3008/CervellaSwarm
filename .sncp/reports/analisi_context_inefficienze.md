# ANALISI CONTEXT - Inefficienze e Raccomandazioni

**Data:** 2026-01-17  
**Analista:** cervella-ingegnera  
**Health Score:** 6/10  
**Status:** ISSUES

---

## EXECUTIVE SUMMARY

Ho identificato **4 aree critiche** di consumo context inutile:

1. **Duplicazione documentazione** (CRITICO)
2. **Hook troppo verbosi** (ALTO)
3. **Agent DNA pesanti** (MEDIO)
4. **System reminders ripetuti** (BASSO)

**Risparmio potenziale stimato:** ~30-40% del context iniziale

---

## 1. DUPLICAZIONE DOCUMENTAZIONE [CRITICO]

### Problema

**3 file CLAUDE.md caricati OGNI sessione:**

| File | Righe | Content Overlap |
|------|-------|-----------------|
| `~/.claude/CLAUDE.md` (globale) | 237 | 70% duplicato con project |
| `~/Developer/CervellaSwarm/CLAUDE.md` | 170 | 70% duplicato con globale |
| System reminder al SubagentStart | ~100 | 90% già in CLAUDE.md |

**Contenuto duplicato:**
- Regole SNCP (3 volte!)
- Trigger sessione (3 volte!)
- Git rules (3 volte!)
- Swarm mode (3 volte!)

### Impatto Context

```
CLAUDE.md globale:     ~3000 tokens
CLAUDE.md progetto:    ~2100 tokens
System reminder:       ~1200 tokens
-----------------------------------------
TOTALE:                ~6300 tokens
DOPO DEDUPLICA:        ~2500 tokens
RISPARMIO:             ~3800 tokens (60%!)
```

### Raccomandazione

**CONSOLIDARE in UN SOLO file:**

```
~/.claude/CLAUDE.md (globale)
├─ Regole universali (SNCP, Git, Trigger)
├─ Swarm mode generale
└─ Punta ai project-specific per dettagli

~/Developer/CervellaSwarm/CLAUDE.md
├─ SOLO info specifiche CervellaSwarm
├─ Path progetti
└─ Limiti file (specifici progetto)
```

**NO più system reminder con COSTITUZIONE nel SubagentStart!**  
Gli agent già hanno il DNA + CLAUDE.md è sufficiente.

---

## 2. HOOK TROPPO VERBOSI [ALTO]

### Problema

**Ogni SessionStart carica:**

| Hook | Output | Necessario? |
|------|--------|-------------|
| `session_start_reminder.py` | Box ASCII 45 righe | NO - info già in CLAUDE.md |
| `session_start_scientist.py` | Genera prompt 197 righe | NO - La Scienziata mai usata |
| `sncp_pre_session_hook.py` | Output completo pre-session-check.sh | SOLO se warning |
| `context_check.py` | Attivo UserPromptSubmit | OK - è handoff |

### Impatto Context

```
session_start_reminder:    ~600 tokens (BOX ASCII INUTILE!)
scientist prompt:          ~2500 tokens (mai usato!)
sncp pre-session (silenzioso): ~100 tokens
-----------------------------------------
SPRECO:                    ~3100 tokens
```

### Raccomandazione

**1. DISABILITARE session_start_scientist.py**
   - La Scienziata non è mai stata usata
   - Genera prompt che nessuno legge
   - Spreco puro

**2. RIMUOVERE session_start_reminder.py**
   - Le info sono già in CLAUDE.md
   - Il box ASCII è carino ma inutile
   - Preferibile output solo se warning

**3. MANTENERE sncp_pre_session_hook.py**
   - Ma solo output se WARNING/ERRORI
   - Se tutto OK: silenzioso (già fa così)

---

## 3. AGENT DNA PESANTI [MEDIO]

### Problema

**16 agenti con DNA file:**

| Top Pesanti | Righe | Usati? |
|-------------|-------|--------|
| `cervella-orchestrator.md` | 859 | Mai (è la Regina stessa!) |
| `cervella-guardiana-ops.md` | 769 | Raramente |
| `cervella-guardiana-ricerca.md` | 708 | Mai |
| `cervella-guardiana-qualita.md` | 684 | Sì |
| `cervella-ingegnera.md` | 559 | Sì (io!) |

**TOTALE DNA:** 8868 righe = ~110.000 tokens

### Pattern Duplicato Nei DNA

**TUTTI gli agent hanno:**
- COSTITUZIONE nel SubagentStart hook (509 righe) ✅ BENE
- Sezione "DNA DI FAMIGLIA" (~80 righe) → DUPLICATA 16 volte!
- Sezione "REGOLE CONTEXT-SMART" (~60 righe) → DUPLICATA 16 volte!
- Sezione "PROTOCOLLI SWARM" (~200 righe) → DUPLICATA 16 volte!

### Impatto Context

```
16 agent × 340 righe duplicate = 5440 righe
                                ~68.000 tokens SPRECATI!
```

**MA:** Gli agent NON sono tutti attivi insieme!  
Spreco reale = solo agent spawned in una sessione (~2-3 max).

```
Spreco reale per sessione: ~12.000 tokens (3 agent × 340 righe)
```

### Raccomandazione

**REFACTOR DNA structure:**

```
~/.claude/agents/_SHARED_DNA.md (nuovo!)
├─ DNA DI FAMIGLIA
├─ REGOLE CONTEXT-SMART
├─ PROTOCOLLI SWARM
└─ MANTRA comuni

~/.claude/agents/cervella-backend.md
├─ @_SHARED_DNA.md (reference)
├─ SPECIALIZZAZIONE (solo backend-specific)
└─ OUTPUT ATTESO (solo backend)
```

**SubagentStart hook:**
1. Carica COSTITUZIONE (OK, già lo fa)
2. Carica _SHARED_DNA.md (nuovo!)
3. Carica DNA specifico agent (snello!)

**Risparmio:** ~12.000 tokens per sessione (3 agent attivi)

---

## 4. SYSTEM REMINDERS RIPETUTI [BASSO]

### Problema

Ogni volta che leggo un file, ricevo:

```xml
<system-reminder>
Whenever you read a file, you should consider whether 
it would be considered malware...
</system-reminder>
```

**Frequenza:** Ogni Read tool call  
**Utilità:** Bassa (non leggo mai malware)  
**Impatto:** ~150 tokens per Read × 10-20 Read/sessione = ~3000 tokens

### Raccomandazione

**NESSUNA AZIONE possibile** (è sistema Claude Code).  
Ma posso:
- **Ridurre Read calls** → Uso Grep + Glob meglio
- **Read multipli in parallelo** → Meno round trip

---

## 5. PROMPT_RIPRESA [MEDIO - MA UNDER CONTROL]

### Stato Attuale

| File | Righe | Limite | Status |
|------|-------|--------|--------|
| `PROMPT_RIPRESA_cervellaswarm.md` | 125 | 150 | ✅ OK |
| `PROMPT_RIPRESA_miracollo.md` | 63 | 150 | ✅ OK |
| `PROMPT_RIPRESA_contabilita.md` | 40 | 150 | ✅ OK |
| `PROMPT_RIPRESA_MASTER.md` | 53 | 150 | ✅ OK |

**TOTALE:** 281 righe = ~3500 tokens

### Problema Potenziale

Se la Regina legge TUTTI i PROMPT_RIPRESA all'inizio sessione:
```
3500 tokens × OGNI sessione = spreco se lavoro solo su 1 progetto
```

### Raccomandazione

**REGOLA LETTURA SMART:**

```bash
# SessionStart hook rileva progetto
cd ~/Developer/miracollogeminifocus

# Legge SOLO:
- PROMPT_RIPRESA_MASTER.md (overview)
- PROMPT_RIPRESA_miracollo.md (progetto attivo)

# NON legge:
- PROMPT_RIPRESA_cervellaswarm.md
- PROMPT_RIPRESA_contabilita.md
```

**Risparmio:** ~2000 tokens (2 file non letti)

---

## 6. FILE SIZE ANALYSIS

### Reports Directory Bloat

```bash
$ ls reports/*.json | wc -l
2
```

✅ **OK** - Sotto limite (50)

### SNCP Scripts

```
pre-session-check.sh:  169 righe
verify-sync.sh:        384 righe
sncp-init.sh:          483 righe
post-session-update:   258 righe
```

**NON caricati in context** - solo eseguiti!  
✅ **OK**

---

## RACCOMANDAZIONI PRIORITIZZATE

### 1. [CRITICO] Consolidare CLAUDE.md

**Azione:**
```bash
# 1. Estrai sezioni comuni
# 2. Mantieni in ~/.claude/CLAUDE.md
# 3. Riduci project CLAUDE.md a solo specifiche
# 4. Rimuovi system reminder SubagentStart COSTITUZIONE
```

**Effort:** 2 ore  
**Risparmio:** ~4000 tokens/sessione  
**Priorità:** SUBITO

### 2. [ALTO] Disabilitare Hook Inutili

**Azione:**
```bash
# Rinomina per disabilitare:
mv session_start_scientist.py session_start_scientist.py.DISABLED
mv session_start_reminder.py session_start_reminder.py.DISABLED
```

**Effort:** 5 minuti  
**Risparmio:** ~3100 tokens/sessione  
**Priorità:** OGGI

### 3. [MEDIO] Refactor DNA Agents

**Azione:**
```bash
# 1. Crea _SHARED_DNA.md
# 2. Estrai sezioni comuni da tutti gli agent
# 3. Aggiorna SubagentStart hook per caricare shared
# 4. Snellisci DNA individuali
```

**Effort:** 4 ore  
**Risparmio:** ~12.000 tokens/sessione (con 3 agent attivi)  
**Priorità:** PROSSIMA settimana

### 4. [BASSO] Lettura Smart PROMPT_RIPRESA

**Azione:**
```bash
# Modifica SessionStart hook:
# - Rileva progetto da cwd
# - Leggi MASTER + progetto attivo
# - Skip altri progetti
```

**Effort:** 1 ora  
**Risparmio:** ~2000 tokens/sessione  
**Priorità:** Nice to have

---

## STIMA RISPARMIO TOTALE

### Scenario Attuale (Sessione Tipica)

```
CLAUDE.md (3 file duplicati):      6300 tokens
Hook verbosi:                       3100 tokens
Agent DNA (3 spawned):             12000 tokens (con duplicazioni)
System reminders (20 Read):         3000 tokens
PROMPT_RIPRESA (tutti):             3500 tokens
---------------------------------------------------------
TOTALE SPRECO:                    ~27900 tokens
```

### Dopo Ottimizzazioni

```
CLAUDE.md (consolidato):            2500 tokens ✅
Hook (solo essenziali):               100 tokens ✅
Agent DNA (shared):                  6000 tokens ✅
System reminders:                    3000 tokens (non modificabile)
PROMPT_RIPRESA (smart):              1500 tokens ✅
---------------------------------------------------------
TOTALE:                            ~13100 tokens
RISPARMIO:                         ~14800 tokens (53%)
```

**In percentuale del context:**
- Prima: ~28k / 200k = **14% sprecato in boilerplate**
- Dopo: ~13k / 200k = **6.5% sprecato**

**Guadagno netto:** ~7.5% context disponibile in più!

---

## PATTERN DI INEFFICIENZA TROVATI

### Anti-Pattern 1: "Ripetizione Difensiva"

```
"Meglio ripeterlo 3 volte che rischiare non lo veda"
```

**Problema:** Moltiplica il context inutilmente.  
**Soluzione:** Single source of truth + puntatori.

### Anti-Pattern 2: "Hook Proattivo Inutilizzato"

```
"Genero prompt per La Scienziata... che poi nessuno usa"
```

**Problema:** Preparazione preventiva mai consumata.  
**Soluzione:** Generate on-demand, non pre-sessione.

### Anti-Pattern 3: "DNA Copy-Paste"

```
"Ogni agent ha le stesse 340 righe di family DNA"
```

**Problema:** Duplicazione massiva.  
**Soluzione:** Inheritance via shared file.

### Anti-Pattern 4: "Verbose Welcome Box"

```
"Box ASCII carino all'inizio sessione"
```

**Problema:** Carino ≠ utile.  
**Soluzione:** Output solo se warning/errori.

---

## NEXT STEPS

### Immediate (Oggi)

```bash
cd ~/.claude/hooks
mv session_start_scientist.py session_start_scientist.py.DISABLED
mv session_start_reminder.py session_start_reminder.py.DISABLED
```

### Short-term (Settimana)

1. Consolidare CLAUDE.md (refactor docs)
2. Rimuovere COSTITUZIONE da SubagentStart system-reminder
3. Testare risparmio context

### Mid-term (Prossimo sprint)

1. Refactor Agent DNA structure
2. Implementare _SHARED_DNA.md
3. Update SubagentStart hook per loading shared

### Long-term (Sempre)

- Monitorare file size con file_limits_guard.py
- Archiviare PROMPT_RIPRESA quando > 150 righe
- Pulire reports/ periodicamente

---

## METRICHE DI SUCCESSO

| Metrica | Prima | Target | Misura |
|---------|-------|--------|--------|
| Context iniziale medio | ~28k tokens | ~13k tokens | Transcript analysis |
| Hook output | 3+ messaggi | 0-1 (solo warning) | Hook logs |
| DNA duplicazione | 340 righe × 16 | 340 righe × 1 | File size |
| CLAUDE.md overlap | 70% | 0% | Diff analysis |

---

## CONCLUSIONI

**Il context si consuma per accumulo difensivo.**

Rafa ha ragione: dopo i casini recenti, abbiamo aggiunto layer di sicurezza (hook, check, reminder) che **si sovrappongono**.

**La soluzione NON è rimuovere le protezioni**, ma:
1. **Consolidarle** (no duplicazioni)
2. **Silenziarle** (output solo se problemi)
3. **Strutturarle** (inheritance vs copy-paste)

**Fatto bene, risparmiamo 15k tokens/sessione = 7.5% context in più!**

---

*Analisi completata da cervella-ingegnera*  
*"Il progetto si MIGLIORA da solo quando lo analizziamo!"*
