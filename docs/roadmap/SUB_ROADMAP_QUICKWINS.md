# SUB-ROADMAP: Quick Wins

> *"Vittorie veloci che portano valore REALE!"*

**Creato:** 2 Gennaio 2026 - Sessione 41
**Versione:** 1.0.0

---

## PANORAMICA

```
+------------------------------------------------------------------+
|                                                                  |
|   QUICK WINS - Vittorie Veloci!                                 |
|                                                                  |
|   QW-1: Prompt Caching        [ ] 0% → Risparmio 90% token!     |
|   QW-2: GitHub Actions        [ ] 0% → Code review H24!         |
|                                                                  |
|   Tempo totale stimato: 2-4 ore                                  |
|   Beneficio: Risparmio $$ + Qualita automatica                  |
|                                                                  |
+------------------------------------------------------------------+
```

---

## QW-1: PROMPT CACHING (Priorita ALTA)

### Cos'e
Cache delle parti statiche del prompt (DNA agent, system prompts).
Anthropic riutilizza automaticamente per 5 minuti.

### Benefici
| Metrica | Prima | Dopo | Risparmio |
|---------|-------|------|-----------|
| Costo token ripetuti | $3/MTok | $0.30/MTok | **-90%** |
| Latency | ~11s | ~2.4s | **-79%** |
| Break-even | - | 2 chiamate | Immediato! |

### Implementazione

| Step | Descrizione | Stato | Tempo |
|------|-------------|-------|-------|
| 1 | Analizzare lunghezza DNA agent | [ ] TODO | 15 min |
| 2 | Aggiungere `cache_control` ai DNA | [ ] TODO | 30 min |
| 3 | Testare con task ripetuto | [ ] TODO | 15 min |
| 4 | Misurare risparmio reale | [ ] TODO | 15 min |
| 5 | Applicare a PROMPT_RIPRESA | [ ] TODO | 15 min |

**Tempo totale:** ~1.5 ore

### Come Funziona

```python
# Prima (senza cache)
system=[
  {"type": "text", "text": "DNA agent lungo..."}
]

# Dopo (con cache)
system=[
  {"type": "text", "text": "DNA agent lungo...",
   "cache_control": {"type": "ephemeral"}}
]
```

### Dove Applicare
- [x] DNA 14 agent globali (~/.claude/agents/*.md)
- [ ] PROMPT_RIPRESA.md nei progetti
- [ ] ROADMAP_SACRA.md (se inclusa nel context)
- [ ] Tool definitions (se tanti tools)

### Note Tecniche
- Minimo 1024 tokens per cache hit
- Cache dura 5 minuti (o 1 ora con cache estesa)
- Contenuto deve essere IDENTICO per hit

---

## QW-2: GITHUB ACTIONS (Priorita MEDIA)

### Cos'e
Action ufficiale Anthropic per Claude in GitHub.
Code review automatica su ogni PR!

### Benefici
- Code review H24 (zero effort umano)
- Security review automatica
- Fix suggeriti/implementati automaticamente
- Standard consistente su tutti i PR

### Implementazione

| Step | Descrizione | Stato | Tempo |
|------|-------------|-------|-------|
| 1 | Setup `ANTHROPIC_API_KEY` in secrets | [ ] TODO | 10 min |
| 2 | Creare `.github/workflows/claude.yml` | [ ] TODO | 20 min |
| 3 | Test su CervellaSwarm (PR finta) | [ ] TODO | 20 min |
| 4 | Deploy su Miracollo | [ ] TODO | 15 min |
| 5 | Deploy su Contabilita | [ ] TODO | 15 min |

**Tempo totale:** ~1.5 ore

### Workflow Base

```yaml
# .github/workflows/claude.yml
name: Claude Code Review

on:
  pull_request:
    types: [opened, synchronize]
  issue_comment:
    types: [created]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          trigger: "pull_request"
          model: "claude-sonnet-4-5-20251101"
```

### Funzionalita Disponibili
- `/review` - Code review completa
- `/security-review` - Focus sicurezza
- `/fix` - Implementa fix suggeriti
- `@claude` - Mention per domande

### Costi Stimati
- Token Sonnet: $3/MTok input, $15/MTok output
- PR media (~500 righe): ~$0.05-0.10 per review
- 100 PR/mese: ~$5-10/mese

---

## ORDINE ESECUZIONE CONSIGLIATO

```
1. QW-1: Prompt Caching (1.5 ore)
   ↓
   Beneficio IMMEDIATO: -90% costi token
   ↓
2. QW-2: GitHub Actions (1.5 ore)
   ↓
   Beneficio CONTINUO: review H24
```

### Perche Questo Ordine
1. **Prompt Caching PRIMA** perche:
   - Impatto immediato sui costi
   - Zero infrastruttura
   - Basta modificare file esistenti

2. **GitHub Actions DOPO** perche:
   - Richiede setup secrets nei repo
   - Beneficio lungo termine (non immediato)
   - Piu complesso da debuggare

---

## CRITERI DI SUCCESSO

### QW-1: Prompt Caching
- [ ] DNA agent cachati (14 file)
- [ ] Risparmio misurabile (>50% su task ripetuti)
- [ ] Zero regressioni funzionali

### QW-2: GitHub Actions
- [ ] Workflow funzionante su CervellaSwarm
- [ ] Review automatica su PR di test
- [ ] Deployato su almeno 1 progetto reale

---

## DECISIONI DA PRENDERE

| Decisione | Opzioni | Consiglio |
|-----------|---------|-----------|
| Cache duration | 5min / 1h estesa | 5min (default) |
| GitHub model | Sonnet / Haiku | Sonnet (qualita) |
| Primo repo test | CervellaSwarm / Miracollo | CervellaSwarm |

---

## FONTI RICERCA

**Prompt Caching:**
- [Anthropic Prompt Caching Docs](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
- [Case Study: $720 → $72/mese (-90%)](https://medium.com/@labeveryday/prompt-caching)

**GitHub Actions:**
- [Claude Code GitHub Actions - Official](https://code.claude.com/docs/en/github-actions)
- [Claude Code Action - Marketplace](https://github.com/marketplace/actions/claude-code-action-official)

---

## CHANGELOG

| Data | Versione | Modifica |
|------|----------|----------|
| 2 Gen 2026 | 1.0.0 | Creazione iniziale |

---

*"Quick wins = momentum per cose piu grandi!"*

*"Lavoriamo in pace! Senza casino! Dipende da noi!"* 💙
