# RICERCA: Auto-Save File Durante Creazione in Claude Code

**Data ricerca:** 2 Gennaio 2026
**Ricercatrice:** Cervella Researcher
**Obiettivo:** Trovare come salvare automaticamente file .md lunghi durante creazione

---

## TL;DR - RISPOSTA RAPIDA

**NON ESISTE una soluzione native per auto-save DURANTE generazione.**

Claude Code scrive file **atomicamente alla fine**, NON in streaming.

**3 SOLUZIONI PRATICHE:**

1. **HOOK PreCompact** (protegge PRIMA di compact) - GIA' ATTIVO!
2. **Pattern Chunking** (genera file in sezioni) - DA IMPLEMENTARE
3. **c0ntextKeeper** (tool esterno) - OPZIONALE

---

## IL PROBLEMA

Quando un agente genera file lunghi (es. 2600 righe):

```
1. Agent inizia generazione -> file NON esiste su disco
2. Claude raggiunge limite contesto -> trigger AUTO-COMPACT
3. Compact avviene -> contenuto generato va PERSO
4. File viene scritto DOPO -> ma e' incompleto/danneggiato
```

---

## SOLUZIONE RACCOMANDATA: PATTERN CHUNKING

### Come Funziona

Invece di 1 file da 2600 righe -> 5 file da 500 righe

**PRIMA (problematico):**
```
"Crea RICERCA_COMPLETA.md con analisi competitor"
-> 2600 righe -> rischio perdita
```

**DOPO (sicuro):**
```
"Crea questi 5 file:
1. RICERCA_PARTE1_INTRODUZIONE.md
2. RICERCA_PARTE2_COMPETITOR.md
3. RICERCA_PARTE3_BEST_PRACTICES.md
4. RICERCA_PARTE4_RACCOMANDAZIONI.md
5. RICERCA_PARTE5_SINTESI.md"
-> Ogni file salvato SUBITO -> zero rischio
```

### Vantaggi

- Funziona OGGI, zero dipendenze
- Ogni chunk salvato = checkpoint naturale
- Piu' facile review (file piu' piccoli)
- Compatibile con SWARM (agenti paralleli)

---

## HOOK PRECOMPACT (GIA' ATTIVO)

Il nostro sistema HA GIA' un hook che protegge:

```json
// ~/.claude/settings.json
"PreCompact": [
  {
    "matcher": "manual",
    "hooks": [{
      "type": "command",
      "command": "python3 ~/.claude/hooks/pre_compact_save.py"
    }]
  },
  {
    "matcher": "auto",
    "hooks": [{
      "type": "command",
      "command": "python3 ~/.claude/hooks/pre_compact_save.py"
    }]
  }
]
```

**Protegge:** Conversazione completa prima di compact
**NON protegge:** File in corso di generazione

---

## AGGIORNAMENTO DNA AGENTI

Aggiungere ai DNA di researcher/scienziata:

```markdown
## REGOLA FILE LUNGHI

Per report > 500 righe:
- Dividi in file multipli (max 500 righe/file)
- Schema: RICERCA_PARTE1_*.md, PARTE2_*.md, etc
- Salva ogni parte SUBITO prima di continuare

Pattern:
1. Crea PARTE1 -> verifica salvata
2. Crea PARTE2 -> verifica salvata
3. Etc...

Mai generare 2600 righe in un solo file!
```

---

## TOOL OPZIONALE: c0ntextKeeper

```bash
npm install -g c0ntextkeeper
c0ntextkeeper setup
```

- Auto-save conversazioni
- Archivio searchable
- Recupero via CLI

**Valutare dopo test pattern chunking.**

---

## CONCLUSIONE

**La soluzione NON e' tecnica, e' di DESIGN:**

> "Non chiedere 1 file da 2600 righe. Chiedi 5 file da 500 righe."

Compatibile con la nostra filosofia:
- "Fatto BENE > Fatto VELOCE"
- File piu' piccoli = piu' facili da review

**Il nostro sistema e' GIA' protetto (hook PreCompact).**
**Serve solo migliorare i prompt per gli agenti ricerca!**

---

## FONTI

- [Hooks Reference - Claude Code Docs](https://code.claude.com/docs/en/hooks)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [c0ntextKeeper GitHub](https://github.com/Capnjbrown/c0ntextKeeper)
- [Issue #6305: PostToolUse Hooks Bug](https://github.com/anthropics/claude-code/issues/6305)

---

*Cervella Researcher*
