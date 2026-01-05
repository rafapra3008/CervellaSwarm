# TASK: Ricerca Anti-Compact - Claude Code Internals

**Task ID:** RICERCA_ANTICOMPACT_03
**Assegnato a:** cervella-researcher
**Data:** 2026-01-04
**Priorità:** ALTA

---

## CONTESTO

Vogliamo eliminare il flusso MANUALE dell'anti-compact.
Attualmente Rafa deve dire "siamo al 10%" - INACCETTABILE nel 2026!

Rafa ha scoperto:
- Il messaggio "Context left: X%" viene dal BINARIO di Claude
- Dalla v2.0.70 c'è un campo interno `current_usage`
- VS Code solo visualizza

---

## MISSIONE

Ricerca TECNICA su Claude Code internals:

1. **Campo `current_usage`**
   - Dove è esposto?
   - È accessibile via API?
   - È nei file di stato?

2. **Hooks Claude Code**
   - Lista COMPLETA di tutti gli hooks disponibili
   - C'è un hook per "context low"?
   - C'è un hook per "before compact"?

3. **File di stato Claude**
   - `~/.claude/` - cosa c'è?
   - `stats-cache.json` - contiene current_usage?
   - Altri file utili?

4. **GitHub Claude Code**
   - Issues aperte su context monitoring
   - Feature requests
   - Workaround della community

5. **Documentazione ufficiale**
   - Qualcosa che ci siamo persi?
   - API non documentate?

---

## OUTPUT ATTESO

Scrivi report in: `.swarm/tasks/RICERCA_ANTICOMPACT_03_output.md`

Struttura:
```
## CURRENT_USAGE
[dove è, come accederlo]

## HOOKS DISPONIBILI
[lista completa, quale serve]

## FILE DI STATO
[cosa contengono, quale utile]

## COMMUNITY SOLUTIONS
[cosa hanno fatto altri]

## RACCOMANDAZIONE
[strada migliore]

## FONTI
[link, issues, docs]
```

---

## PERCHÉ

"Siamo nel 2026, non anni 80!" - Rafa
Troviamo la soluzione DEFINITIVA!

---

*"UTILE != INTERESSANTE - Ricerchiamo quello che SERVE!"*
