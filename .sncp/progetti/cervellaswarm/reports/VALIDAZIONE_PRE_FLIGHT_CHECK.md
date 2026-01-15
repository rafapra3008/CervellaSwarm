# VALIDAZIONE: Pre-Flight Check Costituzione
> Guardiana Qualita - 15 Gennaio 2026

---

## VERDETTO

```
+================================================================+
|                                                                |
|   SCORE: 7/10 - BUONA IDEA, NECESSITA RAFFINAMENTO             |
|                                                                |
|   APPROVATA CON MODIFICHE                                      |
|                                                                |
+================================================================+
```

---

## ANALISI CRITICA

### 1. E SMART E FLUIDA?

**PARZIALMENTE SI, MA...**

| Aspetto | Valutazione | Note |
|---------|-------------|------|
| Semplicita | 8/10 | 5 domande, formato chiaro |
| Latenza | 6/10 | +50 token ogni spawn = overhead su 16 agenti |
| Valore vs Costo | 7/10 | Vale la pena MA potrebbe essere ottimizzato |
| Praticita | 5/10 | Rischio "risposte meccaniche" col tempo |

**PROBLEMA IDENTIFICATO:**
Dopo 10-20 sessioni, le risposte diventano AUTOMATICHE. L'agente "memorizza" le risposte corrette senza rileggere. Diventa checkbox, proprio quello che vogliamo evitare.

---

### 2. NUMERO DOMANDE: 5 SONO TROPPE O POCHE?

**TROPPE. Consiglio 3 CORE + 1 RANDOM.**

**Le 3 domande PIU IMPORTANTI:**
1. **OBIETTIVO FINALE** - "Qual e l'obiettivo finale?" = LIBERTA GEOGRAFICA
2. **SU CARTA vs REALE** - Distinzione CRITICA per il lavoro quotidiano
3. **PARTNER vs ASSISTENTE** - Cambio di mindset fondamentale

**Domande da RIMUOVERE o rendere OPZIONALI:**
- "Cosa fai PRIMA di proporre?" - Troppo specifica, si deduce dalla #3
- "Pilastro #1 Formula Magica" - Bello ma non CORE per ogni task

**PROPOSTA: Sistema 3+1**
```
3 domande FISSE (sempre) +
1 domanda RANDOM (da pool di 5-7)
```

Il random previene memorizzazione meccanica!

---

### 3. ALTERNATIVE MIGLIORI?

**SI. Ho identificato 2 approcci migliori:**

#### ALTERNATIVA A: "COSTITUZIONE CHECK" LEGGERO

```markdown
## COSTITUZIONE CHECK (10 sec)

Dopo aver letto la Costituzione, conferma:

1. Obiettivo finale: _____________ (una parola)
2. Sono un/a: [ ] Assistente  [ ] Partner
3. Prima di proporre: [ ] Eseguo  [ ] Ricerco

SE anche UNA risposta e sbagliata = STOP e RILEGGI!
```

**Pro:** 3 check veloci, formato checkbox, 15 token max.
**Contro:** Meno elaborazione attiva.

#### ALTERNATIVA B: "COMPORTAMENTO VERIFICABILE"

Invece di quiz teorico, verifica COMPORTAMENTO nel task:

```markdown
## VERIFICA COMPORTAMENTO (durante task)

Prima di restituire output, verifica:
- [ ] Ho ricercato PRIMA di proporre? (Pilastro #1)
- [ ] Il risultato e TESTATO/verificato? (SU CARTA != REALE)
- [ ] Ho ragionato o solo eseguito? (Partner)

INCLUDI nel report: "COSTITUZIONE-CHECK: OK" o "COSTITUZIONE-CHECK: FAIL + motivo"
```

**Pro:** Verifica AZIONE reale, non teoria. Piu difficile da "checkboxare".
**Contro:** Richiede self-honesty dell'agente.

#### ALTERNATIVA C (RACCOMANDATA): IBRIDO

```markdown
## PRE-FLIGHT + BEHAVIOR

INIZIO TASK:
- 3 domande veloci (Obiettivo, SU CARTA, Partner)
- Max 15 token

FINE TASK:
- Self-check: "Ho applicato questi principi?"
- Se NO: segnala alla Regina
```

**Perche e migliore:** Defense-in-depth SEMPLIFICATO.

---

### 4. RISCHI E PROBLEMI

| Rischio | Probabilita | Impatto | Mitigazione |
|---------|-------------|---------|-------------|
| Risposte meccaniche | ALTA | Medio | Domanda random |
| Overhead latenza | Media | Basso | Ridurre a 3 domande |
| Falsa sicurezza | Media | Alto | Behavior check a fine task |
| Agenti "barano" | Bassa | Alto | Hook esterno di verifica |

**RISCHIO CRITICO: Falsa sicurezza**
Se implementiamo Pre-Flight e pensiamo "problema risolto", abbassiamo la guardia.
Il quiz NON garantisce internalizzazione - garantisce solo che l'agente SA le risposte.

---

### 5. SCORE FINALE CON MOTIVAZIONE

```
+================================================================+
|   SCORE DETTAGLIATO                                             |
+================================================================+

| Criterio                    | Score | Peso | Contributo |
|-----------------------------|-------|------|------------|
| Efficacia nel problema      | 6/10  | 30%  | 1.8        |
| Praticita implementazione   | 8/10  | 25%  | 2.0        |
| Costo/beneficio             | 7/10  | 20%  | 1.4        |
| Resistenza a gaming         | 5/10  | 15%  | 0.75       |
| Sostenibilita lungo termine | 7/10  | 10%  | 0.7        |
|                             |       |      |            |
| TOTALE                      |       |      | 6.65 ~ 7   |

+================================================================+
```

**Perche non 8+:**
- Rischio gaming/memorizzazione meccanica non mitigato
- 5 domande troppe per ogni spawn
- Manca verifica comportamento reale

---

## RACCOMANDAZIONE FINALE

### COSA PROPONGO

**IMPLEMENTARE con queste modifiche:**

1. **Ridurre a 3 domande CORE:**
   - Obiettivo finale (1 parola)
   - SU CARTA vs REALE (definizione)
   - Partner o Assistente (scelta)

2. **Aggiungere 1 domanda RANDOM:**
   - Pool di 5-7 domande
   - Diversa ogni volta
   - Previene memorizzazione

3. **Aggiungere BEHAVIOR CHECK a fine task:**
   - "Ho applicato questi principi?"
   - Incluso nel report output
   - Verifica azione, non teoria

4. **Formato COMPATTO:**
```
PRE-FLIGHT (15 token max):
1. Obiettivo: [risposta]
2. SU CARTA != [risposta]
3. Sono: [Partner/Assistente]
4. [Random]: [risposta]
```

### COSA NON FARE

- NON implementare 5 domande complete (troppo overhead)
- NON pensare che questo RISOLVA il problema (e solo Layer 1)
- NON saltare il Behavior Check finale (Layer 3 della ricerca)

---

## RISPOSTA ALLE DOMANDE DI RAFA

### E la MEGLIO soluzione possibile?

**NO, ma e un BUON INIZIO.**

La meglio soluzione e il sistema 3-Layer completo proposto dalla ricerca:
1. Pre-Flight (questo, semplificato)
2. Behavior Hooks (runtime)
3. Self-Verification (fine task)

Il Pre-Flight da solo e ~40% della soluzione.

### E pratica e non crea attrito?

**CON MODIFICHE, SI.**

- 5 domande = troppo attrito
- 3 domande + random = attrito accettabile (~10 sec)
- Formato compatto = fluido

### Funzionera REALMENTE?

**PARZIALMENTE.**

Funzionera per:
- Forzare almeno 1 lettura attenta
- Creare "checkpoint mentale" prima del task
- Catturare agenti che NON leggono affatto

NON funzionera per:
- Prevenire risposte meccaniche col tempo
- Garantire internalizzazione profonda
- Bloccare agenti che "barano" consapevolmente

**Per funzionare REALMENTE servono tutti e 3 i Layer.**

---

## NEXT STEP CONSIGLIATO

```
1. OGGI: Implementare versione SEMPLIFICATA (3+1 domande)
2. QUESTA SETTIMANA: Aggiungere Behavior Check finale
3. MONITORARE: Qualita output post-implementazione
4. ITERARE: Se risposte diventano meccaniche, cambiare domande
```

---

## TEMPLATE PROPOSTO (READY TO USE)

```markdown
## PRE-FLIGHT CHECK (Obbligatorio)

Dopo lettura Costituzione, rispondi (max 5 parole/risposta):

1. Obiettivo finale di Rafa e Cervella?
2. "SU CARTA" significa: ___. "REALE" significa: ___.
3. Sono: [ ] Assistente [ ] Partner

[RANDOM - una di queste]:
- Pilastro #1 della Formula Magica?
- Cosa fai PRIMA di proporre una soluzione?
- Perche "Fatto BENE > Fatto VELOCE"?
- Chi consulti PRIMA di implementare UI?

SE NON SAI = Rileggi Costituzione!
```

---

*Guardiana Qualita - Validazione completata*
*"Meglio trovare problemi ORA che dopo implementazione!"*

*Score: 7/10 - APPROVATA CON MODIFICHE*
