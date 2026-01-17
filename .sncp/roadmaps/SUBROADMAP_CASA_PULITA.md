# SUBROADMAP - CASA PULITA

> **Aggiornato:** 17 Gennaio 2026 - Sessione 249
> "Lavoriamo in pace! Senza casino! Dipende da noi!"

---

## OBIETTIVO

Sistemare l'organizzazione interna della famiglia:
- SNCP pulito e navigabile
- Context che non spreca token
- Comunicazione chiara tra sessioni
- Score SNCP: 5.8 -> 9.5
- **NUOVO:** Manutenzione automatica periodica

---

## STATO FASI

```
FASE 1: Quick Win              [COMPLETATO] Sessione 244
FASE 2: Pulizia SNCP           [COMPLETATO] Sessione 245
FASE 3: Consolidare docs       [COMPLETATO] Sessione 246
FASE 4: DNA Agents             [COMPLETATO] Sessione 246
FASE 5: Automazione            [COMPLETATO] Sessione 247
FASE 6: Studio Periodico       [COMPLETATO] Sessione 248
FASE 7: Comunicazione Interna  [COMPLETATO] Sessione 247
FASE 8: Casa Pulita Clienti    [COMPLETATO] Sessione 248-249 (Implementato!)
FASE 9: Sistema Aggiornamenti  [COMPLETATO] Sessione 249
```

---

## FASE 1: QUICK WIN [COMPLETATO]

**Sessione 244**
- Disabilitati hook inutili (-3100 tokens)

---

## FASE 2: PULIZIA SNCP [COMPLETATO]

**Sessione 245**
- stato.md: 701 -> 216 righe (-69%)
- 6 duplicati VDA eliminati (~200KB)
- Archivio 2026-01 creato

---

## FASE 3: CONSOLIDARE DOCS [COMPLETATO]

**Sessione 246**
- ~/.claude-insiders/CLAUDE.md: 131 -> 10 righe (-92%)
- CervellaSwarm/CLAUDE.md: 171 -> 57 righe (-67%)
- SubagentStart hook COSTITUZIONE: DISABILITATO
- **Risparmio totale: ~4800 tokens/sessione**

---

## FASE 4: DNA AGENTS [COMPLETATO]

**Sessione 246**
- Creato `_SHARED_DNA.md` (~120 righe comuni)
- Refactorizzati 16 DNA agent: 6800 -> 1264 righe (-82%)
- **Risparmio: ~7800 token/sessione (con 3 agent)**

---

## FASE 5: AUTOMAZIONE [COMPLETATO]

**Sessione 247**

| # | Task | Stato |
|---|------|-------|
| 1 | `scripts/archive_old_reports.sh` | FATTO - 13 file archiviati |
| 2 | `.git/hooks/pre-commit` - verifica naming | FATTO |
| 3 | Hook BLOCCA se limite superato | FATTO |

---

## FASE 6: STUDIO MANUTENZIONE PERIODICA [COMPLETATO]

**Sessione 248**

### Studio Completato

| Domanda | Risposta |
|---------|----------|
| **Frequenza** | IBRIDO: Daily (8:30) + Weekly (Lunedi) + Trigger dimensione |
| **Cosa automatizzare** | Health, cleanup, compliance + AUTO-COMPACT |
| **Come** | launchd (già esistente) + trigger dimensione (nuovo) |
| **Scope** | Multi-progetto GIA FUNZIONANTE (SNCP centralizzato) |

### Implementato

| # | Task | Stato |
|---|------|-------|
| 1 | Flag `--auto` in compact-state.sh | FATTO |
| 2 | Trigger dimensione nel daily (>400 righe) | FATTO |
| 3 | Check PROMPT_RIPRESA nel daily | FATTO |
| 4 | Notifica macOS per auto-compact | FATTO |

### Best Practices Adottate (Ricerca 2026)

```
1. Approccio IBRIDO (time + trigger) - best practice 2026
2. Stigmergy (comunicazione via file) - già in uso
3. Self-healing con backup automatico
4. Retention policy (hot/warm/cold)
5. Hierarchical automation (daily/weekly layers)
```

### File Modificati

- `scripts/sncp/compact-state.sh` (flag --auto)
- `scripts/cron/sncp_daily_maintenance.sh` (trigger >400 righe)

---

## METRICHE SUCCESS

| Metrica | Prima | Dopo Fase 4 | Target |
|---------|-------|-------------|--------|
| **SNCP Health** | 5.8/10 | ~8.5/10 | 9.5/10 |
| **stato.md** | 700 righe | 216 righe | < 300 sempre |
| **DNA totale** | 6800 righe | 1264 righe | < 1500 |
| **Context/sessione** | ~28k tokens | ~15k tokens | < 15k |

---

## FASE 7: COMUNICAZIONE INTERNA FAMIGLIA [COMPLETATO]

**Sessione 247**

### Analisi Fatta
- 3 Guardiane consultate in parallelo
- Gap identificati: enforcement debole, decisioni non strutturate
- Scoperta: infrastruttura ESISTEVA gia, mancava ADOZIONE

### Implementato

| # | Task | Stato |
|---|------|-------|
| 1 | compliance-check.sh nel daily | FATTO |
| 2 | docs/decisioni/TEMPLATE.md + README | FATTO |
| 3 | Hook pre-commit con compliance marker | FATTO |
| 4 | docs/PATTERN_COMUNICAZIONE.md | FATTO |

### Pattern Formalizzati
- Maker-Checker (Worker + Guardiana)
- Artifact System (output persistenti)
- Stigmergy (comunicazione via file)
- Memory Types (STM/MTM/LTM)

---

## FASE 8: CASA PULITA PER CLIENTI [COMPLETATO]

**Sessione 248**

### Studio Completato

| Domanda | Risposta |
|---------|----------|
| **Cosa portare** | Limiti file, housekeeping command, best practices |
| **Come** | Templates aggiornati + nuovo comando CLI |
| **Valore** | Risparmio token, manutenzione facile |

### Piano Creato

**Roadmap completa:** `.sncp/roadmaps/ROADMAP_CASA_PULITA_CLIENTI.md`

| Priorità | Feature | Chi |
|----------|---------|-----|
| P1 | Templates con limiti | cervella-backend |
| P1 | Best practices docs | cervella-docs |
| P2 | Comando housekeeping | cervella-backend |
| P3 | Script auto-compact | cervella-devops |

### Risorse Analizzate

- CLI esistente: `packages/cli/src/`
- Templates esistenti: `templates/`
- Comando init: `commands/init.js`
- SNCP init: `sncp/init.js`

### Next Steps (Implementazione)

```
FASE 8.1: Templates + Docs (Quick Win)
FASE 8.2: Comando housekeeping
FASE 8.3: Auto-compact script (opzionale)
```

---

## FASE 9: SISTEMA AGGIORNAMENTI PROGRAMMA [COMPLETATO]

> **Richiesto da Rafa - Sessione 247**
> **Implementato - Sessione 249**

**Chi:** cervella-researcher + Regina
**Output:** Studio + Implementazione COMPLETATI

### Ricerca Completata

| Domanda | Risposta |
|---------|----------|
| **Come fanno altri CLI?** | `update-notifier` (3.5M+ dependents) |
| **GitHub CLI** | Check 24h, notifica stderr, opt-out env |
| **Pattern dominante** | Background check, delayed notification |

### Implementazione

| # | Task | Stato |
|---|------|-------|
| 1 | Aggiunto `update-notifier` a dependencies | FATTO |
| 2 | Creato `src/utils/update-checker.js` | FATTO |
| 3 | Integrato in `cervellaswarm.js` | FATTO |
| 4 | Testato funzionamento | FATTO |

### Come Funziona

```
1. Ogni run: check in background (zero impact)
2. Cache 24h: no spam API
3. Delayed notification: check run N, notify run N+1
4. Auto-disabled in CI
5. Opt-out: NO_UPDATE_NOTIFIER=1
```

### File Creati/Modificati

- `src/utils/update-checker.js` (NUOVO)
- `bin/cervellaswarm.js` (import + chiamata)
- `package.json` (dipendenza aggiunta)

### Studio Salvato

- `docs/studio/RICERCA_CLI_UPDATE_PATTERNS.md`

---

## CASA PULITA - COMPLETATA!

```
+================================================================+
|                                                                |
|   TUTTE LE 9 FASI COMPLETATE!                                 |
|                                                                |
|   Casa Pulita: 100%                                            |
|                                                                |
+================================================================+
```

*"Casa pulita = mente pulita = lavoro pulito!"*

---

*"Casa pulita = mente pulita = lavoro pulito!"*
