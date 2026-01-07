# TASK: Design Dashboard V2 - Jony Ive meets MetaMask

**Assegnato a:** cervella-frontend
**Priorità:** ALTA
**Stato:** ready

---

## CONTESTO

La dashboard funziona ma ha un design "da sviluppatore".
È arrivato il momento del DESIGN SERIO - quello che impone rispetto.

**Rafa ha dichiarato: DESIGN TIME!**

---

## ISPIRAZIONE

### Riferimento Principale: MetaMask.io
- Layout moderno con bento grid
- Card pulite con rounded corners
- Animazioni sottili ma presenti
- Sensazione di innovazione e affidabilità

### Stile: Jony Ive per MetaMask
- Minimalismo ESTREMO
- Ogni elemento ha uno SCOPO
- Spacing generoso (respira!)
- Dettagli perfetti
- Niente di superfluo
- "Less but better"

### Colori: Palette BLU
NON i viola/arancio di MetaMask. Andare verso:
- Blu profondo come primario (#0A1628, #1E3A5F)
- Blu elettrico per accenti (#3B82F6, #60A5FA)
- Bianco/grigio chiaro per contrasto
- Verde solo per "success" states
- Gradiente blu sottile dove serve

---

## COSA CAMBIARE

### 1. Layout Generale
- Sfondo: gradiente blu molto scuro, quasi nero
- Più SPAZIO tra i widget
- Grid più ariosa
- Header più elegante e minimale

### 2. Widget Cards
- Bordi più sottili o nessun bordo (usa ombre)
- Rounded corners più generosi (16px-24px)
- Glassmorphism SOTTILE (blur + trasparenza leggera)
- Hover states eleganti (non aggressivi)

### 3. Tipografia
- Font: Inter o SF Pro (system)
- Dimensioni moderate (NON giganti)
- Pesi: 400 regular, 500 medium, 600 semibold
- Letter-spacing leggermente aumentato sui titoli
- Gerarchia chiara ma non urlata

### 4. Widget NORD
- Box centrale, elegante
- Progress bar sottile, raffinata
- Frase in italic, colore più soft
- Effetto "glow" sottile sul progresso

### 5. Widget FAMIGLIA
- Icone agenti più raffinate
- Stati con colori più sofisticati
- Layout grid più ordinato
- Animazione pulse più sottile per "working"

### 6. Widget ROADMAP
- Timeline più elegante
- Progress bars con gradiente
- Step con hover che mostra dettagli
- Connessioni tra step più raffinate

### 7. Widget SESSIONE
- Log con font monospace elegante
- Scrollbar custom (sottile, blu)
- Timer con design più pulito
- Bottoni con stile MetaMask (rounded, accent color)

---

## PALETTE COLORI PROPOSTA

```css
:root {
  /* Backgrounds */
  --bg-primary: #0A1628;      /* Blu notte profondo */
  --bg-secondary: #111D2E;    /* Blu scuro */
  --bg-card: rgba(30, 58, 95, 0.5);  /* Card con trasparenza */

  /* Accents */
  --accent-primary: #3B82F6;  /* Blu elettrico */
  --accent-secondary: #60A5FA; /* Blu chiaro */
  --accent-glow: rgba(59, 130, 246, 0.3); /* Glow effect */

  /* Text */
  --text-primary: #F8FAFC;    /* Bianco caldo */
  --text-secondary: #94A3B8;  /* Grigio blu */
  --text-muted: #64748B;      /* Grigio più scuro */

  /* States */
  --success: #22C55E;         /* Verde */
  --warning: #F59E0B;         /* Ambra */
  --working: #3B82F6;         /* Blu (in lavoro) */
  --idle: #475569;            /* Grigio */

  /* Effects */
  --border-subtle: rgba(148, 163, 184, 0.1);
  --shadow-card: 0 4px 24px rgba(0, 0, 0, 0.3);
  --blur-card: blur(12px);
}
```

---

## EFFETTI DESIDERATI

1. **Glassmorphism leggero** - Card semi-trasparenti con blur
2. **Glow effects** - Elementi attivi hanno alone blu sottile
3. **Micro-animazioni** - Transizioni 200-300ms, ease-out
4. **Hover states** - Scale(1.02) + ombra più intensa
5. **Gradiente sottile** - Su elementi progress/accent

---

## FILE DA MODIFICARE

```
dashboard/frontend/src/
├── index.css              # Variabili CSS, tema globale
├── App.tsx                # Layout generale
├── components/
│   ├── Layout.tsx         # Header/Footer
│   ├── NordWidget.tsx     # Restyling
│   ├── FamigliaWidget.tsx # Restyling
│   ├── RoadmapWidget.tsx  # Restyling
│   └── SessioneWidget.tsx # Restyling
└── tailwind.config.js     # Nuova palette
```

---

## CRITERI DI SUCCESSO

- [ ] Apri la dashboard e dici "WOW"
- [ ] Sembra un prodotto SERIO, non un prototipo
- [ ] Jony Ive approverebbe il minimalismo
- [ ] MetaMask approverebbe la modernità
- [ ] Rafa approva (il vero test!)

---

## OUTPUT ATTESO

1. Dashboard completamente restyled
2. Screenshot before/after
3. Note su eventuali problemi/compromessi

---

*"Il design impone rispetto."*
*"Less but better." - Dieter Rams/Jony Ive*

