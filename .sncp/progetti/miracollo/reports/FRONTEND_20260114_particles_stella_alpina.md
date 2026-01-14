# OUTPUT: Particelle Canvas Hero ("Stella Alpina")
**Data**: 20260114 | **Worker**: cervella-frontend
**Task**: Implementare effetto particelle nell'hero section

## File Creati
- `/Users/rafapra/Developer/miracollogeminifocus/frontend/js/particles.js` (7.6KB)

## Implementazione

### Caratteristiche Tecniche
- **Canvas 2D** (vanilla JS, no librerie)
- **Desktop**: 250 particelle, 60fps target
- **Mobile**: 80 particelle, 30fps target (< 768px)
- **Parallax**: Movimento mouse throttled (16ms)
- **Colori**: Palette Miracollo (viola, bianco, sfumature)

### Funzionalità
- Particelle fluttuano naturalmente (velocità random)
- Effetto depth (opacity variabile per profondità)
- Parallax subtile con mouse (particelle vicine = movimento maggiore)
- Wrap around edges (particelle escono e rientrano)
- Auto-resize canvas su window resize
- Graceful degradation: fallback se no canvas support

### Accessibilità
- Rispetta `prefers-reduced-motion` (disabilita animazioni se richiesto)
- Canvas trasparente se JS fallisce (gradient già visibile)

### Performance
- requestAnimationFrame per animazione fluida
- FPS limiting su mobile (30fps)
- Mousemove throttling (max 60fps)
- Resize debouncing (150ms)

## Come Testare

1. Apri `/Users/rafapra/Developer/miracollogeminifocus/frontend/index.html`
2. Verifica particelle visibili nell'hero section
3. Muovi mouse → particelle si muovono con parallax
4. Resize finestra → particelle si ridistribuiscono
5. Mobile: < 768px → meno particelle (80)

## Note Tecniche
- File già incluso in `index.html` (riga 762)
- CSS canvas già configurato (absolute, z-index: 0)
- Classe modulare, stile consistente con `scroll-animations.js`
- Commenti in italiano come richiesto

## Status: ✅ COMPLETO
Pronto per test visivo nel browser.
