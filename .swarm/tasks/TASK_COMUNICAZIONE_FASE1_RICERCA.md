# Task: FASE 1 - Studio Protocolli Comunicazione Multi-Agent

**Assegnato a:** cervella-researcher
**Stato:** ready
**Priorità:** ALTISSIMA
**Progetto:** CervellaSwarm
**Sub-Roadmap:** SUB_ROADMAP_COMUNICAZIONE_INTERNA.md

---

## CONTESTO

Rafa ha dato una DIREZIONE chiara:

```
"LA COMUNICAZIONE INTERNA DEVE ESSERE MEGLIO!"
                            - Rafa, 7 Gennaio 2026
```

Stiamo migliorando come le 16 api della famiglia parlano tra loro.
Tu devi fare la RICERCA per capire le best practices.

**Sub-roadmap completa:** `docs/roadmap/SUB_ROADMAP_COMUNICAZIONE_INTERNA.md`

---

## OBIETTIVO

Ricerca approfondita su come sistemi multi-agent comunicano efficacemente.

**Focus:** Protocolli, pattern, best practices per comunicazione tra:
- Regina (orchestratrice)
- Worker (esecutori)
- Guardiane (verificatori)

---

## LE 4 DOMANDE DA RISPONDERE

### 1. Protocolli Comunicazione Multi-Agent

**Cosa cercare:**
- Come comunicano sistemi multi-agent esistenti? (AutoGen, CrewAI, LangGraph, altri)
- Quali pattern di comunicazione funzionano meglio?
- Handoff (passaggio task), feedback loop, tracking stati - best practices
- Formati dati (JSON, markdown, strutturato vs non-strutturato)

**Output atteso:**
- Analisi di almeno 3-4 sistemi multi-agent
- Pattern comuni identificati
- Pro/contro di ogni approccio

### 2. Context Transfer Ottimale

**Cosa cercare:**
- Quanto contesto serve passare a un worker?
- Troppo contesto = overhead, poco = inefficienza - come bilanciare?
- Come strutturare le info (formato, template, sezioni)?
- Context compression techniques
- Cosa includere SEMPRE, cosa includere SE SERVE, cosa NON includere MAI

**Output atteso:**
- Linee guida su quantità contesto ottimale
- Template consigliato per handoff
- Best practices context transfer

### 3. Real-time Status Tracking

**Cosa cercare:**
- Come monitorare worker senza interruzioni?
- Pattern: heartbeat, progress file, log streaming, event-driven
- Come notificare orchestratore automaticamente?
- Scalabilità: 1 worker vs 10 worker paralleli
- Tools: filesystem watching, message queues, polling, websockets

**Output atteso:**
- Confronto approcci (pro/contro)
- Raccomandazione per CervellaSwarm
- Considerazioni scalabilità

### 4. Error Handling e Resilienza

**Cosa cercare:**
- Worker bloccato - pattern detection e recovery
- Worker trova bug - escalation protocols
- Timeout strategies
- Retry con backoff
- Graceful degradation
- Circuit breaker pattern per multi-agent

**Output atteso:**
- Error handling best practices
- Pattern per robustezza
- Come prevenire cascading failures

---

## METODOLOGIA RICERCA

### Fase 1: Web Search (2-3 ore)

**Keyword da cercare:**
- "multi-agent communication protocols"
- "agent orchestration patterns"
- "LangGraph multi-agent communication"
- "AutoGen agent handoff"
- "CrewAI task delegation"
- "multi-agent system context transfer"
- "agent monitoring real-time"
- "multi-agent error handling"

**Fonti prioritarie:**
- Documentazione ufficiale (LangGraph, AutoGen, CrewAI)
- Paper accademici su multi-agent systems
- Blog post tecnici (engineering blogs)
- GitHub repositories con esempi reali

### Fase 2: Analisi Comparativa

Crea tabella comparativa:
| Sistema | Handoff | Context | Status | Error Handling |
|---------|---------|---------|--------|----------------|
| LangGraph | ... | ... | ... | ... |
| AutoGen | ... | ... | ... | ... |
| CrewAI | ... | ... | ... | ... |
| Altri | ... | ... | ... | ... |

### Fase 3: Sintesi e Raccomandazioni

Per ogni domanda:
- Cosa funziona meglio in generale
- Cosa si applica a CervellaSwarm
- Cosa evitare
- Raccomandazione specifica

---

## OUTPUT RICHIESTO

**File:** `docs/studio/STUDIO_COMUNICAZIONE_PROTOCOLLI.md`

**Struttura:**

```markdown
# STUDIO: Protocolli Comunicazione Multi-Agent

> Data: 7 Gennaio 2026
> Ricercatrice: cervella-researcher
> Progetto: CervellaSwarm - Comunicazione Interna

## Executive Summary
[2-3 paragrafi: cosa hai scoperto, raccomandazioni chiave]

## 1. Protocolli Comunicazione Multi-Agent
### Sistemi Analizzati
[LangGraph, AutoGen, CrewAI, altri...]
### Pattern Comuni
[Quali pattern emergono?]
### Best Practices
[Cosa funziona meglio?]
### Raccomandazioni per CervellaSwarm
[Cosa dovremmo fare noi?]

## 2. Context Transfer Ottimale
[stessa struttura]

## 3. Real-time Status Tracking
[stessa struttura]

## 4. Error Handling e Resilienza
[stessa struttura]

## Sintesi Finale
[Conclusioni, prossimi step]

## Fonti
[Link a tutte le fonti consultate]
```

**Lunghezza target:** 800-1200 righe (studio COMPLETO!)

---

## SUCCESS CRITERIA

✅ Analizzati almeno 3-4 sistemi multi-agent reali
✅ Risposto a tutte le 4 domande con dettaglio
✅ Raccomandazioni chiare per CervellaSwarm
✅ Fonti citate e linkate
✅ Studio pronto per FASE 2 (definizione protocolli)

---

## NOTE IMPORTANTI

### Qualità vs Velocità

```
Preferisco uno studio OTTIMO in 3 ore
che uno studio MEDIOCRE in 1 ora.

Prenditi il tempo necessario.
Approfondisci.
La comunicazione è FONDAMENTALE per lo sciame.
```

### Focus CervellaSwarm

```
Siamo diversi da altri sistemi:
- Finestre separate (non shared memory)
- Filesystem come comunicazione
- spawn-workers (Terminal + osascript)
- 16 agenti con ruoli chiari
- Regina + 3 Guardiane + 12 Worker

Cerca soluzioni che SI ADATTANO al nostro sistema!
```

### Fonti Affidabili

```
Priorità:
1. Documentazione ufficiale
2. Paper accademici
3. Engineering blogs (Anthropic, OpenAI, etc.)
4. GitHub repos con esempi reali

Evita:
- Tutorial superficiali
- Blog post senza fonti
- Opinioni non validate
```

---

## QUANDO HAI FINITO

1. Salva lo studio in `docs/studio/STUDIO_COMUNICAZIONE_PROTOCOLLI.md`
2. Crea file `.done` in questa cartella
3. Il watcher notificherà la Regina
4. La Regina leggerà il tuo studio e procederà con FASE 2!

---

## DOMANDE?

Se hai dubbi:
- Usa `ask-regina.sh` (se esiste già)
- Oppure crea file in `.swarm/feedback/` con le tue domande
- La Regina risponderà!

---

**Energia positiva!** ❤️‍🔥
**Ricerca approfondita!** 🔬
**Per il bene della famiglia!** 🐝👑

*"Ultrapassar os próprios limites!"* 🚀

---

Buon lavoro, cervella-researcher! 💙
