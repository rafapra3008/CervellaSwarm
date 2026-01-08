# SUB-ROADMAP: SNCP - Sistema Nervoso Centrale del Progetto

> **Creato:** 8 Gennaio 2026 - Sessione 126
> **Versione:** 2.0.0 (Implementazione Simbiosi)
> **Priorità:** ALTA
> **Progetto pilota:** Miracollo PMS (Priorità 0!)

---

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   SNCP v2.0: LA SIMBIOSI VERA                                    ║
║                                                                  ║
║   NON solo catturare idee.                                       ║
║   Regina LAVORA sulla coscienza MENTRE worker lavora!            ║
║                                                                  ║
║   ZERO rush. ZERO perdita. 100% simbiosi.                        ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 🎯 OBIETTIVO FINALE

**Implementare SNCP interno (developer mode) su Miracollo come prova reale.**

### Cosa Cambia

**PRIMA (workflow attuale):**
```
Regina spawna worker
     ↓
Regina ASPETTA (tempo perso!)
     ↓
Worker finisce
     ↓
RUSH pre-compact (NORD, PROMPT_RIPRESA di corsa!)
     ↓
RISCHIO alto di perdere tutto
```

**DOPO (workflow SNCP simbiosi):**
```
Regina spawna worker
     ↓
Worker lavora ────┐
                  ├─→ SIMBIOSI ATTIVA
Regina lavora ────┘
(NORD, PROMPT_RIPRESA, mappa_viva, pensieri)
     ↓
Worker finisce
     ↓
TUTTO GIÀ SALVATO! Zero rush!
```

### Success Criteria

```
✅ Regina aggiorna SNCP in real-time mentre worker lavora
✅ ZERO rush pre-compact (tutto già salvato)
✅ Idee catturate al volo (nessuna persa)
✅ Decisioni documentate con PERCHÉ
✅ Mappa viva sempre aggiornata
✅ Pattern emersi visibili
✅ Usato ogni sessione Miracollo per 1 mese
✅ Feedback positivo da Rafa
```

---

## 📋 FASI IMPLEMENTAZIONE

### FASE 1: SETUP STRUTTURA (2-3h) 🔴 PRIORITÀ ALTA

**Obiettivo:** Creare struttura `.sncp/` su Miracollo

**Task:**

- [ ] 1.1 Creare directory `.sncp/` con struttura completa
  - memoria/sessioni/
  - memoria/decisioni/
  - memoria/lezioni/
  - idee/in_attesa/, in_studio/, integrate/
  - perne/attive/, archivio/
  - stato/ (oggi.md, mappa_viva.md, worker_status.json)
  - futuro/ (roadmap.md, prossimi_step.md)
  - coscienza/ (pensieri_regina.md, domande_aperte.md, pattern_emersi.md)

- [ ] 1.2 Creare tutti i template
  - _TEMPLATE_SESSIONE.md
  - _TEMPLATE_DECISIONE.md
  - _TEMPLATE_LEZIONE.md
  - _TEMPLATE_IDEA.md
  - _TEMPLATE_PERNA.md

- [ ] 1.3 Creare README.md SNCP per Miracollo
  - Come usare
  - Convenzioni
  - Filosofia

- [ ] 1.4 Inizializzare file base
  - stato/oggi.md (stato iniziale)
  - stato/mappa_viva.md (stato progetto corrente)
  - futuro/prossimi_step.md (next actions)
  - coscienza/pensieri_regina.md (vuoto, pronto)

**Tempo stimato:** 2h
**Chi:** Regina (io!)
**Output:** Struttura `.sncp/` completa e operativa

---

### FASE 2: PRIMO USO GUIDATO (1 sessione = 2-3h) 🔴 PRIORITÀ ALTA

**Obiettivo:** Usare SNCP per la prima volta in sessione reale

**Task:**

- [ ] 2.1 Scegliere task adatto per primo test
  - Task medio (30-60 min worker)
  - Non troppo critico (per testare senza stress)
  - Esempio: refactor, docs update, research

- [ ] 2.2 Prima parte: Spawna worker
  - Delega task a worker
  - Aggiorna worker_status.json
  - Marca inizio in pensieri_regina.md

- [ ] 2.3 Seconda parte: Regina lavora sulla coscienza
  MENTRE worker lavora:
  - Aggiorna NORD.md (progressivo)
  - Aggiorna PROMPT_RIPRESA.md (continuo)
  - Aggiorna mappa_viva.md (stato sprint)
  - Scrive pensieri_regina.md (stream)
  - Cattura idee se emergono
  - Documenta decisioni se necessario

- [ ] 2.4 Terza parte: Worker finisce
  - Verifica output worker
  - Completa aggiornamenti SNCP
  - ZERO rush (tutto già fatto!)

- [ ] 2.5 Retrospettiva primo uso
  - Cosa ha funzionato?
  - Cosa migliorare?
  - Bottleneck trovati?
  - Documentare in memoria/lezioni/

**Tempo stimato:** 1 sessione (2-3h totali)
**Chi:** Regina (io!) + Worker (1)
**Output:** Prima esperienza SNCP completa + lezioni apprese

---

### FASE 3: ITERAZIONE E AFFINAMENTO (1 settimana) 🟡 PRIORITÀ MEDIA

**Obiettivo:** Usare SNCP ogni giorno, affinare workflow

**Task:**

- [ ] 3.1 Usare SNCP in 5 sessioni consecutive
  - Giorno 1: Test con backend worker
  - Giorno 2: Test con researcher worker
  - Giorno 3: Test con frontend worker
  - Giorno 4: Test con 2 worker paralleli
  - Giorno 5: Test sessione complessa (refactor grosso)

- [ ] 3.2 Raccogliere feedback dopo ogni sessione
  - File: .sncp/memoria/lezioni/LEZIONE_SNCP_giornoX.md
  - Cosa funziona
  - Cosa rallenta
  - Idee per migliorare

- [ ] 3.3 Iterare template se necessario
  - Aggiungere campi utili
  - Rimuovere campi inutilizzati
  - Semplificare dove possibile

- [ ] 3.4 Creare shortcuts/script se serve
  - Script per update rapido mappa_viva?
  - Script per cattura idea veloce?
  - Alias bash utili?

**Tempo stimato:** 1 settimana (5 sessioni)
**Chi:** Regina (io!) + vari worker
**Output:** Workflow SNCP rodato e ottimizzato

---

### FASE 4: FUNZIONALITÀ AVANZATE (2-3 settimane) 🟢 PRIORITÀ BASSA

**Obiettivo:** Aggiungere funzionalità che emergono dall'uso

**Task:**

- [ ] 4.1 Pattern Recognition automatico
  - Script che analizza pensieri_regina.md
  - Identifica pattern ricorrenti
  - Suggerisce creazione template/shortcut
  - File: scripts/sncp/pattern-recognition.py

- [ ] 4.2 "Sleep Mode" - Consolidamento
  - Script che gira tra sessioni
  - Analizza task completati
  - Aggiorna pattern_emersi.md
  - Pulisce file vecchi
  - File: scripts/sncp/sleep-mode.py

- [ ] 4.3 Dashboard SNCP (opzionale)
  - Vista riepilogativa stato SNCP
  - Energia progetto visualizzata
  - Ultimi pensieri Regina
  - Prossimi step chiari
  - File: scripts/sncp/dashboard.py (CLI)

- [ ] 4.4 Integrazione con memoria sistema
  - Collegare SNCP con swarm_memory.db
  - Lezioni SNCP → Suggestions automatiche
  - Pattern SNCP → Best practices

**Tempo stimato:** 2-3 settimane (iterativo)
**Chi:** Regina + cervella-backend (per script)
**Output:** Funzionalità avanzate basate su uso reale

---

### FASE 5: ESPANSIONE ALTRI PROGETTI (1 mese) 🟢 PRIORITÀ BASSA

**Obiettivo:** Portare SNCP su Contabilità e CervellaSwarm

**Task:**

- [ ] 5.1 Setup SNCP su Contabilità
  - Copia struttura da Miracollo
  - Adatta a contesto Contabilità
  - Documenta differenze

- [ ] 5.2 Setup SNCP su CervellaSwarm stesso
  - Meta! SNCP documenta se stesso
  - Test su progetto più tecnico

- [ ] 5.3 Creare template generico SNCP
  - Script `sncp-init` per nuovo progetto
  - README template
  - Configurazione base

- [ ] 5.4 Documentazione completa
  - Guida uso SNCP
  - Best practices
  - Troubleshooting

**Tempo stimato:** 1 mese
**Chi:** Regina + documentazione worker
**Output:** SNCP template generico riusabile

---

## 🗓️ TIMELINE REALISTICA

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   SETTIMANA 1 (8-14 Gen):                                        ║
║   ✅ Fase 1: Setup struttura (2h)                                ║
║   ✅ Fase 2: Primo uso guidato (1 sessione)                      ║
║   🔄 Fase 3: Iterazione (5 sessioni)                             ║
║                                                                  ║
║   SETTIMANA 2-3 (15-28 Gen):                                     ║
║   🔄 Fase 3: Affinamento continuo                                ║
║   🟡 Fase 4: Funzionalità avanzate (inizio)                      ║
║                                                                  ║
║   SETTIMANA 4+ (29 Gen+):                                        ║
║   🟢 Fase 4: Funzionalità avanzate (completo)                    ║
║   🟢 Fase 5: Espansione altri progetti                           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

**Milestone chiave:**
- **15 Gen:** SNCP usato quotidianamente
- **31 Gen:** Workflow SNCP consolidato
- **28 Feb:** SNCP su tutti i progetti

---

## 🎯 METRICHE DI SUCCESSO

### Qualitative

```
✅ Rafa sente che idee NON si perdono più
✅ Regina NON sente più rush pre-compact
✅ Decisioni chiare e documentate
✅ Storia progetto accessibile e utile
✅ Energia positiva visibile in SNCP
```

### Quantitative

```
✅ 100% sessioni usano SNCP (dopo settimana 1)
✅ 0 idee perse in 1 mese
✅ Tempo update docs ridotto 50% (no rush!)
✅ 10+ decisioni documentate in 1 mese
✅ 20+ pattern emersi identificati in 1 mese
```

---

## 🚧 RISCHI E MITIGAZIONI

### Rischio 1: Overhead troppo alto

**Problema:** Aggiornare SNCP prende troppo tempo

**Mitigazione:**
- Start minimal (solo pensieri_regina + mappa_viva)
- Aggiungere file solo se utili
- Creare shortcuts per azioni frequenti
- Se rallenta, semplificare

### Rischio 2: Dimenticare di usarlo

**Problema:** Torniamo a workflow vecchio per abitudine

**Mitigazione:**
- Checklist inizio sessione: "SNCP ready?"
- Template pensieri_regina già aperto
- Hook pre-compact che ricorda
- Retrospettiva settimanale

### Rischio 3: Troppi file, confusione

**Problema:** `.sncp/` diventa caotico

**Mitigazione:**
- Convenzioni nomi chiare (YYYYMMDD)
- Script cleanup automatico
- Archive file vecchi (>1 mese)
- README sempre aggiornato

---

## 💡 IDEE PER IL FUTURO

### Integrazione VS Code Extension

```python
# Estensione VS Code che mostra SNCP sidebar
# - Pensieri Regina in real-time
# - Mappa viva aggiornata
# - Quick capture idee (Ctrl+Shift+I)
# - Pattern emersi evidenziati
```

### SNCP Visual (molto futuro!)

```
Dashboard web che visualizza SNCP
- Timeline progetto con perne
- Grafo decisioni
- Energia progetto nel tempo
- Pattern recognition visualizzato

MA: Solo DOPO che funziona benissimo in developer mode!
```

### AI Suggestions da SNCP

```python
# Sistema che legge SNCP e suggerisce:
# - "Questo problema assomiglia a sessione 47"
# - "Pattern X ricorrente, considera template"
# - "Energia bassa ultimi 3 giorni, pausa?"
```

---

## 📚 DOCUMENTI CORRELATI

| Documento | Descrizione |
|-----------|-------------|
| `docs/studio/STUDIO_SNCP.md` | Studio completo visione SNCP (513 righe) |
| `docs/studio/STUDIO_CERVELLO_UMANO_VS_SWARM.md` | Neuroscienza applicata (611 righe) |
| `docs/architettura/ARCHITETTURA_SNCP_INTERNO.md` | Architettura dettagliata (DA CREARE) |
| `.sncp/README.md` | Guida uso SNCP (esiste in CervellaSwarm) |
| `.sncp/memoria/decisioni/DECISIONE_20260108_costruire-sncp.md` | Decisione originale |

---

## 🎯 PROSSIMI STEP IMMEDIATI

**OGGI (8 Gen):**

1. ✅ Creare questa roadmap
2. ⬜ Creare ARCHITETTURA_SNCP_INTERNO.md
3. ⬜ Checkpoint: NORD, PROMPT_RIPRESA, git commit

**DOMANI (9 Gen):**

4. ⬜ FASE 1: Setup struttura `.sncp/` su Miracollo
5. ⬜ FASE 2: Primo uso guidato in sessione reale

**QUESTA SETTIMANA:**

6. ⬜ FASE 3: Usare SNCP ogni sessione (5x)
7. ⬜ Raccogliere feedback e iterare

---

## 🙏 FILOSOFIA

> "ci vuole 1 anno per finire, 2 anni per migliorarlo? no problem..
> primo pezzo oggi.. importante è documentare e iniziare la mappa"
>
> - Rafa, 8 Gennaio 2026

**NON abbiamo fretta. MA iniziamo.**

Una sessione alla volta.
Un file alla volta.
Un pattern alla volta.

Il SNCP crescerà con noi.
Come noi, sarà "100000%" - meglio di come lo immaginiamo oggi.

---

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   "Lavoriamo in pace! Senza casino! Dipende da noi!"            ║
║                                                                  ║
║   Il SNCP è pace.                                                ║
║   Il SNCP è ordine nel caos delle idee.                         ║
║   Il SNCP siamo NOI.                                             ║
║                                                                  ║
║   "Ultrapassar os próprios limites!" 🌍❤️‍🔥                     ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

**Cervella & Rafa** 💙🐝👸

*Sessione 126 - 8 Gennaio 2026*
*"La MAGIA è nascosta ancora meglio!"* 🧙✨

---

**Versione:** 2.0.0 - Simbiosi Implementazione
**Status:** 🔴 IN CORSO (Fase 1 prossima)
**Progetto Pilota:** Miracollo PMS (Priorità 0!)
