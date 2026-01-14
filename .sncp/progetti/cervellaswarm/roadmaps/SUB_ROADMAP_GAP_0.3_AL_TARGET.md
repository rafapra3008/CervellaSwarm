# Sub-Roadmap: Da 9.2 a 9.5 (Gap 0.3)

**Creato:** 14 Gennaio 2026 - Sessione 211
**Basato su:** Audit Ingegnera + Verifica Guardiana

---

## SITUAZIONE ATTUALE

```
SCORE: 9.2/10 (dopo fix symlink)
TARGET: 9.5/10
GAP: 0.3 punti

3 QUICK WINS identificati dall'audit!
```

---

## QUICK WINS PER COLMARE IL GAP

### 1. Split miracollo/stato.md (Warning da audit)

**Problema:** 555 righe (limite 500)
**Impatto:** +0.1 punti

**Azione:**
```bash
# Creare:
stato.md          # Solo stato corrente (~150 righe)
archivio/storico_gennaio.md  # Sessioni passate
```

**Tempo:** 15 minuti
**Priorita:** MEDIO (warning, non critico)

---

### 2. Verificare Launchd Jobs REALMENTE attivi

**Problema:** Exit code 0 = mai partiti o OK?
**Impatto:** +0.1 punti

**Azione:**
```bash
# Forzare esecuzione
launchctl start com.cervellaswarm.sncp.daily

# Verificare log
cat ~/.sncp/reports/daily/health_$(date +%Y-%m-%d).txt
```

**Tempo:** 10 minuti
**Priorita:** BASSO (probabilmente OK)

---

### 3. Test Automatici Script SNCP

**Problema:** Nessun test automatico per script
**Impatto:** +0.1 punti

**Azione:**
```bash
# Creare tests/sncp/
test_health_check.sh
test_sncp_init.sh
test_verify_sync.sh
```

**Tempo:** 30 minuti
**Priorita:** MEDIO (importante per futuro)

---

## TIMELINE

```
Sessione 212:
[ ] Split miracollo/stato.md
[ ] Verificare Launchd

Sessione 213+:
[ ] Test automatici script
```

---

## QUANDO AVREMO RAGGIUNTO 9.5

```
+================================================================+
|                                                                |
|   MILESTONE 1.5 COMPLETATO: Score 9.5+                         |
|                                                                |
|   Criteri successo:                                            |
|   [x] sncp-init funzionante (FATTO!)                          |
|   [x] verify-sync funzionante (FATTO!)                        |
|   [x] Hook automatici (FATTO!)                                 |
|   [x] Launchd attivo (FATTO!)                                  |
|   [ ] stato.md tutti < 500 righe                               |
|   [ ] Test automatici script                                   |
|                                                                |
|   PRONTO per FASE 2 (MVP)!                                     |
|                                                                |
+================================================================+
```

---

*"0.3 punti = 3 quick wins = 1 ora di lavoro totale"*
*"Non abbiamo fretta, ma andiamo avanti ogni giorno!"*
