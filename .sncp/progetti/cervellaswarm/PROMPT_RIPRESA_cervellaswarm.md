# PROMPT RIPRESA - CervellaSwarm

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 235
> **FASE ATTUALE:** MCP Server configurato per ENTRAMBE le versioni!

---

## AZIONE IMMEDIATA - TEST MCP

```
+================================================================+
|   RIAVVIA CLAUDE CODE E TESTA!                                 |
|                                                                |
|   Sessione 235 ha fixato il bug:                               |
|   - Config era solo in ~/.claude/settings.json                 |
|   - Ma usi Claude Code INSIDERS!                               |
|   - Ora config anche in ~/.claude-insiders/settings.json       |
|                                                                |
|   DOPO RIAVVIO, testa:                                         |
|   > "usa check_status di cervellaswarm"                        |
|   > "list_workers di cervellaswarm"                            |
+================================================================+
```

---

## COSA È STATO FATTO (Sessione 235)

| Cosa | Status |
|------|--------|
| Server MCP funziona | OK (testato via stdio) |
| Protocollo MCP | OK (risponde a initialize + tools/list) |
| 3 tools esposti | OK (spawn_worker, list_workers, check_status) |
| Bug trovato | Config solo in ~/.claude/ non in ~/.claude-insiders/ |
| Fix applicato | Aggiunta config a ~/.claude-insiders/settings.json |

**Files modificati:**
- `~/.claude/settings.json` (Sessione 234)
- `~/.claude-insiders/settings.json` (Sessione 235)

---

## ROADMAP

```
FASE 0: Fondamenta           [####################] FATTO!
FASE 1: POC MCP              [####################] FATTO!
FASE 2: MCP Completo         [########............] IN CORSO
  - settings.json normale    [####################] FATTO
  - settings.json insiders   [####################] FATTO
  - Test REALE post-restart  [....................] DA FARE
  - Resources SNCP           [....................] PROSSIMO
FASE 3: Polish & Launch      [....................]
```

---

## TL;DR

**Sessione 235:** Fixato bug - config mancava per Claude Insiders.

**ORA:** Riavvia Claude Code e testa `check_status`.

*"SU CARTA != REALE!"*
