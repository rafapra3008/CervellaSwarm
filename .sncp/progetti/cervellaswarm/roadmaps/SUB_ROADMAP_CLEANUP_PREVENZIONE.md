# SUB-ROADMAP: Cleanup + Prevenzione Accumulo

> **Creata:** 15 Gennaio 2026 - Sessione 215
> **Obiettivo:** Pulire il sistema E garantire che MAI si accumuli di nuovo
> **Principio:** "Prevenire è meglio che curare"

---

## PROBLEMA IDENTIFICATO

```
+------------------------------------------------------------------+
|   ACCUMULO INCONTROLLATO                                          |
|                                                                    |
|   - 287 JSON reports (17MB) - generati automaticamente            |
|   - Context iniziale 2335 righe - file troppo lunghi              |
|   - ROADMAP/PROMPT duplicati - nessuna pulizia                    |
|   - Regole scritte MA ignorate - nessun enforcement               |
|                                                                    |
|   CAUSA ROOT: Nessun meccanismo AUTOMATICO di prevenzione!        |
+------------------------------------------------------------------+
```

---

## SOLUZIONE: 3 LIVELLI

```
LIVELLO 1: CLEANUP (una tantum)
LIVELLO 2: LIMITI HARD (hook che bloccano)
LIVELLO 3: MANUTENZIONE AUTOMATICA (scheduled)
```

---

## FASE 1: CLEANUP CRITICO (Sessione 215)

### 1.1 File da Cancellare

| Cosa | Quantità | Spazio |
|------|----------|--------|
| JSON engineer reports | 287 file | 17MB |
| ROADMAP obsolete | 3 file | 15KB |
| PROMPT backup | 4 file | 8KB |
| HANDOFF vecchi | 2 file | 1KB |

### 1.2 Comandi

```bash
# JSON reports (tenere ultimi 5)
cd reports && mkdir -p archive && mv engineer_report_*.json archive/

# ROADMAP obsolete
rm ROADMAP_SACRA.md ROADMAP_COMMERCIALIZZAZIONE.md ROADMAP_BEEHIVE.md

# PROMPT backup
rm PROMPT_RIPRESA_ORIGINALE.md PROMPT_RIPRESA_BACKUP_*.md CLAUDE_ORIGINALE.md

# HANDOFF vecchi
rm HANDOFF_SESSIONE_*.md
```

### 1.3 Risultato Atteso

```
reports/: 19MB → 2MB (-89%)
Root: 17 file → 10 file
```

**Status:** [ ] DA FARE

---

## FASE 2: LIMITI HARD (Sessione 215-216)

### 2.1 Hook Prevenzione File Lunghi

```python
# ~/.claude/hooks/file_size_guard.py
# Trigger: PreToolUse (Write/Edit)

LIMITI = {
    "PROMPT_RIPRESA.md": 300,
    "oggi.md": 60,
    "stato.md": 500,
}

# Se file supera limite → WARNING + suggerimento archiviare
# Se file supera limite x2 → BLOCK operazione
```

### 2.2 Hook Prevenzione Reports

```python
# ~/.claude/hooks/report_cleanup_guard.py
# Trigger: SessionEnd

# Conta file in reports/
# Se > 50 file JSON → WARNING
# Se > 100 file JSON → AUTO-ARCHIVE vecchi
```

### 2.3 Limiti in CLAUDE.md (già fatto)

```
PROMPT_RIPRESA.md: MAX 300 righe
oggi.md: MAX 60 righe
VIOLAZIONE = ERRORE GRAVE!
```

**Status:** [ ] DA FARE

---

## FASE 3: MANUTENZIONE AUTOMATICA (Sessione 216+)

### 3.1 Launchd Weekly Cleanup

```bash
# scripts/sncp/weekly_cleanup.sh
# Eseguito ogni Lunedì via launchd

1. Archivia reports > 7 giorni
2. Compatta stato.md se > 400 righe
3. Verifica limiti file
4. Report email/log se problemi
```

### 3.2 Pre-Session Check Esteso

```bash
# scripts/sncp/pre-session-check.sh (aggiornare)

# Aggiungere:
- Check PROMPT_RIPRESA < 300 righe
- Check oggi.md < 60 righe
- Check reports/ < 50 file
- Se violazione → WARNING VISIBILE
```

### 3.3 Dashboard Health

```
Metriche da monitorare:
- Dimensione reports/
- Righe file critici
- Età file più vecchio non archiviato
```

**Status:** [ ] DA FARE

---

## PREVENZIONE: REGOLE AUTOMATICHE

### Regola 1: File Size Guard

```
SE file > LIMITE:
  → WARNING a inizio output
  → Suggerimento: "Archivia contenuto vecchio"

SE file > LIMITE x 2:
  → BLOCCA scrittura
  → Forza archiviazione prima di continuare
```

### Regola 2: Report Rotation

```
SE reports/*.json > 10:
  → AUTO-MOVE vecchi in archive/
  → Tenere solo ultimi 10

SE reports/*.md > 30:
  → WARNING
  → Suggerire consolidamento
```

### Regola 3: Cleanup Schedulato

```
OGNI LUNEDI:
  → weekly_cleanup.sh automatico
  → Log risultato
  → Alert se problemi
```

### Regola 4: Context Guard

```
SE context iniziale > 1000 righe:
  → WARNING visibile
  → Suggerire split file pesanti

OBIETTIVO: < 700 righe context iniziale
```

---

## CHECKLIST IMPLEMENTAZIONE

### Sessione 215 (OGGI)

- [ ] FASE 1: Cleanup critico
  - [ ] Cancellare JSON reports
  - [ ] Cancellare ROADMAP obsolete
  - [ ] Cancellare PROMPT backup
  - [ ] Cancellare HANDOFF vecchi

- [ ] FASE 2: Hook base
  - [ ] file_size_guard.py (limiti file)
  - [ ] Testare su PROMPT_RIPRESA

### Sessione 216

- [ ] FASE 2: Hook completi
  - [ ] report_cleanup_guard.py
  - [ ] Integrare con pre-session-check

- [ ] FASE 3: Automazione
  - [ ] weekly_cleanup.sh
  - [ ] Launchd config
  - [ ] Test ciclo completo

### Validazione

- [ ] Test: creare file > limite → deve WARNING
- [ ] Test: > 50 reports → deve auto-archiviare
- [ ] Test: weekly cleanup → deve funzionare
- [ ] Guardiana Qualità: audit finale

---

## METRICHE SUCCESSO

| Metrica | Prima | Dopo | Target |
|---------|-------|------|--------|
| reports/ size | 19MB | <2MB | <5MB sempre |
| Context iniziale | 2335 righe | <700 | <1000 |
| File > 500 righe | 5+ | 0 | 0 |
| Cleanup manuale | Ogni sessione | Mai | Automatico |

---

## NOTA FINALE

```
+------------------------------------------------------------------+
|                                                                    |
|   "MAI PIÙ ACCUMULO!"                                             |
|                                                                    |
|   Non basta scrivere regole - servono MECCANISMI AUTOMATICI       |
|   che IMPEDISCONO fisicamente di superare i limiti.               |
|                                                                    |
|   Hook + Launchd + Check = PREVENZIONE REALE                      |
|                                                                    |
+------------------------------------------------------------------+
```

---

*"Prevenire è meglio che curare"*
*Sessione 215 - CervellaSwarm*
