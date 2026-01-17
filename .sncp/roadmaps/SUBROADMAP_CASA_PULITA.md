# SUBROADMAP - CASA PULITA

> **Aggiornato:** 17 Gennaio 2026 - Sessione 245
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
FASE 1: Quick Win         [COMPLETATO] Sessione 244
FASE 2: Pulizia SNCP      [COMPLETATO] Sessione 245
FASE 3: Consolidare docs  [PROSSIMO]
FASE 4: DNA Agents        [DA FARE]
FASE 5: Automazione       [DA FARE]
FASE 6: Studio Periodico  [NUOVO - DA FARE]
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

## FASE 3: CONSOLIDARE DOCS

**Chi:** Ingegnera design + Backend implementa
**Quando:** Prossima sessione

| # | Task | Risparmio |
|---|------|-----------|
| 1 | Consolidare 3 CLAUDE.md in 1 | 3800 tokens |
| 2 | Rimuovere COSTITUZIONE da SubagentStart | 1200 tokens |
| 3 | Aggiornare project CLAUDE.md (solo specifiche) | Chiarezza |

---

## FASE 4: DNA AGENTS

**Chi:** Ingegnera + Backend

| # | Task | Risparmio |
|---|------|-----------|
| 1 | Creare `_SHARED_DNA.md` | Base |
| 2 | Refactor 16 DNA agent | 12000 tokens |
| 3 | Aggiornare SubagentStart hook | Loading smart |

---

## FASE 5: AUTOMAZIONE

**Chi:** Backend

| # | Task | Valore |
|---|------|--------|
| 1 | Script archivio automatico reports > 7 giorni | Zero manutenzione |
| 2 | Hook pre-commit: verifica naming | Compliance |
| 3 | Hook che BLOCCA (non solo warning) | Enforcement |

---

## FASE 6: STUDIO MANUTENZIONE PERIODICA [NUOVO]

> **Richiesto da Rafa - Sessione 245**
> "Vale la pena automatizzare Casa Pulita periodicamente?"

**Chi:** cervella-ingegnera + cervella-researcher
**Quando:** Sessione dedicata (puo essere background)
**Output:** Report con raccomandazioni

### Domande da Rispondere

```
1. FREQUENZA
   - Ogni 7 giorni? Ogni 3 giorni?
   - Trigger su dimensione file? (es. stato.md > 400 righe)
   - Trigger su numero file? (es. reports/ > 50)

2. COSA AUTOMATIZZARE
   - Archivio automatico file vecchi
   - Check duplicati
   - Compattazione stato.md
   - Verifica naming
   - Health score check

3. COME IMPLEMENTARE
   - launchd job (come sncp_daily)
   - Hook pre-sessione
   - Script manuale con reminder
   - Combinazione?

4. SCOPE
   - Solo CervellaSwarm?
   - Tutti i progetti?
   - Configurabile per progetto?

5. EFFORT vs VALORE
   - Quanto costa implementare?
   - Quanto risparmia nel tempo?
   - ROI positivo?
```

### Best Practices da Studiare

```
- Come fanno grandi team multi-agent?
- Pattern manutenzione codebase (git gc, etc)
- Strategie archivio enterprise
- Self-healing systems
```

---

## METRICHE SUCCESS

| Metrica | Prima | Dopo Fase 2 | Target |
|---------|-------|-------------|--------|
| **SNCP Health** | 5.8/10 | ~7.2/10 | 9.5/10 |
| **stato.md** | 700 righe | 216 righe | < 300 sempre |
| **Duplicati** | 15+ file | 0 file | 0 file |

---

## PROSSIMO STEP

**Fase 3:** Consolidare CLAUDE.md (prossima sessione)
**Fase 6:** Studio Manutenzione Periodica (sessione dedicata o background)

---

*"Casa pulita = mente pulita = lavoro pulito!"*
