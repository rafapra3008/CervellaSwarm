# Output: Aggiornamento DNA 11 Worker

## Risultato
✅ **TASK COMPLETATO**

## Obiettivo
Aggiungere sezione "PROTOCOLLI COMUNICAZIONE SWARM v1.0.0" ai DNA dei restanti 11 worker (Sonnet).

## Worker Aggiornati

| # | Worker | File | Status |
|---|--------|------|--------|
| 1 | cervella-frontend | ~/.claude/agents/cervella-frontend.md | ✅ |
| 2 | cervella-tester | ~/.claude/agents/cervella-tester.md | ✅ |
| 3 | cervella-reviewer | ~/.claude/agents/cervella-reviewer.md | ✅ |
| 4 | cervella-researcher | ~/.claude/agents/cervella-researcher.md | ✅ |
| 5 | cervella-scienziata | ~/.claude/agents/cervella-scienziata.md | ✅ |
| 6 | cervella-ingegnera | ~/.claude/agents/cervella-ingegnera.md | ✅ |
| 7 | cervella-marketing | ~/.claude/agents/cervella-marketing.md | ✅ |
| 8 | cervella-devops | ~/.claude/agents/cervella-devops.md | ✅ |
| 9 | cervella-docs | ~/.claude/agents/cervella-docs.md | ✅ |
| 10 | cervella-data | ~/.claude/agents/cervella-data.md | ✅ |
| 11 | cervella-security | ~/.claude/agents/cervella-security.md | ✅ |

## Verifica Finale

```bash
$ grep -c "PROTOCOLLI COMUNICAZIONE" ~/.claude/agents/*.md
```

**Risultato: 16 file trovati** (4 già fatti + 11 nuovi = 15 agenti + 1 orchestrator)

Tutti i 16 agenti della famiglia hanno ora la sezione PROTOCOLLI COMUNICAZIONE!

## Contenuto Sezione Aggiunta

Ogni worker ha ricevuto:
- **Header**: PROTOCOLLI COMUNICAZIONE SWARM v1.0.0
- **Riferimento**: Link a cervella-guardiana-qualita per docs completa
- **Script Helper**: update-status.sh, heartbeat-worker.sh, ask-regina.sh
- **Workflow Task Standard**: 7 step procedura
- **Esempio Pratico**: Personalizzato per ogni ruolo

## Esempi Personalizzati

| Worker | Esempio |
|--------|---------|
| Frontend | Creare UserCard component |
| Tester | Test API /api/users |
| Reviewer | Review modulo authentication |
| Researcher | Ricerca best practices SSE |
| Scienziata | Analisi competitor PMS |
| Ingegnera | Analisi tech debt modulo backend |
| Marketing | Ottimizza landing page checkout |
| DevOps | Setup monitoring dashboard |
| Docs | Documentare API users |
| Data | Ottimizza query report mensile |
| Security | Audit sicurezza modulo auth |

## Note
- Sezione inserita PRIMA della firma finale di ogni DNA
- Stesso formato e stile del template (cervella-backend)
- Tutti i file leggibili e formattati correttamente

---

**Completato da:** cervella-docs
**Data:** 2026-01-07
**Tempo:** ~30 minuti
