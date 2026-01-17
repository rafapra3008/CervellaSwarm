# SUBROADMAP - CASA PULITA

> **Sessione 244** - 17 Gennaio 2026
> "Lavoriamo in pace! Senza casino! Dipende da noi!"

---

## OBIETTIVO

Sistemare l'organizzazione interna della famiglia:
- SNCP pulito e navigabile
- Context che non spreca token
- Comunicazione chiara tra sessioni
- Score SNCP: 5.8 → 9.5

---

## STUDI COMPLETATI

| Report | Cosa | Score |
|--------|------|-------|
| `analisi_ingegnera_organizzazione.md` | Struttura SNCP, problemi, soluzioni | 680 righe |
| `ricerca_best_practices_multi_agent.md` | Pattern Google/Microsoft/AWS | 491 righe |
| `analisi_context_inefficienze.md` | Consumo token, sprechi | 463 righe |
| `audit_guardiana_standard.md` | Regole ignorate | (Guardiana) |

---

## DECISIONI PRESE

```
1. stato.md    → Archiviare sessioni < 220
2. Reports     → Soglia 7 giorni per archivio
3. Duplicati   → Originali in bracci/, eliminare da idee/
4. Naming      → YYYYMMDD_TIPO_descrizione.md (confermato)
```

Documento: `.sncp/decisioni/20260117_STANDARD_SNCP_FAMIGLIA.md`

---

## FASE 1: QUICK WIN (30 min)

**Chi:** Backend Worker
**Quando:** Prima occasione

| # | Task | Risparmio |
|---|------|-----------|
| 1 | Disabilitare `session_start_scientist.py` | 2500 tokens |
| 2 | Disabilitare `session_start_reminder.py` | 600 tokens |
| 3 | Compattare `cervellaswarm/stato.md` (700 → 280) | Compliance |

**Comando quick:**
```bash
cd ~/.claude/hooks
mv session_start_scientist.py session_start_scientist.py.DISABLED
mv session_start_reminder.py session_start_reminder.py.DISABLED
```

---

## FASE 2: PULIZIA SNCP (1-2 sessioni)

**Chi:** Backend Worker + Guardiana verifica
**Quando:** Prossima sessione dedicata

| # | Task | Impatto |
|---|------|---------|
| 1 | Archiviare reports Miracollo > 7 giorni | 87 → 22 file |
| 2 | Eliminare 8 duplicati VDA da idee/ | -600KB |
| 3 | Creare struttura `archivio/2026-01/` | Organizzazione |
| 4 | Creare `archivio/SESSIONI_207_218.md` | stato.md sotto limite |

---

## FASE 3: CONSOLIDARE DOCS (2-3 ore)

**Chi:** Ingegnera design + Backend implementa
**Quando:** Settimana prossima

| # | Task | Risparmio |
|---|------|-----------|
| 1 | Consolidare 3 CLAUDE.md in 1 | 3800 tokens |
| 2 | Rimuovere COSTITUZIONE da SubagentStart system-reminder | 1200 tokens |
| 3 | Aggiornare project CLAUDE.md (solo specifiche) | Chiarezza |

---

## FASE 4: DNA AGENTS (4 ore)

**Chi:** Ingegnera + Backend
**Quando:** Sprint dedicato

| # | Task | Risparmio |
|---|------|-----------|
| 1 | Creare `_SHARED_DNA.md` (340 righe comuni) | Base |
| 2 | Refactor 16 DNA agent (solo specializzazione) | 12000 tokens |
| 3 | Aggiornare SubagentStart hook | Loading smart |

---

## FASE 5: AUTOMAZIONE (4-6 ore)

**Chi:** Backend
**Quando:** Dopo Fase 4

| # | Task | Valore |
|---|------|--------|
| 1 | Script archivio automatico reports > 7 giorni | Zero manutenzione |
| 2 | Hook pre-commit: verifica naming standard | Compliance |
| 3 | Hook che BLOCCA (non solo warning) | Enforcement |
| 4 | File locks per evitare conflitti paralleli | Zero doppio lavoro |

---

## METRICHE SUCCESS

| Metrica | Prima | Dopo Fase 1 | Dopo Tutto |
|---------|-------|-------------|------------|
| **SNCP Health** | 5.8/10 | 7.2/10 | 9.5/10 |
| **Context spreco** | 14% | 11% | 6.5% |
| **stato.md** | 700 righe | 280 righe | < 300 sempre |
| **Duplicati** | 15+ file | 15 file | 0 file |
| **Naming issues** | ~40% | ~40% | < 5% |

---

## UN PROGRESSO AL GIORNO

```
+================================================================+
|                                                                |
|   "Non importa quanto e grande il progetto.                   |
|    Arriveremo. SEMPRE."                                       |
|                                                                |
|   Un task alla volta.                                          |
|   Una fase alla volta.                                         |
|   Un progresso al giorno.                                      |
|                                                                |
+================================================================+
```

---

## PROSSIMO STEP

**FASE 1** - Quick Win (oggi o prossima sessione):
1. Disabilitare i 2 hook inutili
2. Compattare stato.md

*"I dettagli fanno SEMPRE la differenza!"*
