# SUBROADMAP: Deploy Blindato

> **Creata:** 18 Gennaio 2026 - Sessione 259
> **Consolidata:** 18 Gennaio 2026 - Sessione 260
> **Status:** FASE 1 + FASE 2 COMPLETATE!
> **Obiettivo:** Rendere IMPOSSIBILE sbagliare il deploy

---

## IL PROBLEMA ROOT

```
+--------------------------------------------------------------------+
|                                                                    |
|   "Rendere il PATH CORRETTO piu FACILE del path sbagliato"        |
|                                                                    |
+--------------------------------------------------------------------+
```

**Pattern identificato (Sessioni 256-259):**
```
CREIAMO SCRIPT → NON LI USIAMO → CASINO → FIX → REPEAT
```

**Cause root:**
- Path manuale più corto del path corretto
- Nessun enforcement (posso bypassare)
- Checklist passive che non leggiamo
- Container duplicati non rilevati

---

## ARCHITETTURA ATTUALE (funziona!)

```
LOCALE                          VM MIRACOLLO
┌─────────────────┐            ┌─────────────────┐
│ ./deploy.sh     │            │ ~/app/          │
│                 │    SSH     │                 │
│ 1. git status   │ ────────── │ 3. git pull     │
│ 2. git push     │            │ 4. docker up    │
│                 │            │ 5. health check │
└─────────────────┘            └─────────────────┘
         │
         ▼
   GitHub Actions
   (deploy.yml v4.1.0)
```

**Container attivi:**
- `miracollo-backend-1` (healthy)
- `miracollo-nginx` (healthy)

---

## DOCUMENTI CORRELATI

| Documento | Path | Scopo |
|-----------|------|-------|
| **CHECKLIST_DEPLOY** | `~/.claude/CHECKLIST_DEPLOY.md` | Checklist OBBLIGATORIA pre-deploy |
| **deploy.sh** | `miracollogeminifocus/deploy.sh` | Script deploy locale |
| **deploy.yml** | `.github/workflows/deploy.yml` | GitHub Actions (auto) |
| **docker-compose.yml** | `miracollogeminifocus/docker-compose.yml` | Stack Docker |

---

## FASI IMPLEMENTAZIONE

### FASE 1: FIX IMMEDIATO

| Status | Completata 18 Gennaio 2026 - Sessione 259 |
|--------|-------------------------------------------|

| Task | Descrizione | Commit |
|------|-------------|--------|
| 1.1 | Fix naming conflict planning.py → planning_core.py | 7c2867f |
| 1.2 | Rimosso container rogue `app-backend-1` | 2436923 |
| 1.3 | Aggiunto `name: miracollo` in docker-compose.yml | 2436923 |
| 1.4 | Eseguita migration 025 (colonna imported) | manuale |

**Risultato:** Produzione STABILE, 1 solo container backend.

---

### FASE 2: GUARDRAIL TECNICI

| Status | Completata 18 Gennaio 2026 - Sessione 260 |
|--------|-------------------------------------------|

**Obiettivo:** Bloccare comandi manuali pericolosi

| Task | Cosa | Status |
|------|------|--------|
| 2.1 | Wrapper bash che blocca `docker run` | **FATTO** |
| 2.2 | Pre-flight check in deploy.sh (conta container) | **FATTO** |
| 2.3 | Post-deploy health check OBBLIGATORIO (3 check) | **FATTO** |

**Cosa è stato implementato:**

1. **Wrapper in ~/.bashrc sulla VM:**
   - Blocca `docker run` in sessione interattiva
   - Forza uso di `docker compose`

2. **Pre-flight check in deploy.sh:**
   - Conta container backend
   - Blocca deploy se > 1 container
   - Avvisa se naming non corretto

3. **Health check OBBLIGATORIO (3 verifiche):**
   - Container status sulla VM
   - Endpoint /api/health
   - Endpoint /api/hotels (routing funzionante)
   - Se fallisce → exit 1 + suggerisce rollback

**Commit:** d71290d

---

### FASE 3: UN SOLO ENTRY POINT

| Status | PIANIFICATA |
|--------|-------------|

**Obiettivo:** Da molti script a 4 comandi

| Comando | Cosa fa |
|---------|---------|
| `miracollo start` | Verifica stato (container, DB, health) |
| `miracollo deploy` | Deploy con TUTTE le verifiche automatiche |
| `miracollo logs` | Mostra logs container |
| `miracollo rollback` | Torna alla versione precedente |

---

### FASE 4: WIZARD INTERATTIVO

| Status | PIANIFICATA |
|--------|-------------|

**Obiettivo:** Non puoi saltare step

```
$ miracollo deploy

╔════════════════════════════════════════╗
║         MIRACOLLO DEPLOY v1.0          ║
╚════════════════════════════════════════╝

[PRE-FLIGHT]
  ✓ Git pulito
  ✓ Test locale passato
  ? Backup DB fatto? (s/n) > s
  ? Guardiana approvato? (s/n) > s

[DEPLOY]
  → docker-compose down --remove-orphans
  → docker-compose up -d --build
  → Health check...

[POST-DEPLOY]
  ✓ 1 container backend
  ✓ Health check OK
  ✓ Planning risponde

╔════════════════════════════════════════╗
║         DEPLOY COMPLETATO!             ║
╚════════════════════════════════════════╝
```

---

### FASE 5: MONITORAGGIO CONTINUO

| Status | FUTURO |
|--------|--------|

| Task | Cosa |
|------|------|
| 5.1 | Cron ogni 5 min che verifica N container |
| 5.2 | Alert se container duplicati |
| 5.3 | Log di tutti i deploy |
| 5.4 | Dashboard stato infrastruttura |

---

## CHECKLIST STATO FASI

| Fase | Descrizione | Status | Data |
|------|-------------|--------|------|
| FASE 1 | Fix immediato | **COMPLETATA** | 18 Gen 2026 |
| FASE 2 | Guardrail tecnici | **COMPLETATA** | 18 Gen 2026 |
| FASE 3 | Un solo entry point | PIANIFICATA | - |
| FASE 4 | Wizard interattivo | PIANIFICATA | - |
| FASE 5 | Monitoraggio | FUTURO | - |

---

## SUCCESS CRITERIA

```
+--------------------------------------------------------------------+
|                                                                    |
|   SUCCESSO = 0 incidenti deploy per 30 giorni consecutivi         |
|                                                                    |
|   Contatore attuale: 0 giorni (reset 18 Gen 2026)                  |
|                                                                    |
+--------------------------------------------------------------------+
```

---

## REGOLE D'ORO

```
+--------------------------------------------------------------------+
|                                                                    |
|   1. MAI comandi Docker manuali sulla VM                           |
|   2. SEMPRE usare deploy.sh o GitHub Actions                       |
|   3. SEMPRE leggere CHECKLIST_DEPLOY prima                         |
|   4. Se serve altro → PRIMA aggiorna lo script                     |
|                                                                    |
+--------------------------------------------------------------------+
```

---

## NOTE CONSOLIDAMENTO

Questo documento consolida:
- `SUBROADMAP_DEPLOY_BLINDATO.md` (Sessione 259)
- `SUBROADMAP_DEPLOY_ROBUSTO.md` (Sessione 256) → Archiviata

La versione precedente di DEPLOY_ROBUSTO è stata archiviata in:
`.sncp/archivio/2026-01/roadmaps/SUBROADMAP_DEPLOY_ROBUSTO_ARCHIVED.md`

---

*"Lavoriamo in pace! Senza casino! Dipende da noi!"*
*"Fatto BENE > Fatto veloce"*
