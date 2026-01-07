# Task: FASE 3 - Creare Templates Operativi

**Assegnato a:** cervella-docs
**Stato:** ready
**Priorità:** ALTA
**Progetto:** CervellaSwarm
**Sub-Roadmap:** SUB_ROADMAP_COMUNICAZIONE_INTERNA.md

---

## CONTESTO

Stiamo implementando i nuovi protocolli di comunicazione per le 16 api!

**FASE 1:** ✅ Studio completato (cervella-researcher - 1,385 righe)
**FASE 2:** ✅ Protocolli definiti (Regina - 736 righe)
**FASE 3:** ⏳ Templates operativi (TU!)

**File protocolli:** `docs/protocolli/PROTOCOLLI_COMUNICAZIONE.md`

Leggi TUTTO il documento protocolli prima di iniziare!

---

## OBIETTIVO

Creare i template pratici che Regina e Worker useranno ogni giorno.

**Output:** 4 template pronti in `.swarm/templates/`

---

## I 4 TEMPLATE DA CREARE

### 1. TEMPLATE_HANDOFF.md

**Path:** `.swarm/templates/TEMPLATE_HANDOFF.md`

**Cosa:** Template che Regina usa per creare task

**Basato su:** Sezione 1.2 del documento protocolli

**Deve includere:**
- Frontmatter YAML completo (tutti i campi)
- Tutte le sezioni del protocollo
- Placeholder chiari (es: [NOME_TASK], [DESCRIZIONE], etc.)
- Commenti inline che spiegano cosa mettere in ogni sezione
- Esempi pratici in alcuni campi

**Esempio struttura:**

```markdown
---
task_id: TASK_[XXX]  # Numero progressivo
assigned_to: cervella-[TIPO]  # backend, frontend, tester, etc.
priority: high|medium|low
timeout_minutes: 30  # Adjust based on task complexity
created_at: [AUTO]  # Timestamp ISO8601
created_by: cervella-orchestrator
project: [PROJECT_NAME]
retry_allowed: true
max_retries: 3
---

# Task: [NOME DESCRITTIVO DEL TASK]

**Status:** ready

---

## 🎯 OBIETTIVO

[1-2 frasi chiare: cosa deve essere fatto]

**Output atteso:**
- [Cosa deve produrre - formato specifico]
- [File, report, codice - sii specifico]

---
[... continua con tutte le sezioni dal protocollo ...]
```

### 2. TEMPLATE_FEEDBACK.md (4 varianti!)

**Path:** 4 file separati in `.swarm/templates/`:
- `TEMPLATE_FEEDBACK_QUESTION.md`
- `TEMPLATE_FEEDBACK_ISSUE.md`
- `TEMPLATE_FEEDBACK_BLOCKER.md`
- `TEMPLATE_FEEDBACK_SUGGESTION.md`

**Cosa:** Template che Worker usa per comunicare con Regina

**Basato su:** Sezione 3.3 del documento protocolli

**Ogni template deve avere:**
- Frontmatter YAML con campi specifici per quel tipo
- Sezioni appropriate
- Placeholder chiari
- Guida inline su come compilare

**Esempio per QUESTION:**

```markdown
---
tipo: QUESTION
task_id: [TASK_ID]
worker: cervella-[TIPO]
urgenza: BASSA|MEDIA  # Questions usually not critical
timestamp: [AUTO]
---

# QUESTION: [Titolo breve della domanda]

## Situazione

[Descrivi chiaramente il contesto e il dubbio]

## Cosa Ho Provato

- Tentativo 1: [cosa hai fatto] → [risultato]
- Tentativo 2: [cosa hai fatto] → [risultato]

## Domanda Specifica

[Cosa ti serve sapere dalla Regina per procedere?]

## Impatto

- [x] Posso continuare su altre parti del task mentre aspetto
- [ ] Sono bloccato e non posso procedere
- [ ] Rischio di fare scelte sbagliate senza chiarimento

## File Rilevanti (se applicabile)

- `path/to/file.py:123` - [perché è rilevante]

---

**In attesa di risposta dalla Regina! 💙**
```

### 3. TEMPLATE_COMPLETION_REPORT.md

**Path:** `.swarm/templates/TEMPLATE_COMPLETION_REPORT.md`

**Cosa:** Template per report finale quando worker finisce task

**Basato su:** Sezione 1.2 (output richiesto) del protocollo

**Deve includere:**
- Riepilogo task (cosa doveva fare)
- Cosa è stato fatto
- File modificati/creati (lista completa)
- Decisioni prese durante il lavoro
- Problemi incontrati e come risolti
- Test eseguiti
- Next steps suggeriti (se applicabile)

**Esempio:**

```markdown
# COMPLETION REPORT: [NOME TASK]

**Task ID:** [TASK_XXX]
**Worker:** cervella-[TIPO]
**Completato:** [TIMESTAMP]
**Durata:** [X] minuti

---

## ✅ TASK SUMMARY

**Obiettivo era:**
[Copia obiettivo dal task originale]

**Risultato:**
[Task completato con successo / Completato con note / etc.]

---

## 🔨 LAVORO SVOLTO

### File Modificati

- `path/to/file1.py`
  - [Descrizione modifiche]
  - [Righe: XXX-YYY]

- `path/to/file2.md`
  - [Descrizione modifiche]

### File Creati

- `path/to/newfile.py` ([X] righe)
  - [Cosa contiene]

### Decisioni Tecniche

1. **[Decisione 1]**
   - Motivo: [perché]
   - Alternativa scartata: [cosa non hai fatto e perché]

2. **[Decisione 2]**
   - ...

---

## 🧪 TESTING

**Test eseguiti:**
- [ ] Test 1: [descrizione] → [PASS/FAIL]
- [ ] Test 2: [descrizione] → [PASS/FAIL]

**Coverage:** [se applicabile]

**Note testing:** [se ci sono]

---

## ⚠️ PROBLEMI & SOLUZIONI

### Problema 1: [Titolo]
**Cosa:** [descrizione]
**Soluzione:** [come risolto]

### Problema 2: [Se presente]
...

---

## 📋 SUCCESS CRITERIA CHECK

[Copia checklist success criteria dal task originale e marca]

- [x] Criterio 1: COMPLETATO
- [x] Criterio 2: COMPLETATO
- [x] Criterio 3: COMPLETATO

---

## 🚀 NEXT STEPS

[Cosa dovrebbe succedere dopo? Suggerimenti per Regina]

1. [Step 1]
2. [Step 2]

---

## 📎 RIFERIMENTI

**Task originale:** `.swarm/tasks/TASK_[XXX].md`
**Commit git:** [hash se applicabile]
**Documentazione aggiornata:** [link se applicabile]

---

**Task completato con ❤️ per la famiglia!** 🐝👑
```

### 4. TEMPLATE_STATUS_UPDATE.md

**Path:** `.swarm/templates/TEMPLATE_STATUS_UPDATE.md`

**Cosa:** Guida per worker su come aggiornare status

**Basato su:** Sezione 2 del protocollo

**Non è un template da compilare, ma una GUIDA:**

```markdown
# GUIDA: Come Aggiornare Status

## Format Status File

**Path:** `.swarm/status/[WORKER_NAME].status`

**Formato ogni riga:**
```
timestamp|stato|task_id|note
```

## Stati Disponibili

| Stato | Quando usare | Esempio note |
|-------|--------------|--------------|
| READY | Pronto per task | "Pronto per nuovi task" |
| WORKING | Task in corso | "Creando endpoint API" |
| BLOCKED | Serve aiuto | "In attesa risposta question XXX" |
| DONE | Task completato | "Completato con successo" |
| FAILED | Task fallito | "Errore: [descrizione]" |

## Come Aggiornare Manualmente

```bash
# Ottieni timestamp corrente
TIMESTAMP=$(date +%s)

# Scrivi update
echo "$TIMESTAMP|WORKING|TASK_001|Analyzing codebase" >> .swarm/status/cervella-backend.status
```

## Script Helper (quando disponibile)

```bash
# Sarà disponibile dopo FASE 4
update-status.sh WORKING "Creating endpoints"
```

## Heartbeat (ogni 60s)

```bash
# Durante il lavoro, ogni 60s scrivi heartbeat
echo "$(date +%s)|TASK_001|WORKING|Creating endpoint /api/users" >> .swarm/status/heartbeat_cervella-backend.log
```

## Best Practices

✅ DO:
- Aggiorna status quando cambi attività
- Note chiare e specifiche
- Heartbeat regolare (60s)

❌ DON'T:
- Update troppo frequenti (spam)
- Note generiche ("working...")
- Dimenticare heartbeat

---

**Ricorda:** Regina ti monitora con amore! 💙👑
```

---

## SUCCESS CRITERIA

✅ 4 template creati in `.swarm/templates/`
✅ Ogni template segue il protocollo definito
✅ Placeholder chiari e ben commentati
✅ Esempi pratici dove serve
✅ Template pronti per essere usati SUBITO da Regina e Worker

---

## NOTE IMPORTANTI

### Linguaggio e Tone

```
✅ Positivo e incoraggiante
✅ Chiaro e pratico
✅ Emoji dove appropriato (famiglia 🐝👑💙)
✅ Istruzioni step-by-step

❌ Tecnicismi inutili
❌ Tono freddo o burocratico
❌ Ambiguità
```

### Riferimenti

**Leggi TUTTO:**
- `docs/protocolli/PROTOCOLLI_COMUNICAZIONE.md` (736 righe)
  - Sezione 1.2 per HANDOFF
  - Sezione 2 per STATUS
  - Sezione 3.3 per FEEDBACK
  - Sezione 1.2 per COMPLETION_REPORT

### Qualità

Questi template saranno usati OGNI GIORNO!

- Prenditi tempo
- Fai template completi
- Pensa all'usabilità
- Testa mentalmente: "Se fossi un worker, capirei cosa fare?"

---

## OUTPUT RICHIESTO

**Directory:** `.swarm/templates/`

**File da creare:**
1. `TEMPLATE_HANDOFF.md` (task assignment)
2. `TEMPLATE_FEEDBACK_QUESTION.md`
3. `TEMPLATE_FEEDBACK_ISSUE.md`
4. `TEMPLATE_FEEDBACK_BLOCKER.md`
5. `TEMPLATE_FEEDBACK_SUGGESTION.md`
6. `TEMPLATE_COMPLETION_REPORT.md`
7. `TEMPLATE_STATUS_UPDATE.md` (guida)

**Quando hai finito:**
1. Verifica che tutti i 7 file esistano
2. Crea `.swarm/tasks/TASK_COMUNICAZIONE_FASE3_TEMPLATES.done`
3. Il watcher notificherà la Regina!

---

**Energia positiva!** ❤️‍🔥
**Template perfetti!** 📝
**Per la famiglia!** 🐝👑💙

