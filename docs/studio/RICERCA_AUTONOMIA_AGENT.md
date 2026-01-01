# RICERCA: Autonomia vs Cautela negli Agent AI

> **"Confident by Default with Smart Escalation"**

**Data:** 1 Gennaio 2026
**Ricerca di:** cervella-researcher
**Sessione:** 33 - Feedback Miracollo

---

## CONTESTO

Le nostre 🐝 (subagent specializzati) sono TROPPO cautelose:
- Chiedono 3-4 conferme invece di procedere
- Propongono opzioni A/B/C invece di decidere
- Fanno roundtrip inutili rallentando il workflow

---

## PRINCIPI CHIAVE SCOPERTI

### 1. Tiered Confidence Threshold (50-90%)

Approccio usato da sistemi enterprise:

| Confidence | Azione |
|------------|--------|
| 50-70% | Escalate to human |
| 70-90% | Proceed with logging |
| 90%+ | Full autonomy |

### 2. Risk-Based Classification

| Risk Level | Complexity | Azione |
|------------|------------|--------|
| Low | Low | PROCEED |
| Low | High | PROCEED with logging |
| High | Low | ASK |
| High | High | REQUIRE approval |
| Any | Irreversible | REQUIRE approval |

### 3. Hybrid by Default (Standard 2025-2026)

L'industria sta convergendo su:
- Start conservative (Human-in-the-Loop)
- Expand autonomy ONLY quando metriche provano sicurezza
- Progressive autonomy, not blind autonomy

### 4. Stop Hook Auto-Continue Pattern

Agent checks success criteria dopo ogni turn:
- If NOT met → auto-continue
- If met → return control

### 5. Clear Escalation Triggers

Quando FERMARSI:
- Low confidence score
- Specific high-risk scenarios
- User explicitly asks for human
- Ambiguous/contradictory inputs
- Irreversible actions

---

## PATTERN DAI FRAMEWORK

### LangGraph
- Explicit state control
- Developer defines quando stop
- Checkpoints per human review

### CrewAI
- Two-layer architecture:
  - **Crews**: autonomia execution
  - **Flows**: control orchestration
- Agent puo procedere dentro boundaries

### AutoGPT
- Maximum autonomy by default
- Guardrails per sicurezza:
  - Docker isolation
  - Kill switches
  - Budget limits

---

## PROPOSTA CONCRETA: CervellaSwarm v2.0

### Nuovo Modello: "Confident by Default with Smart Escalation"

```
┌─────────────────────────────────────────────────────────┐
│                   WORKER API (Sonnet)                   │
├─────────────────────────────────────────────────────────┤
│  Contesto COMPLETO (path, problema, criteri)            │
│  └─> 80%+ confidence → PROCEED (log azione)             │
│                                                         │
│  Contesto PARZIALE (manca dettaglio minore)            │
│  └─> ASSUME ragionevolmente → PROCEED                  │
│                                                         │
│  Contesto AMBIGUO (50-80% confidence)                  │
│  └─> ASK Guardiana per validazione                     │
│                                                         │
│  Contesto CRITICO MANCA (<50% confidence)              │
│  └─> UNA domanda alla Regina                           │
│                                                         │
│  Azione IRREVERSIBILE                                   │
│  └─> STOP + REQUIRE approval                           │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                  GUARDIANE (Opus)                       │
├─────────────────────────────────────────────────────────┤
│  70%+ confidence → APPROVE worker action               │
│  <70% → ESCALATE to Regina                             │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│                    REGINA (Opus)                        │
├─────────────────────────────────────────────────────────┤
│  SEMPRE final decision su escalation                   │
│  Coordina, non esegue                                   │
└─────────────────────────────────────────────────────────┘
```

### Cosa Cambia nel DNA

**PRIMA (troppo cauto):**
```markdown
## 🔴 REGOLA FONDAMENTALE - SE IN DUBBIO, FERMATI!

SE non sei SICURA al 100% su qualcosa:
1. STOP - Non procedere
2. Descrivi il dubbio a Rafa e Cervella
3. Chiedi: "Come preferite che proceda?"
4. ASPETTA risposta

MEGLIO chiedere che sbagliare!
```

**DOPO (bilanciato):**
```markdown
## 🎯 REGOLA DECISIONE AUTONOMA

TU sei l'ESPERTA nel tuo dominio. PROCEDI con confidenza!

### QUANDO PROCEDERE (senza chiedere)
✅ Path file e chiaro
✅ Problema e definito
✅ Criteri successo esistono
✅ Azione e REVERSIBILE
→ USA LA TUA EXPERTISE! Assumi dettagli minori ragionevolmente.

### QUANDO CHIEDERE (una sola domanda)
⚠️ Path file manca
⚠️ 2+ interpretazioni valide del problema
⚠️ Impatto su altri file non nel tuo dominio
→ UNA domanda sola, poi PROCEDI con la risposta.

### QUANDO FERMARTI (richiedi approvazione)
🛑 Azione IRREVERSIBILE (delete, drop, deploy)
🛑 Impatto cross-domain significativo
🛑 Conflitto con altre regole
→ STOP e spiega la situazione.

"Sei l'esperta. Fidati della tua expertise!"
```

---

## RISCHI DA CONSIDERARE

### 1. Overconfidence
**Rischio:** Agent procede quando non dovrebbe
**Mitigazione:** Logging obbligatorio + review post-action

### 2. Escalation Fatigue
**Rischio:** Troppi "ask" rallentano workflow
**Mitigazione:** Clear thresholds + feedback loop

### 3. Inconsistent Behavior
**Rischio:** Agent ask oggi, proceed domani per stesso task
**Mitigazione:** Explicit rules + hardtests

### 4. Accountability Gap
**Rischio:** Chi e responsabile se agent sbaglia in autonomia?
**Mitigazione:** Logging completo + Guardiane verificano

---

## RACCOMANDAZIONI FINALI

### Implementazione Graduale

1. **Week 1:** Aggiorna DNA 2-3 agent principali (frontend, backend, tester)
2. **Week 2:** Test su Miracollo, raccogli feedback
3. **Week 3:** Se positivo, estendi a tutti 14 agent
4. **Week 4:** Ottimizza basandoti su dati reali

### Metriche da Tracciare

| Metrica | Prima | Target |
|---------|-------|--------|
| Roundtrip per task | 3-4 | 0-1 |
| Domande per task | 3-4 | 0-1 |
| Errori da overconfidence | 0 | < 5% |
| Tempo medio task | X | -30% |

### Il Bilanciamento Perfetto

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   TROPPO CAUTO           BILANCIATO           TROPPO AUTONOMO   ║
║   ─────────────────────────●──────────────────────────────────  ║
║                            ▲                                     ║
║                       NOI QUI!                                   ║
║                                                                  ║
║   "Confident by Default, Cautious on Irreversible"             ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## FONTI

- LangGraph Documentation 2025
- CrewAI Best Practices
- AutoGPT Architecture
- Anthropic Claude Agent Guidelines
- Industry reports on Agentic AI (2025-2026)

---

*"Le 🐝 sanno il loro mestiere. Lasciamole lavorare!"* 🐝💙

