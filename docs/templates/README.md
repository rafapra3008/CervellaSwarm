# Templates - CervellaSwarm

> *"I template salvano tempo. E prevengono dimenticanze."*

---

## Template Disponibili

| Template | Quando Usarlo | Output |
|----------|---------------|--------|
| `REPORT_FINALE.md` | Fine sessione, fine sprint, checkpoint importante | `reports/REPORT_AAAAMMGG_HHMMSS.md` |
| `../tasks/TEMPLATE_DUBBI.md` | Worker bloccato da ambiguità | `.swarm/tasks/DUBBIO_TASK_XXX.md` |
| `../tasks/TEMPLATE_PARTIAL.md` | Compact imminente, task non finito | `.swarm/tasks/PARTIAL_TASK_XXX.md` |

---

## REPORT_FINALE.md

### Quando Usarlo

```
✅ Al termine di ogni sessione swarm
✅ Dopo completamento di uno Sprint
✅ Prima di switchare progetto
✅ Come checkpoint documentale importante
```

### Come Usarlo

1. **Copia il template**
   ```bash
   cd /Users/rafapra/Developer/[PROGETTO]
   mkdir -p reports
   cp /Users/rafapra/Developer/CervellaSwarm/docs/templates/REPORT_FINALE.md \
      reports/REPORT_$(date +%Y%m%d_%H%M%S).md
   ```

2. **Compila le sezioni**
   - Leggi i commenti HTML `<!-- -->`
   - Guarda l'esempio: `REPORT_FINALE_ESEMPIO.md`
   - Riempi TUTTE le sezioni con precisione

3. **Salva e riferisci**
   - Committa il report in git
   - Riferisci in PROMPT_RIPRESA.md per storico
   - Utile per review future e retrospettive

### Sezioni Chiave

```
INTESTAZIONE       → Chi, cosa, quando
OBIETTIVO          → Perché questa sessione
TASK COMPLETATI    → Cosa abbiamo fatto (tabella)
FILE MODIFICATI    → Cosa abbiamo toccato (dettaglio!)
DECISIONI PRESE    → Scelte architetturali (IMPORTANTE!)
PROBLEMI/BLOCCHI   → Cosa è andato storto (lezioni!)
PROSSIMI STEP      → Cosa fare dopo (mappa!)
METRICHE           → Numeri (opzionale ma utile)
INSIGHT            → Il momento "AHA!" della sessione
GIT STATUS         → Verifica tutto committato
```

### Regole d'Oro

1. **Scrivi per il te di domani**
   - Chi leggerà non avrà il tuo contesto
   - Spiega il PERCHÉ, non solo il COSA

2. **Fatti, non opinioni**
   - "Creato file X con 250 righe" ✅
   - "Fatto un po' di refactor" ❌

3. **Decisioni sono ORO**
   - Ogni decisione architetturale va documentata
   - Include: Perché + Impatto + Trade-off

4. **Insight salva tempo**
   - Il momento "AHA!" della sessione
   - Lezioni apprese (prevengono errori futuri)

---

## Automazione (Futuro)

```bash
# Script futuro per generare report automaticamente
./scripts/swarm/generate-report.sh

# Input: legge .swarm/tasks/ + git log + task_manager.py
# Output: report/REPORT_AAAAMMGG_HHMMSS.md pre-compilato
```

**Attualmente:** Compilazione manuale (15-20 minuti fine sessione)

---

## Esempi

Vedi `REPORT_FINALE_ESEMPIO.md` per un esempio completo compilato (Sessione 71).

---

## Compatibilità

- **CervellaSwarm:** v27.x+
- **Altri progetti:** Adattabile (rimuovi sezioni swarm-specific se non applicabili)

---

*Creato: 3 Gennaio 2026*
*Cervella Docs - La Documentatrice*

*"Un buon report oggi = ore risparmiate domani."*
