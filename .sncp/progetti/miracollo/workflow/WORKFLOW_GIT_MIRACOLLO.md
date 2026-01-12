# WORKFLOW GIT MIRACOLLO
> Data: 12 Gennaio 2026 - Sessione 177
> Status: PROPOSTA (da validare con Rafa)

---

## IL PROBLEMA

```
+------------------------------------------------------------------+
|  CICLO VIZIOSO (prima):                                          |
|                                                                  |
|  1. Fix urgente su VM (prod)                                     |
|  2. Dimentichiamo di committare                                  |
|  3. Qualcuno pusha da locale                                     |
|  4. Fix perso!                                                   |
|  5. Frustrazione: "Basta locale!"                                |
|                                                                  |
|  MA senza locale non possiamo testare...                         |
+------------------------------------------------------------------+
```

---

## LA SOLUZIONE

```
+------------------------------------------------------------------+
|                                                                  |
|   GIT = UNICA FONTE DI VERITA                                   |
|                                                                  |
|   - Ogni modifica passa da Git                                   |
|   - VM fa solo PULL (mai edit senza commit)                      |
|   - Locale fa test + push                                        |
|   - GitHub Actions fa deploy                                     |
|                                                                  |
+------------------------------------------------------------------+
```

---

## WORKFLOW NUOVO

### Scenario 1: Sviluppo Normale

```
LOCALE                      GIT                         VM
  |                          |                           |
  |  1. Scrivo codice        |                           |
  |  2. Testo in locale      |                           |
  |  3. git push ------>     |                           |
  |                          |  4. GitHub Actions        |
  |                          |     deploya ----------->  |
  |                          |                           |  5. Pull + restart
  |                          |                           |  6. LIVE!
```

### Scenario 2: Fix Urgente su VM

```
VM                          GIT                         LOCALE
  |                          |                           |
  |  1. Fix urgente!         |                           |
  |  2. git add + commit     |                           |
  |  3. git push ------>     |                           |
  |                          |  4. Codice aggiornato     |
  |                          |                           |  5. git pull
  |                          |                           |  (locale sincronizzato)
```

**REGOLA D'ORO:** Se tocchi codice su VM, COMMIT + PUSH subito!

### Scenario 3: Test Feature Rischiosa (es. Autopilot)

```
LOCALE                      GIT                         VM
  |                          |                           |
  |  1. Sviluppo feature     |                           |
  |  2. Test con DB locale   |                           |
  |  3. Funziona? SI         |                           |
  |  4. git push ------>     |                           |
  |                          |  5. GitHub Actions        |
  |                          |     deploya ----------->  |
  |                          |                           |  6. LIVE!
```

---

## SETUP AMBIENTE LOCALE (una tantum)

### 1. Sincronizza da Git
```bash
cd ~/Developer/miracollogeminifocus
git pull origin master
```

### 2. Copia DB da VM (dati reali per test)
```bash
# Dalla VM, copia il DB
scp miracollo-cervella:/app/miracollo/backend/data/miracollo.db \
    ~/Developer/miracollogeminifocus/backend/data/miracollo_test.db
```

### 3. Avvia ambiente locale
```bash
cd ~/Developer/miracollogeminifocus
docker-compose up -d
# Backend: http://localhost:8001
# Frontend: http://localhost:8080
```

### 4. Testa
```bash
curl http://localhost:8001/health
```

---

## REGOLE SACRE

### 1. MAI PERDERE LAVORO
```
Se modifichi su VM:
  → git add . && git commit -m "Fix: descrizione" && git push

SEMPRE. SUBITO. SENZA ECCEZIONI.
```

### 2. LOCALE = TEST
```
Locale serve per:
  - Testare feature nuove
  - Debug complessi
  - Sviluppo senza rischio

Locale NON serve per:
  - Fix urgenti (quelli su VM, con commit immediato)
```

### 3. GIT = VERITÀ
```
Se c'è conflitto tra locale e VM:
  → GIT ha ragione
  → Risolvi il conflitto
  → Mai sovrascrivere senza merge
```

### 4. GITHUB ACTIONS = DEPLOY
```
Push su master = Deploy automatico su VM
  - Health check
  - Rollback se fallisce
  - Zero intervento manuale
```

---

## CHECKLIST PRIMA DI PUSHARE

```
[ ] Ho testato in locale?
[ ] Il codice compila/funziona?
[ ] Ho fatto git pull prima? (evita conflitti)
[ ] Il commit message è chiaro?
```

---

## CHECKLIST FIX URGENTE SU VM

```
[ ] Ho fixato il problema?
[ ] Ho fatto git add?
[ ] Ho fatto git commit con messaggio chiaro?
[ ] Ho fatto git push?
[ ] Ho avvisato il team? (opzionale)
```

---

## VANTAGGI

1. **Mai perdere lavoro** - Tutto in Git
2. **Test sicuri** - Locale non tocca prod
3. **Rollback facile** - Git history
4. **Collaborazione** - Tutti sincronizzati
5. **Audit trail** - Chi ha fatto cosa, quando

---

## DOMANDE APERTE PER RAFA

1. **Chi accede alla VM?**
   - Solo Cervelle via GitHub Actions?
   - O anche Rafa manualmente?

2. **Frequenza sync DB?**
   - Copia DB da VM a locale ogni settimana?
   - O solo quando serve?

3. **Branch strategy?**
   - Tutto su master?
   - O feature branch per cose grosse?

---

*"Lavorare organizzati = Mai perdere lavoro!"*
*"Git è la fonte di verità, sempre."*
