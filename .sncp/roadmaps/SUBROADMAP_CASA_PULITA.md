# SUBROADMAP - CASA PULITA

> **Aggiornato:** 17 Gennaio 2026 - Sessione 246
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
FASE 3: Consolidare docs  [COMPLETATO] Sessione 246
FASE 4: DNA Agents        [COMPLETATO] Sessione 246
FASE 5: Automazione       [PROSSIMO]
FASE 6: Studio Periodico  [DA FARE]
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

| Metrica | Prima | Dopo Fase 4 | Target |
|---------|-------|-------------|--------|
| **SNCP Health** | 5.8/10 | ~8.5/10 | 9.5/10 |
| **stato.md** | 700 righe | 216 righe | < 300 sempre |
| **DNA totale** | 6800 righe | 1264 righe | < 1500 |
| **Context/sessione** | ~28k tokens | ~15k tokens | < 15k |

---

## PROSSIMO STEP

**Fase 5:** Automazione (script archivio, hook pre-commit)
**Fase 6:** Studio Manutenzione Periodica

---

*"Casa pulita = mente pulita = lavoro pulito!"*
