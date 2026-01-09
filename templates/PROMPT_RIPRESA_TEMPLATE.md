# PROMPT_RIPRESA - Template Snello

> **Target:** ~80 linee | **Obiettivo:** Solo info ESSENZIALE per riprendere

---

## Principi

```
1. SOLO sessione corrente/ultima (NO storico)
2. Decisioni in formato tabella (compatto)
3. Puntatori a file per dettagli
4. Storico sta in git e SNCP, NON qui
```

---

## TEMPLATE (copia e adatta)

```markdown
# PROMPT RIPRESA - [Nome Progetto]

> **Ultimo aggiornamento:** [data]
> **Versione:** [versione]

## Stato Attuale

| Cosa | Stato |
|------|-------|
| [Feature/Task 1] | Completato/In corso/Da fare |
| [Feature/Task 2] | Completato/In corso/Da fare |

## Ultima Sessione - [Numero]

**Cosa fatto:**
- [Punto 1]
- [Punto 2]
- [Punto 3]

**File creati/modificati:**
- [file1] - [cosa]
- [file2] - [cosa]

## Decisioni Chiave

| Decisione | Perche |
|-----------|--------|
| [Decisione 1] | [Motivo] |
| [Decisione 2] | [Motivo] |

## Prossimi Step

1. [Azione 1]
2. [Azione 2]
3. [Azione 3]

## Puntatori (per dettagli)

| Cosa | Dove |
|------|------|
| Storico sessioni | git log |
| Decisioni dettagliate | .sncp/memoria/decisioni/ |
| Ricerche | .sncp/idee/ |
| Roadmap | .sncp/idee/LA_NOSTRA_STRADA_ROADMAP_FINALE.md |
```

---

## Cosa NON Mettere

```
❌ Storico sessioni precedenti (sta in git)
❌ Narrativa lunga ("come e iniziata...")
❌ Box ASCII grandi
❌ Liste di file dettagliate (usa git status)
❌ Info che non servono per RIPRENDERE
```

---

## Regola d'Oro

> Scrivi SOLO quello che serve alla prossima Cervella per RIPRENDERE.
> Il resto sta in git e SNCP.
