# TASK: Popolare Database con Lezioni Apprese

**Assegnato a:** cervella-data
**Priorità:** ALTA
**Creato:** 8 Gennaio 2026 - Sessione 123
**Sprint:** 1.3 - Popolamento Database

---

## 🎯 OBIETTIVO

Inserire **15 lezioni apprese** nel database swarm_memory usando le query SQL preparate da cervella-researcher.

---

## 📚 CONTESTO

**INPUT:**
- File: `docs/studio/RICERCA_LEZIONI_SESSIONI_119_122.md`
- 18 lezioni identificate
- Top 15 selezionate dalla Regina
- Query SQL già preparate (righe 366-593)

**STATO ATTUALE:**
- Database swarm_memory ha 0 lezioni
- Schema database esiste (verificato in sessioni passate)
- Serve popolare con lezioni REALI

---

## 📋 TASK SPECIFICI

### 1. VERIFICA DATABASE
- Trova database swarm_memory.db (probabilmente in ~/.claude/ o progetto locale)
- Verifica schema tabella `lessons_learned`
- Controlla campi: title, description, category, impact, tags, session_id, project_id, created_at
- Se schema non corrisponde alle query, adatta query

### 2. PREPARAZIONE QUERY
- Leggi query SQL da `docs/studio/RICERCA_LEZIONI_SESSIONI_119_122.md` (righe 366-593)
- Crea file `scripts/data/populate_lessons_v123.sql` con le 15 query
- Top 15 lezioni (ordinate per priorità):
  1. Headless di Default
  2. Context Overhead Misurabile
  3. tmux invece Terminal.app
  4. Comunicazione = Filesystem
  5. Ricerca → Implementazione
  6. Carica SOLO Ciò Che Serve
  7. Test Subito Dopo Impl.
  8. Documentation WHILE Coding
  9. "La Magia Nascosta"
  10. Worker Background Senza GUI
  11. Output Buffering Blocca Log
  12. Ottimizzazioni Aggressive OK
  13. Eventi Recenti > Storia
  14. Versioning Semantico
  15. Log File Separati

### 3. INSERIMENTO
- Esegui query SQL sul database
- Verifica nessun errore di inserimento
- Controlla che tutte le 15 lezioni siano state inserite

### 4. VERIFICA POST-INSERIMENTO
```sql
-- Conta lezioni
SELECT COUNT(*) FROM lessons_learned;

-- Raggruppa per categoria
SELECT category, COUNT(*) FROM lessons_learned GROUP BY category;

-- Raggruppa per impatto
SELECT impact, COUNT(*) FROM lessons_learned GROUP BY impact;

-- Mostra tutte le lezioni
SELECT title, category, impact FROM lessons_learned ORDER BY category;
```

### 5. REPORT
Crea report in `docs/data/REPORT_POPOLAMENTO_LEZIONI_v123.md` con:
- Quante lezioni inserite
- Breakdown per categoria
- Breakdown per impatto
- Query verifica eseguite
- Eventuali problemi/warning

---

## 📤 OUTPUT RICHIESTO

**File 1:** `scripts/data/populate_lessons_v123.sql`
- Query SQL per inserire 15 lezioni

**File 2:** `docs/data/REPORT_POPOLAMENTO_LEZIONI_v123.md`
- Report completo popolamento

**Verifica:**
- [ ] Database ha 15 nuove lezioni
- [ ] Categorie: spawn-workers (3), context (3), comunicazione (3), decisioni (3), workflow (3)
- [ ] Impact: HIGH (8), MEDIUM (6), LOW (1)

---

## ✅ CRITERI DI SUCCESSO

- [x] Database trovato e schema verificato
- [x] 15 lezioni inserite correttamente
- [x] Nessun errore SQL
- [x] Report completo creato
- [x] Query verifica mostrano dati corretti

---

## 💡 SUGGERIMENTI

- Se database non trovato in ~/.claude/, cerca in progetto corrente
- Se schema diverso, adatta query ma SENZA perdere informazioni
- Usa transazione per rollback in caso di errore
- Testa prima 1 lezione, poi tutte le 15

---

## ⏰ TEMPO STIMATO

30-45 minuti

---

**Buon lavoro, cervella-data!** 📊

*La Regina conta su di te per dare memoria allo sciame!*
