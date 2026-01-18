# ROADMAP - Landing Page Contabilita

> **Creata:** 18 Gennaio 2026 - Sessione 265
> **Obiettivo:** Presentare il nostro primo capolavoro

---

## VISIONE

Una landing page nascosta (solo con link) che racconta la storia del progetto Contabilita Antigravity: le sfide, le soluzioni, il metodo. Non marketing, ma STORIA.

---

## DATI DEL PROGETTO

| Metrica | Valore |
|---------|--------|
| Righe di codice | 31.657 |
| Commit | 142 |
| Portali supportati | 3 (NL, HP, SHE) |
| Rating sistema | 9.9/10 |
| Versione | v2.7.0 |
| FORTEZZA MODE | v4.3.0 |
| Inizio | Dicembre 2025 |

---

## SEZIONI DELLA LANDING (Ordine)

### 1. HERO + IMPATTO
- Titolo potente
- Numero concreto: "X ore/mese automatizzate"
- Screenshot hero del sistema

### 2. IL PROBLEMA
- Multi-portale (3 sistemi diversi, 3 formati PDF)
- PDF "rompicapo" con dati sparsi
- Nomi invertiti, caratteri accentati
- Match caparre/giroconti manuale

### 3. LA SOLUZIONE (come STORIA)
**Parser PDF - Il Rompicapo**
- v1.3.0: Bug associazione cliente
- v1.4.0: Formato SHE diverso
- v1.5.0: Deduplicazione (Heyvaert, Mazzon, Moise)
- v1.6.0: "Caso Niccolo" - caratteri accentati

**Algoritmo Pareggi**
- Similarita nomi con SequenceMatcher
- Gestione inversione nome/cognome
- Match 1:1 e N:M

### 4. ESEMPI VISIVI
- Upload PDF -> Parsing automatico
- Schermata validazione (caparre quadrano)
- Sistema pareggi in azione
- Export Excel finale

### 5. NUMERI REALI
```
142 commit | 31.657 righe | 3 portali | 1 team | 0 compromessi
```

### 6. IL METODO
Citazioni dalla COSTITUZIONE:
- "Fatto BENE > Fatto VELOCE"
- "I dettagli fanno SEMPRE la differenza"
- "Nulla e complesso - solo non ancora studiato"

---

## SPRINT DI IMPLEMENTAZIONE

### SPRINT 1: Contenuti (PRIMA del codice!) - COMPLETATO 18 Gen!
| Task | Status |
|------|--------|
| Scrivere testo Hero | FATTO |
| Scrivere sezione Problema | FATTO |
| Scrivere storia Parser (con casi reali) | FATTO |
| Scrivere storia Pareggi | FATTO |
| Lista screenshot (anonimizzati) | FATTO |
| Sezione Perche e Unico | FATTO |
| Sezione Il Metodo | FATTO |
| Sezione Conclusione | FATTO |

**8 file creati - 1.433 righe totali!**

### SPRINT 2: Design
| Task | Status |
|------|--------|
| Mockup layout (cervella-marketing) | TODO |
| Palette colori (coerente col portale) | TODO |
| Animazioni counter | TODO |

### SPRINT 3: Implementazione
| Task | Status |
|------|--------|
| Creare pagina HTML/CSS | TODO |
| Integrare screenshot | TODO |
| Counter animato | TODO |
| Test responsive | TODO |

### SPRINT 4: Deploy
| Task | Status |
|------|--------|
| Decidere hosting (GitHub Pages? Vercel?) | TODO |
| Path: /showcase/contabilita/ | TODO |
| Link nascosto (no index) | TODO |

---

## STORIE DA RACCONTARE

### Il Caso Niccolo (Perfetto per storytelling)
```
PROBLEMA: "Bordin Galtarossa Niccolo" non veniva riconosciuto
INDAGINE: La regex [A-Za-z] ignora i caratteri accentati
FIX: Pattern esteso a [A-Za-z...] per tutti i caratteri latini
MORALE: "I dettagli fanno SEMPRE la differenza"
```

### Il Bug dei Duplicati (€1.484,80 x 3)
```
PROBLEMA: 3 clienti con stesso importo sembravano duplicati
- Heyvaert Johan [26403]/[26404]
- Mazzon Eva [26744]/[26745]
- Moise Cornelia [26837]/[26838]
INDAGINE: Chiave deduplicazione non includeva client_id
FIX: Aggiunto client_id alla chiave
RISULTATO: €1.484,80 x 3 = €4.454,40 recuperati!
```

### Righe Spezzate
```
PROBLEMA: PDF con pagamento su 2 righe
"Caparra - Unicredit100 - NL -"
"MASTERCARD 01/02/2026"
FIX: Pre-processing che unisce righe spezzate
```

---

## PERCHE E UNICO

### Conoscenza dal Campo
```
Questo sistema NON poteva essere costruito da un developer esterno.

PERCHE?
- I PDF Ericsoft non hanno documentazione
- Ogni portale (NL, HP, SHE) ha formati DIVERSI
- Le eccezioni si scoprono SOLO processando dati reali
- I pattern emergono dopo MESI di lavoro quotidiano
```

### Esempi di Conoscenza "Invisibile"
```
1. Righe spezzate su pagine diverse
   → Solo chi processa centinaia di PDF lo scopre

2. "FEST - Nome" vs "FE - Nome" vs "Nome"
   → Varianti che cambiano senza preavviso

3. Caparre senza nome cliente (solo circuito)
   → Bisogna matchare per importo e data

4. Nomi invertiti (ROSSI MARIO vs MARIO ROSSI)
   → I portali non sono consistenti

5. Caratteri accentati nei nomi stranieri
   → Niccolo, Francois, Jose - ignorati da regex standard
```

### Il Vero Valore
```
NON e il codice. E la CONOSCENZA codificata.

Anni di esperienza manuale trasformati in algoritmo.
Ogni IF, ogni regex, ogni controllo = una lezione imparata.

Un developer esterno scriverebbe codice "pulito"
che fallirebbe al primo PDF reale.

Questo sistema funziona perche chi l'ha progettato
VIVE questi problemi ogni giorno.
```

---

## COSA NON FARE

- Linguaggio troppo tecnico (racconta come storia)
- Lista features invece di narrazione
- Screenshot vuoti/generici
- Vanteria ("il migliore di tutti")
- Dimenticare il PERCHE (liberta, non solo codice)

---

## NOTE

- Path suggerito: `/showcase/contabilita/`
- Nascosta ma linkabile
- Contenuti PRIMA, codice DOPO
- Anonimizzare dati sensibili negli screenshot

---

*"La qualita non si negozia. Questo progetto la dimostra."*
