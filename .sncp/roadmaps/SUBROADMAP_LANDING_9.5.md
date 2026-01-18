# SUBROADMAP - Landing da 7.5 a 9.5

> **Creata:** 18 Gennaio 2026 - Sessione 259
> **Obiettivo:** Score 7.5/10 → 9.5/10
> **Target:** Show HN (24-25 Gennaio)
> **Fonte:** Studio Evil Martians + WCAG + HN Best Practices

---

## MAPPA VISIVA

```
7.5/10 ──────────────────────────────────► 9.5/10

[MUST]           [SHOULD]          [NICE]
 24h               48h               72h
  │                 │                 │
  ├─ Form → Dual CTA    ├─ OG Image       ├─ Social Proof
  ├─ Focus States       └─ Mobile Menu    └─ Hero Copy
  └─ OG Tags
```

---

## FASE 1: MUST (Critici) - Target: +1.0 punti

### 1.1 Form → Dual CTA
**Problema:** Form email non funziona, CTA principale inutile
**Soluzione:** Rimuovere form, creare dual CTA

```
PRIMA:
  [Form email] [Get Install Link]  ← Non funziona

DOPO:
  [npm install -g cervellaswarm]   ← Copiabile
  [Start Free]  [View Docs]        ← Dual CTA
```

**Effort:** LOW (30 min)
**Impatto:** ALTO
**Chi:** cervella-frontend

### 1.2 Focus States
**Problema:** Accessibilità keyboard assente
**Soluzione:** Aggiungere CSS focus-visible

```css
a:focus-visible,
button:focus-visible,
input:focus-visible {
  outline: 2px solid #F59E0B;
  outline-offset: 2px;
}
```

**Effort:** LOW (15 min)
**Impatto:** MEDIO
**Chi:** cervella-frontend

### 1.3 Open Graph Tags
**Problema:** Preview social brutto
**Soluzione:** Aggiungere meta tags

```html
<meta property="og:title" content="CervellaSwarm - 16 AI Agents, One Team">
<meta property="og:description" content="Coordinate 16 specialized AI agents via MCP. Built-in quality gates. Privacy-first.">
<meta property="og:image" content="https://cervellaswarm.com/og-image.jpg">
<meta property="og:url" content="https://cervellaswarm.com">
<meta property="og:type" content="website">
<meta name="twitter:card" content="summary_large_image">
```

**Effort:** LOW (10 min)
**Impatto:** ALTO (social sharing HN!)
**Chi:** cervella-frontend

---

## FASE 2: SHOULD (Importanti) - Target: +0.5 punti

### 2.1 OG Image
**Problema:** Nessuna immagine per preview social
**Soluzione:** Creare immagine 1200x630px

**Contenuto suggerito:**
```
+------------------------------------------+
|                                          |
|   👸 CervellaSwarm                       |
|                                          |
|   16 AI Agents. One Unstoppable Team.    |
|                                          |
|   🐝🐝🐝🐝  🛡️🛡️🛡️  📊                 |
|                                          |
|   cervellaswarm.com                      |
+------------------------------------------+
```

**Effort:** MED (1h con Canva)
**Impatto:** ALTO
**Chi:** cervella-marketing o Rafa

### 2.2 Mobile Menu
**Problema:** Menu nascosto su mobile (50% traffico HN)
**Soluzione:** Hamburger menu con slide

**Effort:** MED (1-2h)
**Impatto:** MEDIO
**Chi:** cervella-frontend

---

## FASE 3: NICE (Bonus) - Target: +0.5 punti

### 3.1 Social Proof
**Se disponibile:** Aggiungere counter o testimonial
```
"Used by X developers" o quote beta tester
```

### 3.2 Hero Copy Rework
**Attuale:** Feature-first (16 agents, MCP, etc)
**Target:** Problem-first

```
PRIMA:
  "16 Specialized AI Agents. One Unstoppable Team."

DOPO:
  "Stop explaining context to AI. Start shipping."
  "16 agents remember your codebase. 3 guardians check their work."
```

---

## CHECKLIST IMPLEMENTAZIONE

### FASE 1 (OGGI)
- [ ] 1.1 Rimuovere form, creare dual CTA
- [ ] 1.2 Aggiungere focus states CSS
- [ ] 1.3 Aggiungere OG meta tags

### FASE 2 (DOMANI)
- [ ] 2.1 Creare OG image
- [ ] 2.2 Implementare mobile menu

### FASE 3 (SE TEMPO)
- [ ] 3.1 Social proof (se dati disponibili)
- [ ] 3.2 Hero copy rework (opzionale)

---

## SCORE PREVISTO

| Fase | Fix | Punti |
|------|-----|-------|
| Attuale | - | 7.5 |
| FASE 1 | Form + Focus + OG | +1.0 → 8.5 |
| FASE 2 | Image + Mobile | +0.5 → 9.0 |
| FASE 3 | Proof + Copy | +0.5 → 9.5 |

---

## TEST PRIMA DEL DEPLOY

1. **OG Preview:** https://orcascan.com/tools/open-graph-validator
2. **Mobile:** Chrome DevTools responsive mode
3. **Keyboard:** Tab through senza mouse
4. **Lighthouse:** Score > 90

---

*"Da 7.5 a 9.5 - Un fix alla volta!"*
