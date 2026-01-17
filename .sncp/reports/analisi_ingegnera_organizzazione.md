# Analisi Architettura SNCP - Cervella Ingegnera
> Data: 17 Gennaio 2026
> Analista: cervella-ingegnera
> Dimensione totale: 9.6MB | 693 file | 5 progetti

---

## Executive Summary

**HEALTH SCORE: 5.8/10**

```
PROBLEMI CRITICI: 3
PROBLEMI ALTI: 5
PROBLEMI MEDI: 4
CRESCITA: Da 6.5MB a 9.6MB in 3 giorni (+47%)
```

**TOP 3 PROBLEMI:**
1. CRITICO: cervellaswarm/stato.md = 700 righe (limite: 500)
2. CRITICO: 15+ file duplicati tra idee/ e bracci/
3. ALTO: Miracollo 4.8MB (50% totale), 375 file

---

## 1. PROBLEMI ARCHITETTURALI TROVATI

### 1.1 CRITICO - Violazione Limiti File

| File | Righe Attuali | Limite | Violazione |
|------|---------------|--------|------------|
| `cervellaswarm/stato.md` | 700 | 500 | +200 righe (+40%) |

**Impatto:**
- Context window sprecato
- Difficile capire stato attuale
- Rallenta caricamento sessione

**Root Cause:**
- Accumulo sessioni senza archivio
- Nessun trigger automatico quando > 500 righe

---

### 1.2 CRITICO - Duplicazione File tra Livelli

**15 file duplicati esatti:**

```
idee/20260115_VDA_H155300_RCU_RESEARCH.md
bracci/room-hardware/studi/20260115_VDA_H155300_RCU_RESEARCH.md
→ 1227 righe IDENTICHE in 2 posti!

idee/20260115_VDA_MODBUS_REVERSE_ENGINEERING_PARTE1.md
bracci/room-hardware/studi/20260115_VDA_MODBUS_REVERSE_ENGINEERING_PARTE1.md

idee/20260115_VDA_MODBUS_REVERSE_ENGINEERING_PARTE2.md
bracci/room-hardware/studi/20260115_VDA_MODBUS_REVERSE_ENGINEERING_PARTE2.md

idee/20260115_VDA_MODBUS_REVERSE_ENGINEERING_PARTE3.md
bracci/room-hardware/studi/20260115_VDA_MODBUS_REVERSE_ENGINEERING_PARTE3.md

idee/20260115_VDA_DOCUMENTAZIONE_UFFICIALE.md
bracci/room-hardware/studi/20260115_VDA_DOCUMENTAZIONE_UFFICIALE.md

idee/20260115_VDA_ARCHITETTURA_SISTEMA_RESEARCH.md
bracci/room-hardware/studi/20260115_VDA_ARCHITETTURA_SISTEMA_RESEARCH.md

idee/20260115_VDA_VE503_TERMOSTATI_RESEARCH.md
bracci/room-hardware/studi/20260115_VDA_VE503_TERMOSTATI_RESEARCH.md

idee/20260116_VDA_ROSETTA_STONE_PIANO.md
bracci/room-hardware/studi/20260116_VDA_ROSETTA_STONE_PIANO.md

reports/big_players_rms_research_20260112_INDEX.md
bracci/room-hardware/studi/big_players_research.md (simile, non identico)

... (+ altri 6 file duplicati) ...
```

**Costo totale duplicazione:**
- ~10K righe duplicate
- ~600KB spazio sprecato
- Confusione: quale è la versione "vera"?

**Root Cause:**
- Ricerca fatta a livello progetto → copiata in braccio
- Nessuna regola chiara "dove va il file?"
- Manca link simbolico o riferimento

---

### 1.3 ALTO - Crescita Incontrollata Miracollo

| Metriche | Valore |
|----------|--------|
| File totali | 375 |
| Dimensione | 4.8MB (50% totale SNCP) |
| File > 1000 righe | 21 |
| Cartelle reports/ | 87 file |
| Cartelle idee/ | 51 file |

**Bracci interni (sub-progetti):**
```
miracallook:   91 file, 1.4MB
room-hardware: 42 file, 804KB
pms-core:       4 file,  16KB
```

**Problema:**
- Non c'è strategia archivio per ricerche vecchie
- Reports mai eliminati dopo implementazione
- Ogni sessione aggiunge 3-5 file, mai rimuove

---

### 1.4 ALTO - Naming Inconsistente

**Pattern trovati (CONFUSIONE!):**

```
RICERCA vs ricerca vs Ricerca
AUDIT vs audit vs Audit
20260115_ vs 2026-01-15_ vs session_115_
PARTE1 vs PARTE_1 vs parte1 vs P1
INDEX vs index vs Index
```

**Esempi concreti:**
```
✅ CORRETTO: 20260115_RICERCA_VDA_MODBUS.md
❌ TROVATO:  ricerca_vda_modbus_session214.md
❌ TROVATO:  VDA-Modbus-Research.md
❌ TROVATO:  vda_modbus_parte_1.md
```

**Impatto:**
- Impossibile trovare file con pattern
- Ordinamento alfabetico non funziona
- Grep/Glob diventano complicati

---

### 1.5 ALTO - Sessioni Parallele Caotiche

**Struttura attuale:**
```
.sncp/progetti/miracollo/sessioni_parallele/
→ Vuota! (cartella esiste ma non usata)

.sncp/progetti/miracollo/bracci/miracallook/
→ 91 file mescolati (reports, studi, handoff, tutto insieme)
```

**Problema:**
- Sessioni parallele non hanno "casa" chiara
- Bracci usati come sessioni parallele MA anche come moduli permanenti
- Confusione: "braccio" = modulo o sessione temporanea?

---

### 1.6 MEDIO - Handoff Duplicati

**Trovati:**
```
miracollo/HANDOFF_SESSIONE_170.md
miracollo/HANDOFF_SESSIONE_171.md
miracollo/bracci/room-hardware/HANDOFF_SESSIONE_172.md
miracollo/bracci/room-hardware/HANDOFF_SESSIONE_172_FINALE.md
```

**Problema:**
- Handoff sia in root progetto che in bracci
- Nessuna regola chiara dove metterli
- Duplicazione "FINALE" (dovrebbe essere unico!)

---

### 1.7 MEDIO - Reports Mai Archiviati

**Miracollo/reports/: 87 file**

File vecchi (> 5 giorni) ancora in reports/:
```
20260112_* → 31 file (5 giorni fa)
20260113_* → 24 file (4 giorni fa)
20260114_* → 18 file (3 giorni fa)
```

**Problema:**
- Reports rimangono forever anche dopo implementazione
- Nessun trigger automatico "archivia dopo X giorni"
- Crescita lineare senza bound

---

### 1.8 MEDIO - Cartelle Ridondanti

**Trovato:**
```
idee/ vs ricerca/ vs ricerche/ vs studi/

miracollo/idee/          → 51 file
miracollo/ricerca/       → vuota
miracollo/ricerche/      → 3 file
bracci/*/studi/          → 27 file (contenuto simile a idee/)
```

**Problema:**
- 4 cartelle per stesso scopo (ricerche/idee)
- Dove va una nuova ricerca? Nessuno lo sa!
- Duplicazione come conseguenza

---

### 1.9 BASSO - File Grandi (> 1500 righe)

| File | Righe | Tipo |
|------|-------|------|
| BIG_PLAYERS_EMAIL_RESEARCH.md | 2128 | Ricerca |
| RICERCA_GAP3_GAP4_ML_WHATIF.md | 2007 | Ricerca |
| RICERCA_PERFORMANCE_EMAIL_CLIENTS.md | 1699 | Ricerca |

**Nota:** Questi sono OK (ricerche approfondite), ma potrebbero essere splittati in PARTE1/PARTE2.

---

## 2. ANALISI ROOT CAUSE

### Perché i File Crescono Senza Controllo?

```
1. Nessun trigger automatico archivio
   → stato.md cresce oltre 500 righe
   → reports/ accumula infinito

2. Workflow "aggiungi sempre, mai rimuovi"
   → Ogni sessione: +5 file
   → Nessuna sessione: -N file

3. Duplicazione tra livelli
   → Ricerca in idee/ → implementazione → copia in bracci/
   → Nessuna regola "muovi vs copia vs link"

4. Naming non standardizzato
   → Ogni agente sceglie formato proprio
   → Impossibile automatizzare pulizia
```

---

### Come Sessioni Parallele Creano Casino?

```
SCENARIO:
1. Regina lavora su Miracollo PMS
2. Lancia sessione parallela: Miracollook design
3. Miracollook crea bracci/miracallook/
4. Dentro miracallook: reports/, studi/, handoff/
5. Regina torna: confusione totale!
   → miracallook è braccio o sessione parallela?
   → I file vanno archiviati o sono permanenti?
```

**Problema architetturale:**
- `bracci/` usato per 2 scopi DIVERSI:
  1. Moduli permanenti (pms-core, room-hardware)
  2. Sessioni parallele temporanee (miracallook design sprint)

**Soluzione necessaria:**
- Separare bracci/ (moduli) da sessioni_parallele/ (temporanee)

---

## 3. STRUTTURA IDEALE PROPOSTA

### 3.1 Principi Architetturali

```
SEPARAZIONE CHIARA:
- Permanente vs Temporaneo
- Progetto vs Modulo vs Sessione
- Attivo vs Archiviato

REGOLA UNICA FONTE DI VERITA:
- Ogni file ha UN posto solo
- Link simbolici invece di copie
- Riferimenti invece di duplicati

LIFECYCLE AUTOMATICO:
- Reports → Archivio dopo 7 giorni
- stato.md → Archivio quando > 400 righe
- Sessioni parallele → Merge o Archivio dopo completamento
```

---

### 3.2 Struttura Proposta (Layer 1: Progetto)

```
.sncp/progetti/{progetto}/
│
├── PROMPT_RIPRESA_{progetto}.md  # MAX 150 righe (REGOLA!)
├── stato.md                       # MAX 500 righe (TRIGGER ARCHIVIO!)
├── NORD.md                        # Direzione progetto
│
├── attivo/                        # 🆕 FILE ATTIVI SESSIONE CORRENTE
│   ├── idee/                      # Ricerche/idee correnti
│   ├── decisioni/                 # Decisioni correnti
│   ├── reports/                   # Reports ultimi 7 giorni
│   └── roadmaps/                  # Roadmap attive
│
├── moduli/                        # 🆕 MODULI PERMANENTI (ex bracci/)
│   ├── {modulo}/
│   │   ├── stato.md               # Stato modulo
│   │   ├── docs/                  # Documentazione permanente
│   │   └── decisioni/             # Decisioni modulo-specifiche
│
├── sessioni_parallele/            # SESSIONI TEMPORANEE
│   ├── {sessione_YYYYMMDD}/
│   │   ├── obiettivo.md           # Cosa fa questa sessione
│   │   ├── output/                # Risultati
│   │   └── handoff.md             # Handoff finale
│
├── archivio/                      # FILE VECCHI (> 7 giorni)
│   ├── 2026-01/                   # Per mese
│   │   ├── idee/
│   │   ├── reports/
│   │   └── sessioni/
│
└── docs/                          # DOCUMENTAZIONE PERMANENTE
    ├── architettura/
    ├── workflow/
    └── guide/
```

---

### 3.3 Regole Naming (STANDARD OBBLIGATORIO)

#### Formato Standard

```
{DATA}_{TIPO}_{DESCRIZIONE}_{PARTE}.md

DATA:     YYYYMMDD (es: 20260117)
TIPO:     MAIUSCOLO (RICERCA, AUDIT, DECISIONE, REPORT, PIANO)
DESCRIZIONE: snake_case_minuscolo
PARTE:    PARTE1, PARTE2, ... (solo se multi-parte)

✅ ESEMPI CORRETTI:
20260117_RICERCA_vda_modbus.md
20260117_AUDIT_stato_sncp.md
20260117_DECISIONE_architettura_bracci.md
20260117_RICERCA_competitor_analysis_PARTE1.md
20260117_RICERCA_competitor_analysis_PARTE2.md

❌ ESEMPI SBAGLIATI:
ricerca_vda.md              → manca data
20260117_VDA_Modbus.md      → caso misto
2026-01-17_ricerca_vda.md   → data con trattini
vda_modbus_parte_1.md       → manca tipo
```

#### Eccezioni (File Permanenti)

```
File che NON seguono formato data:

stato.md
NORD.md
PROMPT_RIPRESA_{progetto}.md
README.md
INDEX.md
COSTITUZIONE_{modulo}.md
```

---

### 3.4 Lifecycle Automatico (TRIGGER PROPOSTI)

#### Trigger Archivio Automatico

```bash
# 1. Reports vecchi → Archivio
TRIGGER: File in reports/ con data > 7 giorni fa
AZIONE:  Muovi in archivio/YYYY-MM/reports/

# 2. stato.md troppo grande → Archivio
TRIGGER: stato.md > 400 righe (80% del limite)
AZIONE:  
  1. Estrai sessioni vecchie (> 14 giorni)
  2. Muovi in archivio/YYYY-MM/stato_old.md
  3. Mantieni solo ultimi 14 giorni in stato.md

# 3. Sessioni parallele completate → Merge o Archivio
TRIGGER: Sessione parallela con handoff.md completato
AZIONE:
  1. Se output importante: merge in moduli/
  2. Altrimenti: muovi in archivio/YYYY-MM/sessioni/
```

---

### 3.5 Regola Anti-Duplicazione

```
PRIMA di creare file:
1. Cerca se esiste gia (fd + grep)
2. Se esiste:
   a. Stesso contenuto? → Link simbolico
   b. Contenuto simile? → Aggiungi riferimento
   c. Contenuto diverso? → Naming diverso

ESEMPIO:
Ricerca VDA fatta in idee/ → implementata in room-hardware

SBAGLIATO:
  cp idee/20260115_RICERCA_vda.md moduli/room-hardware/studi/

CORRETTO:
  # In moduli/room-hardware/docs/FONTI.md
  ## Ricerca Originale
  Vedi: ../../archivio/2026-01/idee/20260115_RICERCA_vda.md
```

---

## 4. PROPOSTA COMPATTAZIONE FILE GRANDI

### 4.1 cervellaswarm/stato.md (700 → 300 righe)

**Strategia:**

```
1. ESTRAI sessioni archiviate (< Sessione 220)
   → archivio/2026-01/STATO_SESSIONI_PRE_220.md

2. MANTIENI in stato.md:
   - TL;DR (sempre primo)
   - Ultime 5 sessioni (221-232)
   - Metriche attuali
   - Next steps

3. AGGIUNGI riferimento archivio:
   ## Storia Completa
   Vedi: archivio/2026-01/STATO_SESSIONI_PRE_220.md

RISULTATO: 700 → ~280 righe
```

---

### 4.2 Miracollo Reports (87 → 20 file)

**Strategia:**

```
1. ARCHIVIA reports > 7 giorni:
   20260112_* → archivio/2026-01/reports/
   20260113_* → archivio/2026-01/reports/

2. MANTIENI in reports/:
   - Ultimi 7 giorni (20260115+)
   - Reports "permanenti" (AUDIT_ARCHITETTURA, MAPPA_*)

3. CREA INDEX:
   archivio/2026-01/reports/INDEX.md
   → Lista tutti reports archiviati con summary

RISULTATO: 87 → ~22 file attivi
```

---

### 4.3 Duplicati VDA (15 → 8 file)

**Strategia:**

```
1. SCEGLI versione "source of truth":
   → idee/ è la fonte originale (ricerca primaria)

2. RIMUOVI da bracci/room-hardware/studi/:
   rm 20260115_VDA_*.md

3. CREA riferimento in room-hardware:
   # In moduli/room-hardware/docs/RICERCHE_VDA.md
   ## Ricerche Completate
   
   ### 15 Gennaio 2026 - VDA Architettura Completa
   - [VDA Architettura](../../../archivio/2026-01/idee/20260115_VDA_ARCHITETTURA_SISTEMA_RESEARCH.md)
   - [VDA Modbus P1](../../../archivio/2026-01/idee/20260115_VDA_MODBUS_REVERSE_ENGINEERING_PARTE1.md)
   - [VDA Modbus P2](../../../archivio/2026-01/idee/20260115_VDA_MODBUS_REVERSE_ENGINEERING_PARTE2.md)
   ...

RISULTATO: 15 file duplicati → 8 file originali + 1 INDEX
```

---

## 5. PIANO IMPLEMENTAZIONE

### Fase 1: COMPATTAZIONE URGENTE (Adesso!)

```
PRIORITA: CRITICA
EFFORT: 30 minuti
AGENT: cervella-backend (file operations)

[ ] Archivia sessioni vecchie da cervellaswarm/stato.md
    → Porta da 700 a ~280 righe
    
[ ] Archivia reports Miracollo > 7 giorni
    → 87 → 22 file attivi
    
[ ] Elimina duplicati VDA esatti
    → -600KB, +8 file puliti
```

---

### Fase 2: RISTRUTTURAZIONE (3-5 giorni)

```
PRIORITA: ALTA
EFFORT: 2-3 ore totali (splittate)
AGENT: cervella-ingegnera (design) + cervella-backend (implementazione)

[ ] Crea struttura attivo/ vs archivio/
[ ] Sposta file attuali in nuova struttura
[ ] Rinomina bracci/ → moduli/
[ ] Crea docs/NAMING_STANDARD.md
[ ] Implementa verifiche pre-commit naming
```

---

### Fase 3: AUTOMAZIONE (1-2 settimane)

```
PRIORITA: MEDIA
EFFORT: 4-6 ore
AGENT: cervella-backend (scripts)

[ ] Script archivio automatico reports > 7 giorni
[ ] Hook pre-sessione: verifica stato.md < 400 righe
[ ] Hook pre-commit: verifica naming standard
[ ] Script anti-duplicazione (cerca prima di creare)
[ ] Dashboard health SNCP (dimensione, violazioni, etc)
```

---

## 6. METRICHE SUCCESS

### Prima (Oggi)

```
Dimensione:    9.6MB
File totali:   693
Duplicati:     15+
stato.md:      700 righe (VIOLAZIONE!)
Reports attivi: 87
Naming issues: ~40%
Health Score:  5.8/10
```

### Dopo Fase 1 (Domani)

```
Dimensione:    8.2MB (-15%)
File totali:   620 (-73)
Duplicati:     0
stato.md:      280 righe (OK!)
Reports attivi: 22 (-75%)
Naming issues: ~40% (invariato)
Health Score:  7.2/10
```

### Dopo Fase 2 (1 settimana)

```
Dimensione:    7.8MB
File totali:   580
Duplicati:     0
stato.md:      <300 righe (SEMPRE!)
Reports attivi: <25 (SEMPRE!)
Naming issues: <5%
Health Score:  8.5/10
```

### Dopo Fase 3 (2 settimane)

```
TUTTO AUTOMATICO!
- Archivio automatico
- Naming verificato pre-commit
- Anti-duplicazione automatica
- Dashboard health SNCP
Health Score:  9.2/10
```

---

## 7. RACCOMANDAZIONI FINALI

### CRITICO - Fare Subito

1. Compatta cervellaswarm/stato.md (700 → 280 righe)
2. Elimina duplicati VDA (15 → 0 file)
3. Archivia reports vecchi Miracollo (87 → 22)

**Tempo stimato:** 30 minuti
**Chi:** cervella-backend
**Quando:** OGGI (prima di fine sessione)

---

### ALTO - Pianificare Questa Settimana

1. Crea struttura attivo/ vs archivio/
2. Documenta standard naming
3. Implementa hook pre-commit naming

**Tempo stimato:** 2-3 ore (splittate in 3 sessioni)
**Chi:** cervella-ingegnera (design) + cervella-backend (exec)

---

### MEDIO - Roadmap 2 Settimane

1. Automazioni archivio
2. Dashboard health SNCP
3. Anti-duplicazione automatica

**Tempo stimato:** 4-6 ore
**Chi:** cervella-backend

---

## 8. DOMANDE PER RAFA

Prima di procedere con Fase 1 (compattazione):

1. **Sessioni vecchie cervellaswarm/stato.md:**
   Archiviare tutto < Sessione 220? O preferisci tenere piu storico?

2. **Reports Miracollo:**
   Confermi 7 giorni come soglia archivio? O preferisci 14 giorni?

3. **Duplicati VDA:**
   OK eliminare da bracci/ e tenere solo in idee/ (poi archivio)?

4. **Naming standard:**
   Il formato proposto `YYYYMMDD_{TIPO}_{descrizione}.md` va bene?

---

## Conclusione

**SNCP ha crescita sana MA senza controllo.**

Come un giardino:
- Le piante crescono (bene!)
- Ma servono potature regolari (archivio)
- Servono vialetti chiari (struttura)
- Serve nomenclatura (naming)

**Fase 1 è urgente (stato.md violazione!).**
**Fase 2-3 prevengono il problema in futuro.**

Il progetto si MIGLIORA da solo quando lo analizziamo!

---

*Analisi completata: 17 Gennaio 2026*
*Cervella Ingegnera*
*"Il codice pulito è codice che rispetta chi lo leggerà domani!"*
