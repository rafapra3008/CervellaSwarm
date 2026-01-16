# Performance Round 2 - Big Players Analysis

**Data**: 14 Gennaio 2026
**Autore**: Cervella Researcher
**Obiettivo**: Identificare tecniche avanzate dei big players applicabili a Miracollook

---

## EXECUTIVE SUMMARY

Miracollook ha GIÀ implementato le basi solide:
- IndexedDB cache + prefetch intelligente
- Service Worker + offline mode
- React optimization (memo/useCallback)
- Code splitting + lazy loading
- Skeleton + optimistic updates

**Gap identificati rispetto ai big players:**
1. **PRIORITÀ ALTA** - Tecniche con impatto significativo su email client
2. **PRIORITÀ MEDIA** - Nice to have che migliorano UX
3. **PRIORITÀ BASSA** - Futuro o non applicabili

---

## 1. COSA HANNO LORO CHE NOI NON ABBIAMO

### PRIORITÀ ALTA (Impatto Significativo)

#### 1.1 Keyboard-First Architecture (Superhuman)

**COSA FANNO:**
- 100+ keyboard shortcuts integrati dal giorno 1
- Ogni azione eseguibile senza mouse
- Risparmio documentato: **134 ore/anno per utente**
- Latenza **32ms** vs Gmail 100ms

**APPLICABILITÀ A MIRACOLLOOK:**
```
ALTA - Hotel staff lavora VELOCE, tastiera è più rapida del mouse

Shortcuts essenziali per email client hotel:
- J/K: Email precedente/successiva
- E/A: Archive/elimina
- R/F: Rispondi/Forward
- C: Componi nuova
- S: Stella/importante
- /: Cerca
- ESC: Chiudi modale
- ⌘K: Command palette

IMPATTO: Riduzione 30-40% tempo gestione inbox per utenti power
```

**IMPLEMENTAZIONE:**
- Libreria: `cmdk` (Command Menu Kit) - lightweight, headless
- Alternative: `@mattis44/react-command-palette` (React 19 ready)
- Hook custom: `useKeyCombo` per shortcut globali
- Pattern: Cmd+K / Ctrl+K apre palette globale

**RIFERIMENTI:**
- [Superhuman Keyboard Architecture](https://blog.superhuman.com/gmail-vs-superhuman/)
- [cmdk Library](https://github.com/pacocoursey/cmdk)
- [React Command Palette Guide](https://www.dhiwise.com/post/the-ultimate-guide-to-using-react-command-palettes)

---

#### 1.2 Virtual Scrolling / Windowing (Linear, Gmail)

**COSA FANNO:**
- Renderizzano SOLO email visibili (10-20 items)
- Gmail carica batch progressivi, non tutto insieme
- Linear: "window" si muove durante scroll, DOM minimale

**APPLICABILITÀ A MIRACOLLOOK:**
```
ALTA - Se inbox > 100 email, windowing è CRITICO

Attualmente:
- Miracollook carica ~50 email per pagina?
- Se sono tutte in DOM = overhead inutile

Con windowing:
- Solo 10-15 email in DOM
- 10x meno calcoli layout/paint
- Memory footprint ridotto 80%
```

**NUMERI CONCRETI:**
- Con >50 item: windowing obbligatorio
- Con >100 item: windowing = differenza tra 200ms e 50ms
- React-window: -70% DOM nodes, +300% scroll perf

**IMPLEMENTAZIONE:**
- Libreria: `react-window` (più leggera) o `react-virtuoso` (dynamic height)
- Overhead minimo se <50 items, massivo beneficio se >100
- Usa `overscanCount` per prevenire flash vuoto

**RIFERIMENTI:**
- [Virtual Lists Pattern](https://www.patterns.dev/vanilla/virtual-lists/)
- [react-window vs react-virtuoso](https://medium.com/@stuthineal/infinite-scrolling-made-easy-react-window-vs-react-virtuso-1fd786058a73)
- [Windowing Best Practices](https://web.dev/articles/virtualize-long-lists-react-window)

---

#### 1.3 IndexedDB Sharding + Batching (Linear, RxDB)

**COSA FANNO:**
- Linear carica TUTTO in memory all'avvio → 0ms search
- Sharding: dividono DB in 10+ store separati
- Batch operations invece di 1 transaction per write

**APPLICABILITÀ A MIRACOLLOOK:**
```
ALTA - Email client = LETTURE MASSIVE, scritture batch

Attualmente:
- Miracollook usa IndexedDB per cache
- Ma probabilmente 1 transaction per email?

Optimization:
1. SHARDING: Store per anno/mese (hotels/ anni di email!)
2. BATCHING: Scrivi 100 email in 1 transazione
3. Relaxed durability: 2-3x faster writes

NUMERI:
- 1k emails 1-by-1 = 2 secondi
- 1k emails batch = 80ms
- Sharding = +28% read speed, +43% query speed
```

**IMPLEMENTAZIONE:**
```javascript
// BATCH WRITE
const tx = db.transaction(['emails'], 'readwrite', { durability: 'relaxed' });
const store = tx.objectStore('emails');
emails.forEach(email => store.put(email));
await tx.complete(); // 100x più veloce!

// SHARDING
- emails_2024 store
- emails_2025 store
- Query parallele su 10 stores = 28% faster
```

**RIFERIMENTI:**
- [IndexedDB Performance Deep Dive](https://rxdb.info/slow-indexeddb.html)
- [Batching & Sharding Benchmarks](https://nolanlawson.com/2021/08/22/speeding-up-indexeddb-reads-and-writes/)
- [RxDB Storage Optimization](https://rxdb.info/rx-storage-indexeddb.html)

---

#### 1.4 CSS Performance (will-change, containment, content-visibility)

**COSA FANNO:**
- Animazioni SEMPRE a 60fps usando `transform` invece di `top/left`
- `will-change` su elementi prima di animare (GPU acceleration)
- `content-visibility: auto` per email fuori viewport
- `contain: layout style paint` per isolare rendering

**APPLICABILITÀ A MIRACOLLOOK:**
```
ALTA - Modale, liste, animazioni devono essere FLUIDE

Problemi comuni:
- Modale che "lagga" all'apertura
- Lista che scatta durante scroll
- Animazioni che droppano frame

Fix:
1. Modale: `will-change: transform, opacity` PRIMA apertura
2. Lista email: `content-visibility: auto` (skip render off-screen)
3. Animazioni: SOLO transform/opacity (GPU accelerated)
```

**NUMERI CONCRETI:**
- `content-visibility`: -80% rendering time (825ms → 172ms)
- `contain`: Isola subtree, layout +40% faster
- `will-change`: +2-3x animation smoothness (ma rimuovi dopo!)

**IMPLEMENTAZIONE:**
```css
/* Email row fuori viewport */
.email-row {
  content-visibility: auto;
  contain-intrinsic-size: 80px; /* Placeholder size */
}

/* Modale che apre */
.modal {
  will-change: transform, opacity;
  transform: translateZ(0); /* Force GPU layer */
}

/* Container email list */
.email-list {
  contain: layout style paint;
}
```

**CAVEAT:** `will-change` consuma memoria → rimuoverlo dopo animazione!

**RIFERIMENTI:**
- [60 FPS Animations Guide](https://www.algolia.com/blog/engineering/60-fps-performant-web-animations-for-optimal-ux)
- [CSS Containment Performance](https://www.speedkit.com/blog/field-testing-css-containment-for-web-performance-optimization)
- [content-visibility Baseline](https://web.dev/articles/content-visibility)

---

#### 1.5 React 18 Concurrent Features (startTransition, useDeferredValue)

**COSA FANNO:**
- Marking updates come "non-urgent" → non bloccano UI
- Search/filter pesanti diventano "interruptable"
- Input rimane responsivo anche con render pesanti

**APPLICABILITÀ A MIRACOLLOOK:**
```
MEDIA-ALTA - Utile per search/filtri, MA solo se attualmente lagga

Quando usare:
- Search bar che filtra 500+ email → wrap in startTransition
- Cambio folder pesante → defer render lista
- Input che triggerano calcoli complessi

NUMERI:
- Input responsiveness: da 300ms a <50ms
- Rendering NON blocca typing/clicking
```

**IMPLEMENTAZIONE:**
```javascript
// Search che non blocca typing
const [query, setQuery] = useState('');
const [isPending, startTransition] = useTransition();

const handleSearch = (value) => {
  setQuery(value); // Urgent: aggiorna input subito
  startTransition(() => {
    // Non-urgent: filtra lista può aspettare
    setFilteredEmails(expensiveFilter(value));
  });
};

// Alternative: useDeferredValue
const deferredQuery = useDeferredValue(query);
const results = useMemo(() =>
  expensiveFilter(deferredQuery), [deferredQuery]
);
```

**CAVEAT:** Non wrappare tutto! Solo operazioni che GIÀ laggano (>100ms).

**RIFERIMENTI:**
- [React 18 Concurrent Rendering](https://www.curiosum.com/blog/performance-optimization-with-react-18-concurrent-rendering)
- [useTransition Guide](https://www.developerway.com/posts/use-transition)
- [startTransition vs useDeferredValue](https://blog.openreplay.com/usetransition-vs-usedeferredvalue-in-react-18/)

---

### PRIORITÀ MEDIA (Nice to Have)

#### 2.1 Intersection Observer per Lazy Rendering

**COSA FANNO:**
- Email fuori viewport = componenti NON renderizzati
- Componente si "attiva" quando entra nel viewport
- -20% CPU usage documentato

**APPLICABILITÀ A MIRACOLLOOK:**
```
MEDIA - Utile se lista email è molto lunga O se email hanno immagini

Attualmente:
- Se usi windowing, Intersection Observer è ridondante
- Se NON usi windowing, è critico per performance

Use case:
- Email con immagini embedded → lazy render HTML body
- Attachment preview → render solo quando visibile
- Thread lungo → lazy render risposte vecchie
```

**IMPLEMENTAZIONE:**
```javascript
// Hook custom
const useIntersectionObserver = (ref, options) => {
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const observer = new IntersectionObserver(([entry]) => {
      setIsVisible(entry.isIntersecting);
    }, options);

    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, [ref, options]);

  return isVisible;
};

// Uso in EmailRow
const EmailRow = ({ email }) => {
  const ref = useRef();
  const isVisible = useIntersectionObserver(ref, {
    rootMargin: '50px' // Preload 50px prima
  });

  return (
    <div ref={ref}>
      {isVisible ? <EmailBody email={email} /> : <Skeleton />}
    </div>
  );
};
```

**RIFERIMENTI:**
- [Intersection Observer Performance](https://medium.com/draftkings-engineering/lazy-rendering-web-uis-with-intersectionobserver-api-bc69a4b61325)
- [React Lazy Rendering](https://giancarlobuomprisco.com/react/lazy-rendering-react-components-with-intersection-observer)
- [IO API Complete Guide](https://future.forem.com/sherry_walker_bba406fb339/mastering-the-intersection-observer-api-2026-a-complete-guide-561k)

---

#### 2.2 Web Workers per HTML Sanitization

**COSA FANNO:**
- Parsing HTML email in worker thread separato
- Main thread libero = UI non blocca MAI
- Fastmail usa questo pattern per email sicure

**APPLICABILITÀ A MIRACOLLOOK:**
```
MEDIA - Solo se email HTML complesse O se sanitization blocca UI

Problema:
- Parsing HTML hotel email (conferme booking) può essere pesante
- Sanitization XSS deve essere sicura MA veloce

Soluzione:
- Worker thread parsea + sanitizza HTML
- Main thread riceve HTML safe, ready to render

CAVEAT: DOMPurify NON funziona in worker (serve DOM)
→ Usare libreria compatible con worker O sanitize su server
```

**IMPLEMENTAZIONE:**
```javascript
// email-worker.js
self.addEventListener('message', async (e) => {
  const { html, emailId } = e.data;

  // Parse + sanitize (con lib worker-safe)
  const sanitized = sanitizeHTML(html);
  const parsed = parseEmailContent(sanitized);

  self.postMessage({ emailId, content: parsed });
});

// EmailViewer.jsx
const worker = new Worker('email-worker.js');

worker.postMessage({ html: email.body, emailId: email.id });
worker.onmessage = (e) => {
  setEmailContent(e.data.content);
};
```

**CAVEAT:** Complessità aumenta. Implementare SOLO se rendering blocca UI (>100ms).

**RIFERIMENTI:**
- [Web Workers Overview](https://web.dev/learn/performance/web-worker-overview)
- [Parsing HTML in Workers](https://lexmihaylov.github.io/posts/Parsing-HTML-and-XML-Data-in-Web-Workers/)
- [Fastmail HTML Sanitization](https://www.fastmail.com/blog/sanitising-html-the-dom-clobbering-issue/)

---

#### 2.3 requestIdleCallback per Background Tasks

**COSA FANNO:**
- Tasks non-urgent eseguiti quando browser è "idle"
- Prefetch, analytics, cleanup eseguiti senza bloccare UI

**APPLICABILITÀ A MIRACOLLOOK:**
```
MEDIA - Buono per prefetch Top 3 O cleanup cache vecchia

Use case:
- Prefetch Top 3 email DOPO che inbox è renderizzata
- Cleanup IndexedDB email vecchie (>6 mesi)
- Pre-caricamento attachment preview
- Sync background con server

NOTA: React NON usa più requestIdleCallback nativo!
→ Hanno custom scheduler che yielda ogni 5ms
```

**IMPLEMENTAZIONE:**
```javascript
// Prefetch in idle time
const prefetchTopEmails = () => {
  requestIdleCallback((deadline) => {
    const topEmails = getTop3Emails();

    topEmails.forEach(email => {
      if (deadline.timeRemaining() > 10) {
        // Abbiamo tempo, prefetch!
        prefetchEmail(email.id);
      }
    });
  }, { timeout: 2000 }); // Max 2s delay
};

// Cleanup cache in idle
const cleanupOldCache = () => {
  requestIdleCallback(async () => {
    const sixMonthsAgo = Date.now() - (6 * 30 * 24 * 60 * 60 * 1000);
    await db.emails.where('date').below(sixMonthsAgo).delete();
  });
};
```

**RIFERIMENTI:**
- [requestIdleCallback Chrome Guide](https://developer.chrome.com/blog/using-requestidlecallback)
- [rAF vs rIC](https://www.luisball.com/blog/request-animation-frame-versus-request-idle-callback)
- [Event Loop Navigation](https://macarthur.me/posts/navigating-the-event-loop/)

---

### PRIORITÀ BASSA (Futuro / Non Applicabili)

#### 3.1 Local-First Architecture (Linear Style)

**COSA FANNO:**
- Caricano TUTTO in memory all'avvio (Linear: tutti issues in IndexedDB)
- Search = filter array JS → 0ms latency
- Sync in background, UI sempre responsive

**APPLICABILITÀ A MIRACOLLOOK:**
```
BASSA - Impraticabile per hotel con 10k+ email

Linear può farlo perché:
- Issues sono ~1000-5000 max
- Ogni issue è piccolo (JSON)

Hotel email:
- 10k+ email accumulate negli anni
- Email con HTML body pesante
- Attachment da multi-MB

IMPOSSIBILE caricare tutto in memory!

Alternative:
- Windowing + prefetch intelligente (GIÀ fatto)
- IndexedDB sharding per anno (FATTIBILE)
```

**RIFERIMENTI:**
- [Local-First Architecture](https://blog.devstract.site/technical-deep-dive/the-rise-of-local-first-software/)
- [Linear Performance](https://articles.mergify.com/why-we-switched-from-notion-to-linear/)

---

#### 3.2 WASM per Computazioni Pesanti

**COSA FANNO:**
- Usano WebAssembly per parsing/crypto/compression

**APPLICABILITÀ A MIRACOLLOOK:**
```
BASSA - Email client non ha computazioni così pesanti

Use case teorici:
- Encryption email end-to-end
- Compression attachment
- OCR su immagini attachment

→ OVERKILL per Miracollook v1
→ Considerare solo se ci sono bottleneck DOCUMENTATI (profiler)
```

---

#### 3.3 React Suspense + Streaming SSR

**COSA FANNO:**
- Server streama HTML progressivamente
- Parti pesanti arrivano dopo, hydrate individualmente
- Next.js 15: Suspense boundaries + streaming nativo

**APPLICABILITÀ A MIRACOLLOOK:**
```
BASSA - Miracollook è CLIENT-SIDE app (SPA)

Streaming SSR serve per:
- Landing page SEO
- Blog, marketing site
- Dashboard con sections lente

Email inbox:
- È dietro autenticazione (no SEO)
- Dati arrivano da API (non SSR)
- SPA è architettura corretta

→ NON applicabile
```

---

## 2. RACCOMANDAZIONI PER MIRACOLLOOK

### AZIONI IMMEDIATE (Sprint 5.1)

**1. Keyboard Shortcuts Foundation**
```
PRIORITÀ: ALTISSIMA
EFFORT: 2-3 ore setup + 1 ora per shortcut
ROI: Massimo (hotel staff = power users)

Task:
- [ ] Installare cmdk o @mattis44/react-command-palette
- [ ] Implementare 10 shortcuts base (J/K/E/R/F/C/S//ESC)
- [ ] Command palette con Cmd+K
- [ ] Help overlay con lista shortcuts (? key)
- [ ] Persistere preferenze shortcuts in localStorage

Metriche successo:
- Apertura modale <10ms
- Shortcut registrati globalmente (anche modale chiuso)
- 100% coverage azioni comuni
```

**2. Virtual Scrolling Lista Email**
```
PRIORITÀ: ALTA (se inbox >100 email)
EFFORT: 4-6 ore implementazione
ROI: Alto se liste lunghe, basso se liste corte

Task:
- [ ] Testare inbox attuale: quante email renderizzate?
- [ ] Se >50: implementare react-window o react-virtuoso
- [ ] Configurare overscanCount (2-3 items)
- [ ] Testare scroll performance (Chrome DevTools)

Metriche successo:
- Scroll 60fps costante (Performance tab)
- DOM nodes <20 anche con 500+ email
- Memoria <50MB anche con liste lunghe
```

**3. CSS Performance Audit**
```
PRIORITÀ: ALTA
EFFORT: 2-3 ore refactor
ROI: Animazioni fluide = UX premium

Task:
- [ ] Audit animazioni: usano transform/opacity? O top/left?
- [ ] Aggiungere content-visibility: auto alle email row
- [ ] will-change su modale PRIMA apertura (rimuovi dopo 500ms)
- [ ] contain: layout style paint su email-list container
- [ ] Testare con Chrome Performance profiler

Metriche successo:
- Animazioni 60fps costante (no frame drop)
- Rendering time <16ms per frame
- Paint events <5ms
```

---

### AZIONI MEDIO TERMINE (Sprint 5.2-5.3)

**4. IndexedDB Optimization**
```
PRIORITÀ: MEDIA (ottimizzazione, non feature)
EFFORT: 6-8 ore refactor
ROI: Medio (già veloce, ma può essere 10x più veloce)

Task:
- [ ] Audit transazioni attuali: batch o singole?
- [ ] Implementare batch writes (100 email in 1 tx)
- [ ] Durability: 'relaxed' per sync cache
- [ ] Valutare sharding per anno (se >5k email)
- [ ] Benchmark prima/dopo

Metriche successo:
- Sync 1000 email: da ~2s a <100ms
- Read query: -30-40% latency
```

**5. React 18 Concurrent per Search**
```
PRIORITÀ: MEDIA (se search lagga)
EFFORT: 2-3 ore
ROI: Alto se search è lento, basso se già veloce

Task:
- [ ] Testare search attuale: blocca UI? >100ms?
- [ ] Se sì: wrap filter in startTransition
- [ ] useDeferredValue per query pesanti
- [ ] Mostrare "searching..." durante defer

Metriche successo:
- Input typing: <50ms response (mai blocca)
- Search pesante: può prendere 300ms MA non blocca UI
```

**6. Intersection Observer per Email Body**
```
PRIORITÀ: BASSA (solo se NON usi windowing)
EFFORT: 3-4 ore
ROI: Medio (se email hanno HTML complesso)

Task:
- [ ] Lazy render email body HTML solo quando visibile
- [ ] Preload rootMargin: 100px prima viewport
- [ ] Skeleton durante load
- [ ] Testare CPU usage (Chrome Task Manager)

Metriche successo:
- CPU -20% durante scroll
- Email fuori viewport: componenti unmounted
```

---

### AZIONI LUNGO TERMINE (Post v1.0)

**7. Command Palette Avanzato**
```
- Actions: Tutte le operazioni app
- Recent commands
- Search email dentro palette
- Fuzzy matching
- Analytics: quali comandi più usati
```

**8. Web Workers per Email Parsing**
```
- SOLO se HTML sanitization blocca UI (profiler!)
- Implementare DOPO altri fix
- Server-side sanitization è alternativa migliore
```

**9. Background Prefetch Intelligente**
```
- requestIdleCallback per prefetch Top 10 (non solo 3)
- Prefetch basato su ML pattern utente (futuro)
- Cleanup automatico cache vecchia (>6 mesi)
```

---

## 3. METRICHE TARGET POST-OPTIMIZATION

### Performance Targets

| Metrica | Attuale | Target Sprint 5.1 | Target v1.0 |
|---------|---------|-------------------|-------------|
| **Open Email** | ~40-80ms | <30ms | <20ms |
| **Scroll 60fps** | ? | 60fps costante | 60fps + smooth |
| **Search typing** | ? | <50ms | <30ms |
| **Modale open** | ? | <16ms | <10ms |
| **Memory usage** | ? | <80MB | <50MB |
| **IndexedDB write 1k** | ~2s? | <200ms | <100ms |

### User Experience Targets

| Feature | Target | Metodo Misura |
|---------|--------|---------------|
| **Keyboard shortcuts** | 100% azioni comuni | Checklist completa |
| **Animation smoothness** | 0 frame drops | Chrome Performance |
| **Inbox load** | <500ms per 100 email | Lighthouse |
| **Offline mode** | 100% funzionante | Service Worker |

---

## 4. COSA NON FARE (TRAPPOLE)

### ❌ Over-Engineering

```
NON implementare:
- Local-first se non hai 100k+ email/sec
- WASM senza profiler che dimostra bottleneck
- Streaming SSR per app SPA
- Web Workers "perché fa figo"

REGOLA: Profiler PRIMA, ottimizzazione DOPO
```

### ❌ Premature Optimization

```
NON ottimizzare:
- Componenti che renderizzano <16ms
- Liste con <50 items
- Animazioni che GIÀ vanno a 60fps

REGOLA: Misura prima, ottimizza solo se slow
```

### ❌ Breaking Working Features

```
NON refactorare:
- Prefetch attuale (GIÀ funziona!)
- Cache IndexedDB (GIÀ funziona!)
- Offline mode (GIÀ funziona!)

REGOLA: Iterativo, non riscrittura totale
```

---

## 5. TESTING & VALIDATION

### Performance Testing Checklist

```
Prima di dichiarare "fatto":

[ ] Chrome DevTools Performance tab
    - Rendering <16ms per frame
    - No long tasks >50ms
    - FPS stabile a 60

[ ] Chrome DevTools Memory tab
    - No memory leak durante scroll
    - <100MB dopo 10 minuti uso intensivo

[ ] Lighthouse audit
    - Performance >90
    - Accessibility >95
    - Best Practices >90

[ ] Real device testing
    - iPhone 12/13 (Safari)
    - Android mid-range
    - Desktop Chrome/Firefox/Safari

[ ] Network throttling
    - Fast 3G: app usabile
    - Offline: 100% funzionante
```

### User Testing

```
Metriche qualitative:

[ ] Staff hotel: "Si sente veloce?"
[ ] Shortcuts: "Dopo 1 settimana, quanti usi?"
[ ] Animazioni: "Fluide o scattose?"
[ ] Affidabilità: "Mai perso un'email?"
```

---

## 6. CONCLUSIONI

### Il Vero Gap

**Miracollook GIÀ HA la base solida.**

Il gap rispetto a Superhuman/Gmail NON è tecnologico, è:
1. **Keyboard-first UX** - Manca command palette + shortcuts sistematici
2. **Perceived performance** - Animazioni devono essere FLUIDE (CSS fix)
3. **Scalabilità liste** - Windowing per inbox >100 email

### Priorità Assoluta

**TOP 3 AZIONI:**
1. Keyboard shortcuts + command palette (2-3 ore, ROI MASSIMO)
2. CSS performance audit (2-3 ore, animazioni fluide)
3. Virtual scrolling (4-6 ore, SE liste >100 email)

**TOTALE**: ~8-12 ore per portare UX da "buona" a "eccellente"

### Il Segreto dei Big Players

```
NON è tecnologia magica.
È attenzione maniacale ai DETTAGLI:

- Ogni animazione a 60fps
- Ogni shortcut pensato
- Ogni latency <100ms
- Ogni pixel ottimizzato

"Speed is a feature." - Superhuman
```

---

## 7. FONTI

### Performance Architecture
- [Superhuman vs Gmail Performance](https://blog.superhuman.com/gmail-vs-superhuman/)
- [Linear Local-First Architecture](https://blog.devstract.site/technical-deep-dive/the-rise-of-local-first-software/)
- [Gmail Performance Tips](https://developers.google.com/workspace/gmail/api/guides/performance)

### React Optimization
- [Virtual Lists Best Practices](https://www.patterns.dev/vanilla/virtual-lists/)
- [react-window Guide](https://web.dev/articles/virtualize-long-lists-react-window)
- [React 18 Concurrent Rendering](https://www.curiosum.com/blog/performance-optimization-with-react-18-concurrent-rendering)
- [useTransition Performance](https://www.developerway.com/posts/use-transition)

### CSS Performance
- [60 FPS Animations Guide](https://www.algolia.com/blog/engineering/60-fps-performant-web-animations-for-optimal-ux)
- [content-visibility Baseline](https://web.dev/articles/content-visibility)
- [CSS Containment Performance](https://www.speedkit.com/blog/field-testing-css-containment-for-web-performance-optimization)

### IndexedDB Optimization
- [IndexedDB Performance Deep Dive](https://rxdb.info/slow-indexeddb.html)
- [Batching & Sharding](https://nolanlawson.com/2021/08/22/speeding-up-indexeddb-reads-and-writes/)
- [RxDB Storage Optimization](https://rxdb.info/rx-storage-indexeddb.html)

### Advanced Techniques
- [Command Palette React](https://www.dhiwise.com/post/the-ultimate-guide-to-using-react-command-palettes)
- [Intersection Observer Performance](https://medium.com/draftkings-engineering/lazy-rendering-web-uis-with-intersectionobserver-api-bc69a4b61325)
- [requestIdleCallback Chrome](https://developer.chrome.com/blog/using-requestidlecallback)
- [Web Workers Overview](https://web.dev/learn/performance/web-worker-overview)

### Comparisons & Benchmarks
- [Why We Switched to Linear](https://articles.mergify.com/why-we-switched-from-notion-to-linear/)
- [Notion Performance Review](https://hackceleration.com/notion-review/)
- [Gmail Speed Tips](https://hiverhq.com/blog/speed-up-gmail)

---

**Fine Report - 14 Gennaio 2026**

*"Speed is not just a feature. It's THE feature."*
