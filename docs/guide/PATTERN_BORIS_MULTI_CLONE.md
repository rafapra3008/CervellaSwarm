# Pattern Boris - Multi-Clone Parallelo

> **Validato:** Sessione 133, 9 Gennaio 2026
> **Ispirato da:** Boris Cherny (creatore Claude Code) che usa 5 Claude paralleli

---

## Cosa E'

Pattern per lanciare multiple sessioni Claude in parallelo, ognuna nel suo git clone separato.

```
IO (Meta-Regina)
├── Clone A (sessione Claude separata)
│   └── Lavora su Task A
├── Clone B (sessione Claude separata)
│   └── Lavora su Task B
└── Monitoro e coordino da qui
```

---

## Come Funziona

### Step 1: Creare Git Clones

```bash
cd ~/Developer
git clone PROGETTO PROGETTO-regina-A
git clone PROGETTO PROGETTO-regina-B
```

### Step 2: Lanciare Sessioni tmux

```bash
# Sessione A
tmux new-session -d -s "regina-A" \
  "cd ~/Developer/PROGETTO-regina-A && \
   claude -p 'TASK A' 2>&1 | tee /tmp/regina-A.log; \
   echo 'SESSION_A_DONE' >> /tmp/regina-A.log"

# Sessione B
tmux new-session -d -s "regina-B" \
  "cd ~/Developer/PROGETTO-regina-B && \
   claude -p 'TASK B' 2>&1 | tee /tmp/regina-B.log; \
   echo 'SESSION_B_DONE' >> /tmp/regina-B.log"
```

### Step 3: Monitorare

```bash
# Verificare sessioni attive
tmux list-sessions

# Leggere log
tail -f /tmp/regina-A.log
tail -f /tmp/regina-B.log
```

### Step 4: Verificare Output

```bash
# Controllare file creati nei clones
ls ~/Developer/PROGETTO-regina-A/
ls ~/Developer/PROGETTO-regina-B/
```

### Step 5: Cleanup

```bash
# Chiudere sessioni
tmux kill-session -t regina-A
tmux kill-session -t regina-B

# Opzionale: rimuovere clones
rm -rf ~/Developer/PROGETTO-regina-A
rm -rf ~/Developer/PROGETTO-regina-B
```

---

## Test Validato (Sessione 133)

| Sessione | Task | Output | Tempo |
|----------|------|--------|-------|
| Regina A | Analisi archived/ | ANALISI_ARCHIVED.md (950 bytes) | ~15 sec |
| Regina B | Executive Summary | EXECUTIVE_SUMMARY.md (921 bytes) | ~15 sec |

**Risultato:** Entrambe hanno completato correttamente in parallelo.

---

## Quando Usare

| Scenario | Pattern Consigliato |
|----------|---------------------|
| Task veloci (<10 min) | Task tool interno |
| Task che modificano molti file | Pattern Boris (clones separati) |
| 2+ task completamente indipendenti | Pattern Boris |
| Task che potrebbero avere conflitti | Pattern Boris |
| Ricerche/analisi senza scrittura | Task tool interno |

---

## Pro e Contro

### Pro
- Isolamento totale (zero conflitti)
- Sessioni VERE parallele (non subagent)
- Ogni clone puo' fare commit separati
- Sopravvive a compact della Regina principale

### Contro
- Usa piu' spazio disco (clone completo)
- Setup manuale dei clones
- Merge manuale dei risultati
- Non puo' condividere contesto tra clones

---

## Differenza da Boris Originale

| Boris | Noi |
|-------|-----|
| 5 clones | 2 clones (per ora) |
| Opus sempre | Sonnet per worker |
| Lui monitora | IO (Regina) monitoro |
| Manual check | tmux + log automatici |

---

## Clones Attivi

Dopo il test, abbiamo questi clones disponibili:
- `~/Developer/CervellaSwarm-regina-A`
- `~/Developer/CervellaSwarm-regina-B`

Possono essere riutilizzati per test futuri o rimossi.

---

*Documentato: 9 Gennaio 2026 - Sessione 133*
*Pattern validato e funzionante*
