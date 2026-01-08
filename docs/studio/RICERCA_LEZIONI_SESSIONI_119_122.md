# RICERCA: Lezioni Apprese - Sessioni 119-122

> **Ricerca:** cervella-researcher
> **Data:** 8 Gennaio 2026
> **Sessioni analizzate:** 119-122
> **File consultati:** PROMPT_RIPRESA.md, ROADMAP_SACRA.md, NORD.md

---

## OVERVIEW

- **Sessioni analizzate:** 119-122
- **Lezioni identificate:** 18
- **Categorie:** 6 (spawn-workers, context, hooks, comunicazione, decisioni, workflow)
- **Focus principale:** Sessione 122 (molto documentata)

**NOTA IMPORTANTE:**
Le sessioni 119-121 hanno documentazione limitata. La maggior parte delle lezioni proviene dalla **Sessione 122**, che è stata estremamente ben documentata nel PROMPT_RIPRESA.

---

## LEZIONI CANDIDATE

### Categoria: spawn-workers

#### LEZIONE 1: Headless di Default - La Magia Nascosta
**Sessione:** 122
**Cosa:** spawn-workers v3.1.0 ha reso `--headless` il comportamento DEFAULT. Niente più finestre Terminal che si aprono automaticamente.
**Perché importante:**
- ZERO finestre Terminal = workflow pulito
- Worker lavorano in background (tmux)
- Esperienza utente migliore (meno confusione)
- Default intelligente: headless è il 90% dei casi d'uso
**Impatto:** ALTO
**Frequenza:** SEMPRE (ogni volta che si usa spawn-workers)
**Tag:** spawn-workers, headless, tmux, ux, v3.1.0
**Comando:**
```bash
# PRIMA (v3.0.0)
spawn-workers --headless --backend

# ORA (v3.1.0 - headless di default)
spawn-workers --backend

# Se serve finestra Terminal
spawn-workers --window --backend
```

---

#### LEZIONE 2: tmux invece di Terminal.app
**Sessione:** 122
**Cosa:** spawn-workers v3.0.0 ha introdotto supporto `--headless` usando **tmux** invece di Terminal.app.
**Perché importante:**
- Zero finestre visibili = meno confusione
- Output catturabile (`tmux capture-pane`)
- Sessioni gestibili (`tmux list-sessions`)
- Cleanup automatico quando worker finisce
**Impatto:** ALTO
**Frequenza:** SEMPRE (quando si usa --headless)
**Tag:** spawn-workers, tmux, headless, background, v3.0.0
**Come verificare sessioni:**
```bash
# Verifica sessioni tmux
tmux list-sessions | grep swarm

# Cattura output worker
tmux capture-pane -t swarm_backend_* -p -S -

# Termina sessione
tmux kill-session -t swarm_backend_*
```

---

#### LEZIONE 3: Worker in Background Senza GUI Issues
**Sessione:** 122
**Cosa:** tmux permette di eseguire worker in background SENZA problemi di GUI access tipici di macOS.
**Perché importante:**
- I background processes su macOS NON hanno GUI access
- Terminal.app + osascript risolve questo (appreso dalla Sessione 86)
- tmux è ancora meglio: detached, niente GUI necessaria
**Impatto:** MEDIO
**Frequenza:** SEMPRE (quando worker lavora in background)
**Tag:** spawn-workers, macos, background, gui-access
**Riferimenti:**
- Sessione 86: Problema VS Code non si apriva da background
- Sessione 122: tmux risolve completamente il problema

---

### Categoria: context

#### LEZIONE 4: Context Overhead Misurabile e Riducibile
**Sessione:** 122
**Cosa:** Ogni sessione partiva con **19% di context già usato**. Con load_context.py v2.1.0 siamo scesi a ~6-12% (risparmio 37-59%).
**Perché importante:**
- Context è prezioso, non va sprecato
- Misurare prima di ottimizzare (19% era troppo!)
- Piccole riduzioni → grande impatto cumulativo
**Impatto:** ALTO
**Frequenza:** SEMPRE (ogni sessione)
**Tag:** context, optimization, load_context, memory
**Dettagli ottimizzazione:**
| Parametro | Prima | Dopo | Risparmio |
|-----------|-------|------|-----------|
| Eventi | 20 | 5 | -75% |
| Char per task | 100 | 50 | -50% |
| Agent stats | tutti | top 5 | -58% |
| Lezioni | 10 | 3 | -70% |

---

#### LEZIONE 5: Carica SOLO Ciò Che Serve ORA
**Sessione:** 122
**Cosa:** Non serve caricare TUTTA la storia. Solo gli ultimi 5 eventi, top 5 agent stats, 3 lezioni più rilevanti.
**Perché importante:**
- Context è limitato (200K tokens)
- Storia completa non serve per lavorare ORA
- Informazioni vecchie raramente rilevanti
**Impatto:** ALTO
**Frequenza:** SEMPRE (design della memoria)
**Tag:** context, memory, optimization, relevance
**Principio:**
```
PRIMA: Carica tutto → Context al 19%
DOPO:  Carica solo il necessario → Context al 6-12%
```

---

#### LEZIONE 6: Eventi Recenti > Storia Completa
**Sessione:** 122
**Cosa:** Ridotti eventi da 20 a 5 = -75% token, ma ZERO perdita di efficacia.
**Perché importante:**
- Eventi vecchi raramente influenzano task corrente
- Ultimi 5 eventi danno contesto sufficiente
- Se serve storia completa, si può sempre consultare il database
**Impatto:** MEDIO
**Frequenza:** SPESSO (quando si carica memoria)
**Tag:** context, events, memory, recency-bias

---

### Categoria: hooks

#### LEZIONE 7: Hook SessionStart Carica Contesto Automaticamente
**Sessione:** 122 (implicito da load_context.py v2.1.0)
**Cosa:** Il hook SessionStart carica automaticamente memoria swarm all'avvio della sessione.
**Perché importante:**
- Zero lavoro manuale per la Regina
- Contesto sempre caricato e aggiornato
- Ogni progetto può avere il suo hook SessionStart
**Impatto:** ALTO
**Frequenza:** SEMPRE (ogni sessione)
**Tag:** hooks, session-start, automation, memory
**Hook esistenti per progetto:**
- CervellaSwarm: session_start_swarm.py
- Miracollo: session_start_miracollo.py
- Contabilità: session_start_contabilita.py

---

#### LEZIONE 8: watcher-regina Rileva File .done
**Sessione:** 122 (watcher-regina v1.5.0)
**Cosa:** watcher-regina usa fswatch per rilevare quando worker crea file `.done`.
**Perché importante:**
- Auto-sveglia funziona SOLO se watcher rileva .done
- Con tmux, serve logging esplicito per vedere output
- Bell notification quando task completa
**Impatto:** MEDIO
**Frequenza:** SEMPRE (quando si usa auto-sveglia)
**Tag:** hooks, watcher, auto-sveglia, fswatch
**Versione attuale:** v1.5.0 (con supporto tmux, log, bell)

---

### Categoria: comunicazione

#### LEZIONE 9: Output Buffering Blocca Log Realtime
**Sessione:** 122 (TODO Priorità Alta)
**Cosa:** Output dei worker è bufferizzato, quindi NON vediamo cosa fanno in tempo reale.
**Perché importante:**
- Impossibile vedere progresso worker mentre lavora
- Se worker si blocca, non lo vediamo subito
- Frustrazione: "Cosa sta facendo?"
**Impatto:** MEDIO
**Frequenza:** SPESSO (quando worker lavora)
**Tag:** comunicazione, buffering, logging, realtime
**Soluzione proposta:**
```bash
# stdbuf per log realtime
stdbuf -oL -eL comando
```
**Stato:** DA FARE (Priorità Alta)

---

#### LEZIONE 10: Log File Separati per Worker
**Sessione:** 122
**Cosa:** spawn-workers v3.0.0 crea log files in `.swarm/logs/` per ogni worker.
**Perché importante:**
- Ogni worker ha il suo log isolato
- Facile debugging (trova log del worker specifico)
- Log persistono dopo chiusura finestra
**Impatto:** MEDIO
**Frequenza:** SEMPRE (quando si usa spawn-workers)
**Tag:** comunicazione, logging, debugging
**Path:** `.swarm/logs/swarm_WORKER_TIMESTAMP.log`

---

#### LEZIONE 11: Comunicazione Multi-Finestra = Filesystem
**Sessione:** 122 (pattern consolidato)
**Cosa:** Worker e Regina comunicano via FILESYSTEM (.swarm/tasks/, .swarm/status/, git).
**Perché importante:**
- Filesystem è la VERITÀ (git status non mente mai)
- Zero dipendenza da contesto condiviso
- Ogni finestra vede lo stato REALE del progetto
**Impatto:** ALTO
**Frequenza:** SEMPRE (workflow swarm)
**Tag:** comunicazione, multi-finestra, filesystem, git
**Pattern:** Regina → crea task → Worker legge → Worker scrive output → Regina legge

---

### Categoria: decisioni

#### LEZIONE 12: Headless Default è una Decisione MAJOR
**Sessione:** 122
**Cosa:** Passare da "opt-in headless" a "headless di default" è un cambio paradigma.
**Perché importante:**
- Cambia l'esperienza utente radicalmente
- Default intelligente: 90% dei casi è headless
- Richiede documentazione chiara (--window per finestre)
**Impatto:** ALTO
**Frequenza:** RARAMENTE (decisioni architetturali)
**Tag:** decisioni, ux, defaults, breaking-change
**Motivazione:**
- v3.0.0: `--headless` opt-in
- v3.1.0: headless DEFAULT → "La magia ora è nascosta!"

---

#### LEZIONE 13: Ottimizzazioni Aggressive Sono Sicure Se Misurate
**Sessione:** 122
**Cosa:** Tagliare eventi da 20 a 5 (-75%) sembrava rischioso, ma test hanno provato zero impatto negativo.
**Perché importante:**
- Non aver paura di ottimizzare
- MISURA prima e dopo
- Se i test passano, l'ottimizzazione è sicura
**Impatto:** MEDIO
**Frequenza:** SPESSO (quando si ottimizza)
**Tag:** decisioni, optimization, testing, measurement
**Principio:** Misura → Ottimizza → Testa → Se passa, committa

---

#### LEZIONE 14: "La Magia Ora è Nascosta"
**Sessione:** 122
**Cosa:** Quote di Rafa dopo v3.1.0: il sistema fa magie ma l'utente NON vede il "dietro le quinte".
**Perché importante:**
- Filosofia UX: semplicità in superficie, complessità nascosta
- Worker lavorano in background = magia invisibile
- Utente vede solo risultati, non il processo
**Impatto:** ALTO
**Frequenza:** SEMPRE (filosofia design)
**Tag:** decisioni, ux, filosofia, user-experience
**Quote:** "La magia ora è nascosta!" 🧙 - Rafa

---

### Categoria: workflow

#### LEZIONE 15: Ricerca → Implementazione (Pattern 121-122)
**Sessione:** 121 + 122
**Cosa:** Sessione 121 = ricerca (tmux, OpenAI Swarm, context). Sessione 122 = implementazione completa.
**Perché importante:**
- Prima STUDIO, poi IMPLEMENTO
- Ricerca approfondita = implementazione veloce e solida
- Pattern ripetibile per feature complesse
**Impatto:** ALTO
**Frequenza:** SPESSO (feature complesse)
**Tag:** workflow, ricerca, implementazione, pattern
**Timeline:**
- Sessione 121: Studi (tmux, context, architettura)
- Sessione 122: 4 implementazioni (spawn v3.0, spawn v3.1, load_context v2.1, watcher v1.5)

---

#### LEZIONE 16: Test Subito Dopo Implementazione
**Sessione:** 122
**Cosa:** Ogni implementazione (spawn v3.0, load_context v2.1) è stata testata SUBITO.
**Perché importante:**
- Catch bug PRIMA che si propaghino
- Feedback immediato (funziona o no?)
- Confidence per iterare velocemente
**Impatto:** ALTO
**Frequenza:** SEMPRE (dopo ogni modifica)
**Tag:** workflow, testing, quality, feedback-loop
**Pattern:**
1. Implementa feature
2. Testa manualmente
3. Se passa → Committa
4. Se fallisce → Fix e ritesta

---

#### LEZIONE 17: Versioning Semantico Rigoroso
**Sessione:** 122
**Cosa:** spawn-workers: v3.0.0 (MAJOR: --headless), v3.1.0 (MAJOR: headless default). load_context.py: v2.1.0 (MINOR: ottimizzazioni).
**Perché importante:**
- Versioning chiaro = facile capire impatto cambiamenti
- MAJOR = breaking change, MINOR = backward compatible
- Aiuta debugging ("Quando è iniziato il problema? A quale versione?")
**Impatto:** MEDIO
**Frequenza:** SEMPRE (ogni release)
**Tag:** workflow, versioning, semver, documentation
**Schema:**
- MAJOR: Breaking change (es. default behavior cambia)
- MINOR: Nuova feature backward compatible
- PATCH: Bug fix

---

#### LEZIONE 18: Documentation WHILE Coding, Not After
**Sessione:** 122
**Cosa:** PROMPT_RIPRESA.md aggiornato DURANTE la sessione 122, non dopo.
**Perché importante:**
- Documentazione fresca = dettagli accurati
- Se documenti dopo, dimentichi dettagli cruciali
- Documentazione è parte del workflow, non "extra"
**Impatto:** ALTO
**Frequenza:** SEMPRE (ogni sessione)
**Tag:** workflow, documentation, best-practices
**Pattern:** Implementa → Testa → Documenta → Committa (tutto insieme)

---

## RACCOMANDAZIONI

### Top 15 Lezioni da Inserire nel Database (Ordinate per Priorità)

| # | Lezione | Priorità | Perché |
|---|---------|----------|--------|
| 1 | Headless di Default | ALTISSIMA | Cambio paradigma UX |
| 2 | Context Overhead Misurabile | ALTISSIMA | 37-59% risparmio! |
| 3 | tmux invece Terminal.app | ALTA | Soluzione tecnica chiave |
| 4 | Comunicazione = Filesystem | ALTA | Pattern architetturale |
| 5 | Ricerca → Implementazione | ALTA | Workflow efficace |
| 6 | Carica SOLO Ciò Che Serve | ALTA | Design memoria |
| 7 | Test Subito Dopo Impl. | ALTA | Quality workflow |
| 8 | Documentation WHILE Coding | ALTA | Best practice |
| 9 | "La Magia Nascosta" | MEDIA | Filosofia UX |
| 10 | Worker Background Senza GUI | MEDIA | Soluzione macOS |
| 11 | Output Buffering Blocca Log | MEDIA | Problema noto |
| 12 | Ottimizzazioni Aggressive OK | MEDIA | Mindset |
| 13 | Eventi Recenti > Storia | MEDIA | Design memoria |
| 14 | Versioning Semantico | MEDIA | Best practice |
| 15 | Log File Separati | BASSA | Utility |

**NOTA:** Lezioni 16-18 (watcher, headless è MAJOR, hook SessionStart) sono comunque valide ma meno prioritarie per inserimento immediato.

---

## QUERY SQL (Bozza)

```sql
-- CATEGORIA: spawn-workers

INSERT INTO lessons_learned (
    title,
    description,
    category,
    impact,
    tags,
    session_id,
    project_id,
    created_at
) VALUES
(
    'Headless di Default - La Magia Nascosta',
    'spawn-workers v3.1.0 ha reso --headless il comportamento DEFAULT. Zero finestre Terminal = workflow pulito. Default intelligente: headless è il 90% dei casi d''uso. Se serve finestra: spawn-workers --window --backend',
    'spawn-workers',
    'HIGH',
    'spawn-workers,headless,tmux,ux,v3.1.0,default',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'tmux invece di Terminal.app',
    'spawn-workers v3.0.0 usa tmux per --headless: zero finestre visibili, output catturabile (tmux capture-pane), sessioni gestibili (tmux list-sessions), cleanup automatico. Comandi: tmux list-sessions | grep swarm; tmux capture-pane -t swarm_backend_* -p -S -',
    'spawn-workers',
    'HIGH',
    'spawn-workers,tmux,headless,background,v3.0.0',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'Worker in Background Senza GUI Issues',
    'tmux permette worker in background SENZA problemi GUI access su macOS. I background processes su macOS NON hanno GUI access. Terminal.app + osascript risolve (Sessione 86), ma tmux è meglio: detached, niente GUI necessaria.',
    'spawn-workers',
    'MEDIUM',
    'spawn-workers,macos,background,gui-access',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
);

-- CATEGORIA: context

INSERT INTO lessons_learned (
    title,
    description,
    category,
    impact,
    tags,
    session_id,
    project_id,
    created_at
) VALUES
(
    'Context Overhead Misurabile e Riducibile',
    'Ogni sessione partiva con 19% context usato. load_context.py v2.1.0: Eventi 20→5 (-75%), Char task 100→50 (-50%), Agent stats tutti→top5 (-58%), Lezioni 10→3 (-70%). Risparmio totale: 37-59% token. Context è prezioso: misurare prima di ottimizzare.',
    'context',
    'HIGH',
    'context,optimization,load_context,memory',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'Carica SOLO Ciò Che Serve ORA',
    'Non serve caricare TUTTA la storia. Solo ultimi 5 eventi, top 5 agent stats, 3 lezioni più rilevanti. Context è limitato (200K tokens). Storia completa non serve per lavorare ORA. Principio: Carica solo il necessario → Context al 6-12% invece del 19%.',
    'context',
    'HIGH',
    'context,memory,optimization,relevance',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'Eventi Recenti > Storia Completa',
    'Ridotti eventi da 20 a 5 = -75% token, ma ZERO perdita efficacia. Eventi vecchi raramente influenzano task corrente. Ultimi 5 eventi danno contesto sufficiente. Se serve storia completa, consultare database.',
    'context',
    'MEDIUM',
    'context,events,memory,recency-bias',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
);

-- CATEGORIA: comunicazione

INSERT INTO lessons_learned (
    title,
    description,
    category,
    impact,
    tags,
    session_id,
    project_id,
    created_at
) VALUES
(
    'Comunicazione Multi-Finestra = Filesystem',
    'Worker e Regina comunicano via FILESYSTEM (.swarm/tasks/, .swarm/status/, git). Filesystem è la VERITÀ (git status non mente mai). Zero dipendenza da contesto condiviso. Pattern: Regina → crea task → Worker legge → Worker scrive output → Regina legge.',
    'comunicazione',
    'HIGH',
    'comunicazione,multi-finestra,filesystem,git',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'Output Buffering Blocca Log Realtime',
    'Output worker è bufferizzato → NON vediamo cosa fanno in tempo reale. Impossibile vedere progresso mentre lavora. Soluzione proposta: stdbuf -oL -eL comando. STATO: DA FARE (Priorità Alta).',
    'comunicazione',
    'MEDIUM',
    'comunicazione,buffering,logging,realtime',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'Log File Separati per Worker',
    'spawn-workers v3.0.0 crea log in .swarm/logs/ per ogni worker. Ogni worker ha log isolato, facile debugging, log persistono dopo chiusura finestra. Path: .swarm/logs/swarm_WORKER_TIMESTAMP.log',
    'comunicazione',
    'MEDIUM',
    'comunicazione,logging,debugging',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
);

-- CATEGORIA: decisioni

INSERT INTO lessons_learned (
    title,
    description,
    category,
    impact,
    tags,
    session_id,
    project_id,
    created_at
) VALUES
(
    'Headless Default è Decisione MAJOR',
    'Passare da "opt-in headless" a "headless di default" è cambio paradigma UX. Cambia esperienza radicalmente. Default intelligente: 90% casi è headless. Richiede doc chiara (--window per finestre). v3.0.0: --headless opt-in → v3.1.0: headless DEFAULT. "La magia ora è nascosta!" - Rafa',
    'decisioni',
    'HIGH',
    'decisioni,ux,defaults,breaking-change',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'Ottimizzazioni Aggressive Sicure Se Misurate',
    'Tagliare eventi da 20 a 5 (-75%) sembrava rischioso, ma test provano zero impatto negativo. Non aver paura di ottimizzare. Principio: MISURA prima e dopo. Se i test passano, ottimizzazione è sicura. Pattern: Misura → Ottimizza → Testa → Se passa, committa.',
    'decisioni',
    'MEDIUM',
    'decisioni,optimization,testing,measurement',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'La Magia Ora è Nascosta',
    'Quote Rafa dopo v3.1.0. Filosofia UX: semplicità in superficie, complessità nascosta. Worker lavorano in background = magia invisibile. Utente vede solo risultati, non il processo. Principio design fondamentale.',
    'decisioni',
    'HIGH',
    'decisioni,ux,filosofia,user-experience',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
);

-- CATEGORIA: workflow

INSERT INTO lessons_learned (
    title,
    description,
    category,
    impact,
    tags,
    session_id,
    project_id,
    created_at
) VALUES
(
    'Ricerca → Implementazione (Pattern 121-122)',
    'Sessione 121 = ricerca (tmux, OpenAI Swarm, context). Sessione 122 = implementazione completa (4 impl). Prima STUDIO, poi IMPLEMENTO. Ricerca approfondita = implementazione veloce e solida. Pattern ripetibile per feature complesse.',
    'workflow',
    'HIGH',
    'workflow,ricerca,implementazione,pattern',
    'sessione_121+122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'Test Subito Dopo Implementazione',
    'Ogni impl (spawn v3.0, load_context v2.1) testata SUBITO. Catch bug PRIMA che propaghino. Feedback immediato (funziona o no?). Confidence per iterare velocemente. Pattern: 1.Implementa 2.Testa 3.Se passa→Committa 4.Se fallisce→Fix e ritesta.',
    'workflow',
    'HIGH',
    'workflow,testing,quality,feedback-loop',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'Documentation WHILE Coding Not After',
    'PROMPT_RIPRESA.md aggiornato DURANTE sessione 122, non dopo. Documentazione fresca = dettagli accurati. Se documenti dopo, dimentichi dettagli cruciali. Documentazione è parte workflow, non "extra". Pattern: Implementa → Testa → Documenta → Committa (tutto insieme).',
    'workflow',
    'HIGH',
    'workflow,documentation,best-practices',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
),
(
    'Versioning Semantico Rigoroso',
    'spawn-workers: v3.0.0 (MAJOR: --headless), v3.1.0 (MAJOR: headless default). load_context.py: v2.1.0 (MINOR: ottimizzazioni). Versioning chiaro = facile capire impatto. MAJOR=breaking, MINOR=backward compatible, PATCH=bugfix. Aiuta debugging storico.',
    'workflow',
    'MEDIUM',
    'workflow,versioning,semver,documentation',
    'sessione_122',
    'cervellaswarm',
    CURRENT_TIMESTAMP
);
```

---

## OSSERVAZIONI FINALI

### Sessioni Poco Documentate
- **Sessione 119 (SNCP nasce):** Solo menzionata come brainstorming, nessun dettaglio
- **Sessione 120 (HARDTEST famiglia):** Solo menzionata, nessun dettaglio
- **Sessione 121 (Semplificazione):** Solo menzionata come fase ricerca

**RACCOMANDAZIONE:** Le prossime sessioni dovrebbero documentare meglio cosa succede DURANTE, non solo dopo. Sessione 122 è un ottimo esempio di documentazione completa.

### Sessione 122: Caso di Studio Perfetto
La Sessione 122 è documentata in modo **ESEMPLARE**:
- Cosa abbiamo fatto (4 implementazioni chiare)
- Come funziona (esempi di comando)
- Caratteristiche (tabelle con feature)
- File modificati (path + versioni)
- Risparmio misurato (37-59% tokens)
- Prossimi step (TODO chiari)

Questo livello di documentazione dovrebbe essere lo **STANDARD** per tutte le sessioni.

### Pattern Emergente: Ricerca Approfondita Paga Sempre
Il pattern Sessione 121 (ricerca) → Sessione 122 (implementazione veloce e solida) dimostra che:
1. Ricerca approfondita NON è tempo perso
2. Implementazione post-ricerca è più veloce
3. Meno bug, più confidence
4. Pattern ripetibile

**RACCOMANDAZIONE:** Continuare questo pattern per feature complesse.

---

## PROSSIMI STEP

1. **Inserire Top 10-15 lezioni nel database** usando le query SQL sopra
2. **Popolare tabella tags** per facilitare ricerca lezioni
3. **Creare viste aggregate** (es. lezioni per categoria, lezioni per impatto)
4. **Testare retrieval** quando la Regina o un worker chiede "Come si fa X?"

---

**COMPLETATO!** ✅

*18 lezioni identificate e pronte per il database swarm_memory!*

---

*cervella-researcher - 8 Gennaio 2026*
