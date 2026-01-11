# SCOPERTA: Context "Cache Invalidation" Phenomenon

> **Data:** 11 Gennaio 2026 - Sessione 166
> **Segnalato da:** Rafa
> **Status:** INVESTIGATO! Pattern identificato!

---

## SCOPERTA PRINCIPALE

Il fenomeno e' causato da **CACHE INVALIDATION + RICOSTRUZIONE COMPRESSA**!

### I Numeri (dalla nostra sessione)

```
DROP #1: 67.5% -> 52.8% (-14.8%)
  PRIMA: cache_read = 134,619 | cache_create = 442
  DOPO:  cache_read =  19,365 | cache_create = 86,166

DROP #2: 71.4% -> 60.3% (-11.1%)
  PRIMA: cache_read = 142,097 | cache_create = 661
  DOPO:  cache_read =  19,365 | cache_create = 99,667
```

### Il Pattern

1. `cache_read` CROLLA sempre a ~19,365 (costante!)
2. `cache_create` ESPLODE (da ~500 a ~86,000-99,000)
3. TOTALE scende perche' nuova cache e' piu' COMPATTA

### Cosa Significa

- La cache viene INVALIDATA silenziosamente
- Il sistema RICREA la cache in forma compressa
- Il "core" (~19,365 tokens) rimane sempre = system prompt + CLAUDE.md
- Il resto viene ricostruito/riassunto

### Differenza da Auto-Compact

- Auto-compact: visibile, triggerato a ~77-78%, messaggio di sistema
- Cache invalidation: SILENTE, trigger sconosciuto, nessun messaggio

---

## Fenomeno Osservato Originale

Rafa ha notato che il context scende (es. 70% -> 50%) SENZA che venga triggerato auto-compact.

**Caratteristiche:**
- NON e' auto-compact (quello e' a ~77-78%)
- Succede "all'improvviso"
- Sembra che Claude "liberi" spazio
- E' successo multiple volte

**Momento specifico osservato:**
- Stavamo a ~70%
- Dopo un prompt, siamo scesi a ~50%
- Nessun messaggio di compact
- Sessione continuata normalmente

---

## Ipotesi da Verificare

1. **Cache Expiration**
   - Prompt caching scade dopo X tempo?
   - cache_read_input_tokens calano?

2. **Lazy Evaluation**
   - Claude non carica tutto in memoria finche' non serve?
   - Rilascia parti "dormienti"?

3. **Background Optimization**
   - Il sistema ottimizza silenziosamente?
   - Diverso da "compact" ufficiale?

4. **Token Counting Bug**
   - Il nostro calcolo e' sbagliato in certi casi?
   - usage.input_tokens cambia significato?

5. **Session Memory Sync**
   - Session memory si sincronizza e libera context?

---

## Come Investigare

1. **Log dettagliato**
   - Catturare usage PRIMA e DOPO il "drop"
   - Confrontare tutti i campi (input, cache_creation, cache_read)

2. **Leggere transcript**
   - Vedere se c'e' qualche evento speciale
   - Cercare pattern

3. **Documentazione Anthropic**
   - Cercare info su cache expiration
   - Cercare info su memory management

4. **Test controllato**
   - Creare sessione di test
   - Monitorare context ogni 30 secondi
   - Vedere quando/se scende senza prompt

---

## Idee da Altra Cervella (Sessione 166)

> L'altra Cervella che lavorava su Miracollo ha suggerito:

### Ipotesi da Testare

1. **Numero di tool calls?**
   - Forse succede dopo un certo numero di chiamate?
   - Contare tool calls prima del drop

2. **Contenuto cambia molto?**
   - Forse quando il contenuto della conversazione cambia significativamente?
   - Analizzare tipo di messaggi prima del drop

3. **Time-based?**
   - Forse la cache scade dopo X minuti?
   - Misurare tempo tra inizio sessione e drop

### Idea Test Controllato

Creare sessione di test:
1. Inviare messaggi regolari ogni 30 secondi
2. Loggare usage dopo ogni messaggio
3. Identificare esattamente quando cache si invalida
4. Cercare pattern nel tipo di messaggi/tool calls

---

## Sessione Dedicata

Quando: Prossima sessione libera
Durata: ~1 ora
Obiettivo: Capire ESATTAMENTE cosa causa il "drop" di context

**Preparazione:**
- Script per logging automatico usage
- Sequenza test predefinita
- File per raccogliere dati

---

*"Nulla e' complesso - solo non ancora studiato!"*
*"La SCOPERTA e' gia' oro perche' capiamo cosa succede!"*
