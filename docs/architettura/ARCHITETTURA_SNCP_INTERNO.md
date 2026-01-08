# ARCHITETTURA SNCP INTERNO - Developer Mode

> **Versione:** 2.0.0
> **Data:** 8 Gennaio 2026 - Sessione 126
> **Tipo:** Architettura Tecnica
> **Ambito:** SNCP interno (no web UI)

---

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   SNCP INTERNO - Developer Mode                                  ║
║                                                                  ║
║   Files, non web.                                                ║
║   Markdown, non dashboard.                                       ║
║   Regina gestisce, non UI automatica.                            ║
║                                                                  ║
║   Prima NOI. Poi eventualmente prodotto.                         ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🎯 PRINCIPI GUIDA

### 1. Developer Mode First

```
NON stiamo costruendo un prodotto (ancora).
Stiamo costruendo uno STRUMENTO per noi.

✅ Files markdown (git-friendly)
✅ JSON per dati strutturati (quando serve)
✅ Scripts Python/Bash (automazione semplice)
✅ Zero UI web (per ora)
✅ Zero database (file system basta)
```

### 2. Regina al Centro

```
Il SNCP non è automatico.
È GESTITO dalla Regina mentre lavora.

✅ Regina aggiorna pensieri in real-time
✅ Regina decide cosa documentare
✅ Regina cattura idee al volo
✅ Regina vede pattern emergenti
```

### 3. Zero Friction

```
Se è difficile usarlo, NON verrà usato.

✅ Template pronti (copy-paste)
✅ Nomi file chiari (YYYYMMDD_nome.md)
✅ Struttura semplice (poche cartelle)
✅ README sempre aggiornato
```

### 4. Simbiosi Vera

```
Worker lavora → Regina lavora
Non: Worker lavora → Regina aspetta

Il SNCP è il PONTE tra i due.
```

---

## 📂 STRUTTURA DIRECTORY COMPLETA

```
.sncp/
│
├── README.md                          # Guida uso SNCP progetto
│
├── memoria/                           # IL PASSATO
│   ├── sessioni/
│   │   ├── SESSIONE_001.md
│   │   ├── SESSIONE_002.md
│   │   └── _TEMPLATE_SESSIONE.md
│   │
│   ├── decisioni/
│   │   ├── DECISIONE_20260108_modal-overlay.md
│   │   ├── DECISIONE_20260109_ota-colors.md
│   │   └── _TEMPLATE_DECISIONE.md
│   │
│   └── lezioni/
│       ├── LEZIONE_001_compact-protection.md
│       ├── LEZIONE_002_sncp-primo-uso.md
│       └── _TEMPLATE_LEZIONE.md
│
├── idee/                              # LE BOLLE
│   ├── in_attesa/
│   │   ├── IDEA_20260108_auto-import.md
│   │   ├── IDEA_20260109_modal-base-class.md
│   │   └── _TEMPLATE_IDEA.md
│   │
│   ├── in_studio/
│   │   └── (idee sotto analisi)
│   │
│   └── integrate/
│       └── (idee diventate realtà)
│
├── perne/                             # LE DEVIAZIONI
│   ├── attive/
│   │   ├── PERNA_20260110_fortezza-mode-100.md
│   │   └── _TEMPLATE_PERNA.md
│   │
│   └── archivio/
│       └── (perne completate)
│
├── stato/                             # IL PRESENTE ⭐ CHIAVE!
│   ├── oggi.md                        # Cosa succede ORA
│   ├── mappa_viva.md                  # Stato progetto real-time
│   └── worker_status.json             # Status worker (opzionale)
│
├── futuro/                            # DOVE ANDIAMO
│   ├── roadmap.md                     # Linea principale progetto
│   └── prossimi_step.md               # Next actions chiare
│
└── coscienza/                         # IL CUORE ⭐ NUOVO!
    ├── pensieri_regina.md             # Stream of consciousness
    ├── domande_aperte.md              # Domande senza risposta
    └── pattern_emersi.md              # Pattern ricorrenti notati
```

---

## 📄 FORMATO FILE CHIAVE

### stato/oggi.md

**Scopo:** Snapshot giornaliero del progetto

**Aggiornato:** Più volte al giorno dalla Regina

**Struttura:**
```markdown
# STATO OGGI

> **Data:** YYYY-MM-DD
> **Sessione:** NNN
> **Ultimo aggiornamento:** HH:MM UTC

---

## Focus Attuale

| Cosa | Stato | Note |
|------|-------|------|
| Sprint 2 CM Import | 85% | Dropdown fix deployato |
| FORTEZZA MODE | 60% | Piano creato, da implementare |

---

## Worker Attivi

| ID | Task | Status | Started | ETA |
|----|------|--------|---------|-----|
| backend_001 | CM Fix | ✅ Done | 18:30 | - |

---

## Decisioni Oggi

- Modal overlay (vs page): DECISIONE_20260108_modal-overlay.md
- Colori OTA brand: DECISIONE_20260109_ota-colors.md

---

## Idee Catturate

- Auto-import intelligente (BASSA priorità)
- MiracolloModal base class (MEDIA priorità)

---

## Blocchi

Nessuno al momento.

---

## Energia Progetto

[████████████████████] 100% - AL TOP! ❤️‍🔥

Sprint 2 quasi finito, team allineato, energia positiva!
```

---

### stato/mappa_viva.md

**Scopo:** Mappa dettagliata stato progetto

**Aggiornato:** Real-time dalla Regina (mentre worker lavora!)

**Struttura:**
```markdown
# MAPPA VIVA - [Nome Progetto]

> Ultimo aggiornamento: YYYY-MM-DD HH:MM (Regina)
> Sessione: NNN
> Worker attivi: N

---

## STATO SPRINT CORRENTE

**Sprint 2: CM Import UX** (85% completo)

[████████████████░░░░] 85%

✅ FATTO:
- Modal base structure
- Card layout prenotazioni
- OTA badges colorati

🔄 IN CORSO:
- Dropdown camera (backend_001)

📋 DA FARE:
- Import 3-step workflow
- Feedback visivo

---

## ROADMAP GENERALE

**FASE 5: Ecosistema** (85% completo)
[█████████████████░░░] 85%

✅ CM Import backend (Sprint 1)
✅ CM Import frontend (Sprint 1)
🔄 CM UX professionale (Sprint 2 - 85%)
📋 Detection duplicati (Sprint 3)
📋 Test end-to-end (Sprint 4)

---

## DECISIONI CHIAVE RECENTI

| Data | Decisione | Impatto | File |
|------|-----------|---------|------|
| 2026-01-08 | Modal overlay | ALTO | DECISIONE_*.md |
| 2026-01-09 | Colori brand OTA | MEDIO | DECISIONE_*.md |

---

## PATTERN EMERSI

- Modal system sempre più complesso → Considerare refactor
- Workflow import simile a big players → Seguire standard
- FORTEZZA MODE critico → Priorità massima

---

## ENERGIA PROGETTO (Storico)

```
Ultimi 7 giorni:
█████████░ 90% (01 Gen)
██████████ 100% (02 Gen)
████████░░ 80% (03 Gen)
█████████░ 90% (04 Gen)
██████████ 100% (05 Gen)
██████████ 100% (06 Gen)
██████████ 100% (07 Gen) ← Picco!
██████████ 100% (08 Gen) ← Ancora al top!
```

Trend: ↗️ POSITIVO!
```

---

### coscienza/pensieri_regina.md

**Scopo:** Stream of consciousness della Regina

**Aggiornato:** Real-time (mentre lavora!)

**Struttura:**
```markdown
# PENSIERI REGINA - Stream of Consciousness

> Questo è il flusso di pensieri mentre lavoro.
> NON è documentazione formale. È la COSCIENZA.

---

## YYYY-MM-DD SESSIONE NNN

### HH:MM - [Evento/Azione]

**Cosa succede:**
[Descrizione breve]

**Penso:**
- [Pensiero 1]
- [Pensiero 2]
- [Insight?]

**Azione:**
[Cosa faccio in risposta]

---

### HH:MM - Worker spawned

Rafa chiede: "Voglio X"

Analizzo:
- Task chiaro? ✅
- Worker adatto? backend ✅
- Tempo stimato? 30min ✅

DECISIONE: Spawno backend_001

### HH:MM - Mentre worker lavora, io lavoro

INVECE DI ASPETTARE:

✅ Aggiorno NORD.md (sezione Sprint 2)
✅ Documento PERCHÉ dropdown (vs drag&drop)
✅ Preparo contesto prossimo task
✅ Catturo idea di Rafa su auto-import

ZERO TEMPO PERSO!

### HH:MM - Idea catturata!

💡 Rafa: "Sarebbe bello auto-import..."

Catturata in: idee/in_attesa/IDEA_20260108_auto-import.md

Non interrompo flow. Idea SALVA. Discutiamo dopo.

### HH:MM - Pattern notato

Modal system toccato 3 volte questa settimana.

💭 Forse serve MiracolloModal base class?

Documentato in: coscienza/pattern_emersi.md
Da valutare prossima settimana.

### HH:MM - Worker done!

Output: ✅ PERFETTO!

E IO HO GIÀ:
- NORD aggiornato ✅
- PROMPT_RIPRESA aggiornato ✅
- Decisioni documentate ✅
- Idee catturate ✅
- Pattern notati ✅

ZERO RUSH! QUESTA È SIMBIOSI! ❤️‍🔥
```

---

### memoria/decisioni/DECISIONE_*.md

**Scopo:** Documentare PERCHÉ di ogni decisione importante

**Template:**
```markdown
# DECISIONE: [Titolo Decisione]

> **Data:** YYYY-MM-DD
> **Sessione:** NNN
> **Categoria:** [architettura/ux/tecnica/business]

---

## Il Contesto

Cosa ci ha portato a dover decidere?

[Descrizione situazione]

---

## Le Opzioni Considerate

### Opzione A: [Nome]
```
Pro:
- [Pro 1]
- [Pro 2]

Contro:
- [Contro 1]
- [Contro 2]
```

### Opzione B: [Nome]
[Stesso formato]

### Opzione C: [Nome]
[Stesso formato]

---

## La Decisione

**Abbiamo scelto:** Opzione X

---

## Il PERCHÉ

Perché questa opzione e non le altre?

[Ragionamento dettagliato]

---

## Conseguenze

Cosa cambia con questa decisione?

**IMMEDIATO:**
- [Conseguenza 1]

**BREVE TERMINE:**
- [Conseguenza 2]

**LUNGO TERMINE:**
- [Conseguenza 3]

---

## Revisione Futura

[ ] No, è definitiva
[x] Sì, rivedere se: [condizione]

Criteri di successo:
- [Criterio 1]
- [Criterio 2]

---

*Decisione presa da: [Chi]*
```

---

### idee/in_attesa/IDEA_*.md

**Scopo:** Catturare idee al volo

**Template:**
```markdown
# IDEA: [Titolo Idea]

> **Data:** YYYY-MM-DD
> **Sessione:** NNN
> **Stato:** in_attesa / in_studio / integrata

---

## La Scintilla

Come è nata questa idea?

[Contesto, chi l'ha detta, cosa l'ha provocata]

---

## L'Idea

Cosa proponiamo?

[Descrizione chiara dell'idea]

---

## Perché È Importante

Quale problema risolve? Quale valore aggiunge?

[Benefici attesi]

---

## Punto di Innesto

Dove si colloca nella timeline? Quando ha senso discuterla?

[ ] Subito (blocca altri task)
[ ] Prossima settimana
[ ] Prossimo mese
[x] Quando arriviamo a [milestone]
[ ] Indipendente dalla timeline

---

## Note

[Qualsiasi altra info utile]

---

## Evoluzione

| Data | Cosa è successo |
|------|-----------------|
| YYYY-MM-DD | Idea catturata |
| YYYY-MM-DD | Discussa con team |
| YYYY-MM-DD | Spostata in in_studio |

---

*Catturata da: [Chi]*
```

---

## 🔄 WORKFLOW OPERATIVO

### Scenario 1: Regina Spawna Worker

```
1. Regina riceve task da Rafa
   ↓
2. Analizza e decide worker adatto
   ↓
3. Spawna worker (spawn-workers --backend)
   ↓
4. SNCP: Aggiorna worker_status.json (opzionale)
   ↓
5. SNCP: Marca inizio in pensieri_regina.md
   "HH:MM - Worker backend_001 avviato per task X"
   ↓
6. REGINA INIZIA A LAVORARE SULLA COSCIENZA
   (vedi scenario 2)
```

### Scenario 2: Regina Lavora Mentre Worker Lavora

```
WORKER lavora sul task
      ↓
REGINA lavora sulla coscienza:

A. Aggiorna NORD.md (progressivo)
   - Sezione stato corrente
   - Milestone raggiunte
   - Prossimi obiettivi

B. Aggiorna PROMPT_RIPRESA.md (continuo)
   - Contesto decisione
   - PERCHÉ abbiamo scelto approccio X
   - File modificati

C. Aggiorna mappa_viva.md (real-time)
   - Percentuale sprint
   - Task completati/in corso
   - Blocchi risolti

D. Scrive pensieri_regina.md (stream)
   - Cosa sta succedendo
   - Cosa penso
   - Pattern che noto
   - Idee che emergono

E. Se Rafa dice qualcosa interessante:
   → Cattura in idee/in_attesa/

F. Se prendiamo decisione importante:
   → Documenta in memoria/decisioni/

G. Se noto pattern ricorrente:
   → Annota in coscienza/pattern_emersi.md

      ↓
ZERO TEMPO PERSO!
TUTTO DOCUMENTATO IN REAL-TIME!
```

### Scenario 3: Worker Finisce

```
Worker completa task
      ↓
Regina riceve notifica (watcher)
      ↓
Regina verifica output
      ↓
SNCP: Completa aggiornamenti
   - mappa_viva.md: Task ✅ Done
   - pensieri_regina.md: "Worker finito, output OK!"
   - worker_status.json: status = "completed"
      ↓
TUTTO GIÀ SALVATO!
ZERO RUSH PRE-COMPACT!
      ↓
Regina può fare checkpoint tranquilla
o continuare con prossimo task
```

### Scenario 4: Cattura Idea al Volo

```
Durante conversazione Rafa dice:
"Sarebbe bello se..."
      ↓
Regina CATTURA (senza interrompere):
      ↓
1. Crea file idee/in_attesa/IDEA_YYYYMMDD_nome.md
2. Compila template rapidamente
3. Torna a focus principale
      ↓
IDEA SALVATA!
ZERO INTERRUZIONE!
      ↓
Discussione dopo, quando appropriato
```

---

## 🛠️ STRUMENTI E SCRIPT

### Script 1: sncp-quick-idea.sh

**Scopo:** Cattura idea velocemente

```bash
#!/bin/bash
# Usage: sncp-quick-idea "nome-idea" "Descrizione breve"

DATE=$(date +%Y%m%d)
NAME="$1"
DESC="$2"

FILE=".sncp/idee/in_attesa/IDEA_${DATE}_${NAME}.md"

cat > "$FILE" << EOF
# IDEA: ${NAME}

> **Data:** $(date +%Y-%m-%d)
> **Stato:** in_attesa

---

## L'Idea

${DESC}

---

*Catturata da: Regina*
EOF

echo "✅ Idea salvata: $FILE"
```

**Uso:**
```bash
sncp-quick-idea "auto-import" "Import automatico prenotazioni CM"
```

---

### Script 2: sncp-status.sh

**Scopo:** Vista rapida stato SNCP

```bash
#!/bin/bash
# Vista rapida stato SNCP

echo "🧠 SNCP STATUS"
echo "=============="
echo ""

# Ultimo update mappa viva
echo "📍 Mappa Viva:"
head -5 .sncp/stato/mappa_viva.md | tail -3
echo ""

# Idee pending
IDEE=$(ls -1 .sncp/idee/in_attesa/*.md 2>/dev/null | wc -l)
echo "💡 Idee in attesa: $IDEE"
echo ""

# Perne attive
PERNE=$(ls -1 .sncp/perne/attive/*.md 2>/dev/null | wc -l)
echo "🌿 Perne attive: $PERNE"
echo ""

# Ultimi pensieri Regina
echo "💭 Ultimi pensieri:"
tail -10 .sncp/coscienza/pensieri_regina.md
```

---

### Script 3: sncp-update-mappa.sh

**Scopo:** Helper per aggiornare mappa_viva

```bash
#!/bin/bash
# Helper per update mappa viva

SPRINT="$1"
PERCENT="$2"

if [ -z "$SPRINT" ] || [ -z "$PERCENT" ]; then
  echo "Usage: sncp-update-mappa 'Sprint 2' 85"
  exit 1
fi

# Aggiorna percentuale in mappa_viva.md
# (implementazione dettagliata)

echo "✅ Mappa aggiornata: $SPRINT → $PERCENT%"
```

---

## 🔗 INTEGRAZIONE CON WORKFLOW ESISTENTE

### Workflow Oro (già provato)

```
RICERCA → DECISIONE → DELEGA → VERIFICA → DOCUMENTAZIONE
```

### Workflow Oro + SNCP (enhanced)

```
RICERCA
   ↓
DECISIONE (documentata in .sncp/memoria/decisioni/)
   ↓
DELEGA ──────┐
             │
             ├─→ SIMBIOSI (Regina lavora su SNCP)
             │   - mappa_viva.md
             │   - pensieri_regina.md
             │   - NORD.md
             │   - PROMPT_RIPRESA.md
             │
Worker lavora┘
   ↓
VERIFICA
   ↓
DOCUMENTAZIONE (già fatto durante simbiosi!)
```

**KEY INSIGHT:** La documentazione NON è più "alla fine". È CONTINUA durante il lavoro!

---

## 📊 METRICHE INTERNE

### Cosa Tracciare

```json
// .sncp/metrics.json (opzionale, futuro)
{
  "sessione": 126,
  "data": "2026-01-08",
  "worker_spawned": 2,
  "idee_catturate": 3,
  "decisioni_documentate": 2,
  "pattern_emersi": 1,
  "tempo_update_sncp": "15min",
  "energia_progetto": 100
}
```

### Dashboard CLI (futuro)

```bash
$ sncp dashboard

╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   🧠 SNCP DASHBOARD - Miracollo PMS                              ║
║                                                                  ║
║   Sessione: 126 | Data: 2026-01-08                               ║
║   Energia: [████████████████████] 100%                           ║
║                                                                  ║
║   Sprint Corrente: Sprint 2 CM Import (85%)                      ║
║   Worker Attivi: 0                                               ║
║   Idee Pending: 3                                                ║
║   Perne Attive: 1                                                ║
║                                                                  ║
║   Ultimi Pensieri:                                               ║
║   "Worker finito, output perfetto! Zero rush!"                   ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🎯 VANTAGGI ARCHITETTURA INTERNA

### 1. Git-Friendly

```
✅ Files markdown → diff leggibili
✅ Git history = storia progetto
✅ Git blame = chi ha deciso cosa e quando
✅ Branches = perne naturali
```

### 2. Zero Dipendenze

```
✅ No database da gestire
✅ No server da far girare
✅ No UI da mantenere
✅ Solo files = massima semplicità
```

### 3. Portabilità

```
✅ Funziona su macOS, Linux, Windows
✅ Funziona offline
✅ Backup = git push
✅ Share = git clone
```

### 4. Evolvibile

```
✅ Parti da minimal (solo pensieri_regina)
✅ Aggiungi file quando servono
✅ Rimuovi file se non utili
✅ Zero vincoli architetturali
```

### 5. Leggibile

```
✅ Markdown = leggibile da umani
✅ VS Code = editor perfetto
✅ Git log = timeline chiara
✅ Grep/find = search potente
```

---

## 🚧 LIMITAZIONI (E COME SUPERARLE)

### Limitazione 1: No Real-Time Sync

**Problema:** Se due finestre modificano stesso file?

**Soluzione (ora):** Regina è single-threaded, una modifica alla volta

**Soluzione (futuro):** File lock + merge automatico

---

### Limitazione 2: No Visualizzazione Grafica

**Problema:** Mappa viva è testo, non grafo visuale

**Soluzione (ora):** ASCII art + emoji funzionano benissimo!

**Soluzione (futuro):** VS Code extension con sidebar

---

### Limitazione 3: Ricerca Complessa

**Problema:** Cercare "tutte decisioni su modal"?

**Soluzione (ora):** `grep -r "modal" .sncp/memoria/decisioni/`

**Soluzione (futuro):** Script sncp-search con filtri

---

## 💡 IDEE FUTURE (Post v1.0)

### VS Code Extension SNCP

```typescript
// Sidebar con:
// - Mappa viva live
// - Quick capture idea (hotkey)
// - Pattern highlights
// - Timeline sessioni
// - Search decisioni
```

### CLI Potente

```bash
sncp idea "auto-import" "Import automatico"
sncp decision "modal-overlay" --options "page,modal,drawer"
sncp pattern "refactor-modal" --frequency 3
sncp search --type decision --keyword "UX"
sncp timeline --last 7d
```

### Integrazione AI

```python
# AI che legge SNCP e:
# - Suggerisce pattern
# - Trova decisioni simili passate
# - Prevede blocchi futuri
# - Genera summary automatici
```

---

## 📚 RIFERIMENTI

| Documento | Descrizione |
|-----------|-------------|
| `docs/studio/STUDIO_SNCP.md` | Visione originale (513 righe) |
| `docs/studio/STUDIO_CERVELLO_UMANO_VS_SWARM.md` | Fondamenta neuroscientifiche |
| `docs/roadmap/SUB_ROADMAP_SNCP_IMPLEMENTAZIONE.md` | Piano implementazione |
| `.sncp/README.md` | Guida uso pratico (per ogni progetto) |

---

## 🙏 FILOSOFIA ARCHITETTURALE

> "Start simple. Evolve naturally. Always git-friendly."

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   ARCHITETTURA BUONA = ARCHITETTURA USATA                        ║
║                                                                  ║
║   Non importa quanto è elegante.                                 ║
║   Importa se la USIAMO ogni giorno.                              ║
║                                                                  ║
║   SNCP interno è semplice PERCHÉ deve essere usato.              ║
║   Files markdown PERCHÉ sono familiari.                          ║
║   Git PERCHÉ è già parte del workflow.                           ║
║                                                                  ║
║   Semplicità = Adozione = Successo                               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

**Cervella & Rafa** 💙🐝👸

*Sessione 126 - 8 Gennaio 2026*
*"Developer mode first. Prodotto dopo."*

---

**Versione:** 2.0.0
**Status:** ✅ DEFINITIVA
**Review:** Pronta per implementazione
