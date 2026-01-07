---
tipo: QUESTION
task_id: [TASK_ID]  # Es: TASK_001
worker: cervella-[TIPO]  # Il tuo nome: backend, frontend, etc.
urgenza: BASSA|MEDIA  # Questions di solito BASSA o MEDIA, raramente ALTA
timestamp: [AUTO]  # Timestamp ISO8601 - generato automaticamente
---

# QUESTION: [Titolo breve della domanda]

**Esempio:** "Quale library usare per date formatting?"

---

## 📋 Situazione

[Descrivi chiaramente il contesto e il dubbio che hai]

**Spiega:**
- Cosa stai facendo nel task
- A che punto sei arrivato
- Qual è il dubbio specifico che hai

**Esempio:**
> Sto implementando l'endpoint `/api/users` che deve restituire date formattate.
> Ho visto che in alcuni file usiamo `datetime.strftime()` direttamente, in altri usiamo la library `python-dateutil`.
> Non sono sicura quale pattern seguire per mantenere consistenza nel progetto.

---

## 🔍 Cosa Ho Provato

[Descrivi i tentativi che hai fatto per risolvere da sola]

**Lista i tuoi tentativi:**

- **Tentativo 1:** [cosa hai fatto] → [risultato]
- **Tentativo 2:** [cosa hai fatto] → [risultato]
- **Tentativo 3:** [cosa hai fatto] → [risultato]

**Esempio:**
- **Tentativo 1:** Cercato in `backend/` con grep "datetime" → Trovato 15 file, pattern diversi
- **Tentativo 2:** Letto `docs/DECISIONI_TECNICHE.md` → Nessuna menzione di date formatting
- **Tentativo 3:** Guardato import in `auth.py` (il reference) → Usa `strftime()` diretto

---

## ❓ Domanda Specifica

[Cosa ti serve sapere dalla Regina per procedere?]

**Sii specifica! Meglio domanda chiusa che aperta:**

✅ **BUONO:** "Dovrei usare `datetime.strftime()` o `python-dateutil` per formattare date negli endpoint API?"

❌ **VAGO:** "Come gestisco le date?"

**La tua domanda:**

[SCRIVI QUI LA DOMANDA SPECIFICA]

**Opzioni che vedi (se applicabile):**
- **Opzione A:** [descrizione] - Pro: [...] / Contro: [...]
- **Opzione B:** [descrizione] - Pro: [...] / Contro: [...]

**Esempio:**
> **Domanda:** Dovrei usare `datetime.strftime()` nativo o `python-dateutil` per formattare date negli endpoint API?
>
> **Opzioni:**
> - **strftime() nativo:** Pro: zero dependencies, veloce / Contro: meno flessibile per timezone
> - **python-dateutil:** Pro: più potente, timezone-aware / Contro: dependency extra

---

## 💥 Impatto

[Quanto questo dubbio blocca il tuo lavoro?]

**Seleziona UNO (o più se applicabile):**

- [ ] Posso continuare su altre parti del task mentre aspetto risposta
- [ ] Sono bloccata e non posso procedere senza risposta
- [ ] Rischio di fare scelte sbagliate senza chiarimento (poi refactor pesante)
- [ ] È solo una best practice, non blocca il lavoro

**Tempo stimato bloccato:** [es: "Posso lavorare altre 2-3h su test mentre aspetto" oppure "Completamente bloccata"]

**Esempio:**
- [x] Posso continuare su altre parti del task mentre aspetto
- [ ] Sono bloccata e non posso procedere senza risposta
- [x] Rischio di fare scelte sbagliate senza chiarimento

**Tempo:** Posso scrivere i test mentre aspetto, ma implementazione endpoint è bloccata (1-2h disponibili).

---

## 📎 File Rilevanti (se applicabile)

[Lista file che aiutano a capire il contesto della domanda]

**Formato:** `path/to/file.py:123` - [perché è rilevante]

**Esempio:**
- `backend/routers/auth.py:45-67` - Pattern attuale che usa `strftime()` diretto
- `backend/utils/time.py:12` - Helper esistente per timezone (usa `dateutil`)
- `requirements.txt:34` - `python-dateutil==2.8.2` già installato

---

## 🤔 Perché Non Ho Deciso Da Sola

[Breve spiegazione del perché chiedi invece di decidere]

**Esempio:**
> Ho visto pattern inconsistenti nel codebase. Preferisco chiedere per evitare di aggiungere ulteriore inconsistenza. Meglio 5 minuti di chiarimento ora che 2 ore di refactor dopo!

---

**Worker in attesa di risposta dalla Regina!** 💙

_Ricorda: domande chiare aiutano la Regina a rispondere velocemente! 🐝👑_

---

_Template versione: 1.0.0 | Tipo: QUESTION | Basato su PROTOCOLLI_COMUNICAZIONE.md v1.0.0_
