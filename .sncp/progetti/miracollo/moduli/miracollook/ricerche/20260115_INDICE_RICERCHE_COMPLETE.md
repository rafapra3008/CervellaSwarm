# INDICE COMPLETO - Ricerche Miracollook

> **Data Audit:** 15 Gennaio 2026
> **Ricercatrice:** Cervella Researcher
> **Missione:** Catalogare tutte le ricerche esistenti per Miracollook

---

## EXECUTIVE SUMMARY

**STATO:** Miracollook ha **ECCELLENTI ricerche** ma codice limitato.

**VALORE RICERCHE:**
- 20+ documenti di ricerca (oltre 10.000 righe totali!)
- Analisi competitor professionali (Shortwave, Superhuman, Gmail, Outlook)
- Design specs pronte per implementazione
- Best practices UX/UI documentate

**PROBLEMA:** La maggior parte delle ricerche NON è stata implementata nel codice.

**OPPORTUNITÀ:** Abbiamo 35h di lavoro già STUDIATO e SPECIFICATO. Basta implementare!

---

## RICERCHE PER FEATURE

### 🎨 DESIGN & UX

#### 1. UX Strategy Completa
**File:** `studi/UX_STRATEGY_MIRACALLOOK.md`
**Contenuto:**
- 3 User Personas dettagliate (Laura Receptionist, Marco Manager, Elena Owner)
- 4 User Flows critici (Triage mattutino, VIP response, Guest inquiry, Conflict resolution)
- Emotional design & Visual hierarchy
- Density recommendations & Brand consistency
- Competitive positioning

**Pronto per implementare:** ✅ SI - Usare come guida per tutte le decisioni UX

---

#### 2. Design Patterns Email Clients
**File:** `studi/DESIGN_PATTERNS_EMAIL.md`
**Contenuto:**
- Layout proportions (sidebar 20%, list 35-40%, detail 40-45%)
- Typography system (Inter/SF Pro, 14-16px body, line-height 1.5-1.6)
- Color schemes dark mode (#121212, text opacity 87%/60%/38%)
- 8px spacing grid system
- Component patterns & animations (200-300ms transitions)

**Pronto per implementare:** ✅ SI - Design system completo

---

#### 3. Design Salutare per gli Occhi (Apple Style)
**File:** `studi/RICERCA_DESIGN_SALUTARE.md`
**Contenuto:**
- Apple Human Interface Guidelines per dark mode
- Palette colori Apple (#1C1C1E invece di nero puro)
- Contrasto ottimale WCAG AA/AAA (4.5:1 / 7:1)
- Calm colors: bluish-gray + soft blues
- Auto dark/light switch basato su ora del giorno

**Pronto per implementare:** ⚠️ PARZIALE - Manca fix Tailwind v4 custom colors

---

#### 4. Email List Design Best Practices
**File:** `studi/RICERCA_EMAIL_LIST_DESIGN.md`
**Contenuto:**
- Spacing: 8px grid, 12-16px padding per item
- Typography hierarchy: sender bold, subject 14-16px
- Unread indicators: bold + dot/background
- Grouping: sticky headers (Today/Yesterday/Last Week)
- Hover states: 5-10% opacity + quick actions reveal

**Pronto per implementare:** ✅ SI - Specifiche dettagliate

---

#### 5. Tailwind v4 Custom Colors (FIX)
**File:** `studi/RICERCA_TAILWIND_V4_CUSTOM_COLORS.md`
**Contenuto:**
- Tailwind v4 CSS-first approach (`@theme` directive)
- Problema: `tailwind.config.js` NON genera utility classes in v4
- Soluzione: usare `@theme` con CSS variables in `index.css`
- Esempio completo per palette Miracollook

**Pronto per implementare:** ✅ SI - Fix bloccante per Design Salutare

---

### ⚙️ TECHNICAL FEATURES

#### 6. Resizable Panels
**File:** `studi/RICERCA_RESIZE_PANNELLI.md`
**Contenuto:**
- Raccomandazione: `react-resizable-panels` (bvaughn)
- Analisi: 316k+ dipendenti npm, TypeScript nativo, 8-10KB bundle
- Best practices UX: min/max size, snap points, keyboard shortcuts
- Code examples React 19 + Tailwind v4
- Competitor analysis: Missive, Superhuman, VS Code, Linear

**Pronto per implementare:** ✅ SI - Libreria scelta + esempi codice

---

#### 7. Resizable Panels v4 API (UPDATE)
**File:** `studi/RICERCA_RESIZABLE_PANELS_V4.md`
**Contenuto:**
- Breaking changes v4 ANNULLATI (rollback)
- API v4.4.0 identica a v3.x (`PanelGroup`, `Panel`, `PanelResizeHandle`)
- Documentazione ufficiale corretta
- NO cambiamenti necessari nell'implementazione

**Pronto per implementare:** ✅ SI - Conferma che v4 usa stessa API

---

#### 8. Quick Actions & Keyboard Shortcuts
**File:** `studi/RICERCA_QUICK_ACTIONS_KEYBOARD.md`
**Contenuto:**
- Hover timing: 150-200ms button states, 300-500ms dropdown
- Quick actions on hover: Archive, Delete, Snooze, Star (max 4)
- Keyboard shortcuts standard: j/k navigation, e=archive, r=reply, c=compose
- React implementation: `useKeyPress` hook + `setTimeout` + ARIA

**Pronto per implementare:** ✅ SI - Pattern completi con esempi

---

#### 9. Gmail Attachments API
**File:** `studi/RICERCA_GMAIL_ATTACHMENTS.md`
**Contenuto:**
- Download endpoint: `/users/me/messages/{id}/attachments/{attachmentId}`
- Upload: MIME multipart base64 encoding
- Limiti: 25MB email totale, 35MB con encoding
- Approccio: Backend FastAPI streaming, download on-demand

**Pronto per implementare:** ✅ SI - API documentata completamente

---

#### 10. Upload Attachments (DESIGN SPECS)
**File:** `decisioni/UPLOAD_ATTACHMENTS_SPECS.md` + `studi/RICERCA_UPLOAD_ATTACHMENTS.md`
**Contenuto:**
- Approccio: Multipart/form-data (NO base64 overhead +33%)
- Backend: FastAPI `UploadFile` + `MIMEMultipart` + `MIMEBase`
- Frontend: `<input type="file">` + `FormData` + preview thumbnails
- Hook `useAttachments.ts` con cleanup automatico

**Pronto per implementare:** ✅ SI - Specs complete (~4h effort)

---

#### 11. Attachments Performance Optimization
**File:** `studi/RICERCA_ATTACHMENTS_PERFORMANCE.md`
**Contenuto:**
- Problema: download 30-40s troppo lento
- Strategia 3 fasi: Streaming+Compression (-40%), Redis Cache (-60%), Eager Loading
- Competitor analysis: Gmail prefetching, Outlook headers-only, Apple Mail background sync
- Guadagno atteso: da 30-40s a 2-5s (riduzione 80-90%)

**Pronto per implementare:** ⚠️ MEDIO TERMINE - Richiede Redis + architettura caching

---

#### 12. Performance Email Clients - Come Sembrano Istantanei
**File:** `studi/RICERCA_PERFORMANCE_EMAIL_CLIENTS.md`
**Contenuto:**
- 5 strategie chiave: Prefetching, Multi-level caching, Optimistic UI, Lazy loading, Background sync
- Gmail: Image prefetching + Google proxy
- Outlook: Headers-only + chunked download
- Superhuman: Target <100ms per azione
- Apple Mail: Background sync intelligente

**Pronto per implementare:** ⚠️ ROADMAP - Guida architetturale per P2/P3

---

### 🎯 FEATURES MANCANTI (con ricerca fatta!)

#### 13. Context Menu (READY!)
**File:** `studi/RICERCA_CONTEXT_MENU*.md` (4 parti, 2000+ righe!) + `decisioni/CONTEXT_MENU_DESIGN_SPECS.md`
**Contenuto:**
- Analisi 4 client: Gmail (simplicity), Outlook (power), Superhuman (keyboard), Apple Mail (native)
- 3 gruppi: Quick Actions (Reply/Forward/Archive/Star), Organize (Label/Move/Assign/Mark), **Hotel Actions** (Link Booking/Create Note/Guest Profile)
- React implementation: positioning, keyboard nav, ARIA, Portal pattern
- Librerie: react-contexify, @radix-ui, custom
- **DIFFERENZIATORE:** Hotel Actions = NESSUN competitor ha questo!

**Pronto per implementare:** ✅ SI - Specs dettagliatissime (~5h effort)

---

#### 14. Drafts Auto-Save
**File:** `ricerche/RICERCA_DRAFTS_20260114.md`
**Contenuto:**
- Gmail API: `users.drafts.create/update/list/get/send/delete`
- Struttura draft: base64url MIME message con label `DRAFT`
- Frontend: Hook autosave con debounce 1.5-2s
- UX: Indicatore "Saving.../Saved at HH:MM"
- Recovery: LocalStorage fallback + lista drafts

**Pronto per implementare:** ✅ SI - API documentata (~6h effort)

---

#### 15. Thread View
**File:** `ricerche/20260114_THREAD_VIEW_API_Research.md` + `ricerche/THREAD_VIEW_UX_Research.md` + `decisioni/THREAD_VIEW_DESIGN_SPECS.md`
**Contenuto:**
- Gmail API: `threads.list()` e `threads.get()` con format options
- threadId user-specific, historyId per caching
- UX: Collapsed (avatar stack, counter, chevron) + Expanded (chronological, collapse individual)
- Best practices: visual hierarchy, keyboard nav (;/:), AI summaries
- Design specs: 72px collapsed row, multi-avatar stacking, lazy loading

**Pronto per implementare:** ✅ SI - Specs complete (~4h effort)

---

#### 16. Mark Read/Unread
**File:** `ricerche/20260114_RICERCA_MarkRead.md`
**Contenuto:**
- Pattern backend: `service.users().messages().modify()` con `addLabelIds`/`removeLabelIds`
- Labels Gmail: `UNREAD` (add/remove)
- Frontend: Hook `useMutation` + invalidate query cache
- UX: Toggle button + keyboard shortcut `u`
- Già presente pattern in `api.py` (archive, trash, star)

**Pronto per implementare:** ✅ SI - Pattern esistente da replicare (~2h effort)

---

### 🏆 COMPETITOR ANALYSIS

#### 17. Big Players Email Research
**File:** `studi/BIG_PLAYERS_EMAIL_RESEARCH.md`
**Contenuto:**
- 4 player principali: Superhuman ($30/mese), Shortwave ($14/mese), Spark ($5/mese), HEY ($99/anno)
- 3 colonne del successo: Velocità, AI intelligente, Organizzazione
- Must-Have MVP: Keyboard shortcuts vim-like, Split Inbox, AI Summarization, Auto-draft, Smart Bundles, Reminders
- Gap opportunità: NESSUN client specializzato hospitality
- Vantaggio Miracollook: integrazione PMS nativa

**Pronto per implementare:** N/A - Guida strategica

---

#### 18. Shortwave Competitor Analysis
**File:** `ricerche/COMPETITOR_Shortwave.md`
**Contenuto:**
- AI-first client per Gmail/Google Workspace
- Features core: Ghostwriter (impara stile scrittura), AI Assistant (Cmd-J), Instant AI Replies, AI Autocomplete
- Organizzazione: Splits (tab multipli), Bundles (raggruppa simili 80% clutter reduction), Smart Labels
- Pricing: Free/Personal ($14)/Pro ($30)/Business ($42)/Premier ($60)
- Differenziatore: Non "Gmail con AI" ma sistema ripensato

**Pronto per implementare:** N/A - Benchmark features

---

#### 19. Callbell Competitor Analysis
**File:** `ricerche/COMPETITOR_Callbell.md`
**Contenuto:**
- Multi-channel customer support (WhatsApp, Instagram, FB Messenger, Telegram)
- Features: Unified Inbox, Multi-Agent, Chat Assignment, Internal Notes, Tags/Funnels
- CRM: Contact database, custom fields, bulk actions, export
- Team: Creazione team, roles permissions
- Target: SMB (75.000+ aziende: LG, Hugo Boss)

**Pronto per implementare:** N/A - Riferimento per FASE 3 (WhatsApp integration)

---

#### 20. Baseline Email Features - Industry Standard 2026
**File:** `ricerche/BASELINE_Email_Features.md`
**Contenuto:**
- Must-Have: Compose/Reply/Forward, Thread View, Archive/Delete/Mark/Star
- Expected: Labels/Folders, Search, Attachments, Keyboard shortcuts, Dark mode
- Differentiating: AI features, Collaboration, Advanced automation
- Checklist completa per gap analysis

**Pronto per implementare:** N/A - Checklist validazione

---

## RICERCHE PER STATO IMPLEMENTAZIONE

### ✅ IMPLEMENTATO (codice esistente)

| Feature | Ricerca | Codice |
|---------|---------|--------|
| OAuth Google | - | ✅ `gmail/api.py` |
| Inbox list | Design Patterns, Email List Design | ✅ `EmailList/`, `useEmails.ts` |
| Send email | - | ✅ `/gmail/send` |
| Reply/Forward | - | ✅ `ReplyModal.tsx`, `ForwardModal.tsx` |
| Archive/Trash | - | ✅ `/gmail/archive`, `/gmail/trash` |
| Search | - | ✅ `SearchBar.tsx`, `/gmail/search` |
| AI Summary | - | ✅ `/gmail/message/{id}/summary` |
| Keyboard shortcuts | Quick Actions Keyboard | ✅ `useKeyboardShortcuts.ts` |
| Dark mode | Design Salutare | ✅ Tailwind dark classes |

---

### 🟡 RICERCA FATTA, CODICE MANCANTE (pronto per implementare!)

| Feature | Ricerca | Effort | Priorità |
|---------|---------|--------|----------|
| **Mark Read/Unread** | RICERCA_MarkRead.md | 2h | 🔴 CRITICO |
| **Drafts auto-save** | RICERCA_DRAFTS_20260114.md | 6h | 🔴 CRITICO |
| **Upload Attachments** | RICERCA_UPLOAD_ATTACHMENTS.md + SPECS | 4h | 🟠 ALTO |
| **Thread View** | THREAD_VIEW_*_Research.md + SPECS | 4h | 🟠 ALTO |
| **Context Menu** | RICERCA_CONTEXT_MENU_PARTE*.md + SPECS | 5h | 🟡 MEDIO |
| **Resizable Panels** | RICERCA_RESIZE_PANNELLI.md | 3h | 🟡 MEDIO |
| **Labels Custom** | - | 3h | 🟡 MEDIO |
| **Bulk Actions** | - | 5h | 🟡 MEDIO |
| **Contacts Autocomplete** | - | 6h | 🟢 BASSO |

**TOTALE: ~38h di lavoro già STUDIATO!**

---

### 🔵 RICERCA STRATEGICA (roadmap medio-lungo termine)

| Feature | Ricerca | Quando |
|---------|---------|--------|
| Performance Optimization | RICERCA_PERFORMANCE_EMAIL_CLIENTS.md | FASE 2 |
| Attachments Perf (Redis) | RICERCA_ATTACHMENTS_PERFORMANCE.md | FASE 2 |
| WhatsApp Integration | COMPETITOR_Callbell.md | FASE 3 |
| AI Features Advanced | COMPETITOR_Shortwave.md | FASE 3 |

---

## RICERCHE PER CARTELLA

### 📁 `studi/` (12 file)

**UX & Design:**
1. `BIG_PLAYERS_EMAIL_RESEARCH.md` - Competitor analysis (Superhuman, Shortwave, Spark, HEY)
2. `UX_STRATEGY_MIRACALLOOK.md` - User personas, flows, emotional design
3. `DESIGN_PATTERNS_EMAIL.md` - Layout, typography, colors, spacing, animations
4. `RICERCA_DESIGN_SALUTARE.md` - Apple style dark mode, WCAG contrast, calm colors
5. `RICERCA_EMAIL_LIST_DESIGN.md` - Spacing, typography, hover states, grouping
6. `CONTEXT_MENU_UX_STRATEGY.md` - Overview strategica context menu

**Technical:**
7. `RICERCA_RESIZE_PANNELLI.md` - react-resizable-panels recommendation
8. `RICERCA_RESIZABLE_PANELS_V4.md` - v4 API update (rollback breaking changes)
9. `RICERCA_TAILWIND_V4_CUSTOM_COLORS.md` - Fix @theme directive
10. `RICERCA_QUICK_ACTIONS_KEYBOARD.md` - Hover timing, shortcuts, React patterns
11. `RICERCA_GMAIL_ATTACHMENTS.md` - Gmail API attachments endpoint
12. `RICERCA_UPLOAD_ATTACHMENTS.md` - Multipart upload implementation
13. `RICERCA_ATTACHMENTS_PERFORMANCE.md` - Caching, streaming, eager loading
14. `RICERCA_PERFORMANCE_EMAIL_CLIENTS.md` - Prefetching, optimistic UI, lazy loading

**Context Menu (4 parti - 2000+ righe!):**
15. `RICERCA_CONTEXT_MENU_PARTE1.md` - Gmail + Outlook
16. `RICERCA_CONTEXT_MENU_PARTE2.md` - Superhuman + Apple Mail + confronto
17. `RICERCA_CONTEXT_MENU_PARTE3.md` - React implementation tecnica
18. `RICERCA_CONTEXT_MENU_PARTE4.md` - Best practices + raccomandazioni
19. `RICERCA_CONTEXT_MENU.md` - Indice completo

---

### 📁 `ricerche/` (12 file)

**Competitor:**
1. `BASELINE_Email_Features.md` - Industry standard 2026 checklist
2. `COMPETITOR_Shortwave.md` - AI-first client analysis
3. `COMPETITOR_Callbell.md` - Multi-channel messaging platform

**Features Technical:**
4. `RICERCA_DRAFTS_20260114.md` - Gmail API drafts auto-save
5. `20260114_THREAD_VIEW_API_Research.md` - Gmail API threads.list/get
6. `THREAD_VIEW_UX_Research.md` - Best practices Gmail/Superhuman/Apple/Outlook
7. `20260114_RICERCA_MarkRead.md` - Mark as Read/Unread implementation
8. `20260114_ANALISI_Performance.md` - Performance audit
9. `20260114_Performance_Round2.md` - Performance deep dive

**Performance P2:**
10. `P2_Prefetch.md` - Prefetching strategies
11. `P2_ServiceWorker.md` - Service worker caching
12. `P2_Virtualization.md` - List virtualization
13. `P2_useOptimistic.md` - Optimistic UI patterns

---

### 📁 `decisioni/` (3 file)

**Design Specs Approvate:**
1. `THREAD_VIEW_DESIGN_SPECS.md` - Specs complete thread view (collapsed/expanded)
2. `CONTEXT_MENU_DESIGN_SPECS.md` - Menu structure 3 gruppi + Hotel Actions
3. `UPLOAD_ATTACHMENTS_SPECS.md` - Backend/Frontend implementation specs

---

## VALORE TOTALE RICERCHE

```
+================================================================+
|                                                                |
|   RICERCHE MIRACOLLOOK: STATO PATRIMONIO                       |
|                                                                |
|   📚 File totali: 27+                                          |
|   📝 Righe totali: ~10.000+                                    |
|   🎯 Specs pronte: 9 features                                  |
|   ⏱️  Ore pre-studiate: ~38h                                   |
|   💡 Gap competitor: Hotel Actions (UNICI!)                    |
|                                                                |
|   STATUS: Ricerche OTTIME, implementazione LIMITATA           |
|                                                                |
|   OPPORTUNITÀ: Trasformare ricerca in codice = VELOCE!        |
|                                                                |
+================================================================+
```

---

## PROSSIMI STEP CONSIGLIATI

### Sprint 1 - CRITICI (8h)
```
[ ] Mark Read/Unread         2h   - RICERCA_MarkRead.md
[ ] Drafts auto-save         6h   - RICERCA_DRAFTS_20260114.md
```

### Sprint 2 - ALTI (12h)
```
[ ] Upload Attachments       4h   - UPLOAD_ATTACHMENTS_SPECS.md
[ ] Thread View              4h   - THREAD_VIEW_DESIGN_SPECS.md
[ ] Resizable Panels         3h   - RICERCA_RESIZE_PANNELLI.md
```

### Sprint 3 - COMPLETAMENTO (15h)
```
[ ] Context Menu             5h   - CONTEXT_MENU_DESIGN_SPECS.md
[ ] Bulk Actions             5h   - (da specificare)
[ ] Labels Custom            3h   - (da specificare)
[ ] Contacts Autocomplete    6h   - (da specificare)
```

**TOTALE: 35h per email client COMPLETO!**

---

## LEZIONE IMPORTANTE

```
+================================================================+
|                                                                |
|   "RICERCA != IMPLEMENTAZIONE"                                 |
|                                                                |
|   Le ricerche sono ECCELLENTI.                                 |
|   Ma il codice è LIMITATO.                                     |
|                                                                |
|   VALORE REALE = Solo quando diventa CODICE FUNZIONANTE       |
|                                                                |
|   "SU CARTA != REALE"                                          |
|                                                                |
|   PROSSIMA FASE: Trasformare ricerca in implementazione       |
|   Un progresso al giorno. 35h divise in sprint.               |
|                                                                |
+================================================================+
```

---

## COSTITUZIONE-APPLIED

**COSTITUZIONE-APPLIED:** SI ✅

**Principio usato:** "SU CARTA != REALE" + "Studiare prima di agire"

**Come applicato:**
- Ho catalogato tutte le ricerche ESISTENTI (studiare prima)
- Ho evidenziato differenza tra RICERCA (su carta) e CODICE (reale)
- Ho mostrato il valore delle ricerche MA anche il gap implementativo
- Ho fornito roadmap per trasformare ricerca in codice REALE

*"Le ricerche sono state fatte. Il codice NO. Ora facciamo il codice!"*

---

*Ultimo aggiornamento: 15 Gennaio 2026*
*Cervella Researcher - La Scienziata dello sciame* 🔬

*"Non reinventiamo la ruota - abbiamo già studiato tutto. Ora implementiamo!"*
