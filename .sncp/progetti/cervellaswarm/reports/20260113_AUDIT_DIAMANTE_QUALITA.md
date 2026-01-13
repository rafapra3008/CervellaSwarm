# AUDIT QUALITA - COMUNICAZIONE INTER-AGENT (Protocollo Diamante)

**Guardiana**: cervella-guardiana-qualita
**Data**: 13 Gennaio 2026
**Documento auditato**: `~/.claude/docs/COMUNICAZIONE_INTER_AGENT.md`
**Versione documento**: Sessione 181

---

## VERDETTO GLOBALE

| Categoria | Score |
|-----------|-------|
| Completezza | 8/10 |
| Chiarezza | 9/10 |
| Consistenza | 7/10 |
| Actionability | 8/10 |
| Rischi gestiti | 7/10 |
| **TOTALE** | **7.8/10** |

**Esito**: APPROVATO CON RISERVE

---

## PUNTI DI FORZA

### 1. Workflow ben strutturato
Il flusso 6-step (Regina riceve -> Identifica esperta -> Consulta -> Assegna -> Valida -> Report) e chiaro e logico.

### 2. Matrice decisionale chiara
La sezione "Quando consultare l'esperta" con casi OBBLIGATORIO vs OPZIONALE e eccellente. La regola semplice (utente vede? dati a rischio? produzione?) e memorizzabile.

### 3. Template concreti
Template per SPECS, OUTPUT e VALIDAZIONE sono completi e usabili. L'esempio LoginPage e realistico e illustrativo.

### 4. Anti-pattern documentati
Sezione anti-pattern ben pensata: worker che improvvisa, Regina che salta, specs vaghe, validazione superficiale.

### 5. Coerenza con Costituzione
Rispetta "Fatto BENE > Fatto VELOCE" e "La Regina orchestra, non fa tutto da sola".

---

## PROBLEMI TROVATI

### P0 - CRITICO

#### 1. INCONSISTENZA SPAWN-WORKERS vs TASK TOOL

**Problema**: Il documento dice (riga 463-492):
```
spawn-workers --marketing
spawn-workers --data
```

Ma l'Orchestrator prompt (REGOLA 13) dice:
```
SEMPRE spawn-workers per invocare le Cervelle!
```

E nella sezione "comandi" non include `--marketing` o `--data` nel prompt orchestrator originale. Solo `--backend`, `--frontend`, `--researcher`, `--docs`, `--tester`, `--reviewer`.

**Severita**: P0 - Se Regina prova `spawn-workers --marketing` e non esiste, il workflow si blocca!

**Raccomandazione**: Verificare che TUTTI gli agenti citati nel documento abbiano uno spawn-workers corrispondente. Aggiornare spawn-workers script se mancano.

---

### P1 - IMPORTANTE

#### 2. CONFLITTO SNCP PATH

**Problema**: Il documento propone (riga 147):
```
.sncp/progetti/{progetto}/handoff/YYYYMMDD_{feature}_specs.md
```

Ma le REGOLE SNCP v3.0 in TUTTI gli agent prompt dicono:
```
Cartelle Permesse:
.sncp/
├── stato/oggi.md
├── coscienza/
├── idee/
├── memoria/decisioni/
└── archivio/YYYY-MM/
```

**handoff/** NON esiste nella lista cartelle permesse!

**Severita**: P1 - SNCP Guardian potrebbe BLOCCARE i file handoff!

**Raccomandazione**:
- Opzione A: Aggiornare SNCP v3.0 in TUTTI gli agent prompt per includere `handoff/`
- Opzione B: Usare path diverso (es: `idee/` o `decisioni/`)

---

#### 3. MANCA RIFERIMENTO A QUESTO DOCUMENTO NEGLI AGENT PROMPT

**Problema**: Frontend, Backend, Marketing NON hanno riferimento a questo protocollo nei loro prompt. Il documento dice (riga 628-629):
```
### Fase 2: Rollout
- [ ] Aggiornare prompt agent con riferimento a questo doc
```

Ma e un "PROSSIMO STEP", non e fatto!

**Severita**: P1 - Gli agenti NON SANNO che devono seguire questo protocollo!

**Raccomandazione**: Prima del rollout, aggiornare TUTTI gli agent prompt con:
- Link al documento
- Sezione "SE ricevi task con specs, seguile!"

---

#### 4. GUARDIANA NON HA TEMPLATE AGGIORNATO

**Problema**: Il mio prompt (cervella-guardiana-qualita) NON include la sezione "Verifica Specs vs Output" del documento. Ho solo checklist generiche.

**Severita**: P1 - Non so che devo confrontare specs con output in modo strutturato!

**Raccomandazione**: Aggiornare il mio prompt con la checklist validazione dal documento.

---

### P2 - MINORE

#### 5. GESTIONE CONFLITTI NON DEFINITA

**Problema**: Cosa succede se:
- Worker non segue le specs?
- Guardiana respinge ma Worker non e d'accordo?
- Due esperte danno specs contraddittorie?

Il documento non copre questi edge case.

**Severita**: P2 - Non critico ma potrebbe causare confusione.

**Raccomandazione**: Aggiungere sezione "Risoluzione Conflitti" con escalation path.

---

#### 6. METRICHE SENZA STRUMENTO

**Problema**: Sezione metriche (riga 499-514) definisce:
- Rework rate < 10%
- Specs compliance > 90%
- Handoff success > 95%

Ma NON dice COME misurarle. Chi conta? Dove si registra?

**Severita**: P2 - Metriche non actionable senza strumento.

**Raccomandazione**: Definire dove tracciare (file SNCP? Script automatico? Manuale a fine settimana?).

---

#### 7. ESEMPIO WORKFLOW INCOMPLETO

**Problema**: L'esempio (riga 567-603) e buono ma non mostra:
- Cosa succede se Guardiana RESPINGE?
- Loop di fix e re-validazione

**Severita**: P2 - Happy path documentato, error path no.

**Raccomandazione**: Aggiungere flowchart con caso "RESPINTO -> Fix -> Re-validazione".

---

## CONSISTENZA CON ALTRI DOCUMENTI

### Verifiche Effettuate

| Documento | Coerente? | Note |
|-----------|-----------|------|
| COSTITUZIONE.md | SI | Rispecchia filosofia |
| cervella-orchestrator.md | PARZIALE | Manca --marketing in spawn-workers |
| cervella-marketing.md | SI | Gia parla di specs |
| cervella-frontend.md | NO | Nessun riferimento a specs |
| cervella-data.md | SI | Pronta per specs |
| SNCP v3.0 | NO | handoff/ non permesso |

---

## ACTIONABILITY - TEST PRATICO

### Ho provato a seguire il documento

**Scenario**: "Verifica specs LoginPage per frontend"

1. Trovo specs? SI - path chiaro
2. Trovo output? SI - path chiaro
3. Checklist? SI - formato tabellare
4. Verdetto? SI - template chiaro
5. Comunicazione? PARZIALE - non so dove scrivere se respingo

**Risultato**: 80% actionable. Manca gestione caso RESPINTO.

---

## RISCHI NON CONSIDERATI

### 1. OVERHEAD ECCESSIVO PER TASK PICCOLI

**Rischio**: Task da 20 righe richiede:
- Specs da esperta (spawn)
- Implementazione da worker (spawn)
- Validazione guardiana (spawn)

3 spawn per 20 righe = overhead significativo.

**Mitigazione suggerita**: Soglia minima (es: "Task < 50 righe senza UI = no specs obbligatorie").

### 2. BOTTLENECK ESPERTE

**Rischio**: Se Marketing deve fare specs per OGNI UI, diventa bottleneck.

**Mitigazione suggerita**: Batch specs (piu feature insieme) o template pre-approvati per pattern comuni.

### 3. SPECS OBSOLETE

**Rischio**: Specs scritte ma requisiti cambiano durante implementazione. Worker segue specs vecchie.

**Mitigazione suggerita**: Aggiungere nota "SE requisiti cambiano -> UPDATE specs PRIMA di implementare".

---

## RACCOMANDAZIONI FINALI

### PRIMA DI ROLLOUT (P0/P1)

1. **Verificare spawn-workers** - Tutti gli agenti citati devono avere comando
2. **Aggiornare SNCP v3.0** - Aggiungere `handoff/` alle cartelle permesse in TUTTI i prompt
3. **Aggiornare prompt agenti** - Riferimento a questo documento

### DOPO PILOT (P2)

4. **Aggiungere sezione conflitti** - Escalation path
5. **Definire strumento metriche** - File SNCP o script
6. **Documentare error path** - Cosa succede se respinto

### QUICK WINS

7. **Soglia minima task** - Evitare overhead per task piccoli
8. **Template pre-approvati** - Pattern UI comuni gia specs

---

## CONCLUSIONE

Il documento **COMUNICAZIONE_INTER_AGENT.md** e un **ottimo primo draft**. Risolve il problema reale del 37% di fallimenti per misalignment.

**Tuttavia**, richiede allineamento con:
- Prompt agenti esistenti (riferimenti mancanti)
- SNCP v3.0 (handoff/ non permesso)
- spawn-workers (comandi mancanti)

**Consiglio**: NON fare rollout PRIMA di fixare P0 e P1.

Pilot puo iniziare con workaround (usare `idee/` invece di `handoff/`), ma soluzione pulita richiede aggiornamento SNCP.

---

## VERDETTO FINALE

```
+------------------------------------------------------------------+
|                                                                  |
|   APPROVATO CON RISERVE                                          |
|                                                                  |
|   Score: 7.8/10                                                  |
|                                                                  |
|   P0: 1 problema critico (spawn-workers)                         |
|   P1: 3 problemi importanti (SNCP, prompt, guardiana)            |
|   P2: 3 problemi minori (conflitti, metriche, error path)        |
|                                                                  |
|   Next: Fix P0 e P1 prima di rollout                             |
|                                                                  |
+------------------------------------------------------------------+
```

---

*Audit completato da cervella-guardiana-qualita*
*13 Gennaio 2026 - Sessione 181*

*"Qualita non e inspection finale. E processo costante."*
