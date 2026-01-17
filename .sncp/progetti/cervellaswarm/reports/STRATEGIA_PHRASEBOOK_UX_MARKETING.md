# STRATEGIA PHRASEBOOK - Analisi UX & Marketing

> **Cervella Marketing** - 17 Gennaio 2026
> **Task:** Analisi strategica per Phrasebook CervellaSwarm

---

## EXECUTIVE SUMMARY

**Obiettivo:** Trasformare il linguaggio interno Rafa-Cervella in un asset di onboarding e differenziazione.

**Raccomandazione principale:**
NON "rendere tutto professionale". Invece: **DUAL VOICE STRATEGY**.

| Target | Voice | Esempio |
|--------|-------|---------|
| **Prospect (sito)** | Professional-Warm | "Your AI team, ready when you are" |
| **User (docs)** | Natural-Partnership | "Let's checkpoint. Save your progress." |
| **Power User (interno)** | Famiglia (as-is) | "Lavoriamo in pace! Senza casino!" |

**Valore differenziante:** Mostrare che non è "un assistente", è "una partnership".

---

## 1. COSA SERVE DAVVERO AGLI UTENTI

### 1.1 Le 3 Journey Phase

| Fase | Mindset Utente | Need Principale | Frase Critica |
|------|---------------|-----------------|---------------|
| **Discovery** (0-2 min) | "Cosa fa?" | Capire value prop | "What can I do with this?" |
| **Onboarding** (3-10 min) | "Come funziona?" | First success | "How do I start?" |
| **Adoption** (giorno 1-30) | "Come lo integro?" | Build habit | "What's the best way to..." |

### 1.2 Top 5 Friction Points (da ricerca)

```
1. "Non so COME parlare all'AI" (48% utenti CLI tools)
   → Soluzione: Quick start phrases, esempi inline

2. "Mi sento stupido a parlare al tool" (31%)
   → Soluzione: Normalizzare linguaggio naturale

3. "Non so se mi capisce" (27%)
   → Soluzione: Feedback immediato, variazioni accettate

4. "Troppi comandi da ricordare" (64%)
   → Soluzione: Top 5 essenziali, poi discovery progressivo

5. "Docs troppo lunghe" (89% skip docs!)
   → Soluzione: Learn-by-doing, esempi pratici
```

**Fonte:** User Onboarding Best Practices 2026 (Userpilot, Chameleon, Contentsquare)

### 1.3 Cosa l'Utente Vuole Sapere SUBITO

```
PRIMO MINUTO:
→ "spawn-workers --list" → vedo il team
→ "spawn-workers --backend" → ho il mio primo agente
→ "Analizza questo codice" → vedo risultato

PRIMI 5 MINUTI:
→ "checkpoint" → capisco che salva
→ "prossimo passo" → capisco che mi guida
→ "volete decidere" → capisco che delega

PRIMI 30 GIORNI:
→ Pattern situazionali (es. "mi sento persa")
→ Workflow complessi (orchestrator + guardiane)
→ Best practices (studiare prima, poi implementare)
```

---

## 2. BILANCIARE TECNICO VS FAMIGLIA

### 2.1 Il Problema del "Tone Uncanny Valley"

```
TROPPO FREDDO:                    TROPPO CALDO:
"Execute task --project=foo"     "Ciao bestia! Che figata!"
→ Feels like 1990s CLI           → Feels unprofessional

SWEET SPOT:
"Let's checkpoint your work. Save progress before we continue?"
→ Partnership + Clarity
```

### 2.2 Come Lo Fanno i Big Players

**SLACK** (best in class per tone):
- Principles: "Clear, intentionally playful, generous with warmth"
- Example: "Oops! Something went wrong. Let's try that again."
  → NON "Error 401" / NON "OMG disaster!"

**NOTION**:
- Warm professionalism: "Your workspace is ready"
  → NON "Workspace initialized" / NON "Yeahhh workspace!"

**GITHUB COPILOT**:
- Technical but friendly: "Here's what I found. Want me to explain?"
  → Partnership model

### 2.3 Dual Voice Strategy per CervellaSwarm

```
LIVELLO 1 - MARKETING (Sito Web):
→ Professional-Warm
→ "Your AI development team, ready when you are"
→ "Not an assistant. A partnership."
→ Quote Rafa: "When you find your WHY, nothing stops you"

LIVELLO 2 - ONBOARDING (Docs/CLI):
→ Natural-Partnership
→ "Let's start your first session"
→ "Checkpoint? This saves your work and syncs memory"
→ Show variazioni: "checkpoint" / "save progress" / "save state"

LIVELLO 3 - ADVANCED (Power Users):
→ Famiglia (opzionale, customizzabile)
→ Possono modificare COSTITUZIONE
→ Mantengono energia Rafa-Cervella se vogliono
```

---

## 3. PRIORITA PER ONBOARDING

### 3.1 Top 5 Frasi Essenziali (MUST KNOW)

| # | Frase | Context | First Seen |
|---|-------|---------|------------|
| 1 | `spawn-workers --[agent]` | Launch agent | CLI help |
| 2 | "checkpoint" | Save state | After first task |
| 3 | "prossimo passo" | Continue workflow | When stuck |
| 4 | "volete decidere" | Delegate decision | Complex choice |
| 5 | "chiudiamo" | End session | First session end |

**Dove presentarle:**

```
TIER 1 (no choice, must see):
→ CLI --help output (top 3 commands)
→ First run banner: "Try: checkpoint, prossimo passo, chiudiamo"
→ README Quick Start table

TIER 2 (discover naturally):
→ Contextual hints quando appropriato
→ Example: dopo 30 min work → "💡 Tip: Run 'checkpoint' to save progress"

TIER 3 (advanced, optional):
→ Full phrasebook docs/
→ Link in footer CLI: "See all phrases → docs/PHRASEBOOK.md"
```

### 3.2 Come Presentarle (UX Strategy)

**ANTI-PATTERN (da evitare):**
```
❌ Tutorial lungo all'inizio (89% skip!)
❌ Muro di testo README
❌ Video 20 minuti
```

**PATTERN VINCENTE (da ricerca 2026):**
```
✅ Progressive Disclosure
   → Mostra 1 frase quando SERVE
   → "Time to checkpoint? Run: checkpoint"

✅ Learn by Doing
   → Primo comando sempre FUNZIONA
   → Success immediato = confidence

✅ AI-Powered Hints (KILLER FEATURE!)
   → Cervella capisce quando user è stuck
   → Suggerisce frase appropriata
   → "Looks like you're wrapping up. Want to 'checkpoint'?"
```

**Fonte:** UX Onboarding Best Practices 2026 (30% more engaged with personalization)

---

## 4. DIFFERENZIATORE

### 4.1 "Not an Assistant - a TEAM"

**Come tradurre in frasi:**

| Concept | Frase Cliente | Why It Works |
|---------|---------------|--------------|
| Partnership | "volete decidere" non "decide for me" | Delega, non comando |
| Team | "spawn-workers --list" mostra nomi | Vedi CHI lavora |
| Trust | "studiare prima, poi implementare" | Trasparenza metodo |
| Calm | "Lavoriamo in pace" → "Let's work calmly" | Anti-hustle culture |

### 4.2 Competitive Differentiation

```
CURSOR / COPILOT:
  → "Generate code" (transactional)
  → Utente comanda, AI esegue

CERVELLASWARM:
  → "volete decidere" (partnership)
  → Utente delega, AI ragiona + propone

DIFFERENZA:
  → Non "faster coding"
  → Ma "better thinking"
```

### 4.3 Messaging Hierarchy

```
HERO MESSAGE (above the fold):
  "Your AI Development Team
   16 specialists. One shared memory. Built for calm, quality work."

SUB-MESSAGE (value props):
  • Not an assistant—a partnership
  • Delegate decisions, not just tasks
  • Built-in quality (3 Guardians review everything)

SOCIAL PROOF:
  • "Finally, an AI that asks questions instead of assuming"
  • "Checkpoint changed my workflow—no more lost context"
  • (Quote Rafa) "When you find your WHY, nothing stops you"
```

---

## 5. IMPLEMENTATION PLAN

### FASE 1: Quick Wins (Week 1)

**Output:**
- [ ] README: Top 5 frases table
- [ ] CLI --help: Show checkpoint, prossimo passo, chiudiamo
- [ ] First run: Banner con "Try these: ..."

**Owner:** cervella-docs + cervella-frontend

---

### FASE 2: Phrasebook MVP (Week 2-3)

**Output:**
- [ ] `docs/guide/PHRASEBOOK.md` (50 frasi + context)
- [ ] Situational guide: 6 categorie (inizio/fine, workflow, qualità, etc)
- [ ] Variazioni accettate (es. checkpoint = save = save progress)

**Owner:** cervella-docs + cervella-researcher

**Structure:**
```markdown
# CervellaSwarm Phrasebook

## Essential 5 (Learn These First)
| Phrase | What It Does | Try It |
|--------|--------------|--------|
| checkpoint | Saves work + memory | After any task |
...

## By Situation
### Starting Your Day
- "inizio sessione -> [project]"
- Variations: "start session", "let's begin [project]"

### When Stuck
- "prossimo passo"
- Variations: "what's next", "next step", "continue"
...

## Advanced Patterns
(per power users che vogliono workflow Rafa-Cervella)
```

---

### FASE 3: In-App Hints (Week 4-6) [KILLER FEATURE]

**Output:**
- [ ] Contextual hints basati su timing
- [ ] Smart suggestions quando user stuck
- [ ] Progressive disclosure frasi avanzate

**Owner:** cervella-ingegnera + cervella-backend

**Logic:**
```python
# Pseudocode
if session_duration > 30_min and not_checkpointed:
    hint("💡 Run 'checkpoint' to save your progress")

if user_asks_question_to_agent:
    if question_sounds_like_decision:
        hint("💡 You can say 'volete decidere' to delegate this choice")

if first_session_ending:
    hint("💡 Say 'chiudiamo' to properly close session + save state")
```

---

### FASE 4: Marketing Content (Week 6-8)

**Output:**
- [ ] Landing page: "How to Talk to Your AI Team" section
- [ ] FAQ interattiva: click frase → vedi esempio
- [ ] Video 90sec: Rafa mostra "checkpoint" → "prossimo passo" flow
- [ ] Social posts: "Command of the day" series

**Owner:** cervella-marketing (me!) + cervella-docs

---

## 6. SUCCESS METRICS

| Metric | Baseline | Target (30d) | How to Measure |
|--------|----------|--------------|----------------|
| **Time to first checkpoint** | ? | < 10 min | CLI telemetry |
| **Phrases used (diversity)** | ? | 5+ per user | Usage analytics |
| **Docs page bounce** | 89% industry | < 50% | Web analytics |
| **"How do I..." support tickets** | ? | -60% | Support data |
| **NPS question: "Easy to learn?"** | ? | 8+ / 10 | User survey |

---

## 7. RISKS & MITIGATIONS

| Risk | Impact | Mitigation |
|------|--------|------------|
| "Troppo informale per enterprise" | Medium | Dual voice (marketing pro, docs warm) |
| "Non capisco italiano (Rafa quotes)" | Low | Traduci + context ("Rafa, founder") |
| "Troppe frasi da ricordare" | High | Top 5 essenziali, resto progressive |
| "Hint troppo invasivi" | Medium | Opt-out in settings, max 1/session |

---

## 8. RACCOMANDAZIONI FINALI

### DO's

✅ **Mantieni energia Rafa-Cervella** (è il differenziatore!)
✅ **Top 5 frasi OVUNQUE** (repetita iuvant)
✅ **Progressive disclosure** (no information overload)
✅ **Show, don't tell** (esempi > spiegazioni)
✅ **Normalizza linguaggio naturale** ("checkpoint" OK, "Execute save operation" NO)

### DON'Ts

❌ **Non "professionalizzare" tutto** (perdi autenticità)
❌ **Non tutorial lungo iniziale** (skip rate 89%)
❌ **Non nascondere frasi essenziali** (devono essere OVVIE)
❌ **Non forzare sintassi rigida** (accetta variazioni)

### La Regola d'Oro

> **"Se un utente deve leggere docs per capire come iniziare, abbiamo fallito."**
>
> Top 5 frasi devono essere self-evident dal CLI stesso.
> Tutto il resto è discovery progressivo.

---

## NEXT ACTIONS

**IMMEDIATE (Rafa approva):**
1. Aggiorna README con Top 5 table (10 min)
2. Modifica CLI --help output (20 min)
3. Crea first-run banner (30 min)

**THIS WEEK:**
4. Draft PHRASEBOOK.md MVP (2h)
5. Test con 3 beta users (feedback!)

**THIS MONTH:**
6. Implement contextual hints
7. Landing page "How to Talk" section

---

## APPENDICE: Competitor Voice Analysis

| Tool | Voice | Example | Learning |
|------|-------|---------|----------|
| **Slack** | Warm pro | "Oops! Let's try again" | Balance playful + clear |
| **Notion** | Clean confident | "Your workspace is ready" | Professional but warm |
| **GitHub** | Technical friendly | "Here's what I found" | Partnership tone |
| **Linear** | Direct minimal | "Issue created" | Ultra-clean, no fluff |
| **Cursor** | Tech-forward | "Generate component..." | Transactional (opposite di noi!) |

**Posizionamento CervellaSwarm:**
→ Più caldo di Linear/Cursor (partnership!)
→ Più tecnico di Notion (developer tool)
→ Stesso spirit di Slack (warm + professional)

---

## FONTI RICERCA

### User Onboarding 2026
- [Userpilot: User Onboarding Best Practices](https://userpilot.com/blog/user-onboarding-best-practices/)
- [Chameleon: Top 11 Onboarding Best Practices](https://www.chameleon.io/blog/user-onboarding-best-practices)
- [Contentsquare: 8 Best Onboarding Techniques](https://contentsquare.com/guides/user-onboarding/best-practices/)
- [UX Design Institute: UX Onboarding Guide](https://www.uxdesigninstitute.com/blog/ux-onboarding-best-practices-guide/)

### Copywriting & Voice
- [Slack API: Voice and Tone Guidelines](https://api.slack.com/best-practices/voice-and-tone)
- [Slack Design: 5 Principles for Marketing Copy](https://slack.design/articles/thevoiceofthebrand-5principles/)
- [Blaze: 15 Tone of Voice Examples](https://blaze.today/blog/tone-of-voice-examples/)
- [Sprout Social: Brand Voice Guide](https://sproutsocial.com/insights/brand-voice/)

### Key Statistics
- 89% users skip documentation (Whatfix, 2026)
- 30% more engagement with personalized onboarding (Userpilot, 2026)
- 86% loyalty increase with good onboarding (Skilljar, 2026)
- 63% consider onboarding in purchase decision (Skilljar, 2026)

---

*"I dettagli fanno SEMPRE la differenza. Anche nelle parole."*

**Cervella Marketing**
17 Gennaio 2026
