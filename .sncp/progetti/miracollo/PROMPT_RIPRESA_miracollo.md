# PROMPT RIPRESA - Miracollo

> **Ultimo aggiornamento:** 18 Gennaio 2026 - Sessione 260
> **Status:** PRODUZIONE STABILE

---

## SESSIONE 260: CONSOLIDAMENTO DOCUMENTI

### Cosa Abbiamo Fatto

```
CONSOLIDAMENTO DEPLOY BLINDATO:

1. SUBROADMAP_DEPLOY_BLINDATO.md
   - Aggiornata come documento MASTER
   - FASE 1 marcata COMPLETATA (era erroneamente PENDENTE)
   - Integrata architettura e diagrammi

2. SUBROADMAP_DEPLOY_ROBUSTO.md
   - ARCHIVIATA in .sncp/archivio/2026-01/roadmaps/
   - Contenuto migrato nel documento MASTER

Risultato: 1 solo documento deploy da seguire!
```

---

## STATO SUBROADMAP DEPLOY BLINDATO

```
Path: CervellaSwarm/.sncp/roadmaps/SUBROADMAP_DEPLOY_BLINDATO.md

FASE 1: Fix immediato          ✓ COMPLETATA (18 Gen)
FASE 2: Guardrail tecnici      ← PRONTA
FASE 3: Un solo entry point    PIANIFICATA
FASE 4: Wizard interattivo     PIANIFICATA
FASE 5: Monitoraggio           FUTURO

Success criteria: 0 incidenti per 30 giorni
Contatore: 0 giorni (reset 18 Gen 2026)
```

---

## ARCHITETTURA 3 BRACCI

```
MIRACOLLO
├── PMS CORE (:8001)        90% - STABILE!
├── MIRACOLLOOK (:8002)     60% - Non toccato
└── ROOM HARDWARE (:8003)   10% - Attesa hardware
```

---

## MODULO VCC (DA TESTARE)

```
Backend: POST /api/payments/charge-vcc
Frontend: Stripe Elements + bottone "VCC Booking"
Stripe Sandbox: acct_1Sqrxk7aXUHP1bna
Carta test: 4242 4242 4242 4242

STATUS: Codice completo, DA TESTARE!
```

---

## STATO INFRASTRUTTURA

```
VM MIRACOLLO:
- 1 container: miracollo-backend-1 (healthy)
- 1 nginx: miracollo-nginx (healthy)
- docker-compose.yml con name:miracollo
```

---

## PROSSIMI STEP

```
1. Test VCC nel browser (carta 4242)
2. FASE 2 subroadmap (wrapper docker run)
3. Documentare VCC
```

---

## FILE CHIAVE

| File | Scopo |
|------|-------|
| `.sncp/roadmaps/SUBROADMAP_DEPLOY_BLINDATO.md` | Roadmap deploy MASTER |
| `~/.claude/CHECKLIST_DEPLOY.md` | Checklist obbligatoria |
| `miracollogeminifocus/deploy.sh` | Script deploy locale |

---

*"Fatto BENE > Fatto veloce"*
