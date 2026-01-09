# [NOME PROGETTO] - CLAUDE.md Template Snello

> **Target:** ~40 linee | **Obiettivo:** -60% token startup

---

## Cosa Tenere

```
1. Nome + visione (5 linee)
2. Regole context-smart (10 linee)
3. Memoria: dove scrivere (5 linee)
4. Puntatori a file dettagli (10 linee)
5. Note progetto specifiche (10 linee)
```

---

## TEMPLATE (copia e adatta)

```markdown
# [Nome Progetto]

> [Una frase che descrive il progetto]

## Regole Context-Smart

- Task < 5 min → Task tool interno
- Task > 5 min → Git clone separato
- Scrivi su .sncp/ mentre lavori
- Output conciso, max 500 token

## Memoria

- `.sncp/idee/` → idee e ricerche
- `.sncp/memoria/decisioni/` → decisioni prese
- `.sncp/coscienza/` → pensieri sessione

## File Importanti

| File | Quando Leggerlo |
|------|-----------------|
| PROMPT_RIPRESA.md | Inizio sessione |
| NORD.md | Se serve direzione |
| .sncp/idee/*.md | Per dettagli specifici |

## Note Progetto

[Specifiche di questo progetto: tech stack, comandi, path importanti]
```

---

## Cosa NON Mettere

- Diagrammi grandi (mettili in docs/)
- Liste complete (puntatori invece)
- Filosofia dettagliata (sta in COSTITUZIONE)
- Struttura file (si vede con ls)
