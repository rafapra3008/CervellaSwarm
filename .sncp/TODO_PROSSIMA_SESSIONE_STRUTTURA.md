# TODO PROSSIMA SESSIONE - Allineamento Struttura SNCP

> **Creato:** 18 Gennaio 2026 - Sessione 260
> **Da fare:** PRIMA di lavorare su qualsiasi progetto
> **Priorità:** ALTA

---

## PROBLEMA IDENTIFICATO

La Guardiana Qualità ha verificato la struttura SNCP e trovato inconsistenze.

---

## REGOLE DEFINITIVE (da CLAUDE.md)

| File | Dove | Scopo | Max Righe |
|------|------|-------|-----------|
| **oggi.md** | `.sncp/stato/oggi.md` | GLOBALE giornaliero | 60 |
| **NORD.md** | **ROOT progetto** (es: `CervellaSwarm/NORD.md`) | Bussola PER PROGETTO | - |
| **PROMPT_RIPRESA** | `.sncp/progetti/{prog}/PROMPT_RIPRESA_{prog}.md` | Ripresa PER PROGETTO | 150 |
| **stato.md** | `.sncp/progetti/{prog}/stato.md` | Stato dettagliato PER PROGETTO | 500 |

---

## TASK DA FARE

### 1. NORD.md per Miracollo

```
PROBLEMA:
  NORD.md è in: .sncp/progetti/miracollo/NORD.md (SBAGLIATO)
  Dovrebbe essere in: ~/Developer/miracollogeminifocus/NORD.md (ROOT)

AZIONE:
  1. Leggere .sncp/progetti/miracollo/NORD.md
  2. Creare ~/Developer/miracollogeminifocus/NORD.md
  3. Archiviare il vecchio in .sncp/progetti/miracollo/archivio/
```

### 2. NORD.md per Contabilita

```
VERIFICA:
  Esiste ~/Developer/ContabilitaAntigravity/NORD.md?

AZIONE (se mancante):
  Creare NORD.md nella ROOT del progetto
```

### 3. Pulizia file duplicati

```
VERIFICA:
  .sncp/stato.md (11 righe, sembra auto-generato)

AZIONE:
  Se duplicato di oggi.md → rimuovere o archiviare
```

### 4. Verificare CLAUDE.md

```
VERIFICA:
  Le istruzioni in ~/.claude/CLAUDE.md sono chiare?
  La struttura documentata corrisponde alla realtà?

AZIONE:
  Se serve aggiornamento → aggiornare
```

---

## CHECKLIST VERIFICA

- [ ] NORD.md CervellaSwarm in ROOT? (SI, già OK)
- [ ] NORD.md Miracollo in ROOT? (NO, da sistemare)
- [ ] NORD.md Contabilita in ROOT? (DA VERIFICARE)
- [ ] oggi.md UNICO in .sncp/stato/? (SI, già OK)
- [ ] PROMPT_RIPRESA per ogni progetto? (SI, già OK)
- [ ] Limiti righe rispettati? (SI, verificato)

---

## ORDINE ESECUZIONE

```
1. Verificare struttura attuale (5 min)
2. Sistemare NORD.md Miracollo (10 min)
3. Verificare NORD.md Contabilita (5 min)
4. Pulire file duplicati se esistono (5 min)
5. Aggiornare CLAUDE.md se serve (10 min)
6. Commit checkpoint "Allineamento struttura SNCP"
```

---

## NOTE

- CervellaSwarm è la CENTRALE - tutti gli SNCP sono qui
- NORD.md va nella ROOT di ogni progetto (non dentro SNCP)
- Questo è un task di "manutenzione" - va fatto PRIMA di lavorare

---

*"I dettagli fanno SEMPRE la differenza."*
