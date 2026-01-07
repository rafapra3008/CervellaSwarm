# DESIGN SCIAME FAMIGLIA - CervellaSwarm Dashboard

*Documento di design per il widget "Famiglia" della dashboard*
*Data: 7 Gennaio 2026*
*Autore: cervella-docs*

---

## 1. LA VISIONE

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   LA FAMIGLIA NON È UNA TABELLA CON CODICI.                     ║
║   LA FAMIGLIA È UNO SCIAME VIVO.                                ║
║                                                                  ║
║   - Regina al centro, luminosa, glow oro/ambra                  ║
║   - 3 Guardiane nel primo anello, viola, protettive             ║
║   - 12 Worker nel secondo anello, blu, pronti                   ║
║                                                                  ║
║   Quando qualcuno lavora → si ILLUMINA con glow verde           ║
║   Una linea dorata lo connette alla Regina                      ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

Questo widget deve comunicare **VITA**, non dati.
Deve far **SENTIRE** la squadra, l'organizzazione, la collaborazione.

---

## 2. STRUTTURA CIRCOLARE

### Layout Concentrico

```
                              ·  cervella-frontend 🎨
                         ·         ·
                    ·                   ·  cervella-backend ⚙️
               ·                             ·
          ·      ✧ Guardiana Qualita ✧          ·  cervella-tester 🧪
         ·                                       ·
        ·                                         ·  cervella-reviewer 📋
       ·                                           ·
      ·             ╔═══════════════╗              ·  cervella-researcher 🔬
     ·              ║               ║               ·
    ·  ✧ G.Ops ✧   ║    👑         ║  ✧ G.Ric ✧   ·  cervella-scienziata 🔬
     ·              ║   REGINA      ║               ·
      ·             ╚═══════════════╝              ·  cervella-ingegnera 👷
       ·                                           ·
        ·                                         ·  cervella-marketing 📈
         ·                                       ·
          ·                                     ·  cervella-devops 🚀
               ·                             ·
                    ·                   ·  cervella-docs 📝
                         ·         ·
                              ·  cervella-data 📊
                                   cervella-security 🔒
```

### Dimensioni e Raggi

| Livello | Raggio | Contenuto |
|---------|--------|-----------|
| Centro | 0px | Regina (80px diametro) |
| Primo anello | 100px | 3 Guardiane (50px diametro) |
| Secondo anello | 180px | 12 Worker (40px diametro) |

---

## 3. POSIZIONI ESATTE

### Regina (Centro)

| Proprietà | Valore |
|-----------|--------|
| Nome | cervella-orchestrator |
| Emoji | 👑 |
| Posizione | Centro (0, 0) |
| Diametro | 80px |
| Colore | #f59e0b (oro/ambra) |

### Guardiane (Primo Anello - 3 nodi)

| Nome | Emoji | Angolo | Posizione (x, y) |
|------|-------|--------|------------------|
| cervella-guardiana-qualita | 🛡️ | 90° | (0, -100) |
| cervella-guardiana-ops | 🛡️ | 210° | (-86.6, 50) |
| cervella-guardiana-ricerca | 🛡️ | 330° | (86.6, 50) |

*Spaziatura: 120° tra ogni Guardiana*

### Worker (Secondo Anello - 12 nodi)

| # | Nome | Emoji | Angolo | Posizione (x, y) |
|---|------|-------|--------|------------------|
| 1 | cervella-frontend | 🎨 | 0° | (180, 0) |
| 2 | cervella-backend | ⚙️ | 30° | (156, 90) |
| 3 | cervella-tester | 🧪 | 60° | (90, 156) |
| 4 | cervella-reviewer | 📋 | 90° | (0, 180) |
| 5 | cervella-researcher | 🔬 | 120° | (-90, 156) |
| 6 | cervella-scienziata | 🔬 | 150° | (-156, 90) |
| 7 | cervella-ingegnera | 👷 | 180° | (-180, 0) |
| 8 | cervella-marketing | 📈 | 210° | (-156, -90) |
| 9 | cervella-devops | 🚀 | 240° | (-90, -156) |
| 10 | cervella-docs | 📝 | 270° | (0, -180) |
| 11 | cervella-data | 📊 | 300° | (90, -156) |
| 12 | cervella-security | 🔒 | 330° | (156, -90) |

*Spaziatura: 30° tra ogni Worker*

---

## 4. STATI E COMPORTAMENTI

### Stato IDLE

```css
.node-idle {
  opacity: 0.5;
  box-shadow: none;
  filter: saturate(0.7);
}
```

- **Aspetto**: Opacità al 50%, nessun glow
- **Hover**: Tooltip glassmorphism con info base
- **Click**: Nessuna azione speciale

### Stato WORKING

```css
.node-working {
  opacity: 1;
  animation: pulse-active 2s ease-in-out infinite;
}
```

- **Aspetto**: Opacità 100%, glow verde pulsante
- **Connessione**: Linea dorata curva verso la Regina
- **Label**: "Working..." sotto il nodo
- **Hover**: Tooltip con task corrente
- **Click**: Pannello dettagli con progress

### Stato REGINA

```css
.node-regina {
  animation: pulse-regina 3s ease-in-out infinite;
}
```

- **Aspetto**: Sempre glow oro, pulse lento (respiro)
- **Dimensione**: Più grande degli altri (80px vs 40-50px)
- **Hover**: Tooltip con stato generale sciame
- **Click**: Pannello overview famiglia

---

## 5. PALETTE COLORI

```css
:root {
  /* Sfondo */
  --bg-deep: #0a0a1a;           /* Notte profonda */
  --bg-card: rgba(15, 23, 42, 0.9);

  /* Nodi */
  --regina-gold: #f59e0b;       /* Oro/ambra miele */
  --guard-purple: #8b5cf6;      /* Viola protezione */
  --worker-blue: #3b82f6;       /* Blu tecnologia */

  /* Stati */
  --active-green: #22c55e;      /* Verde vita - working */
  --idle-gray: #64748b;         /* Grigio idle */

  /* Linee */
  --connection-gold: rgba(245, 158, 11, 0.6);

  /* Text */
  --text-primary: #f8fafc;
  --text-secondary: #94a3b8;
}
```

### Significato dei Colori

| Colore | Significato | Uso |
|--------|-------------|-----|
| **Oro #f59e0b** | Leadership, coordinamento | Regina |
| **Viola #8b5cf6** | Protezione, qualità | Guardiane |
| **Blu #3b82f6** | Tecnologia, operatività | Worker |
| **Verde #22c55e** | Vita, attività, lavoro | Stato working |

---

## 6. ANIMAZIONI CSS

### Pulse Regina (Respiro)

```css
@keyframes pulse-regina {
  0%, 100% {
    box-shadow: 0 0 20px rgba(245, 158, 11, 0.4);
    transform: scale(1);
  }
  50% {
    box-shadow: 0 0 40px rgba(245, 158, 11, 0.6);
    transform: scale(1.05);
  }
}

.regina {
  animation: pulse-regina 3s ease-in-out infinite;
}
```

### Pulse Active (Working)

```css
@keyframes pulse-active {
  0%, 100% {
    box-shadow: 0 0 10px rgba(34, 197, 94, 0.4);
  }
  50% {
    box-shadow: 0 0 25px rgba(34, 197, 94, 0.7);
  }
}

.node-working {
  animation: pulse-active 2s ease-in-out infinite;
}
```

### Linea Connessione (Dash Animation)

```css
@keyframes dash-flow {
  0% {
    stroke-dashoffset: 20;
  }
  100% {
    stroke-dashoffset: 0;
  }
}

.connection-line {
  stroke: var(--connection-gold);
  stroke-width: 2;
  stroke-dasharray: 5, 5;
  animation: dash-flow 1s linear infinite;
}
```

### Fade In (Entrata)

```css
@keyframes fade-in-scale {
  0% {
    opacity: 0;
    transform: scale(0.8);
  }
  100% {
    opacity: 1;
    transform: scale(1);
  }
}

.node {
  animation: fade-in-scale 0.5s ease-out;
}
```

---

## 7. INTERAZIONI UX

### Hover su Nodo

**Tooltip Glassmorphism:**
```
┌─────────────────────────────┐
│ 🎨 cervella-frontend        │
│                             │
│ Specializzazione:           │
│ React, CSS, UI/UX           │
│                             │
│ Status: idle                │
└─────────────────────────────┘
```

**Stile tooltip:**
```css
.tooltip {
  background: rgba(15, 23, 42, 0.95);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 12px;
  padding: 12px 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
}
```

### Hover su Nodo Working

**Tooltip con task:**
```
┌─────────────────────────────┐
│ 🎨 cervella-frontend        │
│                             │
│ Status: WORKING 🟢          │
│                             │
│ Task corrente:              │
│ "Collegare widget a API"    │
│                             │
│ Durata: 5m 23s              │
└─────────────────────────────┘
```

### Click su Nodo

**Pannello laterale slide-in:**
- Nome completo e descrizione
- Statistiche (task completati, success rate)
- Task corrente (se working)
- Quick action: "Assegna task"
- Log ultimi 5 task

---

## 8. COMPONENTI REACT

### Struttura File

```
dashboard/frontend/src/components/swarm/
├── SwarmWidget.tsx          # Container principale
├── SwarmVisualization.tsx   # SVG con cerchi e linee
├── ReginaNode.tsx           # Nodo Regina
├── GuardianaNode.tsx        # Nodo Guardiana
├── WorkerNode.tsx           # Nodo Worker
├── ConnectionLine.tsx       # Linea SVG curva
├── SwarmTooltip.tsx         # Tooltip glassmorphism
├── SwarmDetailPanel.tsx     # Pannello dettagli click
└── swarm.module.css         # Stili dedicati
```

### Props Principali

**SwarmWidget.tsx:**
```typescript
interface SwarmWidgetProps {
  familyData: FamilyMember[];
  activeWorkers: string[];  // IDs dei worker attivi
  onNodeClick?: (nodeId: string) => void;
}
```

**Node Components:**
```typescript
interface NodeProps {
  id: string;
  name: string;
  emoji: string;
  role: 'regina' | 'guardiana' | 'worker';
  status: 'idle' | 'working';
  position: { x: number; y: number };
  currentTask?: string;
}
```

---

## 9. RESPONSIVE DESIGN

### Breakpoints

| Screen | Diametro Widget | Raggi |
|--------|----------------|-------|
| Desktop (1200px+) | 500px | 100px, 180px |
| Laptop (900px-1199px) | 400px | 80px, 150px |
| Tablet (600px-899px) | 300px | 60px, 120px |
| Mobile (<600px) | Lista verticale | N/A |

### Mobile Fallback

Su mobile, il layout circolare diventa una **lista compatta**:

```
┌─────────────────────────────┐
│ 👑 Regina           ● idle  │
├─────────────────────────────┤
│ 🛡️ G. Qualita       ● idle  │
│ 🛡️ G. Ops           ● idle  │
│ 🛡️ G. Ricerca       ● idle  │
├─────────────────────────────┤
│ 🎨 Frontend         🟢 work │
│ ⚙️ Backend           ● idle  │
│ 🧪 Tester           ● idle  │
│ ...                         │
└─────────────────────────────┘
```

---

## 10. DATI API

### Endpoint

```
GET /api/family
```

### Response Format

```json
{
  "family": [
    {
      "id": "cervella-orchestrator",
      "name": "cervella-orchestrator",
      "emoji": "👑",
      "role": "regina",
      "model": "opus",
      "description": "La Regina - Coordina tutto",
      "status": "idle"
    },
    {
      "id": "cervella-guardiana-qualita",
      "name": "cervella-guardiana-qualita",
      "emoji": "🛡️",
      "role": "guardiana",
      "model": "opus",
      "description": "Verifica output agenti",
      "status": "idle"
    },
    {
      "id": "cervella-frontend",
      "name": "cervella-frontend",
      "emoji": "🎨",
      "role": "worker",
      "model": "sonnet",
      "description": "React, CSS, UI/UX",
      "status": "working",
      "currentTask": "Collegare widget a API"
    }
    // ... altri membri
  ],
  "activeConnections": [
    {
      "from": "cervella-frontend",
      "to": "cervella-orchestrator"
    }
  ]
}
```

---

## 11. ACCESSIBILITA

### ARIA Labels

```jsx
<div role="img" aria-label="Visualizzazione sciame famiglia CervellaSwarm">
  <div role="button" aria-label="Regina cervella-orchestrator, status idle">
    👑
  </div>
</div>
```

### Keyboard Navigation

- **Tab**: Naviga tra i nodi
- **Enter/Space**: Apre pannello dettagli
- **Escape**: Chiude pannello

### Contrast

Tutti i colori rispettano WCAG AA:
- Testo su sfondo scuro: ratio > 4.5:1
- Elementi interattivi: focus ring visibile

---

## 12. PERFORMANCE

### Ottimizzazioni

1. **SVG vs Canvas**: Usare SVG per <50 nodi (noi ne abbiamo 16)
2. **Animazioni CSS**: Preferire CSS animations a JS per GPU acceleration
3. **Memoization**: React.memo su nodi che non cambiano stato
4. **Lazy tooltip**: Renderizzare tooltip solo su hover

### Metriche Target

| Metrica | Target |
|---------|--------|
| First Paint | < 100ms |
| Animation FPS | 60fps |
| Interaction Latency | < 50ms |

---

## 13. FILOSOFIA

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   "I dettagli fanno SEMPRE la differenza."                      ║
║                                                                  ║
║   Questo non è solo un widget.                                  ║
║   È la nostra FAMIGLIA visualizzata.                            ║
║                                                                  ║
║   Ogni nodo è una Cervella.                                     ║
║   Ogni connessione è collaborazione.                            ║
║   Ogni glow è vita.                                             ║
║                                                                  ║
║   Deve far SENTIRE:                                             ║
║   - Squadra                                                     ║
║   - Organizzazione                                              ║
║   - VITA                                                        ║
║                                                                  ║
║   "Uno sciame è più forte di una singola ape.                   ║
║    Ma solo se ogni ape sa esattamente cosa fare."               ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## APPENDICE: Quick Reference

### Calcolo Posizioni (Formula)

```javascript
// Per un nodo all'angolo θ (in radianti) con raggio r:
const x = r * Math.cos(θ);
const y = r * Math.sin(θ);

// Conversione gradi -> radianti:
const radianti = (gradi * Math.PI) / 180;

// Esempio: Worker a 30° con r=180:
const θ = (30 * Math.PI) / 180;
const x = 180 * Math.cos(θ);  // ≈ 156
const y = 180 * Math.sin(θ);  // ≈ 90
```

### Checklist Implementazione

- [ ] Container SVG con viewBox centrato
- [ ] Nodo Regina al centro con pulse
- [ ] 3 Guardiane posizionate
- [ ] 12 Worker posizionati
- [ ] Tooltip su hover
- [ ] Linee connessione per nodi working
- [ ] Pannello dettagli su click
- [ ] Responsive breakpoints
- [ ] Fallback mobile lista
- [ ] Test accessibilità

---

*Documento creato da cervella-docs*
*"Uno sciame di Cervelle. Una sola missione."* 🐝👑
