# Task: Documentare Design Sciame Famiglia

**Assegnato a:** cervella-docs
**Stato:** ready
**Priorita:** ALTA
**Data:** 2026-01-07

---

## Obiettivo

Creare documentazione completa del design "Sciame Famiglia" per la dashboard CervellaSwarm.

---

## Cosa Creare

File: `docs/design/DESIGN_SCIAME_FAMIGLIA.md`

---

## CONTENUTO DEL DOCUMENTO

### 1. LA VISIONE

La famiglia NON è una tabella con codici (G1, G2, FE, BE).
La famiglia è uno SCIAME VIVO:
- Regina al centro, luminosa, glow oro/ambra
- 3 Guardiane nel primo anello, viola, protettive
- 12 Worker nel secondo anello, blu, pronti

Quando qualcuno lavora → si ILLUMINA con glow verde
Una linea dorata lo connette alla Regina

### 2. STRUTTURA CIRCOLARE

Layout concentrico:
- Centro: Regina (80px, oro #f59e0b)
- Primo anello (r=100px): 3 Guardiane a 120° tra loro
- Secondo anello (r=180px): 12 Worker a 30° tra loro

Guardiane (posizioni):
- cervella-guardiana-qualita (top, 90°)
- cervella-guardiana-ops (210°)
- cervella-guardiana-ricerca (330°)

Worker (in senso orario da top):
1. cervella-frontend 🎨 (0°)
2. cervella-backend ⚙️ (30°)
3. cervella-tester 🧪 (60°)
4. cervella-reviewer 📋 (90°)
5. cervella-researcher 🔬 (120°)
6. cervella-scienziata 🔬 (150°)
7. cervella-ingegnera 👷 (180°)
8. cervella-marketing 📈 (210°)
9. cervella-devops 🚀 (240°)
10. cervella-docs 📝 (270°)
11. cervella-data 📊 (300°)
12. cervella-security 🔒 (330°)

### 3. STATI E ANIMAZIONI

IDLE:
- Opacità 50%
- Nessun glow
- Hover mostra tooltip

WORKING:
- Opacità 100%
- Glow verde pulsante (#22c55e)
- LINEA DORATA curva verso Regina
- Label "Working..."

REGINA:
- Sempre glow oro
- Pulse lento (respiro, 3s)
- Più grande degli altri

### 4. PALETTE COLORI

```
--bg-deep:      #0a0a1a    (notte profonda)
--regina-gold:  #f59e0b    (oro/ambra miele)
--guard-purple: #8b5cf6    (viola protezione)
--worker-blue:  #3b82f6    (blu tecnologia)
--active-green: #22c55e    (verde vita)
```

### 5. ANIMAZIONI CSS

Pulse Regina:
```css
@keyframes pulse-regina {
  0%, 100% { box-shadow: 0 0 20px rgba(245,158,11,0.4); transform: scale(1); }
  50% { box-shadow: 0 0 40px rgba(245,158,11,0.4); transform: scale(1.05); }
}
```

Pulse Active:
```css
@keyframes pulse-active {
  0%, 100% { box-shadow: 0 0 10px rgba(34,197,94,0.4); }
  50% { box-shadow: 0 0 25px rgba(34,197,94,0.4); }
}
```

### 6. INTERAZIONI

Hover su nodo:
- Tooltip glassmorphism
- Mostra: nome, emoji, descrizione, status

Click su nodo:
- Pannello laterale con dettagli
- Task corrente se working
- Quick action "Assegna task"

### 7. COMPONENTI REACT

```
SwarmWidget/
├── SwarmWidget.tsx
├── ReginaNode.tsx
├── GuardianaNode.tsx
├── WorkerNode.tsx
├── ConnectionLine.tsx (SVG)
├── SwarmTooltip.tsx
└── swarm.css
```

### 8. FILOSOFIA

"I dettagli fanno SEMPRE la differenza."

Questo non è solo un widget. È la nostra FAMIGLIA visualizzata.
Ogni nodo è una Cervella. Ogni connessione è collaborazione.
Deve far SENTIRE: squadra, organizzazione, VITA.

---

## Output Atteso

File `docs/design/DESIGN_SCIAME_FAMIGLIA.md` completo con:
- Tutti i dettagli sopra
- ASCII art per visualizzare struttura
- Tabelle chiare per posizioni e colori
- Note filosofiche alla fine

---

## Note

Questo documento servirà come reference per cervella-frontend quando implementerà il widget.

Firma: *"Uno sciame di Cervelle. Una sola missione."* 🐝👑
