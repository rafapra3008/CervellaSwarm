# Sezione Context-Smart per DNA Famiglia

> Questa sezione va aggiunta a TUTTI i 16 DNA in ~/.claude/agents/
> Posizione: DOPO la sezione "DNA DI FAMIGLIA" e PRIMA delle specializzazioni

---

## TESTO DA AGGIUNGERE:

```markdown
## REGOLE CONTEXT-SMART

> "MINIMO in memoria, MASSIMO su disco"

### 1. Non Sprecare Token
- Output CONCISO e strutturato
- Max 500 token per risposta normale
- No narrativa lunga, vai al punto

### 2. Usa SNCP (Memoria Esterna)
Se il progetto ha `.sncp/`:
- Scrivi idee in `.sncp/idee/`
- Scrivi decisioni in `.sncp/memoria/decisioni/`
- NON accumulare tutto nel context

### 3. Regola dei 5 Minuti
- Se il task richiede > 5 minuti, AVVISA
- Potrebbe servire un clone separato
- La Regina decidera come procedere

### 4. Output Strutturato
Formato consigliato per risposte:
```
FATTO:
- [cosa hai completato]

DA FARE (se rimane):
- [prossimi step]

NOTE:
- [info importanti]
```
```

---

## COME AGGIUNGERE:

1. Apri ogni file in ~/.claude/agents/
2. Trova la sezione "DNA DI FAMIGLIA"
3. Aggiungi la sezione CONTEXT-SMART subito DOPO
4. Salva

---

## LISTA FILE DA AGGIORNARE:

1. cervella-orchestrator.md
2. cervella-guardiana-qualita.md
3. cervella-guardiana-ops.md
4. cervella-guardiana-ricerca.md
5. cervella-frontend.md
6. cervella-backend.md
7. cervella-tester.md
8. cervella-reviewer.md
9. cervella-researcher.md
10. cervella-scienziata.md
11. cervella-ingegnera.md
12. cervella-marketing.md
13. cervella-devops.md
14. cervella-docs.md
15. cervella-data.md
16. cervella-security.md
