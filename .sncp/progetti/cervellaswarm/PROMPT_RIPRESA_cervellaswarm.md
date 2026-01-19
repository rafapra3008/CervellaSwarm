# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 19 Gennaio 2026 - Sessione 276
> **STATUS:** W2 Day 3 - Test Miracollo + DECISIONE AUTO-CONTEXT

---

## SESSIONE 276 - W2 DAY 3 TEST + DECISIONE

```
+================================================================+
|   W2 TREE-SITTER - DAY 3 COMPLETATO!                          |
|   Test su Miracollo: PROBLEMA TROVATO                          |
|   DECISIONE: Aspettare W2.5 per AUTO-CONTEXT perfetto         |
+================================================================+
```

**FATTO in Sessione 276:**
- Double check Guardiana Qualita: 91/100 APPROVED
- Test AUTO-CONTEXT su Miracollo PMS
- SCOPERTA: `extract_references()` ritorna vuoto (W2.5)
- PageRank non funziona (ordine alfabetico)
- Analisi con Guardiana Qualita + Guardiana Ops
- **DECISIONE RAFA:** Opzione A - Aspettare W2.5
- Standard richiesto: **minimo 9.5/10**

---

## DECISIONE AUTO-CONTEXT

```
NON usare --with-context fino a W2.5!

Motivo: PageRank non funziona senza references
Soluzione: Implementare extract_references() in W2.5
Target: Score 9.5/10 prima di rilasciare
```

**Report completo:** `reports/decisione_autocontext_20260119.md`

---

## ROADMAP 2.0 AGGIORNATA

```
W1: Git Flow       [DONE] COMPLETATO!
W2: Tree-sitter    [##################..] 60% (Day 3/7)
    Day 1-2: Core + Integration  DONE
    Day 3: Test Miracollo        DONE (problema trovato)
    Day 4-5: W2.5 References     PROSSIMO
    Day 6-7: Polish + 9.5/10     PIANIFICATO
W3: Architect/Editor
W4: Polish + v2.0-beta
```

---

## W2.5 - PIANO REFERENCE EXTRACTION

| Task | Descrizione | Sessioni |
|------|-------------|----------|
| 1 | `extract_references()` Python | 1 |
| 2 | `extract_references()` TypeScript | 1 |
| 3 | Test CervellaSwarm + Miracollo | 1 |
| 4 | Audit Guardiana (9.5/10) | 0.5 |

**Totale:** 3-4 sessioni

---

## FILE W2 TREE-SITTER

| File | Righe | Status |
|------|-------|--------|
| `treesitter_parser.py` | 365 | OK |
| `symbol_extractor.py` | 484 | W2.5 needed |
| `dependency_graph.py` | 451 | OK |
| `repo_mapper.py` | 571 | OK |
| `generate_worker_context.py` | 147 | OK |
| `spawn-workers.sh` | 1136 | v3.7.0 |

---

## VERSIONI LIVE

| Package | Versione |
|---------|----------|
| CLI | 0.1.2 |
| MCP Server | 0.2.3 |
| spawn-workers | 3.7.0 |

---

## PROSSIMA SESSIONE

**W2.5 - Reference Extraction:**
1. Implementare `extract_references()` per import Python
2. Testare PageRank con references reali
3. Verificare ordine file per importanza (non alfabetico)
4. Audit Guardiana Qualita: target 9.5/10

---

*"Non abbiamo fretta. Minimo 9.5 di score!"*
*Sessione 276 - Cervella & Rafa*
