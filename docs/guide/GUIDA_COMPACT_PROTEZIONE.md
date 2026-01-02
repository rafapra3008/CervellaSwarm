# GUIDA PROTEZIONE CONTESTO - /compact

**Data:** 2026-01-02
**Versione:** 1.0.0

---

## IL PROBLEMA

Quando Claude Code fa `/compact`, perde informazioni importanti:
- Decisioni prese
- Cosa NON ha funzionato
- Codice che funziona
- Prossimi step

---

## LA SOLUZIONE: Template Custom

### Template Base (Copia-Incolla)

```
/compact In addition to default summary, include:

1) NEXT ACTION - Cosa fare IMMEDIATAMENTE dopo
2) DECISIONS - Decisioni importanti prese (e perche)
3) DEAD ENDS - Cosa NON ha funzionato (per non ripetere)
4) WORKING CODE - Codice/file che funzionano bene
5) BLOCKERS - Problemi aperti da risolvere
```

### Template CervellaSwarm

```
/compact In addition to default summary, include:

1) NEXT ACTION - Prossimo task da completare
2) DECISIONS - Architettura/pattern scelti
3) DEAD ENDS - Approcci falliti
4) WORKING CODE - Script/file funzionanti
5) BLOCKERS - Bug o problemi aperti
6) SWARM STATE - Quali agent hanno lavorato e cosa hanno prodotto
7) FILES MODIFIED - Lista file creati/modificati questa sessione
```

### Template Miracollo

```
/compact In addition to default summary, include:

1) NEXT ACTION - Feature/fix da completare
2) DECISIONS - Stack tecnologico/pattern scelti
3) DEAD ENDS - Librerie/approcci scartati
4) WORKING CODE - Componenti/API funzionanti
5) BLOCKERS - Bug utente-facing
6) DEPLOY STATE - Cosa e in staging/produzione
```

---

## QUANDO USARE

| Situazione | Azione |
|------------|--------|
| Sessione lunga (>2h) | Usa template prima di compact |
| Molte decisioni prese | Usa template SEMPRE |
| Debugging complesso | Includi DEAD ENDS dettagliati |
| Swarm Mode attivo | Includi SWARM STATE |

---

## ALTERNATIVA: Pre-Compact Hook

Se vuoi automatizzare, abbiamo gia un hook!

File: `~/.claude/hooks/pre_compact_save.py`

Questo hook:
- Salva snapshot automatico prima di compact
- Aggiorna PROMPT_RIPRESA.md
- Non richiede azione manuale

---

## TOOL ESTERNO: c0ntextKeeper

Per protezione TOTALE, esiste:
- GitHub: `github.com/Capnjbrown/c0ntextKeeper`
- Salva TUTTO il contesto in file esterno
- Restore completo dopo compact

**Quando usarlo:**
- Sessioni molto lunghe (>4h)
- Debugging critico
- Prima di sleep/pausa lunga

---

## BEST PRACTICES

1. **Usa template PRIMA di compact** - Non dopo!
2. **Sii specifico** - "API user funziona" > "API funziona"
3. **Includi path** - `/src/api/user.py` > "file user"
4. **Numera i blockers** - Facilita tracking

---

*"Il contesto perso e tempo perso!"*
