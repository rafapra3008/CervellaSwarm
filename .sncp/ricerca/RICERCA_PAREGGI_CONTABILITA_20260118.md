# RICERCA: Sistema PAREGGI Contabilita AntiGravity

**Researcher:** cervella-researcher
**Data:** 18 Gennaio 2026
**Scopo:** Storytelling per landing page - spiegazione non-tecnica del sistema matching

---

## EXECUTIVE SUMMARY

Il sistema PAREGGI di Contabilita AntiGravity è un **motore intelligente di matching automatico** che accoppia **caparre ricevute** con i rispettivi **giroconti** (incasso finale).

**In numeri:**
- 171 acconti importati in un singolo giorno (28/12/2025)
- €1.484,80 recuperati da bug fix parser
- €1.888 recuperati da fix formato SHE
- 3 portali gestiti simultaneamente (NL, HP, SHE)

**La magia:** Trova automaticamente corrispondenze anche quando:
- I nomi sono scritti in ordine diverso ("Varini Andrea" vs "Andrea Varini")
- Ci sono errori di battitura
- Le date non sono perfettamente allineate
- Stesso cliente ha prenotazioni multiple

---

## LA SFIDA

Immagina di gestire un hotel con centinaia di prenotazioni al mese:

1. Cliente prenota → **Caparra ricevuta** (es: €500 da "Rossi Mario")
2. Settimane dopo → **Giroconto bancario** (es: €500 da "gir. Mario Rossi - NL")

**Il problema:** Come abbinare automaticamente questi due movimenti?

**Difficoltà:**
- Nomi invertiti (nome/cognome vs cognome/nome)
- Date diverse (caparra oggi, giroconto fra 2 settimane)
- Stesso importo, clienti diversi
- Stesso cliente, prenotazioni multiple
- Errori di battitura
- Tre portali diversi (NL, HP, SHE) con formati diversi

---

## LA SOLUZIONE: ALGORITMO MULTI-FASE

Il sistema usa un approccio **intelligente a 4 fasi**, dalla certezza assoluta ai casi complessi.

### FASE 1: Match Semplice (Range Date + Importo)

**Cosa cerca:**
- Importo identico (±€0.01)
- Date nel range check-in +2/+14 giorni
- Nomi simili (se disponibili)

**Range dinamico basato su similarità nomi:**
- Nomi IDENTICI → range +0/+120 giorni (4 mesi!)
- Nomi quasi identici (95%+) → range +0/+90 giorni
- Nomi molto simili (90%+) → range +0/+60 giorni
- Similarità bassa → range standard +2/+14 giorni

**Esempio reale:**
```
Caparra: "HP 25490 Grzech Sebastian - MASTERCARD" €394,80
GIR: "gir. Grzech Sebastian - HP" €394,80
→ MATCH AUTOMATICO (similarity 1.0, confidence 100%)
```

**Risultati Fase 1:**
- Confidence 1.0 (100%) per nomi identici
- Confidence 0.98 per nomi quasi identici (95%+)
- Confidence dinamica per altri casi

---

### FASE 2: Match Fuzzy (Nomi Simili)

**Quando attiva:** Fase 1 non ha trovato corrispondenze

**Cosa fa:**
- Calcola **similarità nomi** usando algoritmo SequenceMatcher (Ratcliff/Obershelp)
- Gestisce **inversione nome/cognome** automaticamente
- Tolleranza importi dinamica basata su similarità

**Algoritmo intelligente inversione:**
```python
# "VARINI ANDREA" vs "ANDREA VARINI"
→ Ordina parole alfabeticamente
→ ["ANDREA", "VARINI"] = ["ANDREA", "VARINI"]
→ MATCH! (similarity 1.0)
```

**Tolleranza importi dinamica:**
- Nomi IDENTICI → ±€0.50 (accetta piccole differenze)
- Nomi quasi identici (95%+) → ±€0.20
- Similarità alta (90%+) → ±€0.10
- Similarità normale (80%+) → ±€0.01
- Similarità bassa → solo importi identici

**Soglie decisione:**
- Similarity ≥ 80% → **Pareggio normale** (approvato automaticamente)
- Similarity 70-79% → **Parking** (richiede approvazione)
- Similarity 50-69% → **Parking confidence bassa**
- Similarity < 50% → **Nessun match** (troppo incerto)

**Caso risolto:**
```
Bug fix 20/12/2025:
Caparra: "Spa SOLETO [5791]"
GIR: "gir. Roemer Helene"
→ PRIMA: Match errato (ID duplicato nel PDF)
→ DOPO: Fix ID duplicati, match corretto
```

---

### FASE 3: Range Esteso (Casi Particolari)

**Quando attiva:** Fase 1 e 2 non hanno trovato match

**Range date esteso:**
- Standard: +0 a +21 giorni
- Nomi identici: fino a +120 giorni
- Nomi quasi identici (95%+): fino a +90 giorni
- Similarità alta (90%+): fino a +60 giorni

**Perché serve:**
- Giroconti tardivi
- Date di check-in modificate
- Casi edge (festività, weekend, etc.)

---

### FASE 4: Match Gruppi (Intelligenza Avanzata)

**Quando attiva:** Fase 1-3 completate

**Cosa gestisce:**
- **1 caparra = N giroconti** (cliente paga in più rate)
- **N caparre = 1 giroconto** (gruppo prenota insieme, paga tutto insieme)
- **N caparre = M giroconti** (combinazioni complesse)

**Logica nuova (Fase 4-NEW, implementata 31/12/2025):**

1. **Raggruppa GIR per data** (±10 giorni tolleranza)
2. **Priorità nomi:** Cerca prima match con nomi identici/simili
3. **Verifica importo totale:** Caparre sommate = Giroconti sommati
4. **Calcola confidence:**
   - Similarity media nomi
   - Differenza date
   - Numero items nel gruppo
5. **Auto-approval:**
   - Confidence ≥ 85% → Pareggio automatico
   - Confidence < 85% → Candidato manuale (Tab FASE 4)

**Timeout intelligente:** Max 1-2 ore per evitare calcoli infiniti

**Esempio:**
```
Caparra A: €300 (Cliente X)
Caparra B: €200 (Cliente X)
GIR: €500 (Cliente X)
→ GRUPPO MATCH: 2 caparre = 1 GIR
```

---

## SISTEMA PARKING (Approvazione Manuale)

**Cosa sono i Parking:**
- Match **possibili ma non certi** (similarity 50-79%)
- Richiedono **approvazione utente**
- Mostrati in tab dedicata "PARKING"

**Tipi di Parking:**
- `simple_parking` - Fase 1, similarità 50-79%
- `fuzzy_parking` - Fase 2, nomi diversi ma importo identico
- `date_range_parking` - Fase 3, date estese

**Workflow:**
1. Sistema crea parking
2. Utente vede suggerimento in tab "PARKING"
3. Utente approva o rigetta
4. Se approva → diventa pareggio confermato (`*_confirmed`)
5. Se rigetta → rimosso dal database

**Fix critico 09/12/2025:**
- **Problema:** Parking approvati venivano cancellati dal ricalcolo automatico
- **Soluzione:**
  - `promote_parking_to_pareggio()` cambia `match_type` da `*_parking` a `*_confirmed`
  - `clear_all_pareggi()` preserva pareggi con `*_confirmed`
  - Ricalcolo automatico esclude transazioni in pareggi confermati

---

## GESTIONE CASI DIFFICILI

### 1. Nomi Invertiti

**Problema:** "Varini Andrea" vs "Andrea Varini"

**Soluzione:**
```python
def calculate_name_similarity(name1, name2):
    # 1. Calcola similarity normale
    normal_similarity = SequenceMatcher(None, name1, name2).ratio()

    # 2. Se già alta (≥80%), ritorna subito
    if normal_similarity >= 0.8:
        return normal_similarity

    # 3. Ordina parole alfabeticamente
    words1 = sorted(name1.split())
    words2 = sorted(name2.split())

    # 4. Calcola similarity parole ordinate
    sorted_similarity = SequenceMatcher(None, ' '.join(words1), ' '.join(words2)).ratio()

    # 5. Ritorna il massimo
    return max(normal_similarity, sorted_similarity)
```

**Risultato:** "VARINI ANDREA" vs "ANDREA VARINI" → similarity 1.0 (100%)

---

### 2. Client ID Duplicati (Stesso Cliente, Prenotazioni Diverse)

**Problema risolto 28/12/2025:**

**Prima:**
```
PDF HP con 34 GIR → Database salvava solo 31!
€1.484,80 mancanti!
```

**Causa:**
- Heyvaert Johan [26403] €394,80
- Heyvaert Johan [26404] €394,80
- Stesso nome, stesso importo, stesso documento
- Parser deduplicava: considerava duplicato!

**Soluzione:**
- Aggiunto `client_id` alla chiave deduplicazione
- Chiave: `(numero, importo, cliente, CLIENT_ID)`
- Database UNIQUE: `(numero_movimento, data, totale, client_id)`

**Casi risolti:**
| Cliente | Prenotazioni | Importo | Prima | Dopo |
|---------|--------------|---------|-------|------|
| Heyvaert Johan | [26403], [26404] | €394,80 x2 | ❌ 1 sola | ✅ Entrambe |
| Mazzon Eva | [26744], [26745] | €536,00 x2 | ❌ 1 sola | ✅ Entrambe |
| Moise Cornelia | [26837], [26838] | €554,00 x2 | ❌ 1 sola | ✅ Entrambe |

**Risultato:** €1.484,80 recuperati!

---

### 3. Formati Portale Diversi

**SHE ha formato diverso da NL/HP:**

**Problema 22/12/2025:**
```
PDF SHE con €1.888 non riconosciuti!
```

**Causa - Formati cliente:**
- NL/HP: `[1234] Nome Cognome - MASTERCARD`
- SHE: `[3397]` (solo ID!) o `[3515] Trabacchin` (ID + cognome, no trattino)

**Causa - Formati GIR:**
- NL/HP: `INCASSO CAPARRA (...)` (maiuscolo)
- SHE: `Incasso Caparra (...)` (case-insensitive)

**Soluzione:**
- Pattern cliente: `^\[(\d+)\]` per ID solo
- Pattern cliente: `^\[(\d+)\]\s+([A-Za-z]...)` per ID + Nome
- Pattern GIR: `^Incasso Caparra\s*\(` (case-insensitive)

**Risultato:** Tutti i portali riconosciuti correttamente!

---

### 4. Priorità Match Migliore

**Problema:**
- Caparra trova 2 GIR con stesso importo
- GIR A: similarity 45% (nomi molto diversi)
- GIR B: similarity 95% (quasi identico)

**PRIMA:** Creava parking con GIR A (primo trovato)

**DOPO (Fix 20/12/2025):**
1. Prima di creare parking, **cerca match migliore**
2. Se trova GIR con similarity ≥ 80% → usa quello
3. Ordina GIR per similarity **DECRESCENTE** prima di iterare

**Funzioni:**
- `find_better_match()` - Cerca GIR migliore per caparra
- `find_better_caparra_for_gir()` - Cerca caparra migliore per GIR (inverso)

**Risultato:** Priorità assoluta ai match con nomi simili!

---

## NUMERI E VOLUMI

### Import Acconti HP (28/12/2025)

**Record del giorno:**
```
CSV sorgente: 177 righe
Duplicati saltati: 6
Nuove inserite: 171
DB prima: 116 caparre
DB dopo: 287 caparre

ZERO ERRORI.
```

**Processo FORTEZZA MODE:**
1. Studio script e formati dati
2. Backup DB produzione (`contabilita_hp_PROD_BACKUP.db`)
3. Test locale su copia produzione
4. Dry-run su produzione
5. Import reale
6. Verifica finale

---

### Bug Fix Impact

| Fix | Data | Recupero | Dettaglio |
|-----|------|----------|-----------|
| Parser client_id | 28/12 | €1.484,80 | 3 GIR mancanti (prenotazioni duplicate stesso cliente) |
| Parser formato SHE | 22/12 | €1.888,00 | GIR non riconosciuti formato diverso |
| Fix parking promozione | 09/12 | N/A | Parking approvati non più cancellati da ricalcolo |
| Fix priorità match | 20/12 | N/A | Match migliori hanno priorità su parking sub-ottimali |

**Totale recuperato:** €3.372,80 da fix parser

---

### Portali Gestiti

| Portale | Database | Caratteristiche |
|---------|----------|-----------------|
| NL | `contabilita_nl.db` | Formato standard, volume alto |
| HP | `contabilita_hp.db` | 287 caparre, 64 GIR (post-import) |
| SHE | `contabilita_she.db` | Formato speciale, 16 GIR |

**Totale:** 3 portali simultanei, formati diversi gestiti

---

## TECNOLOGIE USATE

### Algoritmo Similarity

**SequenceMatcher (difflib Python):**
- Algoritmo: Ratcliff/Obershelp
- Output: ratio 0.0-1.0 (percentuale similarità)
- Veloce e affidabile per matching nomi

**Alternative valutate:**
- Levenshtein Distance (edit distance)
- Jaro-Winkler similarity
- FuzzyWuzzy

**Scelta:** SequenceMatcher per semplicità e performance

### Database

**SQLite con vincoli UNIQUE:**
```sql
-- Caparre
UNIQUE(file_name, numero, data_inserimento, importo)

-- GIR (fix 28/12)
UNIQUE(numero_movimento, data, totale, client_id)
```

**Indici compositi (31/12):**
- `idx_caparra_numero_data` - (numero_movimento, data_inserimento)
- `idx_gir_numero_data` - (numero_movimento, data)
- `idx_pareggi_match_type` - performance query `LIKE '%_confirmed'`

---

## WORKFLOW COMPLETO

```
1. UPLOAD PDF
   ↓
2. PARSING INTELLIGENTE
   - Riconosce formato portale (NL/HP/SHE)
   - Estrae caparre e GIR
   - Gestisce client_id duplicati
   ↓
3. VALIDAZIONE TOTALI
   - Somma caparre estratte vs totale PDF
   - Somma GIR estratti vs totale PDF
   - Alert se discrepanza
   ↓
4. SALVATAGGIO DATABASE
   - Vincoli UNIQUE prevengono duplicati
   - Notifica Telegram se >70% duplicate
   ↓
5. CALCOLO PAREGGI AUTOMATICO
   - Fase 1: Match semplice (range date)
   - Fase 2: Match fuzzy (nomi simili)
   - Fase 3: Range esteso
   - Fase 4: Match gruppi
   ↓
6. RISULTATI
   - Pareggi automatici (confidence ≥ 80%)
   - Parking manuali (confidence 50-79%)
   - Candidati Fase 4 (confidence < 85%)
   ↓
7. APPROVAZIONE UTENTE
   - Tab PAREGGI: già approvati
   - Tab PARKING: da approvare/rigettare
   - Tab FASE 4: candidati gruppi
   ↓
8. EXPORT SPRING
   - File Excel per contabile
   - Directory picker moderno
   - Formato compatibile Spring
```

---

## EVOLUTION TIMELINE

### Dicembre 2025 - Mese d'Oro

**08/12** - Miglioramenti UI
- Bottone SPRING NC (non contabilizzato)
- Fix name inversion matching
- Fix cancellazione manual_edits

**09/12** - Fix Parking + Versioning
- Fix parking promozione (preserva confermati)
- Versioning obbligatorio file backend
- CHANGELOG obbligatorio

**11/12** - Notifiche Telegram
- Audit modifiche righe contabilizzate
- Nuovo file `telegram_notifier.py`
- Tabella `audit_contabilizzate`

**16/12** - Dettagli Perfetti
- Telegram prefisso ID (#C2202, #G2202)
- Spring directory picker
- Plurale italiano corretto

**20/12** - Fix Priorità
- Ordina GIR per similarity decrescente
- Fix associazione cliente ID duplicati
- Bonifico Unicredit riconosciuto

**22/12** - Parser SHE
- Supporto formato SHE `[ID]` solo
- Pattern GIR case-insensitive
- €1.888 recuperati

**28/12** - Record Import
- 171 acconti HP importati
- €1.484,80 recuperati (fix client_id)
- Fix vincolo UNIQUE database

**31/12** - Indici Performance
- Indici compositi per query veloci
- Logger conversion (print → logger)

### Gennaio 2026

**04/01** - Suggerimenti Smart
- Match importo identico anche con nomi diversi
- Score checkout fix (data_checkout vs data_inserimento)

---

## STORYTELLING - PUNTI CHIAVE

### Per Landing Page

**1. IL PROBLEMA (Relatable)**
"Gestisci centinaia di prenotazioni. Ogni caparra deve essere accoppiata al giroconto. Nomi invertiti, date diverse, errori di battitura. Farlo a mano? Ore perse. Errori garantiti."

**2. LA SOLUZIONE (Intelligente)**
"Algoritmo multi-fase che pensa come un contabile esperto:
- Prima cerca certezze (importo + date + nome identico)
- Poi gestisce variazioni (nomi invertiti, piccole differenze)
- Infine propone ipotesi (parking da approvare)"

**3. I NUMERI (Impressive)**
- 171 acconti importati in 1 giorno
- €3.372 recuperati da bug fix
- 3 portali diversi gestiti simultaneamente
- Match automatici con confidence fino a 100%

**4. L'INTELLIGENZA (Magic)**
- Riconosce "Varini Andrea" = "Andrea Varini"
- Gestisce stesso cliente, prenotazioni multiple
- Adatta range date basato su similarità nomi
- Trova gruppi complessi (N caparre = M giroconti)

**5. LA SICUREZZA (Trust)**
- Backup automatici prima di ogni operazione
- Vincoli database prevengono duplicati
- Notifiche Telegram per modifiche critiche
- Audit completo di ogni operazione

**6. LA FLESSIBILITÀ (Adaptable)**
- 3 portali con formati diversi
- Pattern riconosciuti automaticamente
- Approvazione manuale per casi incerti
- Export compatibile con sistemi esistenti

---

## FONTI

### Codice
- `/backend/matching.py` - Algoritmo matching multi-fase (v1.2.1)
- `/backend/database.py` - Gestione database e vincoli (v2.13.0)
- `/backend/processors/pdf_parser.py` - Parsing PDF multi-portale (v1.5.0)
- `/frontend/js/pareggi.js` - UI gestione pareggi/parking (v1.6.2)

### Documentazione
- `CHANGELOG.md` - Evolutione sistema Dicembre 2025
- `COSTITUZIONE_CONTABILITA.md` - Timeline traguardi

### Ricerca Web
- [Similarity Metrics Python - GeeksforGeeks](https://www.geeksforgeeks.org/python/python-similarity-metrics-of-strings/)
- [Fuzzy String Matching Python - Typesense](https://typesense.org/learn/fuzzy-string-matching-python/)
- [Levenshtein Distance - StackAbuse](https://stackabuse.com/levenshtein-distance-and-text-similarity-in-python/)

---

## CONCLUSIONE

Il sistema PAREGGI è un esempio di **intelligenza artificiale applicata alla contabilità**:

- **Non è machine learning** (niente training, niente neural networks)
- **È algoritmo deterministico** (stesse condizioni = stesso risultato)
- **Ma è intelligente** (adatta comportamento a contesto)

**La vera magia:** Combina logica rigida (importi, date) con fuzzy logic (nomi simili, tolleranze) per replicare il ragionamento umano.

**Risultato:** Ore di lavoro manuale → Secondi automatici. Con precisione superiore.

---

*"I dettagli fanno SEMPRE la differenza."*
*"Fatto BENE > Fatto VELOCE"*

**Ricerca completata: 18 Gennaio 2026**
