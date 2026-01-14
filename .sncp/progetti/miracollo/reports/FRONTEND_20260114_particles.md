# OUTPUT: Hero Stella Alpina Particellare

**Data**: 20260114 | **Worker**: cervella-frontend
**Task**: Fase 2 Landing - Sistema particelle canvas per hero section

---

## File Creati/Modificati

✅ **CREATO**: `frontend/js/particles.js` (230 righe)
- Sistema particellare performante con canvas 2D
- 300-500 particelle desktop, 150 mobile
- Effetto parallax mouse con throttling
- Distribuzione montagna astratta (bottom-center bias)
- Connessioni tra particelle vicine
- Pause automatico quando tab non visibile

✅ **MODIFICATO**: `frontend/index.html`
- Aggiunto script particles.js nel footer

---

## Specifiche Implementate

### Performance
- `requestAnimationFrame` per animazioni fluide 60fps
- Device Pixel Ratio handling per retina displays
- Riduzione particelle su mobile (150 vs 500)
- Pause automatico quando tab hidden
- No memory leaks (cleanup method)

### Effetti Visivi
- Particelle bianche (70%) e viola (30%)
- Size 1-3px con profondità (grandi = vicine)
- Opacity 0.3-0.8 variabile
- Connessioni sottili tra particelle < 100px
- Drift lento random

### Parallax Mouse
- Radius 150px attorno al cursore
- Force 0.05 proporzionale a size (depth)
- Ritorno graduale a posizione originale
- Throttle implicito via requestAnimationFrame

### Distribuzione Montagna
- Math.pow(random, 0.7) per bias verticale
- Concentrazione bottom-center
- Subtle center bias orizzontale (80%)
- Silhouette astratta, non evidente

---

## Come Testare

1. **Aprire browser**: `frontend/index.html`
2. **Verificare effetto**:
   - Particelle visibili su gradient
   - Movimento lento e fluido
   - Connessioni sottili tra particelle vicine
3. **Test mouse**: Muovere mouse sulla hero
   - Particelle si spostano leggermente
   - Effetto depth (grandi si muovono di più)
4. **Test mobile**: Ridimensionare finestra < 640px
   - Particelle ridotte a 150
   - Performance rimane fluida
5. **Test performance**: Cambiare tab
   - Animation pausa automaticamente

---

## Colori Usati

```css
Particelle bianche: rgba(255, 255, 255, 0.3-0.8)
Particelle viola:   rgba(129, 140, 248, 0.2-0.5)
Linee connessione:  rgba(99, 102, 241, 0.1)
```

---

## Note Tecniche

- **No librerie esterne** - Solo canvas nativo
- **Graceful degradation** - Fallback su gradient se no canvas
- **Clean code** - Commentato e strutturato a classe
- **Mobile-first** - Performance prioritaria
- **Responsive** - Resize handler ricrea particelle

---

## Status

✅ **COMPLETO** - Pronto per test visivo browser

Il sistema è ELEGANTE e NON AGGRESSIVO come richiesto.
Background gradient CSS rimane, particelle sopra con z-index 0.

---

**Cervella Frontend** - 14 Gennaio 2026
*"Il design impone rispetto. Ogni pixel conta."*
