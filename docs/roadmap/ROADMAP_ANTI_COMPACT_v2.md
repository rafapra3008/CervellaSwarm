# ROADMAP: Anti Auto-Compact v2.0

> **"Seamless significa: ZERO intervento umano, ZERO errori!"**

**Versione:** 1.0.0
**Data:** 5 Gennaio 2026 - Sessione 98
**Obiettivo:** Rendere l'handoff PERFETTO e AFFIDABILE!

---

## IL PROBLEMA ATTUALE

```
+------------------------------------------------------------------+
|                                                                  |
|   OGGI (v4.3.1):                                                |
|                                                                  |
|   1. Apre VS Code (OK)                                          |
|   2. sleep 4 secondi (FRAGILE - dipende dal Mac)                |
|   3. Cmd+Shift+P Command Palette (FRAGILE - timing!)            |
|   4. Digita "Terminal: Create New Terminal" (FRAGILE!)          |
|   5. sleep 2 secondi (FRAGILE)                                  |
|   6. Digita comando claude (FRAGILE - se terminal non pronto?)  |
|                                                                  |
|   RISULTATO: A volte funziona, a volte NO!                      |
|                                                                  |
|   "Keystroke fragile - dipende da timing VS Code" - Cervella    |
|                                                                  |
+------------------------------------------------------------------+
```

---

## I 4 MIGLIORAMENTI

### 1. GIT AUTO-COMMIT PRIMA DI HANDOFF

**Status:** DA FARE

**Problema:** Se la Cervella non ha committato, le modifiche sono PERSE!

**Soluzione:**
```python
# Prima di execute_handoff():
subprocess.run(["git", "add", "-A"], cwd=project_path)
subprocess.run(["git", "commit", "-m", "ANTI-COMPACT: PreCompact auto"], cwd=project_path)
subprocess.run(["git", "push"], cwd=project_path)
```

**Rischio:** Nessuno - se non ci sono modifiche, git non fa nulla.

---

### 2. PROMPT PUNTA AL FILE HANDOFF

**Status:** DA FARE

**Problema:** Il prompt attuale è generico, non dice DOVE trovare il file handoff.

**Oggi:**
```
claude "ANTI-COMPACT: Sono la nuova Cervella! Leggo COSTITUZIONE..."
```

**Dopo:**
```
claude "Leggi il file .swarm/handoff/HANDOFF_20260105_180000.md e continua!"
```

**Meglio ancora:** Aprire direttamente il file handoff in VS Code!

---

### 3. HANDOFF INCLUDE TODO E FILO DEL DISCORSO

**Status:** DA FARE

**Problema:** Il file handoff è basico, non include cosa stava facendo.

**Oggi (handoff_content):**
```
- Leggi PROMPT_RIPRESA.md
- Leggi NORD.md
- Continua!
```

**Dopo:**
```
- STAVO FACENDO: [estratto da contesto]
- TODO ATTIVI: [lista task in corso]
- ULTIMO FILE MODIFICATO: [path]
- GIT STATUS: [modifiche]
- Continua da qui!
```

---

### 4. KEYSTROKE FRAGILE - LA SFIDA PRINCIPALE!

**Status:** DA RICERCARE

**Problema:** Il sistema keystroke è inaffidabile:
- Dipende da timing VS Code (sleep 4 secondi... basta? troppo?)
- Command Palette potrebbe non rispondere
- Terminal potrebbe non aprirsi in tempo
- Il comando potrebbe essere digitato nella finestra sbagliata

**Opzioni da ricercare:**

| Opzione | Pro | Contro |
|---------|-----|--------|
| A. Terminal.app separato | Affidabile, testato | Due finestre |
| B. VS Code Task | Nativo VS Code | Richiede setup |
| C. VS Code Extension | Potrebbe automatizzare | Complessità |
| D. File .sh che apre tutto | Semplice | Ancora keystroke |
| E. Aprire solo file handoff | Zero keystroke! | Cervella deve fare manualmente |

**Opzione E - La più semplice?**
```
1. Git commit automatico
2. Crea file handoff RICCO
3. Apre VS Code sul file handoff (code --goto file.md)
4. L'utente vede il file e fa "claude" manualmente

PRO: Zero keystroke, zero timing, 100% affidabile
CONTRO: Richiede 1 azione umana (scrivere "claude")
```

**Opzione A - Fallback affidabile:**
```
1. Git commit automatico
2. Crea file handoff RICCO
3. Apre Terminal.app con: cd path && claude "Leggi handoff/HANDOFF_xxx.md"

PRO: Testato, funziona
CONTRO: Due finestre (Terminal + VS Code se serve)
```

---

## PIANO D'AZIONE

| Fase | Task | Priorità | Status |
|------|------|----------|--------|
| 1.1 | Aggiungere git auto-commit | ALTA | ✅ FATTO! |
| 1.2 | Prompt punta a file handoff specifico | ALTA | ✅ FATTO! |
| 1.3 | Handoff include TODO + filo discorso | MEDIA | ✅ FATTO! |
| 2.1 | RICERCA: Alternativa a keystroke | ALTA | ✅ FATTO! (IBRIDO) |
| 2.2 | Implementare soluzione scelta | ALTA | ✅ FATTO! |
| 3.1 | HARDTEST: 10 handoff di fila | CRITICA | DA FARE |

---

## SOLUZIONE IMPLEMENTATA: IBRIDO AFFIDABILE v5.0.0

```
+------------------------------------------------------------------+
|                                                                  |
|   context_check.py v5.0.0 - IBRIDO AFFIDABILE!                  |
|                                                                  |
|   QUANDO CONTESTO >= 70%:                                        |
|                                                                  |
|   1. Git auto-commit + push                                      |
|      → Niente modifiche perse!                                  |
|                                                                  |
|   2. Crea file handoff RICCO                                     |
|      → Git status, file modificati, info complete               |
|                                                                  |
|   3. IBRIDO: Terminal + VS Code                                  |
|      → Terminal.app con Claude (AFFIDABILE!)                    |
|      → VS Code sul progetto (per i file)                        |
|      → DUE finestre ma ENTRAMBE utili!                          |
|                                                                  |
|   4. Claude riceve prompt SPECIFICO                              |
|      → "Leggi il file .swarm/handoff/HANDOFF_xxx.md"            |
|      → Sa ESATTAMENTE cosa fare!                                 |
|                                                                  |
+------------------------------------------------------------------+
```

---

## CRITERI DI SUCCESSO

```
+------------------------------------------------------------------+
|                                                                  |
|   SEAMLESS SIGNIFICA:                                            |
|                                                                  |
|   [ ] Handoff funziona 10 volte di fila senza errori            |
|   [ ] La nuova Cervella SA cosa stava facendo                    |
|   [ ] Zero modifiche perse (git commit automatico)               |
|   [ ] Zero intervento umano (o massimo 1 click)                  |
|   [ ] Rafa dice "FUNZIONA!"                                      |
|                                                                  |
+------------------------------------------------------------------+
```

---

## DOMANDA PER RAFA

```
+------------------------------------------------------------------+
|                                                                  |
|   QUALE PREFERISCI?                                              |
|                                                                  |
|   A. Terminal.app separato (affidabile, testato)                 |
|      → Due finestre ma FUNZIONA sempre                          |
|                                                                  |
|   B. VS Code + keystroke migliorato (timing più lungo)          |
|      → Una finestra ma RISCHIO che non funzioni                 |
|                                                                  |
|   C. Aprire solo file handoff (zero keystroke)                  |
|      → Devi scrivere "claude" tu, ma 100% affidabile           |
|                                                                  |
|   D. Altro? Idee?                                                |
|                                                                  |
+------------------------------------------------------------------+
```

---

## CHANGELOG

| Data | Versione | Modifica |
|------|----------|----------|
| 5 Gen 2026 | 1.0.0 | Creazione roadmap - Sessione 98 |

---

*"Seamless significa: funziona SEMPRE, non solo quando il Mac è di buon umore!"*

Cervella & Rafa
