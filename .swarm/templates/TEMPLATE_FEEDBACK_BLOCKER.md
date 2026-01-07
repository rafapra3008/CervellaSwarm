---
tipo: BLOCKER
task_id: [TASK_ID]  # Es: TASK_001
worker: cervella-[TIPO]  # Il tuo nome: backend, frontend, etc.
urgenza: CRITICA  # Blockers sono SEMPRE urgenza CRITICA!
timestamp: [AUTO]  # Timestamp ISO8601 - generato automaticamente
---

# 🚫 BLOCKER: [Titolo breve del blocco]

**Esempio:** "Impossibile procedere - API key mancante per servizio esterno"

---

## 🛑 BLOCCO TOTALE

[Descrizione chiara di cosa ti blocca COMPLETAMENTE]

**Cosa è bloccato:**

[Spiega perché non puoi assolutamente procedere]

**Esempio:**
> Non posso completare il task perché l'endpoint deve chiamare l'API di Stripe, ma non ho la API key.
> Ho cercato in:
> - `.env` file (non presente)
> - Documentazione progetto (nessuna menzione)
> - File config (vuoto)
>
> Senza API key è IMPOSSIBILE testare o implementare l'integrazione.

---

## ⏱️ Da Quanto Sei Bloccata

[Quando ti sei bloccata? Da quanto aspetti?]

**Timeline:**
- **Blocco iniziato:** [timestamp o "X minuti fa"]
- **Tentativi fatti:** [quanti tentativi di sbloccarti da sola]
- **Tempo perso:** [stima del tempo speso in debug/tentativi]

**Esempio:**
- **Blocco iniziato:** 30 minuti fa (alle 14:30)
- **Tentativi fatti:** 5 tentativi diversi di trovare la key
- **Tempo perso:** ~25 minuti in ricerca infruttuosa

---

## 🔍 Cosa Ho Provato PER SBLOCCARMI

[TUTTI i tentativi che hai fatto - è importante vedere che hai provato MOLTO prima di escalare]

**Tentativi (sii esaustiva!):**

1. **[Tentativo 1]** → [risultato]
2. **[Tentativo 2]** → [risultato]
3. **[Tentativo 3]** → [risultato]
4. **[Tentativo 4]** → [risultato]
5. **[Tentativo 5]** → [risultato]

**Esempio:**
1. **Cercato `.env` file** → Non esiste nel progetto
2. **Grep "STRIPE" in tutto il repo** → Zero risultati
3. **Letto `docs/setup/` completo** → Nessuna menzione API keys
4. **Controllato `backend/config.py`** → Ha placeholder `STRIPE_KEY = os.getenv("STRIPE_KEY")` ma env var non settata
5. **Cercato in `~/.bashrc` e `~/.zshrc`** → Nessuna env var Stripe
6. **Guardato 1Password/secrets manager** → Non ho accesso (credenziali di Rafa)

---

## 🎯 Cosa Serve ESATTAMENTE per Sbloccarmi

[Sii SPECIFICA! Cosa ti serve dalla Regina per riprendere a lavorare?]

**Opzioni chiare:**

- [ ] **Informazione mancante** - [quale informazione specifica]
- [ ] **Credenziali/Access** - [quale account/sistema]
- [ ] **Decisione tecnica** - [quale decisione serve]
- [ ] **Fix da altro worker** - [cosa deve fare e chi]
- [ ] **Chiarimento scope** - [cosa è poco chiaro nel task]

**Esempio:**
- [x] **Credenziali/Access** - Stripe API key (test mode va bene per ora)
  - Dove metterla: `.env` file (creo io)
  - Formato: `STRIPE_SECRET_KEY=sk_test_...`

**Alternative (se esistono):**
- **Alternativa A:** [descrizione] - Preferenza: [alta/media/bassa]
- **Alternativa B:** [descrizione] - Preferenza: [alta/media/bassa]

**Esempio alternative:**
> - **Alt A:** Stripe API key reale → Preferenza: ALTA (test completo)
> - **Alt B:** Mocko chiamate API per ora → Preferenza: BASSA (non testo integrazione vera)

---

## 💥 Impatto del Blocco

[Cosa succede se rimango bloccata]

**Impatto immediato:**
- [Cosa non posso fare ORA]

**Impatto sul task:**
- [Come impatta il completamento del task]

**Impatto sul progetto:**
- [Se blocca altri task/worker]

**Esempio:**
- **Immediato:** Ferma al 40% del task, non posso procedere
- **Sul task:** Task IMPOSSIBILE da completare senza API key
- **Sul progetto:** Blocca anche TASK_053 (frontend checkout) che dipende da questo

---

## 🔄 Cosa Posso Fare Nel Frattempo

[C'è qualcosa di produttivo che puoi fare mentre aspetti? O sei 100% bloccata?]

**Opzioni:**

- [ ] **Nulla** - Completamente bloccata, non posso fare altro
- [ ] **Altre parti del task** - Posso lavorare su [X] mentre aspetto
- [ ] **Altro task** - Posso switchare temporaneamente su altro task
- [ ] **Documentazione** - Posso documentare quello fatto finora

**Esempio:**
- [x] **Altre parti task** - Posso scrivere test (mockati) mentre aspetto
- Stima tempo disponibile: 1-2 ore max prima di essere 100% bloccata

**Se nulla:**
> Completamente bloccata. Ho esplorato tutte le strade. Aspetto risposta Regina per riprendere.

---

## 📎 Contesto Aggiuntivo

[Ogni altra informazione che aiuta Regina a capirti e sbloccarti VELOCE]

**File rilevanti:**
- `path/to/file:line` - [perché rilevante]

**Link/riferimenti:**
- [URL documentazione]
- [Issue simile passato]

**Esempio:**
- `backend/integrations/stripe.py:23` - Punto dove serve la API key
- `docs/integrations/payment.md` - Documentazione (incompleta) integrazione payment
- Stripe docs: https://stripe.com/docs/keys (come trovare le key)

---

## ⏰ URGENZA MASSIMA

**Tempo prima di timeout task:** [X minuti rimanenti]

**Regina, serve aiuto SUBITO!** 🚨

**Esempio:**
> Task ha timeout 120 min. Già passati 45 min (30 di lavoro + 15 bloccata).
> Restano 75 min ma se non ho key nei prossimi 15-20 min, non ce la faccio a finire.

---

**Worker BLOCCATA - Serve intervento immediato Regina!** 🚫🚨👑

_Ho fatto TUTTO il possibile da sola. Ora serve te! 💙_

**Status aggiornato:** BLOCKED (automatico quando crei questo feedback)

---

_Template versione: 1.0.0 | Tipo: BLOCKER | Basato su PROTOCOLLI_COMUNICAZIONE.md v1.0.0_
