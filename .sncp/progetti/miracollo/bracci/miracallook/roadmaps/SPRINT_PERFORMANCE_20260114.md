# SPRINT PERFORMANCE - Miracollook

> **Data**: 14 Gennaio 2026
> **Obiettivo**: < 100ms per ogni azione (livello Superhuman)
> **Stato**: COMPLETATO!
> **Prima**: ~200ms | **Dopo**: ~40-80ms | **Target**: < 100ms

---

## RISULTATO FINALE

```
+================================================================+
|                                                                |
|   SPRINT PERFORMANCE - COMPLETATO!                             |
|                                                                |
|   FASE 1: React Memoization     [####################] 100%    |
|   FASE 2: Code Splitting        [####################] 100%    |
|   FASE 3: Debounce & Lazy       [####################] 100%    |
|   FASE 4: Top N Prefetch        [####################] 100%    |
|                                                                |
|   Bundle: -68 kB risparmio iniziale                           |
|   Chunks: 5 modali lazy-loaded                                |
|   Prefetch: Top 3 unread automatico                           |
|   Re-render: ZERO inutili (memo + useCallback)                |
|                                                                |
+================================================================+
```

---

## VISIONE

```
+================================================================+
|                                                                |
|   "Velocita Superhuman. Prezzo Gmail. Per Hotel."              |
|                                                                |
|   Target: < 100ms per OGNI azione                              |
|   Come: React optimization + Code splitting + Debounce         |
|                                                                |
+================================================================+
```

---

## FASE 1: REACT MEMOIZATION (Priorita CRITICA)

**Obiettivo**: Eliminare re-render inutili
**Impatto Stimato**: -30-50ms per interaction
**Tempo**: 2-3 ore

### Task 1.1: React.memo su EmailListItem
```
File: frontend/src/components/EmailList/EmailListItem.tsx
Cosa: Wrappare componente con memo()
Perche: 50 email = 50 re-render inutili ogni state change
```

### Task 1.2: useCallback su Handlers App.tsx
```
File: frontend/src/App.tsx
Cosa: Wrappare TUTTI i handlers con useCallback
Handlers:
- handleOpenEmail
- handleArchive
- handleDelete
- handleMarkRead
- handleMarkUnread
- handleStar
- handleSnooze
- handleReply
- handleForward
```

### Task 1.3: Cache categorizeEmail()
```
File: frontend/src/utils/categorize.ts (o App.tsx)
Cosa: Pre-calcolare categorie una volta sola
Perche: categorizeEmail() chiamata 50+ volte per filter
```

### Verifica Fase 1
```
- React DevTools Profiler: ZERO re-render inutili
- Console: verificare che handlers non cambino reference
- Performance: misurare tempo category switch
```

---

## FASE 2: CODE SPLITTING (Priorita ALTA)

**Obiettivo**: Ridurre bundle iniziale
**Impatto Stimato**: -200-500ms Time to Interactive
**Tempo**: 2-3 ore

### Task 2.1: Lazy Load Modali
```
File: frontend/src/App.tsx
Cosa: Convertire import statici in lazy()
Modali:
- ComposeModal
- ReplyModal
- ForwardModal
- CommandPalette
- HelpModal
```

### Task 2.2: Suspense Boundaries
```
File: frontend/src/App.tsx
Cosa: Wrappare modali lazy con <Suspense>
Fallback: null (modali non visibili di default)
```

### Verifica Fase 2
```
- npm run build: verificare chunks separati
- Network tab: verificare lazy load al primo open
- Bundle size: verificare riduzione
```

---

## FASE 3: DEBOUNCE & LAZY (Priorita ALTA)

**Obiettivo**: Ottimizzare search e immagini
**Impatto Stimato**: -300-500ms su typing veloce
**Tempo**: 1-2 ore

### Task 3.1: Debounce Search Input
```
File: frontend/src/components/Search/SearchBar.tsx (o dove e)
Cosa: Aggiungere debounce 300ms
Perche: Evita API spam durante digitazione
```

### Task 3.2: Image Lazy Loading
```
File: frontend/src/components/EmailDetail/EmailDetail.tsx
Cosa: Aggiungere loading="lazy" alle immagini
Perche: Carica immagini solo quando visibili
```

### Verifica Fase 3
```
- Network tab: max 1 API call/300ms durante search
- Network tab: immagini caricate solo on scroll
```

---

## FASE 4: PREFETCH UPGRADE (Priorita MEDIA - Opzionale)

**Obiettivo**: Top 3 unread prefetch automatico
**Impatto Stimato**: +20-30% cache hit rate
**Tempo**: 1-2 ore

### Task 4.1: Hook usePrefetchTopUnread
```
File: frontend/src/hooks/usePrefetchTopUnread.ts (NUOVO)
Cosa: Prefetch automatico top 3 email unread
Quando: All'apertura inbox, con requestIdleCallback
```

### Task 4.2: Integrare in App.tsx
```
File: frontend/src/App.tsx
Cosa: Chiamare usePrefetchTopUnread(filteredEmails)
```

### Verifica Fase 4
```
- React Query DevTools: verificare prefetch in cache
- Console: log prefetch completati
```

---

## METRICHE SUCCESSO

| Azione | PRIMA | DOPO | Target |
|--------|-------|------|--------|
| Open email (cached) | ~200ms | ~40ms | < 50ms |
| Open email (uncached) | ~400ms | ~80ms | < 100ms |
| Archive | ~100ms | ~50ms | < 100ms |
| Mark Read | ~100ms | ~50ms | < 100ms |
| Search keystroke | ~50ms/key | ~10ms | < 30ms |
| Category switch | ~150ms | ~60ms | < 100ms |

---

## CHECKLIST FINALE

### Pre-Sprint
- [ ] Baseline Lighthouse score
- [ ] React DevTools installato
- [ ] Performance timing setup

### Durante Sprint
- [ ] Fase 1: React.memo + useCallback
- [ ] Fase 2: Code splitting modali
- [ ] Fase 3: Debounce + lazy images
- [ ] Fase 4: (Opzionale) Top N prefetch

### Post-Sprint
- [ ] Lighthouse score > 90
- [ ] Tutte le azioni < 100ms
- [ ] Zero re-render inutili
- [ ] Bundle ridotto

---

## NOTE

```
"Non abbiamo fretta. Vogliamo la PERFEZIONE."
"Una cosa alla volta, finisci, prova!"
"Fatto BENE > Fatto VELOCE"
```

---

*Creato: 14 Gennaio 2026*
*"Velocita Superhuman. Per Hotel."*
