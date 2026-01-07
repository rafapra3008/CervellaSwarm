# Task: Implementare Widget Sciame Famiglia

**Assegnato a:** cervella-frontend
**Stato:** pending (aspetta docs)
**Priorita:** ALTA
**Data:** 2026-01-07
**Dipendenza:** TASK_DESIGN_SCIAME deve essere completato prima

---

## Obiettivo

Implementare il widget "Sciame Famiglia" seguendo il design document in `docs/design/DESIGN_SCIAME_FAMIGLIA.md`.

---

## Cosa Creare

Directory: `dashboard/frontend/src/components/SwarmWidget/`

Files:
1. `SwarmWidget.tsx` - Container principale
2. `ReginaNode.tsx` - Nodo regina al centro
3. `GuardianaNode.tsx` - Nodo guardiana (primo anello)
4. `WorkerNode.tsx` - Nodo worker (secondo anello)
5. `ConnectionLine.tsx` - Linea SVG animata
6. `SwarmTooltip.tsx` - Tooltip glassmorphism
7. `swarm.css` - Stili e animazioni

---

## Specifiche Tecniche

### Layout Circolare

Usa trigonometria per posizionare i nodi:

```typescript
// Calcola posizione su cerchio
const getPosition = (index: number, total: number, radius: number) => {
  const angle = (index / total) * 2 * Math.PI - Math.PI / 2; // Start from top
  return {
    x: Math.cos(angle) * radius,
    y: Math.sin(angle) * radius,
  };
};
```

### Dimensioni

- Container: 400x400px (responsive)
- Regina: 80px diametro, centro
- Guardiane: 50px diametro, r=100px dal centro
- Worker: 40px diametro, r=180px dal centro

### Colori (variabili CSS)

```css
:root {
  --regina-gold: #f59e0b;
  --guard-purple: #8b5cf6;
  --worker-blue: #3b82f6;
  --active-green: #22c55e;
  --bg-deep: #0a0a1a;
}
```

### Stati

Props per ogni nodo:
```typescript
interface NodeProps {
  id: string;
  name: string;
  emoji: string;
  description: string;
  status: 'idle' | 'working';
}
```

### Animazioni

Regina: pulse 3s infinite (respiro)
Worker active: pulse 1.5s infinite + glow verde
Linea connessione: stroke-dasharray animato

### SVG per Linee

Quando worker è "working", disegna linea curva SVG dal worker alla regina:
- Colore: gradiente oro
- Animazione: energia che fluisce

---

## Integrazione

Sostituire il vecchio `FamigliaWidget` con `SwarmWidget` in `App.tsx`.

Il widget deve ricevere dati dalla prop `famiglia` (stesso formato di prima).

---

## Test Visivi

1. Regina sempre visibile e luminosa al centro
2. 3 guardiane nel primo anello (viola)
3. 12 worker nel secondo anello (blu quando idle)
4. Hover su nodo → tooltip con info
5. Worker "working" → glow verde + linea verso regina

---

## Reference

Leggi PRIMA: `docs/design/DESIGN_SCIAME_FAMIGLIA.md`

---

## Output Atteso

Widget funzionante con:
- Layout circolare corretto
- Animazioni smooth
- Tooltip informativi
- Stati idle/working visivamente distinti

*"Uno sciame di Cervelle. Una sola missione."* 🐝
