-- ============================================================================
-- POPOLAMENTO DATABASE - 15 Lezioni Apprese (Sessioni 119-122)
-- ============================================================================
-- Creato: 8 Gennaio 2026 - Sessione 123
-- Agent: cervella-data
-- Database: swarm_memory.db
--
-- NOTA: Query adattate allo schema esistente della tabella lessons_learned
-- Mappatura campi:
--   title → pattern (descrizione breve)
--   description → solution (descrizione completa)
--   category → category (già esistente)
--   impact → severity (HIGH, MEDIUM, LOW)
--   tags → tags (già esistente)
--   session_id → context (descrizione sessione)
--   project_id → project (già esistente)
--   created_at → created_at (già esistente)
-- ============================================================================

-- Inizia transazione per rollback in caso di errore
BEGIN TRANSACTION;

-- ============================================================================
-- CATEGORIA: spawn-workers (3 lezioni)
-- ============================================================================

-- Lezione 1: Headless di Default
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_001',
    'Headless di Default - La Magia Nascosta',
    'spawn-workers v3.1.0 ha reso --headless il comportamento DEFAULT. Zero finestre Terminal = workflow pulito. Default intelligente: headless è il 90% dei casi d''uso. Se serve finestra: spawn-workers --window --backend',
    'spawn-workers',
    'HIGH',
    'spawn-workers,headless,tmux,ux,v3.1.0,default',
    'Sessione 122 - Implementazione headless come default',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 2: tmux invece Terminal.app
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_002',
    'tmux invece di Terminal.app',
    'spawn-workers v3.0.0 usa tmux per --headless: zero finestre visibili, output catturabile (tmux capture-pane), sessioni gestibili (tmux list-sessions), cleanup automatico. Comandi: tmux list-sessions | grep swarm; tmux capture-pane -t swarm_backend_* -p -S -',
    'spawn-workers',
    'HIGH',
    'spawn-workers,tmux,headless,background,v3.0.0',
    'Sessione 122 - Introduzione tmux per worker headless',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 3: Worker Background Senza GUI
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_003',
    'Worker in Background Senza GUI Issues',
    'tmux permette worker in background SENZA problemi GUI access su macOS. I background processes su macOS NON hanno GUI access. Terminal.app + osascript risolve (Sessione 86), ma tmux è meglio: detached, niente GUI necessaria.',
    'spawn-workers',
    'MEDIUM',
    'spawn-workers,macos,background,gui-access',
    'Sessione 122 - Soluzione problemi GUI access macOS',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- ============================================================================
-- CATEGORIA: context (3 lezioni)
-- ============================================================================

-- Lezione 4: Context Overhead Misurabile
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_004',
    'Context Overhead Misurabile e Riducibile',
    'Ogni sessione partiva con 19% context usato. load_context.py v2.1.0: Eventi 20→5 (-75%), Char task 100→50 (-50%), Agent stats tutti→top5 (-58%), Lezioni 10→3 (-70%). Risparmio totale: 37-59% token. Context è prezioso: misurare prima di ottimizzare.',
    'context',
    'HIGH',
    'context,optimization,load_context,memory',
    'Sessione 122 - Ottimizzazione load_context.py',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 5: Carica Solo Ciò Che Serve
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_005',
    'Carica SOLO Ciò Che Serve ORA',
    'Non serve caricare TUTTA la storia. Solo ultimi 5 eventi, top 5 agent stats, 3 lezioni più rilevanti. Context è limitato (200K tokens). Storia completa non serve per lavorare ORA. Principio: Carica solo il necessario → Context al 6-12% invece del 19%.',
    'context',
    'HIGH',
    'context,memory,optimization,relevance',
    'Sessione 122 - Principio rilevanza vs completezza',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 6: Eventi Recenti > Storia
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_006',
    'Eventi Recenti > Storia Completa',
    'Ridotti eventi da 20 a 5 = -75% token, ma ZERO perdita efficacia. Eventi vecchi raramente influenzano task corrente. Ultimi 5 eventi danno contesto sufficiente. Se serve storia completa, consultare database.',
    'context',
    'MEDIUM',
    'context,events,memory,recency-bias',
    'Sessione 122 - Recency bias in memoria',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- ============================================================================
-- CATEGORIA: comunicazione (3 lezioni)
-- ============================================================================

-- Lezione 7: Comunicazione = Filesystem
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_007',
    'Comunicazione Multi-Finestra = Filesystem',
    'Worker e Regina comunicano via FILESYSTEM (.swarm/tasks/, .swarm/status/, git). Filesystem è la VERITÀ (git status non mente mai). Zero dipendenza da contesto condiviso. Pattern: Regina → crea task → Worker legge → Worker scrive output → Regina legge.',
    'comunicazione',
    'HIGH',
    'comunicazione,multi-finestra,filesystem,git',
    'Sessione 122 - Pattern comunicazione sciame',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 8: Output Buffering Blocca Log
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_008',
    'Output Buffering Blocca Log Realtime',
    'Output worker è bufferizzato → NON vediamo cosa fanno in tempo reale. Impossibile vedere progresso mentre lavora. Soluzione proposta: stdbuf -oL -eL comando. STATO: DA FARE (Priorità Alta).',
    'comunicazione',
    'MEDIUM',
    'comunicazione,buffering,logging,realtime',
    'Sessione 122 - Problema output buffering',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 9: Log File Separati
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_009',
    'Log File Separati per Worker',
    'spawn-workers v3.0.0 crea log in .swarm/logs/ per ogni worker. Ogni worker ha log isolato, facile debugging, log persistono dopo chiusura finestra. Path: .swarm/logs/swarm_WORKER_TIMESTAMP.log',
    'comunicazione',
    'MEDIUM',
    'comunicazione,logging,debugging',
    'Sessione 122 - Sistema logging migliorato',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- ============================================================================
-- CATEGORIA: decisioni (3 lezioni)
-- ============================================================================

-- Lezione 10: Headless Default = MAJOR
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_010',
    'Headless Default è Decisione MAJOR',
    'Passare da "opt-in headless" a "headless di default" è cambio paradigma UX. Cambia esperienza radicalmente. Default intelligente: 90% casi è headless. Richiede doc chiara (--window per finestre). v3.0.0: --headless opt-in → v3.1.0: headless DEFAULT. "La magia ora è nascosta!" - Rafa',
    'decisioni',
    'HIGH',
    'decisioni,ux,defaults,breaking-change',
    'Sessione 122 - Breaking change v3.1.0',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 11: Ottimizzazioni Aggressive OK
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_011',
    'Ottimizzazioni Aggressive Sicure Se Misurate',
    'Tagliare eventi da 20 a 5 (-75%) sembrava rischioso, ma test provano zero impatto negativo. Non aver paura di ottimizzare. Principio: MISURA prima e dopo. Se i test passano, ottimizzazione è sicura. Pattern: Misura → Ottimizza → Testa → Se passa, committa.',
    'decisioni',
    'MEDIUM',
    'decisioni,optimization,testing,measurement',
    'Sessione 122 - Filosofia ottimizzazione',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 12: La Magia Nascosta
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_012',
    'La Magia Ora è Nascosta',
    'Quote Rafa dopo v3.1.0. Filosofia UX: semplicità in superficie, complessità nascosta. Worker lavorano in background = magia invisibile. Utente vede solo risultati, non il processo. Principio design fondamentale.',
    'decisioni',
    'HIGH',
    'decisioni,ux,filosofia,user-experience',
    'Sessione 122 - Filosofia UX del sistema',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- ============================================================================
-- CATEGORIA: workflow (3 lezioni)
-- ============================================================================

-- Lezione 13: Ricerca → Implementazione
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_013',
    'Ricerca → Implementazione (Pattern 121-122)',
    'Sessione 121 = ricerca (tmux, OpenAI Swarm, context). Sessione 122 = implementazione completa (4 impl). Prima STUDIO, poi IMPLEMENTO. Ricerca approfondita = implementazione veloce e solida. Pattern ripetibile per feature complesse.',
    'workflow',
    'HIGH',
    'workflow,ricerca,implementazione,pattern',
    'Sessione 121+122 - Pattern ricerca-implementazione',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 14: Test Subito Dopo
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_014',
    'Test Subito Dopo Implementazione',
    'Ogni impl (spawn v3.0, load_context v2.1) testata SUBITO. Catch bug PRIMA che propaghino. Feedback immediato (funziona o no?). Confidence per iterare velocemente. Pattern: 1.Implementa 2.Testa 3.Se passa→Committa 4.Se fallisce→Fix e ritesta.',
    'workflow',
    'HIGH',
    'workflow,testing,quality,feedback-loop',
    'Sessione 122 - Workflow test-driven',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Lezione 15: Documentation WHILE Coding
INSERT INTO lessons_learned (
    id,
    pattern,
    solution,
    category,
    severity,
    tags,
    context,
    project,
    timestamp,
    created_at
) VALUES (
    'LESSON_123_015',
    'Documentation WHILE Coding Not After',
    'PROMPT_RIPRESA.md aggiornato DURANTE sessione 122, non dopo. Documentazione fresca = dettagli accurati. Se documenti dopo, dimentichi dettagli cruciali. Documentazione è parte workflow, non "extra". Pattern: Implementa → Testa → Documenta → Committa (tutto insieme).',
    'workflow',
    'HIGH',
    'workflow,documentation,best-practices',
    'Sessione 122 - Documentazione continua',
    'cervellaswarm',
    datetime('now'),
    datetime('now')
);

-- Commit transazione
COMMIT;

-- ============================================================================
-- FINE POPOLAMENTO
-- ============================================================================
-- Totale lezioni inserite: 15
-- Breakdown categorie:
--   - spawn-workers: 3 lezioni
--   - context: 3 lezioni
--   - comunicazione: 3 lezioni
--   - decisioni: 3 lezioni
--   - workflow: 3 lezioni
--
-- Breakdown severity:
--   - HIGH: 10 lezioni
--   - MEDIUM: 5 lezioni
--   - LOW: 0 lezioni
-- ============================================================================
