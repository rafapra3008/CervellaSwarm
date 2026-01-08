# TASK: Ricerca Lezioni Apprese - Sessioni 119-122

**Assegnato a:** cervella-researcher
**Priorità:** ALTA
**Creato:** 8 Gennaio 2026 - Sessione 123
**Sprint:** 1.1 - Popolare Lezioni Apprese

---

## 🎯 OBIETTIVO

Analizzare le sessioni 119-122 e identificare **15-20 lezioni candidate** per popolare il database swarm_memory.

---

## 📚 CONTESTO

**IL PROBLEMA:**
- Database swarm_memory.db ha 0 lezioni attualmente
- Lo sciame non impara dai suoi errori/successi
- Serve popolare con lezioni REALI dalle sessioni passate

**SESSIONI DA ANALIZZARE:**
- Sessione 119: SNCP nasce (brainstorming)
- Sessione 120: HARDTEST famiglia
- Sessione 121: Semplificazione sistema + Ricerche
- Sessione 122: IMPLEMENTAZIONE! (spawn-workers v3.0.0 + load_context v2.1.0)

---

## 📖 FILE DA ANALIZZARE

1. `PROMPT_RIPRESA.md` - Stato attuale + filo del discorso
2. `ROADMAP_SACRA.md` - CHANGELOG con tutte le sessioni
3. `NORD.md` - Dove siamo, cosa abbiamo completato

**Focus su:**
- Cosa ha FUNZIONATO (successi)
- Cosa NON ha funzionato (errori)
- Decisioni importanti prese
- Pattern identificati
- Problemi risolti

---

## 📋 TASK SPECIFICI

### 1. LETTURA E ANALISI
- Leggi i 3 file sopra con attenzione
- Focalizzati su sessioni 119-122
- Identifica eventi significativi

### 2. CATEGORIZZAZIONE
Organizza lezioni per categoria:
- **spawn-workers** (uso, flags, comportamento)
- **hooks** (quando attivarli, come usarli)
- **context** (gestione memoria, ottimizzazione)
- **comunicazione** (Regina-Worker, template)
- **decisioni** (scelte architetturali)
- **errori** (cosa evitare)

### 3. PRIORITIZZAZIONE
Per ogni lezione, valuta:
- **Impatto:** Quanto è importante? (ALTO/MEDIO/BASSO)
- **Frequenza:** Quanto spesso si applica? (SEMPRE/SPESSO/RARAMENTE)
- **Riutilizzabilità:** Vale per altri progetti?

---

## 📤 OUTPUT RICHIESTO

**File:** `docs/studio/RICERCA_LEZIONI_SESSIONI_119_122.md`

**Struttura:**

```markdown
# RICERCA: Lezioni Apprese - Sessioni 119-122

## OVERVIEW
- Sessioni analizzate: 119-122
- Lezioni identificate: [N]
- Categorie: [lista]

## LEZIONI CANDIDATE

### Categoria: spawn-workers

#### LEZIONE 1: [Titolo]
**Sessione:** 122
**Cosa:** [descrizione]
**Perché importante:** [motivazione]
**Impatto:** ALTO/MEDIO/BASSO
**Frequenza:** SEMPRE/SPESSO/RARAMENTE
**Tag:** spawn-workers, headless, tmux

[Ripetere per ogni lezione...]

## RACCOMANDAZIONI

Top 10-15 lezioni da inserire nel database (ordinate per priorità).

## QUERY SQL (Bozza)

Esempio query INSERT per le lezioni più importanti.
```

---

## ✅ CRITERI DI SUCCESSO

- [x] Almeno 15-20 lezioni identificate
- [x] Lezioni categorizzate chiaramente
- [x] Prioritizzazione fatta (impatto + frequenza)
- [x] Top 10-15 raccomandati
- [x] File output completo e strutturato

---

## 💡 SUGGERIMENTI

- Cerca frasi come "L'abbiamo fatto", "Problema risolto", "Scoperta"
- Attenzione a CHANGELOG in ROADMAP_SACRA (molto dettagliato!)
- Le 4 implementazioni della Sessione 122 sono MOLTO importanti
- Headless default è una decisione MAJOR da documentare

---

## ⏰ TEMPO STIMATO

1-2 ore di analisi approfondita

---

**Buon lavoro, cervella-researcher!** 🔬

*La Regina conta su di te per identificare le lezioni più preziose!*
