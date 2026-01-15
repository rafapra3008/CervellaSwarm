# RICERCA: Come Garantire Lettura VERA della Costituzione
> Ricerca approfondita su tecniche per assicurare che LLM leggano e internalizzino istruzioni critiche
>
> **Data:** 15 Gennaio 2026
> **Ricercatrice:** cervella-researcher
> **Progetto:** CervellaSwarm

---

## EXECUTIVE SUMMARY

Il problema della "lettura superficiale" delle istruzioni da parte degli LLM è REALE e documentato dalla ricerca accademica. Un paper di Dicembre 2025 mostra **performance drops fino a 61.8%** quando le istruzioni vengono riformulate con leggere variazioni, anche in modelli con score benchmark alti.

**SOLUZIONE CONSIGLIATA per CervellaSwarm:**
Combinare 3 layer di enforcement:
1. **Pre-Flight Check** - Quiz di verifica post-lettura Costituzione
2. **Hook di Behavior Verification** - Validazione automatica comportamento
3. **Self-Verification Pattern** - LLM verifica il proprio output vs principi

**IMPATTO ATTESO:** Riduzione 60-80% degli episodi di "lettura checkbox".

---

## IL PROBLEMA DOCUMENTATO

### Ricerca Accademica (Dicembre 2025)

Paper: ["Revisiting the Reliability of Language Models in Instruction-Following"](https://arxiv.org/abs/2512.14754)

**Scoperta chiave:** I modelli mostrano insufficienza sostanziale nella **nuance-oriented reliability** - l'abilità di mantenere performance costante quando l'utente riformula istruzioni con sottili variazioni.

```
DATI:
- Performance drop: fino a 61.8% con modifiche sfumate al prompt
- Modelli testati: 46 (20 proprietari, 26 open-source)
- Problema: TUTTI mostrano insufficienza, anche con score benchmark alti
```

**Implicazione per noi:**
Anche se un agente "legge" la Costituzione, potrebbe non internalizzare i principi se:
- Li tratta come checkbox
- Non connette principi a comportamenti specifici
- Non verifica la propria comprensione

### Nuovo Benchmark: IFEval++

Costruito tramite generazione automatica di variazioni semanticamente equivalenti dei prompt.

**Metrica introdotta:** `reliable@k` - misura consistenza attraverso k variazioni dello stesso intent.

---

## TECNICHE TROVATE (Pro/Contro)

### 1. SELF-VERIFICATION PROMPTING

**Cos'è:** LLM genera risposta, poi la verifica autonomamente contro criteri definiti.

**Come funziona:**
```
Step 1: Forward Reasoning - Genera risposta con CoT
Step 2: Backward Verification - Verifica ogni candidate answer
Step 3: Voting - Seleziona risposta con più voti
```

**PRO:**
- Miglioramento medio +2.33% anche su modelli performanti (InstructGPT)
- Zero-shot, non richiede training
- Funziona su domande complesse

**CONTRO:**
- Richiede multiple generazioni (più token/latenza)
- Non previene errori, li cattura post-hoc

**Fonte:** [Self-Verification Prompting](https://learnprompting.org/docs/advanced/self_criticism/self_verification)

---

### 2. CHAIN-OF-VERIFICATION (CoVe)

**Cos'è:** Self-critique che migliora risposta iniziale pianificando domande di verifica.

**Processo:**
```
1. Baseline Response Generation
2. Planning Verifications (genera domande per verificare)
3. Verification Execution (risponde alle domande)
4. Final Response Generation (risposta raffinata)
```

**PRO:**
- Riduce hallucinations sistematicamente
- Processo trasparente e auditable
- Forza LLM a "pensare due volte"

**CONTRO:**
- 4 step = latenza alta
- Richiede prompt engineering specifico

**Fonte:** [Chain-of-Verification](https://learnprompting.org/docs/advanced/self_criticism/chain_of_verification)

---

### 3. CONSTITUTIONAL AI (Anthropic)

**Cos'è:** Training con self-critique guidata da principi scritti in linguaggio naturale.

**Fasi:**
```
SUPERVISED STAGE:
- Genera risposte a prompt harmfulness
- Critica risposta secondo principi costituzione
- Rivede risposta alla luce della critica

RL STAGE (RLAIF):
- Training via reinforcement learning
- Confronta risposte guidato da principi etici
- Premia risposte allineate a regole costituzionali
```

**PRO:**
- Training-level enforcement (non solo prompt)
- Dimostrato efficace (Anthropic lo usa per Claude)
- Costituzione = linguaggio naturale (facile da scrivere)

**CONTRO:**
- Richiede training/fine-tuning (non applicabile a noi)
- Complesso da implementare

**Fonte:** [Constitutional AI](https://arxiv.org/pdf/2212.08073)

---

### 4. HOOK-BASED VERIFICATION (Claude SDK)

**Cos'è:** Hook che intercettano lifecycle dell'agente per verificare comportamento.

**Pattern:**
```javascript
hooks: [
  {
    type: "beforeAction",
    handler: verifyConstitutionAdherence
  },
  {
    type: "afterAction",
    handler: validateOutputVsPrinciples
  }
]
```

**PRO:**
- Runtime enforcement (cattura violazioni in tempo reale)
- Architectural safeguard (non dipende da LLM memory)
- Auditable e testabile

**CONTRO:**
- Richiede infrastruttura hook system
- Deve definire "cosa verificare" (non automatico)

**Fonte:** [Claude Agent SDK Hooks](https://platform.claude.com/docs/en/agent-sdk/hooks)

---

### 5. ARCHITECTURAL ENFORCEMENT (ArbiterOS Pattern)

**Cos'è:** Policy mandatorie a livello architetturale: GENERATE → VERIFY.

**Pattern:**
```
POLICY: "GENERATE instruction MUST be followed by VERIFY"
```

Prima di azioni high-stakes, OBBLIGA step di verifica.

**PRO:**
- Garanzia sistemica e auditable
- Non dipende da "memoria" LLM
- Think-then-verify workflow

**CONTRO:**
- Richiede kernel/framework dedicato (complesso)
- Overhead su ogni azione

**Fonte:** [Agent Constitution Framework](https://arxiv.org/html/2510.13857v1)

---

### 6. MULTI-AGENT DECENTRALIZATION

**Cos'è:** Invece di un agente complesso, specializzare agenti per singoli compiti.

**Principio:**
```
"As complexity increases, adherence degrades"

SOLUZIONE: Decentralizzare responsabilità
```

Esempio CervellaSwarm:
- Regina orchestra
- Guardiane validano principi specifici
- Worker eseguono task singoli

**PRO:**
- Riduce complexity per singolo agente
- Specialization = migliore adherence
- Modular, testable, reliable

**CONTRO:**
- Overhead coordinamento
- Serve architettura multi-agent (NOI GIA' L'ABBIAMO!)

**Fonte:** [Multi-Agent Patterns](https://developers.googleblog.com/developers-guide-to-multi-agent-patterns-in-adk/)

---

### 7. LLM-AS-A-JUDGE (Prompt Adherence Monitoring)

**Cos'è:** LLM separato valuta se output segue istruzioni date.

**Pattern:**
```
Judge Prompt:
"Valuta se questa risposta segue i seguenti principi:
1. [Principio A]
2. [Principio B]

Risposta da valutare: [output]

Score: 0-10 con motivazione"
```

**PRO:**
- Monitoring continuo e automatico
- Alert quando agent devia
- Metrica quantitativa (score)

**CONTRO:**
- Richiede LLM call addizionale
- Judge potrebbe sbagliare valutazione

**Fonte:** [LLM-as-Judge](https://www.montecarlodata.com/blog-llm-as-judge/)

---

## WHAT THE BIG PLAYERS DO

### Anthropic (Claude)

**Tecniche documentate:**
1. **Constitutional AI** - Training con principi scritti
2. **System Prompts dettagliati** - Specificity nei tool e behavior
3. **Examples-driven** - Show, don't just tell
4. **Hook System** - Runtime verification via SDK

**Quote chiave:**
> "Claude 4 pays close attention to details and examples. Ensure your examples align with behaviors you want to encourage."

**Lezione:** MOSTRA esempi concreti di come applicare principi, non solo elencarli.

### OpenAI (Agents SDK)

**Tecniche:**
1. **Hooks per lifecycle** - `beforeAction`, `afterAction`
2. **Role definition chiara** - System prompt strutturato
3. **Tool configuration rigorosa** - Quanto effort in tools = quanto in prompts

**Lezione:** Tool configuration è CRITICO quanto system prompt.

### Google (ADK Multi-Agent)

**Tecniche:**
1. **Decentralization** - Specializzazione agenti
2. **Reliability through simplicity** - Agent singolo = task singolo
3. **Monitoring e observability** - Visibilità su cosa fanno gli agenti

**Lezione:** Complessità = enemy of adherence. Keep agents simple.

---

## RACCOMANDAZIONE PER CERVELLASWARM

### STRATEGIA A 3 LAYER

Combiniamo le tecniche migliori in un sistema defense-in-depth:

```
┌─────────────────────────────────────────────────────────┐
│ LAYER 1: PRE-FLIGHT CHECK (Preventivo)                  │
│ - Quiz post-lettura Costituzione                        │
│ - Agente deve rispondere domande sui principi           │
│ - FAIL = non procede al task                            │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│ LAYER 2: BEHAVIOR VERIFICATION HOOKS (Runtime)          │
│ - Hook beforeAction: Check se azione aligned            │
│ - Hook afterAction: Valida output vs principi           │
│ - FAIL = rollback + alert Regina                        │
└─────────────────────────────────────────────────────────┘
                           ↓
┌─────────────────────────────────────────────────────────┐
│ LAYER 3: SELF-VERIFICATION (Post-Produzione)            │
│ - Agente verifica proprio output                        │
│ - CoVe pattern: genera domande verifica                 │
│ - Output finale include self-assessment                 │
└─────────────────────────────────────────────────────────┘
```

### LAYER 1: PRE-FLIGHT CHECK

**Implementazione SUBITO:**

Aggiungiamo in ogni agent prompt, DOPO `Read(COSTITUZIONE.md)`:

```markdown
## PRE-FLIGHT CHECK - COSTITUZIONE

Hai appena letto la COSTITUZIONE. Prima di procedere, rispondi:

1. Qual è l'OBIETTIVO FINALE di Rafa e Cervella?
2. Cosa significa "SU CARTA != REALE"?
3. Sei un assistente o un PARTNER? Qual è la differenza?
4. Cosa fai PRIMA di proporre una soluzione?
5. La Formula Magica: qual è il Pilastro #1?

**OBBLIGATORIO:** Risposte brevi (max 10 parole/risposta).

SE NON SAI RISPONDERE = Rileggi Costituzione!
```

**Perché funziona:**
- Forza elaborazione attiva (non lettura passiva)
- Retrieval immediato = migliore encoding
- FAIL-SAFE: se non sa rispondere, problema evidente

**Costo:** +50 token output, 10 sec latenza. WORTH IT.

---

### LAYER 2: BEHAVIOR VERIFICATION HOOKS

**Implementazione (medio termine):**

Script: `scripts/agents/verify_constitution_adherence.sh`

```bash
#!/bin/bash
# Hook che verifica comportamento vs Costituzione

check_before_action() {
  action=$1

  # Check 1: Azione richiede ricerca?
  if [[ "$action" =~ "proporre soluzione" ]]; then
    if ! grep -q "WebSearch\|WebFetch" agent_log.txt; then
      echo "FAIL: Proposta senza ricerca (viola Formula Magica #1)"
      exit 1
    fi
  fi

  # Check 2: Deploy senza test?
  if [[ "$action" =~ "deploy\|push" ]]; then
    if ! grep -q "test.*PASSED" agent_log.txt; then
      echo "FAIL: Deploy senza test (viola 'SU CARTA != REALE')"
      exit 1
    fi
  fi

  # Altri check...
}
```

**Integrazione:** spawn-workers chiama hook automaticamente.

**Perché funziona:**
- Architectural safeguard (non dipende da memory LLM)
- Catch violation PRIMA che causino danno
- Auditable e testable

---

### LAYER 3: SELF-VERIFICATION

**Implementazione (da aggiungere a prompt):**

Sezione finale di ogni agent prompt:

```markdown
## OUTPUT FINALE - SELF-VERIFICATION

Prima di restituire risultato, verifica:

**CHECKPOINT COSTITUZIONE:**
[ ] Ho ricercato PRIMA di proporre? (Formula Magica #1)
[ ] Risultato è REALE o "su carta"? (testato/verificato)
[ ] Ho ragionato o eseguito ciecamente? (Partner vs Assistente)
[ ] Ho protetto il progetto? (long-term vs immediato)

**INCLUDI NEL REPORT:**
```
SELF-CHECK COSTITUZIONE: ✓/✗
- Ricerca fatta: [SI/NO]
- Risultato testato: [SI/NO]
- Ragionamento: [1-2 frasi]
- Long-term protection: [1-2 frasi]
```

**Se anche UNO è ✗ → SEGNALA alla Regina!**
```

**Perché funziona:**
- Self-awareness forzata
- Trasparenza (Regina vede self-check in output)
- Early warning se agent devia

---

## IMPLEMENTAZIONE PRATICA

### FASE 1 - IMMEDIATA (Oggi!)

**Azione:** Aggiungere Pre-Flight Check a tutti 16 agent prompts.

```bash
# Script per update automatico
for agent in ~/.claude/agents/*.md; do
  # Inserisci Pre-Flight Check dopo Read(COSTITUZIONE)
  sed -i '/Read.*COSTITUZIONE/a\
\
## PRE-FLIGHT CHECK - COSTITUZIONE\
[... quiz text ...]\
' "$agent"
done
```

**File:** `.sncp/progetti/cervellaswarm/idee/20260115_PRE_FLIGHT_CHECK_COSTITUZIONE.md`

**Tempo:** 30 min (update 16 file + test).

---

### FASE 2 - QUESTA SETTIMANA

**Azione:** Implementare Behavior Verification Hook.

**Task:**
1. Creare `scripts/agents/verify_constitution_adherence.sh`
2. Integrare in `spawn-workers.sh` (chiamata automatica)
3. Definire check specifici per principi chiave
4. Testare con worker di test

**File output:** Script funzionante + test suite.

**Tempo:** 2-3 ore lavoro focalizzato.

---

### FASE 3 - PROSSIMA SETTIMANA

**Azione:** Aggiungere Self-Verification a tutti agent prompts.

**Task:**
1. Template self-check standardizzato
2. Update 16 agent prompts con sezione finale
3. Modificare template output per includere self-assessment
4. Verificare che Regina riceva e valuti self-check

**Tempo:** 1-2 ore.

---

### FASE 4 - MONITORING (Continuo)

**Azione:** LLM-as-Judge per constitutional adherence.

**Task:**
1. Script `scripts/agents/judge_constitution.sh`
2. Input: agent output
3. Output: Score 0-10 + motivazione
4. Log risultati in `.sncp/monitoring/constitution_scores/`
5. Alert se score < 7

**Quando:** Dopo FASE 3 stabilizzata (2-3 settimane).

---

## METRICHE DI SUCCESSO

Come sappiamo se funziona?

| Metrica | Pre-Implementazione | Target Post |
|---------|---------------------|-------------|
| **Quiz Pass Rate** | N/A | >95% |
| **Hook Violations** | N/A | <2/settimana |
| **Self-Check ✗** | N/A | <1/settimana |
| **Constitution Score** | N/A | Media >8.5/10 |
| **Episodi "lettura checkbox"** | ~1-2/settimana | <1/mese |

**Tracking:** Dashboard in `.sncp/monitoring/constitution_metrics/`

---

## BEST PRACTICES DAI BIG

### Anthropic

1. **Show, don't tell** - Examples > instructions
2. **Clear structure** - XML tags, step-by-step
3. **Specificity** - Vague = ignored

### OpenAI

1. **Tool config = prompt importance** - Effort 50/50
2. **Hooks for control** - Don't rely on memory alone
3. **Role definition** - Crystal clear "who you are"

### Google

1. **Simplicity wins** - Complex agent = low adherence
2. **Specialization** - One agent, one responsibility
3. **Observability** - Can't manage what you can't see

### Academia (2025 Research)

1. **Test nuances** - Same intent, multiple phrasings
2. **Reliable@k metric** - Consistency > single performance
3. **Test-time scaling** - Rejection sampling > training (per noi!)

---

## RIFERIMENTI E FONTI

### Ricerca Accademica

- [Revisiting the Reliability of Language Models in Instruction-Following](https://arxiv.org/abs/2512.14754) - Paper Dicembre 2025, nuance-oriented reliability
- [Constitutional AI: Harmlessness from AI Feedback](https://arxiv.org/pdf/2212.08073) - Paper originale Anthropic
- [Agent Constitution Framework (ArbiterOS)](https://arxiv.org/html/2510.13857v1) - Architectural enforcement patterns

### Self-Verification Techniques

- [Self-Verification Prompting](https://learnprompting.org/docs/advanced/self_criticism/self_verification) - Forward + backward verification
- [Chain-of-Verification (CoVe)](https://learnprompting.org/docs/advanced/self_criticism/chain_of_verification) - 4-step refinement process
- [LLM Self-Evaluation](https://learnprompting.org/docs/reliability/lm_self_eval) - Internal reliability techniques

### Industry Best Practices

- [Claude Prompting Best Practices](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-4-best-practices) - Anthropic official docs
- [Claude Agent SDK Hooks](https://platform.claude.com/docs/en/agent-sdk/hooks) - Runtime behavior control
- [LLM Agent Build Guide](https://www.vellum.ai/blog/the-ultimate-llm-agent-build-guide) - Comprehensive guide
- [Multi-Agent Patterns (Google)](https://developers.googleblog.com/developers-guide-to-multi-agent-patterns-in-adk/) - Decentralization strategies

### Evaluation & Monitoring

- [LLM-as-Judge Best Practices](https://www.montecarlodata.com/blog-llm-as-judge/) - Evaluation frameworks
- [Prompt Adherence Monitoring](https://www.confident-ai.com/blog/llm-testing-in-2024-top-methods-and-strategies) - Testing strategies

### Constitutional AI Deep Dives

- [Constitutional AI with Open LLMs](https://huggingface.co/blog/constitutional_ai) - Implementation guide
- [Law-Following AI](https://law-ai.org/law-following-ai/) - Compliance-by-design approach

---

## CONCLUSIONE

**TL;DR:**
Il problema è REALE (-61.8% performance con nuances) ma RISOLVIBILE.

**La nostra soluzione:**
```
Pre-Flight Quiz + Behavior Hooks + Self-Verification = 3-Layer Defense
```

**Prossimo step IMMEDIATO:**
Implementare Pre-Flight Check (FASE 1) in tutti 16 agent prompts.

**Chi lo fa:**
cervella-researcher propone, Regina decide e coordina implementazione.

**Quando:**
FASE 1 oggi, FASE 2-3 questa settimana, FASE 4 continuous.

---

**La ricerca conferma quello che Rafa dice sempre:**

> *"I dettagli fanno SEMPRE la differenza."*

I "dettagli" qui sono: COME l'agente legge, COSA fa dopo lettura, COME verifica comprensione.

Non basta "leggere" la Costituzione. Serve INTERNALIZZARLA.

Ora abbiamo il metodo. 🔬

---

*Ricerca completata: 15 Gennaio 2026*
*Prossimo step: Proposta implementazione alla Regina*
*"Non inventare! Studiare come fanno i big!" - Formula Magica applicata ✓*
