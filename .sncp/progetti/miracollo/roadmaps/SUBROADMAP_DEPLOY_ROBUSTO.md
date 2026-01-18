# SUBROADMAP: Deploy Robusto e Professionale

> **Creata:** 18 Gennaio 2026 - Sessione 256
> **Obiettivo:** Struttura deploy robusta e professionale per Miracollo

---

## CONTESTO

Sessione 256 ha risolto problemi di deploy ricorrenti. Le Guardiane hanno analizzato
e proposto miglioramenti graduali per rendere la struttura più robusta.

---

## COMPLETATO (Sessione 256)

- [x] **Fix Import** - Da assoluto a relativo negli SHIM files
- [x] **Test Pre-Deploy** - Step in GitHub Actions che verifica import
- [x] **Polling Intelligente** - Aspetta backend healthy (max 120s)
- [x] **start_period** - Aumentato da 40s a 90s

---

## FASE 1: Miglioramenti CI/CD (Prossime sessioni)

### 1.1 Build nel CI invece che sulla VM
```
STATO: Da fare
PRIORITA: Media
EFFORT: 3-4 ore

Cosa:
- GitHub Actions builda immagine Docker
- Push a GitHub Container Registry (GHCR)
- VM fa solo docker pull + up (no build)

Benefici:
- Build più veloce (runner GitHub più potenti)
- VM dedicata solo a servire traffico
- Versioning immagini (rollback facile)
```

### 1.2 Test Automatici Pre-Deploy
```
STATO: Parzialmente fatto (solo import)
PRIORITA: Media
EFFORT: 2-3 ore

Cosa:
- Aggiungere test unitari critici
- Eseguire test PRIMA del deploy
- Se test falliscono, deploy non procede

Benefici:
- Catch bug prima di produzione
- Confidence nel deploy
```

---

## FASE 2: Staging Environment (Quando serve)

```
STATO: Da valutare
PRIORITA: Bassa (per ora)
EFFORT: 1 giornata

Cosa:
- VM staging separata (più piccola)
- Deploy PRIMA su staging
- Test su staging
- Se OK, deploy su produzione

Benefici:
- Test in ambiente reale
- Zero rischio produzione

Costo:
- ~5-10 USD/mese VM extra
```

---

## FASE 3: Cloud Run / Kubernetes (Futuro)

```
STATO: Futuro
PRIORITA: Bassa
EFFORT: 1-2 settimane

Quando:
- Miracollo cresce significativamente
- Servono auto-scaling
- Servono SLA enterprise

Cosa:
- Migrare a Google Cloud Run o GKE
- Deploy via container image
- Canary deploys built-in

Benefici:
- Zero gestione infrastruttura
- Auto-scaling
- Pay per use
```

---

## ARCHITETTURA ATTUALE

```
GitHub (push master)
    │
    ▼
GitHub Actions
    │ SSH
    ▼
VM (34.27.179.164)
    │
    ├── git pull
    ├── docker compose build
    ├── TEST IMPORT (nuovo!)
    ├── docker compose up -d backend
    ├── POLLING health (max 120s)
    ├── docker compose up -d nginx
    └── Health check finale
```

---

## PUNTATORI

| File | Scopo |
|------|-------|
| `.github/workflows/deploy.yml` | Workflow deploy v4.1.0 |
| `docker-compose.yml` | Stack Docker |
| `Dockerfile` | Build backend |

---

## NOTE

- Non abbiamo fretta - facciamo quando ha senso
- Ogni fase è indipendente
- L'architettura attuale è SANA (score 8/10)

*"Fatto BENE > Fatto veloce"*
