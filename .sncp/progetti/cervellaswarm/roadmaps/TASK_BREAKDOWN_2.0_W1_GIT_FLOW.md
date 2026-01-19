# TASK BREAKDOWN - CervellaSwarm 2.0 Week 1

> **Feature:** Git Flow + Attribution
> **Periodo:** 20-26 Gennaio 2026
> **Basato su:** Studio Aider Git Integration

---

## OBIETTIVO

```
OGGI:
  Commit manuali → inconsistenti → storia confusa

DOPO W1:
  Auto-commit → conventional → storia professionale
  "feat(api): add login (cervella-backend)"
```

---

## TASK GIORNALIERI

### Giorno 1 (Lun 20 Gen): SETUP + SCRIPT BASE

**Task 1.1: Creare script auto-commit**
```
File: scripts/utils/git_worker_commit.sh

Funzionalità:
- Riceve: worker_name, scope, message
- Genera: conventional commit
- Aggiunge: Co-authored-by attribution
```

**Task 1.2: Creare template prompt**
```
File: .sncp/templates/commit_message_prompt.txt

Template per generare messaggi:
- Tipo (feat/fix/docs/refactor/chore)
- Scope (api/ui/db/etc)
- Descrizione breve
```

**Definition of Done:**
- [ ] Script creato
- [ ] Template creato
- [ ] Test manuale OK

---

### Giorno 2 (Mar 21 Gen): CONVENTIONAL COMMITS

**Task 2.1: Implementare parser tipo commit**
```
TIPI SUPPORTATI:
- feat: Nuova feature
- fix: Bug fix
- docs: Solo documentazione
- refactor: Ristrutturazione codice
- chore: Manutenzione
- test: Aggiunta test
```

**Task 2.2: Implementare scope detection**
```
SCOPE AUTO-DETECT:
- packages/cli/* → cli
- packages/mcp-server/* → mcp
- docs/* → docs
- scripts/* → scripts
```

**Definition of Done:**
- [ ] Parser tipo funziona
- [ ] Scope auto-detect funziona
- [ ] Test su 5 commit diversi

---

### Giorno 3 (Mer 22 Gen): ATTRIBUTION

**Task 3.1: Implementare Co-authored-by**
```
FORMATO:
Co-authored-by: CervellaSwarm (backend-worker/claude-sonnet-4-5) <noreply@cervellaswarm.com>

VARIANTI PER WORKER:
- backend-worker
- frontend-worker
- tester-worker
- guardiana-qualita
- guardiana-ops
```

**Task 3.2: Creare mapping worker → attribution**
```
File: scripts/utils/worker_attribution.json

{
  "cervella-backend": "backend-worker/claude-sonnet-4-5",
  "cervella-frontend": "frontend-worker/claude-sonnet-4-5",
  "cervella-guardiana-qualita": "guardiana-qualita/claude-opus-4-5"
}
```

**Definition of Done:**
- [ ] Attribution corretta per ogni worker
- [ ] JSON mapping creato
- [ ] Test integration

---

### Giorno 4 (Gio 23 Gen): INTEGRAZIONE CLI

**Task 4.1: Integrare in spawn-workers**
```
FLOW:
1. Worker riceve task
2. Worker esegue modifiche
3. Script auto-commit chiamato
4. Commit con attribution
```

**Task 4.2: Flag --no-commit**
```
Opzione per disabilitare auto-commit:
cervellaswarm task "fix bug" --no-commit
```

**Definition of Done:**
- [ ] Integrazione spawn-workers completa
- [ ] Flag --no-commit funziona
- [ ] Test end-to-end

---

### Giorno 5 (Ven 24 Gen): UNDO COMMAND

**Task 5.1: Implementare /undo**
```
COMPORTAMENTO:
1. Verifica ultimo commit è CervellaSwarm
2. Se sì: git reset --soft HEAD^
3. Mostra diff delle modifiche annullate
```

**Task 5.2: Safety checks**
```
PROTEZIONI:
- Non undo commit non-CervellaSwarm
- Conferma prima di undo
- Max 1 undo alla volta
```

**Definition of Done:**
- [ ] /undo funziona
- [ ] Safety checks attivi
- [ ] Documentazione scritta

---

### Giorno 6-7 (Sab-Dom 25-26 Gen): DOCS + POLISH

**Task 6.1: Documentazione**
```
File: docs/GIT_ATTRIBUTION.md

Contenuto:
- Come funziona auto-commit
- Formato messaggi
- Come fare undo
- Esempi
```

**Task 6.2: Test completi**
```
Test scenarios:
- Nuovo file creato
- File modificato
- File eliminato
- Multiple file changes
- Undo dopo commit
```

**Definition of Done:**
- [ ] Docs complete
- [ ] Tutti i test passano
- [ ] README aggiornato

---

## COMMIT MESSAGE ESEMPIO FINALE

```
feat(api): Add authentication endpoints

Implemented login/register/me endpoints with JWT tokens.
Added password hashing and token validation.

Co-authored-by: CervellaSwarm (backend-worker/claude-sonnet-4-5) <noreply@cervellaswarm.com>
```

---

## METRICHE SUCCESSO W1

| Metrica | Target |
|---------|--------|
| Script funzionante | 100% |
| Conventional Commits | 100% formato corretto |
| Attribution | Tutti i worker mappati |
| /undo | Funziona con safety |
| Docs | Complete |

---

*Creato: 19 Gennaio 2026 - Sessione 270*
*Post Show HN Launch - Iniziamo 2.0!*
