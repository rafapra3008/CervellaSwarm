# Task: Integrare Regola "Via Giusta" nel DNA Cervelle

**Assegnato a:** cervella-docs
**Stato:** ready
**Priorita:** MEDIA
**Data:** 5 Gennaio 2026

---

## Contesto

Nella sessione 89, Rafa ha corretto Cervella quando stava per scegliere un symlink (via facile) invece della soluzione architetturale corretta.

> "senza pigrizia.. se serve lavori per essere la cosa giusta..
> facciamo in piu sessioni... ma facciamo le cose giuste.."

Abbiamo creato:
- `docs/studio/STUDIO_VIA_FACILE.md` - Studio completo
- Aggiunta sezione in `~/.claude/CHECKLIST_AZIONE.md`

---

## Obiettivo

Integrare questa regola nel DNA delle Cervelle, in modo che TUTTE le api la seguano.

---

## File da Modificare

### 1. ~/.claude/agents/cervella-orchestrator.md

Aggiungere nelle "Regole Inviolabili":

```markdown
### REGOLA 14: VIA GIUSTA, NON VIA FACILE!

Quando vedi due soluzioni:
- LIVELLO 1 (Pragmatico): symlink, workaround, "per oggi"
- LIVELLO 2 (Architetturale): spostare file, fix vero, soluzione pulita

**SCEGLI SEMPRE LIVELLO 2!**

Se richiede piu tempo: "Possiamo farla in piu sessioni"
Rafa preferisce SEMPRE la cosa giusta.

SEGNALI DI ALLARME:
- "Per oggi faccio cosi..." → STOP!
- "E solo un symlink..." → STOP!
- "Poi sistemiamo..." → STOP!

STUDIO: docs/studio/STUDIO_VIA_FACILE.md
```

### 2. Template per altri DNA (opzionale)

Se c'e tempo, aggiungere una versione breve negli altri DNA:

```markdown
## Regola Via Giusta
Sempre la soluzione GIUSTA, mai quella FACILE.
Se servono piu sessioni, va bene.
```

---

## Output Atteso

1. cervella-orchestrator.md aggiornato con Regola 14
2. (Opzionale) Altri DNA con regola breve

---

## Checklist Verifica

- [ ] Regola 14 aggiunta a cervella-orchestrator.md
- [ ] Testo chiaro e memorabile
- [ ] Riferimento allo studio incluso

---

*Task creato da Cervella Regina - Sessione 90*
