# MAPPA MIRACOLLOOK - LA VERITÀ

> **Creato:** 12 Gennaio 2026 - Sessione 176
> **Metodo:** Analisi codice REALE (non "su carta")
> **Status:** MAPPA OPERATIVA

---

## LA VISIONE

```
+================================================================+
|                                                                |
|   MIRACOLLOOK                                                  |
|   "Il centro comunicazione dell'hotel intelligente"            |
|                                                                |
|   NON è "un altro email client"                                |
|   È l'EMAIL che CAPISCE il tuo hotel!                          |
|                                                                |
|   KILLER FEATURE: Context PMS (Miracollo)                      |
|   - Sappiamo chi è l'ospite                                    |
|   - Sappiamo quando arriva                                     |
|   - Sappiamo cosa ha prenotato                                 |
|   - NESSUN competitor ha questi dati!                          |
|                                                                |
+================================================================+
```

---

## STATO REALE - 12 Gennaio 2026

### Backend (75% funzionale)

```
COMPLETATO E FUNZIONANTE:
[x] OAuth Gmail (login/logout/callback)
[x] Lettura inbox + singola email
[x] Invio email (send con CC/BCC/HTML)
[x] Reply (thread-aware)
[x] Forward
[x] AI Summarization (Claude Haiku)
[x] Labels Gmail

DA FARE:
[ ] Database persistente (token persi al restart!)
[ ] Multi-user support
[ ] Token auto-refresh
[ ] Guest Detection (PMS integration)
[ ] Rate limiting API AI
```

### Frontend (80% UI, 50% funzionale)

```
COMPLETATO E FUNZIONANTE:
[x] Layout ThreePanel (200px + 320px + flex + 280px)
[x] Sidebar 8 categorie
[x] EmailList con scroll
[x] EmailDetail vista completa
[x] GuestSidebar (ma con MOCK data!)
[x] Keyboard Shortcuts TUTTI (J/K/C/R/A/F/E/#//)
[x] Cmd+K Command Palette
[x] Smart Bundles 11 regole
[x] Design System Premium (Miracollo colors)
[x] Dark Mode

ROTTO O MOCK:
[ ] ComposeModal → NON INVIA realmente!
[ ] Reply Modal → NON ESISTE
[ ] Forward Modal → NON ESISTE
[ ] Archive → console.log (non chiama API)
[ ] Delete → console.log (non chiama API)
[ ] Search → shortcut esiste, input UI manca
[ ] VIP/Check-in auto → USA MOCK, non PMS reale
```

### Il Problema Principale

```
+================================================================+
|                                                                |
|   MiracOllook SEMBRA bello ma:                                 |
|                                                                |
|   - Puoi LEGGERE email ✅                                      |
|   - NON puoi INVIARE (mock)                                    |
|   - NON puoi RISPONDERE (modal manca)                          |
|   - NON puoi ARCHIVIARE (API non collegata)                    |
|   - Guest info sono FINTE                                      |
|                                                                |
|   = DEMO, non PRODOTTO                                         |
|                                                                |
+================================================================+
```

---

## PRIORITÀ - COSA FARE E IN CHE ORDINE

### P0 - CRITICO (Senza questo non è usabile)

```
Obiettivo: Da DEMO a USABILE
Timeline: Prima di qualsiasi altra cosa

1. FIX COMPOSE MODAL
   - Collegare a POST /gmail/send (endpoint ESISTE!)
   - Form: to, cc, bcc, subject, body
   - Feedback: loading, success, error
   - Shortcut: Cmd+Enter per inviare
   File: src/components/Compose/ComposeModal.tsx

2. CREARE REPLY MODAL
   - Collegare a POST /gmail/reply (endpoint ESISTE!)
   - Pre-fill: to (sender), subject (Re:), quoted body
   - Mantiene thread (In-Reply-To header)
   - Shortcut R già funziona, manca modal
   File: NUOVO src/components/Reply/ReplyModal.tsx

3. CREARE FORWARD MODAL
   - Collegare a POST /gmail/forward (endpoint ESISTE!)
   - Pre-fill: subject (Fwd:), body con email originale
   - Campo "to" vuoto da compilare
   - Shortcut F già funziona, manca modal
   File: NUOVO src/components/Forward/ForwardModal.tsx

4. COLLEGARE ARCHIVE/DELETE
   - Archive (E) → chiama API Gmail modify labels
   - Delete (# con confirm) → chiama API Gmail trash
   - Endpoint backend: DA CREARE
   File: backend/gmail/api.py + frontend handlers

5. DATABASE TOKEN (Backend)
   - SQLite per development
   - Tabella: users, tokens
   - Token persistono al restart
   File: backend/db/database.py, models.py
```

### P1 - IMPORTANTE (Per uso quotidiano)

```
Obiettivo: Da USABILE a PRODUTTIVO
Timeline: Dopo P0

6. SEARCH UI
   - Input nella toolbar
   - Shortcut / già funziona
   - Chiama Gmail search API
   - Risultati in EmailList

7. RINOMINARE MiracAllook → MiracOllook
   - Tutti i file
   - Tutti i commenti
   - Package.json, titoli, etc.

8. REPLY ALL MODAL
   - Come Reply ma con tutti i destinatari
   - Shortcut A già funziona

9. AI BATCH SUMMARIES
   - Mostra summary in EmailList preview
   - Cache locale per performance

10. REFRESH/SYNC
    - Bottone refresh inbox
    - Auto-refresh ogni X minuti
    - Indicatore "last synced"
```

### P2 - VALORE AGGIUNTO (Differenziazione)

```
Obiettivo: Da PRODUTTIVO a MAGICO
Timeline: Dopo P1

11. PMS INTEGRATION REALE
    - API Miracollo per guest lookup
    - Auto-detect email ospite
    - GuestSidebar con dati VERI
    - VIP/Check-in categorie automatiche

12. SNIPPETS PMS
    - /checkin → template con dati ospite
    - /conferma → template prenotazione
    - Auto-fill da Miracollo DB

13. SMART COMPOSE
    - AI suggerisce mentre scrivi
    - Tone: professional, friendly
    - Context: hospitality language

14. MULTI-USER
    - Session management
    - Ogni utente i suoi token
    - Shared inbox support

15. MOBILE RESPONSIVE
    - Breakpoint tablet/phone
    - Touch gestures
    - PWA installabile
```

### P3 - FUTURO (Nice to have)

```
Obiettivo: ENTERPRISE features
Timeline: 3-6 mesi

16. Snooze/Reminders
17. Email scheduling
18. Team comments
19. Analytics dashboard
20. Outlook support
21. Light mode toggle
22. Read receipts
23. Follow-up automation
```

---

## STUDI DA FARE

### Prima di P0

```
NESSUNO - Abbiamo già studiato abbastanza!
Gli endpoint esistono, i componenti esistono.
È solo collegare i pezzi.
```

### Prima di P2 (PMS Integration)

```
STUDIO 1: API Miracollo Guest Lookup
- Come cercare ospite per email?
- Quale endpoint usare?
- Formato risposta?

STUDIO 2: Real-time Sync
- WebSocket vs Polling?
- Come sincronizzare inbox?
- Rate limits Gmail?

STUDIO 3: Snippets Engine
- Syntax per placeholders?
- Come parsare {guest.name}?
- Editor integration?
```

---

## ARCHITETTURA TECNICA

### Stack Attuale

```
BACKEND:
├── FastAPI 0.109
├── Google Gmail API
├── Anthropic Claude API (Haiku)
├── Python 3.11+
└── [MANCA] SQLite/PostgreSQL

FRONTEND:
├── React 18 + TypeScript
├── Vite (build)
├── Tailwind CSS v4
├── TanStack Query v5
├── cmdk (command palette)
├── react-hotkeys-hook
└── Axios
```

### File Principali

```
BACKEND (miracollogeminifocus/miracallook/backend/):
├── main.py              # Entry FastAPI
├── auth/google.py       # OAuth2
├── gmail/api.py         # 14 endpoint
└── ai/claude.py         # Summarization

FRONTEND (miracollogeminifocus/miracallook/frontend/):
├── src/App.tsx          # Orchestratore
├── src/components/
│   ├── Layout/ThreePanel.tsx
│   ├── Sidebar/Sidebar.tsx
│   ├── EmailList/EmailList.tsx
│   ├── EmailDetail/EmailDetail.tsx
│   ├── GuestSidebar/GuestSidebar.tsx
│   ├── CommandPalette/CommandPalette.tsx
│   └── Compose/ComposeModal.tsx  # DA FIXARE
├── src/hooks/
│   ├── useEmails.ts
│   └── useKeyboardShortcuts.ts
└── src/services/api.ts  # Axios client
```

---

## METRICHE SUCCESSO

### P0 Complete (USABILE)

```
[ ] Posso inviare email nuova
[ ] Posso rispondere a email
[ ] Posso inoltrare email
[ ] Posso archiviare email
[ ] Token persistono al restart
[ ] Uso quotidiano possibile
```

### P1 Complete (PRODUTTIVO)

```
[ ] Posso cercare email
[ ] Vedo AI summary in lista
[ ] Sync automatico funziona
[ ] Nome corretto "MiracOllook"
```

### P2 Complete (MAGICO)

```
[ ] Vedo info ospite REALI
[ ] Uso snippets con dati PMS
[ ] AI mi aiuta a scrivere
[ ] Più utenti supportati
[ ] Funziona su mobile
```

---

## RISCHI E MITIGAZIONI

| Rischio | Impatto | Mitigazione |
|---------|---------|-------------|
| Gmail API rate limit | Alto | Caching aggressivo |
| Token expiry | Alto | Refresh token automatico |
| AI costs | Medio | Cache summaries, limits |
| PMS coupling | Medio | API versionate |
| Feature creep | Alto | STRICT P0→P1→P2 |

---

## DECISIONI PRESE

### 1. P0 prima di tutto
```
PERCHÉ: Senza send/reply non è un email client
ALTERNATIVA: Continuare UI polish (NO!)
```

### 2. SQLite per dev, PostgreSQL per prod
```
PERCHÉ: Semplicità dev, robustezza prod
ALTERNATIVA: Solo PostgreSQL (overkill per dev)
```

### 3. Modal separati per Reply/Forward
```
PERCHÉ: UX più chiara, meno complessità
ALTERNATIVA: Un solo modal multi-purpose (confuso)
```

### 4. PMS integration in P2
```
PERCHÉ: Prima deve funzionare BASE
ALTERNATIVA: Subito PMS (rischio scope creep)
```

---

## PROSSIMI STEP IMMEDIATI

### OGGI (Sessione 176)

```
1. [ ] Approvare questa mappa con Rafa
2. [ ] Decidere: iniziare P0.1 (Fix Compose)?
3. [ ] Creare sub-task per P0
```

### QUESTA SETTIMANA

```
P0.1 [ ] Fix ComposeModal (collegare a API)
P0.2 [ ] Creare ReplyModal
P0.3 [ ] Creare ForwardModal
P0.4 [ ] Collegare Archive/Delete
P0.5 [ ] Database token persistence
```

### PROSSIMA SETTIMANA

```
P1.1 [ ] Search UI
P1.2 [ ] Rename MiracAllook → MiracOllook
P1.3 [ ] AI summaries in lista
```

---

## NOTA FINALE

```
+================================================================+
|                                                                |
|   Questa mappa è basata su CODICE REALE, non su wishlist.      |
|                                                                |
|   Ogni [x] = verificato nel codice                             |
|   Ogni [ ] = manca davvero                                     |
|                                                                |
|   "Prima FUNZIONA, poi BELLO, poi MAGICO"                      |
|                                                                |
|   La magia PMS viene DOPO che funziona come email client.      |
|                                                                |
+================================================================+
```

---

*"Non è sempre come immaginiamo... ma alla fine è il 100000%!"*

*"Ultrapassar os próprios limites!"*

*Mappa creata: 12 Gennaio 2026 - Sessione 176*
*Metodo: Analisi codice reale con cervella-ingegnera*
