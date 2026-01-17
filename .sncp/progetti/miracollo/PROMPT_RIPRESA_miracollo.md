# PROMPT RIPRESA - Miracollo (Generale)

> **Ultimo aggiornamento:** 17 Gennaio 2026 - Sessione 251
> **NOTA:** Questo file e panoramica. Ogni braccio ha il SUO PROMPT_RIPRESA!

---

## SESSIONE 251: AUDIT COMPLETO VM

### Lavoro Completato
- Audit diretto sulla VM di produzione
- Verificato: miracollo.com LIVE e funzionante
- Corretto: Database e SQLite (non PostgreSQL!)
- Creato: STATO_REALE_PMS.md con verifica completa
- Aggiornata tutta la documentazione

### Scoperta Importante
```
PRIMA: Docs dicevano PostgreSQL
REALTA: SQLite (3.8MB, 80+ tabelle, funziona!)

Infrastruttura professionale:
- Nginx con SSL Let's Encrypt
- Rate limiting, HSTS, security headers
- Zero-downtime deploy ready
```

---

## ARCHITETTURA 3 BRACCI

```
MIRACOLLO
├── PMS CORE (:8001)        90% - PRODUZIONE VERIFICATA
├── MIRACOLLOOK (:8002)     60% - Drag/resize in corso
└── ROOM HARDWARE (:8003)   10% - Attesa hardware
```

---

## DOVE TROVARE COSA

| Braccio | PROMPT_RIPRESA |
|---------|----------------|
| PMS Core | `bracci/pms-core/PROMPT_RIPRESA_pms-core.md` |
| Miracollook | `bracci/miracallook/PROMPT_RIPRESA_miracollook.md` |
| Room Hardware | `bracci/room-hardware/PROMPT_RIPRESA_room_hardware.md` |

**NUOVO:** `bracci/pms-core/STATO_REALE_PMS.md` - Verifica completa VM

---

## PROSSIMA SESSIONE

**PMS CORE (pulizia):**
```
1. Rimuovere 56 TODO nel codice
2. Split file planning_*.py (965 righe -> max 500)
3. Verificare integrazione Stripe
```

**MIRACOLLOOK:** Drag/resize panels

**ROOM HARDWARE:** Attesa arrivo hardware Amazon

---

*"Il diamante brilla. Ora e documentato."*
