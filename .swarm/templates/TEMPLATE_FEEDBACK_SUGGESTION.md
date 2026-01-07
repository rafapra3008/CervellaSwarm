---
tipo: SUGGESTION
task_id: [TASK_ID]  # Es: TASK_001 (se correlato a task specifico)
worker: cervella-[TIPO]  # Il tuo nome: backend, frontend, etc.
urgenza: BASSA  # Suggestions sono di solito BASSA urgenza (idee di miglioramento)
timestamp: [AUTO]  # Timestamp ISO8601 - generato automaticamente
scope: task|project|general  # task = solo questo task, project = progetto, general = processo/workflow
---

# 💡 SUGGESTION: [Titolo breve dell'idea]

**Esempio:** "Aggiungere caching Redis per migliorare performance API"

---

## 🌟 L'Idea

[Descrizione chiara della tua proposta di miglioramento]

**Cosa proponi:**

[Spiega l'idea in modo che Regina capisca subito il valore]

**Esempio:**
> Mentre implementavo gli endpoint `/api/users`, ho notato che alcune query (es: lista completa utenti) sono lente (~800ms).
>
> **Proposta:** Aggiungere layer di caching Redis per endpoint GET che non cambiano frequentemente.
>
> **Benefici attesi:**
> - Response time da 800ms a ~50ms (16x più veloce!)
> - Riduce carico database
> - Migliore UX per frontend

---

## 🎯 Scope del Miglioramento

**Impatta:**

- [ ] **Solo questo task** - Migliora solo il task corrente
- [ ] **Tutto il progetto** - Beneficio per tutto il progetto
- [ ] **Processo generale** - Migliora il workflow dello sciame

**Esempio:**
- [x] **Tutto il progetto** - Tutti gli endpoint GET possono beneficiare
- Pattern riutilizzabile per futuri endpoint

---

## 📊 Problema/Opportunità che Risolve

[Quale problema attuale risolverebbe, o quale opportunità coglierebbe]

**Situazione attuale:**

[Cosa c'è ora che non è ottimale]

**Con il miglioramento:**

[Come sarebbe dopo l'implementazione]

**Esempio:**
- **Ora:** Query database diretta ogni volta, lento per liste grandi (1000+ utenti)
- **Dopo:** Cache in Redis (TTL 5min), database chiamato solo se cache miss
- **Risultato:** 95% requests servite da cache → 16x più veloce

---

## 🔨 Come Implementare

[La tua idea di implementazione - anche solo sketch, non serve dettaglio completo]

**Step proposti:**

1. [Passo 1]
2. [Passo 2]
3. [Passo 3]

**Tecnologie/librerie:**
- [Cosa servirebbe]

**Esempio:**
1. Aggiungere Redis al `docker-compose.yml`
2. Installare `redis-py` library
3. Creare decorator `@cache_response(ttl=300)` per endpoint
4. Applicare decorator a GET endpoints read-only
5. Invalidare cache su POST/PUT/DELETE

**Tech stack:**
- Redis 7.x (già in docker-compose? Da verificare)
- `redis-py` library (leggera, ben documentata)
- Decorator pattern (già usato per auth, consistente!)

---

## ⚖️ Pro & Contro

[Analisi onesta della proposta]

### ✅ Vantaggi

- [Vantaggio 1]
- [Vantaggio 2]
- [Vantaggio 3]

### ❌ Svantaggi / Trade-off

- [Svantaggio 1]
- [Svantaggio 2]
- [Svantaggio 3]

**Esempio:**

### ✅ Vantaggi
- Performance 16x migliore (grande!)
- Riduce carico DB (scalabilità)
- Pattern riusabile per futuri endpoint
- User experience migliore (velocità)

### ❌ Svantaggi
- Aggiunge dependency (Redis)
- Cache invalidation è tricky (complexity)
- Serve testing per cache consistency
- Memoria Redis da monitorare

---

## 📅 Priorità Suggerita

[Quando pensi dovrebbe essere implementato]

**Opzioni:**

- [ ] **SUBITO** - Critico, dovremmo farlo ora
- [ ] **PROSSIMO SPRINT** - Importante, da pianificare presto
- [ ] **BACKLOG** - Bella idea, quando c'è tempo
- [ ] **NICE TO HAVE** - Non urgente, opzionale

**Perché questa priorità:**

[Giustifica la tua scelta]

**Esempio:**
- [x] **PROSSIMO SPRINT** - Importante per UX ma non blocca nulla ora
- **Perché:** Performance sono accettabili (800ms non è terribile), ma utenti si lamenterebbero con 10k+ utenti. Meglio farlo prima di lanciare in produzione.

---

## 💭 Alternative Considerate

[Hai pensato ad altre soluzioni? Perché questa è la migliore?]

**Altre opzioni:**

- **Alternativa A:** [descrizione] → [perché scartata]
- **Alternativa B:** [descrizione] → [perché scartata]

**Esempio:**
- **Alt A:** Ottimizzare query SQL con index → PRO: no new dependency, CONTRO: gain limitato (~300ms, non abbastanza)
- **Alt B:** In-memory cache Python (lru_cache) → PRO: zero dependency, CONTRO: non condiviso tra worker, perde cache a restart
- **Scelta Redis:** Migliore balance tra performance e scalabilità

---

## 🧪 Effort Stimato

[Quanto lavoro richiederebbe, secondo te]

**Tempo stimato:** [X ore/giorni]

**Complessità:** BASSA|MEDIA|ALTA

**Chi potrebbe farlo:**
- [Worker più adatto per questo task]

**Esempio:**
- **Tempo:** 4-6 ore (1 persona, full focus)
  - 1h: Setup Redis + docker
  - 2h: Implementare decorator + integration
  - 1h: Testing
  - 1h: Documentazione
- **Complessità:** MEDIA (Redis è standard, decorator pattern conosciuto)
- **Chi:** cervella-backend (io posso farlo!) oppure cervella-devops per Redis setup

---

## 🔗 Riferimenti / Ispirazione

[Dove hai trovato l'idea? Link, progetti simili, docs]

**Risorse:**
- [Link 1 - descrizione]
- [Link 2 - descrizione]
- [Progetto simile che lo fa bene]

**Esempio:**
- FastAPI caching docs: https://fastapi.tiangolo.com/advanced/caching/
- Redis Python guide: https://redis.io/docs/clients/python/
- Esempio progetto simile: FastAPI-cache library (potremmo usarla!)

---

## 🎤 Nota Personale

[Perché ci tieni a questa idea? Motivazione personale]

**Esempio:**
> Ho visto quanto le performance impattano UX nei progetti precedenti. Gli utenti percepiscono la differenza tra 50ms e 800ms, anche se non sanno quantificarla.
>
> Questa è una win facile con grande impatto. Vale assolutamente la pena! 💙

---

## 🤔 Cosa Serve dalla Regina

[Cosa ti aspetti dalla Regina riguardo questa proposta]

**Opzioni:**

- [ ] **Feedback sull'idea** - È una buona idea? Meglio altro approccio?
- [ ] **Decisione go/no-go** - Procedo o lasciamo stare?
- [ ] **Prioritizzazione** - Quando la facciamo?
- [ ] **Solo FYI** - Idea sul tavolo, decidi tu se/quando

**Esempio:**
- [x] **Decisione go/no-go** + **Prioritizzazione**
  - Se ti piace l'idea, posso creare task dettagliato per prossimo sprint?
  - Oppure rimando a dopo il lancio MVP?

**Tempo risposta:** Non urgente, rispondi quando puoi! 😊

---

**Worker ha condiviso un'idea - feedback benvenuto!** 💡💙

_Le migliori idee vengono dal lavoro sul campo! 🐝👑_

---

## 📋 Checklist Regina (per decisione)

[Helper per Regina - cosa valutare]

Quando valuti questa suggestion, considera:

- [ ] Allineata con NORD e roadmap?
- [ ] ROI vale l'effort? (beneficio vs costo)
- [ ] Timing giusto? (ora vs dopo vs mai)
- [ ] Worker giusto disponibile?
- [ ] Impatto su altri task/worker?
- [ ] Technical debt o investment?

---

_Template versione: 1.0.0 | Tipo: SUGGESTION | Basato su PROTOCOLLI_COMUNICAZIONE.md v1.0.0_
