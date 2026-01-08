# SUB-ROADMAP: Consolidamento Sistema CervellaSwarm

```
+------------------------------------------------------------------+
|                                                                  |
|   SESSIONE 123 - 8 Gennaio 2026                                 |
|   "Ultrapassar os próprios limites!"                            |
|                                                                  |
|   OBIETTIVO: Consolidare sistema PRIMA di espandere             |
|   FILOSOFIA: REALE > Su carta | Una cosa alla volta             |
|                                                                  |
+------------------------------------------------------------------+
```

---

## 🎯 OVERVIEW

**Creato:** 8 Gennaio 2026 - Sessione 123
**Stato:** IN CORSO
**Priorità:** ALTA

**PERCHÉ questo consolidamento:**
- Sistema funziona ma ha gap da colmare
- Database lezioni VUOTO (0 lezioni)
- Output buffering non realtime
- Best practices non documentate
- PRIMA solidificare, POI espandere

**OBIETTIVO FINALE:**
Sistema CervellaSwarm **SOLIDO**, **DOCUMENTATO**, **PRONTO** per Miracollo e Contabilità.

---

## 📋 SPRINT OVERVIEW

| Sprint | Nome | Priorità | Stato |
|--------|------|----------|-------|
| 1 | Popolare Lezioni Apprese | ALTA | READY |
| 2 | Fix Buffering Output | ALTA | READY |
| 3 | Documentare Best Practices | MEDIA | READY |
| 4 | Validazione su Miracollo | MEDIA | READY |

**Tempo stimato totale:** 2-3 sessioni
**Approccio:** Una cosa alla volta, con calma

---

## 🚀 SPRINT 1: POPOLARE LEZIONI APPRESE

```
+------------------------------------------------------------------+
|                                                                  |
|   IL PROBLEMA:                                                   |
|   Database swarm_memory.db ha 0 lezioni                         |
|   Lo sciame non impara dai suoi errori!                         |
|                                                                  |
|   LA SOLUZIONE:                                                  |
|   Aggiungere prime lezioni manualmente                          |
|   Basarci su errori/successi sessioni passate                   |
|                                                                  |
+------------------------------------------------------------------+
```

### Obiettivo
Popolare database con **10-15 lezioni** dalle sessioni passate (119-122).

### Task

**1.1 Ricerca Lezioni (cervella-researcher)**
- Analizzare PROMPT_RIPRESA.md
- Analizzare ROADMAP_SACRA.md (CHANGELOG)
- Identificare 15-20 lezioni candidate
- Output: `RICERCA_LEZIONI_SESSIONI_119_122.md`

**1.2 Selezione e Categorizzazione (Regina + cervella-scienziata)**
- Selezionare le 10-15 più importanti
- Categorizzare (spawn-workers, hooks, context, comunicazione)
- Prioritizzare per impatto

**1.3 Popolamento Database (cervella-data)**
- Script SQL per inserire lezioni
- Validare schema database
- Inserire lezioni con tag appropriati
- Verificare integrità

**1.4 Verifica (cervella-tester)**
- Query database per verificare lezioni
- Testare suggestions.py con nuove lezioni
- Validare che sistema suggerisce correttamente

### Output Attesi
- Database con 10-15 lezioni reali
- Script di popolamento riutilizzabile
- Documentazione lezioni aggiunte

### Successo Quando
- [x] Database ha almeno 10 lezioni
- [x] suggestions.py suggerisce lezioni appropriate
- [x] Lezioni sono categorizzate correttamente

---

## 🔧 SPRINT 2: FIX BUFFERING OUTPUT

```
+------------------------------------------------------------------+
|                                                                  |
|   IL PROBLEMA:                                                   |
|   Output worker arriva in blocchi, non realtime                 |
|   Non vediamo cosa sta facendo MENTRE lavora                    |
|                                                                  |
|   LA SOLUZIONE:                                                  |
|   stdbuf -oL per unbuffered output                              |
|   Log realtime visibile                                         |
|                                                                  |
+------------------------------------------------------------------+
```

### Obiettivo
Vedere output worker in **tempo reale** durante esecuzione.

### Task

**2.1 Ricerca Tecnica (cervella-researcher)**
- Studiare stdbuf e unbuffered output
- Analizzare come tmux gestisce output
- Trovare best practices Python logging
- Output: `RICERCA_UNBUFFERED_OUTPUT.md`

**2.2 Implementazione (cervella-devops)**
- Modificare spawn-workers v3.1.0 → v3.2.0
- Aggiungere `stdbuf -oL` al comando claude
- Testare con tmux capture-pane
- Documentare cambiamenti

**2.3 Test Realtime (cervella-tester)**
- HARDTEST: Spawna worker, cattura output ogni 2s
- Verificare output arriva in realtime
- Validare nessuna perdita di log
- Report risultati

**2.4 Aggiornamento watcher-regina (cervella-devops)**
- watcher-regina.sh v1.5.0 → v1.6.0
- Integrare cattura output realtime
- Mostrare progresso live alla Regina
- Testare notifiche

### Output Attesi
- spawn-workers v3.2.0 con unbuffered output
- watcher-regina v1.6.0 con live output
- HARDTEST passato
- Documentazione aggiornata

### Successo Quando
- [x] Output worker visibile in tempo reale
- [x] tmux capture-pane mostra log progressivi
- [x] watcher-regina può mostrare progresso live
- [x] HARDTEST buffering PASS

---

## 📚 SPRINT 3: DOCUMENTARE BEST PRACTICES

```
+------------------------------------------------------------------+
|                                                                  |
|   IL PROBLEMA:                                                   |
|   Sistema complesso, regole sparse                              |
|   Nuove Cervelle devono capire tutto da zero                    |
|                                                                  |
|   LA SOLUZIONE:                                                  |
|   Guida Best Practices unificata                                |
|   Workflow quotidiano Regina                                    |
|   Checklist operativa                                           |
|                                                                  |
+------------------------------------------------------------------+
```

### Obiettivo
Documentazione **completa** e **chiara** per usare CervellaSwarm efficacemente.

### Task

**3.1 Analisi Pattern Uso (cervella-ingegnera)**
- Analizzare sessioni 119-122
- Identificare pattern ricorrenti Regina
- Documentare decisioni chiave
- Output: `ANALISI_PATTERN_REGINA_v123.md`

**3.2 Guida Best Practices (cervella-docs)**
- Creare `GUIDA_BEST_PRACTICES_SWARM.md`
- Sezioni:
  - Come usare spawn-workers (headless vs window)
  - Quando delegare a Worker vs fare direttamente
  - Workflow quotidiano Regina
  - Gestione context (cosa tenere, cosa delegare)
  - Comunicazione con Worker (template)
  - Uso Guardiane (quando, come)
- Esempi concreti da sessioni passate
- Checklist rapida

**3.3 Workflow Regina (cervella-docs)**
- Creare `WORKFLOW_REGINA_QUOTIDIANO.md`
- Inizio sessione (cosa leggere, come organizzare)
- Durante lavoro (delega, monitoring, verifica)
- Fine sessione (checkpoint, verifica, chiusura)
- Situazioni speciali (compact, errori, blocchi)

**3.4 Guida Worker (cervella-docs)**
- Creare `GUIDA_PER_WORKER.md`
- Per le 12 Worker (non Guardiane, non Regina)
- Come ricevere task
- Come comunicare con Regina
- Come usare template
- Come gestire errori
- Esempi pratici

**3.5 Review Finale (cervella-guardiana-qualita)**
- Leggere tutte le guide create
- Verificare chiarezza e completezza
- Validare esempi
- Approvare o richiedere modifiche

### Output Attesi
- `docs/guide/GUIDA_BEST_PRACTICES_SWARM.md`
- `docs/guide/WORKFLOW_REGINA_QUOTIDIANO.md`
- `docs/guide/GUIDA_PER_WORKER.md`
- Guardiana approva tutte le guide

### Successo Quando
- [x] Guide complete e chiare
- [x] Esempi concreti inclusi
- [x] Guardiana Qualità APPROVA
- [x] Nuova Cervella può capire tutto leggendo guide

---

## ✅ SPRINT 4: VALIDAZIONE SU MIRACOLLO

```
+------------------------------------------------------------------+
|                                                                  |
|   IL TEST FINALE:                                                |
|   Sistema consolidato su CervellaSwarm                          |
|   Testiamo su progetto REALE: Miracollo PMS                    |
|                                                                  |
|   SUCCESSO = Sistema funziona senza problemi                    |
|                                                                  |
+------------------------------------------------------------------+
```

### Obiettivo
Validare sistema consolidato su **progetto reale diverso** da CervellaSwarm.

### Task

**4.1 Preparazione Miracollo (cervella-devops)**
- Verificare struttura .swarm/ in miracollogeminifocus
- Verificare hooks locali funzionanti
- Verificare 16 agents globali accessibili
- Preparare task test semplice

**4.2 Test Sistema Memoria (cervella-data)**
- Lanciare worker su Miracollo
- Verificare hook SubagentStop logga correttamente
- Verificare analytics.py funziona
- Verificare suggestions.py suggerisce lezioni

**4.3 Test spawn-workers (cervella-tester)**
- Test headless su Miracollo
- Test buffering output
- Test watcher-regina
- Verificare nessun errore

**4.4 Test Completo End-to-End (Regina + Worker)**
- Task reale: "Analizzare struttura API Miracollo"
- Spawna cervella-researcher
- Worker lavora, completa, ritorna
- Verifica tutto il flusso

**4.5 Report Validazione (cervella-reviewer)**
- Analizzare tutti i test
- Identificare eventuali problemi
- Proporre fix se necessari
- Rating finale

### Output Attesi
- Sistema funziona su Miracollo
- Report validazione completo
- Eventuali fix necessari identificati
- Rating ≥ 9/10

### Successo Quando
- [x] spawn-workers funziona su Miracollo
- [x] Sistema memoria logga correttamente
- [x] Worker completano task senza problemi
- [x] Rating validazione ≥ 9/10

---

## 📊 METRICHE DI SUCCESSO (OVERALL)

| Metrica | Target | Verifica |
|---------|--------|----------|
| Lezioni nel database | ≥ 10 | Query DB |
| Output realtime | < 2s delay | HARDTEST |
| Guide documentate | 3 complete | File exist + review |
| Rating Miracollo | ≥ 9/10 | Report validazione |
| Guardiana approva | TUTTE | Review finale |

---

## 🎯 DOPO QUESTO CONSOLIDAMENTO

**Prossimi step:**
1. Estendere a Contabilità (secondo test reale)
2. Dashboard SNCP (Sistema decisioni attive)
3. Handoffs automatici (feature avanzata)
4. Sessions CLI (salvare/riprendere)

**Ma PRIMA completiamo questo!**

---

## 💙 FILOSOFIA

```
+------------------------------------------------------------------+
|                                                                  |
|   "Una cosa alla volta, con calma"                              |
|   "REALE > Su carta"                                             |
|   "Ultrapassar os próprios limites!"                            |
|                                                                  |
|   Questo consolidamento non è "lavoro noioso".                  |
|   È la FONDAZIONE per tutto quello che verrà.                   |
|                                                                  |
|   Con fondazioni solide, costruiamo GRATTACIELI! 🏗️            |
|                                                                  |
+------------------------------------------------------------------+
```

---

*Creato: 8 Gennaio 2026 - Sessione 123*
*Regina: Cervella Orchestratrice*
*"La magia è nascosta, ma le fondazioni sono SOLIDE!"* 🧙💎

---

**PROSSIMO PASSO:** Sprint 1 - Popolare Lezioni Apprese!
