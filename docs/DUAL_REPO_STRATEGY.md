# Dual Repo Strategy - CervellaSwarm

> **LEZIONE APPRESA**: Sessione 286 - Terza volta che incontriamo questo problema!
> Ora documentato per sempre.

---

## Il Problema

```
+================================================================+
|   ATTENZIONE: NON FARE git push public main!                   |
|                                                                |
|   origin (privato)  = 6900+ file (TUTTO)                      |
|   public (pubblico) = ~100 file (SUBSET CURATO)               |
|                                                                |
|   Un push diretto ESPORREBBE:                                  |
|   - .sncp/ (strategie, handoff, stati)                        |
|   - NORD.md (bussola privata)                                 |
|   - docs/studio/ (ricerche interne)                           |
|   - scripts/memory/ (database interno)                        |
+================================================================+
```

---

## La Soluzione

### Hybrid Model (Sessione 267)

| Repo | URL | Contenuto |
|------|-----|-----------|
| **origin** (privato) | cervellaswarm-internal | Tutto il codice |
| **public** (pubblico) | cervellaswarm | Solo file pubblici |

### Come Sincronizzare

**USA SEMPRE lo script:**

```bash
./scripts/git/sync-to-public.sh
```

Lo script:
1. Crea branch temporaneo da public/main
2. Copia SOLO file pubblici da main
3. Verifica che nessun file sensibile sia incluso
4. Richiede conferma MANUALE prima di push
5. Pusha e pulisce

### File Pubblici (sincronizzati)

```
packages/           # CLI e MCP Server
docs/*.md           # Solo doc pubbliche (non studio/)
README.md
CHANGELOG.md
LICENSE
CONTRIBUTING.md
.github/
```

### File Privati (MAI sincronizzati)

```
.sncp/              # Memoria esterna, strategie
NORD.md             # Bussola progetto
docs/studio/        # Ricerche interne
scripts/memory/     # Database swarm
scripts/learning/   # Apprendimento interno
scripts/engineer/   # Tool interni
reports/            # Report interni
data/               # Dati locali
COSTITUZIONE.md     # (se nel repo)
PROMPT_RIPRESA*.md
MAPPA_*.md
```

---

## Checklist Pre-Sync

Prima di sincronizzare al public:

- [ ] Ho usato `./scripts/git/sync-to-public.sh`?
- [ ] Lo script ha confermato "Verifica sicurezza: PASSATA"?
- [ ] Ho rivisto i file nel diff prima di confermare?
- [ ] NON ho fatto `git push public main` direttamente?

---

## Errori Comuni

### SBAGLIATO

```bash
# MAI fare questo!
git push public main
git push public HEAD:main

# Espone TUTTI i file, inclusi quelli privati!
```

### CORRETTO

```bash
# Sempre usare lo script
./scripts/git/sync-to-public.sh

# Lo script gestisce tutto in sicurezza
```

---

## Storia del Problema

| Sessione | Cosa è successo |
|----------|-----------------|
| 267 | Creato Hybrid Model, primo sync manuale |
| ??? | Secondo incontro con il problema |
| 286 | Terzo incontro → Creato script definitivo |

**Ora documentato. Non deve succedere una QUARTA volta!**

---

## Workflow Release

```
1. Sviluppo su main (origin/privato)
2. Test completi
3. Version bump
4. ./scripts/git/sync-to-public.sh
5. npm publish
6. git tag vX.Y.Z
7. git push public vX.Y.Z
```

---

*"Fatto BENE > Fatto VELOCE"*
*Sessione 286 - Cervella & Rafa*
