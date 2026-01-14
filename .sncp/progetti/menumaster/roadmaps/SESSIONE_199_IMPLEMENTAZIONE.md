# MenuMaster Sesto Grado - Roadmap Implementazione

> **Sessione:** 199
> **Data:** 14 Gennaio 2026
> **Obiettivo:** Trasformare MenuMaster in strumento INTERNO Sesto Grado

---

## STATO ATTUALE (Verificato)

| Componente | Stato | Note |
|------------|-------|------|
| Backend Docker | ATTIVO | porta 8000 |
| PostgreSQL | ATTIVO | porta 5432 |
| Frontend | Esistente | porta 5174 |
| Auth | Da rimuovere | Non serve per uso interno |
| Colori | Da cambiare | Blu/verde → Arancio/marrone |

---

## FASE 2A: COLORI BRAND (Oggi)

### File da modificare:
1. `frontend/tailwind.config.js` - Palette colori
2. `frontend/src/index.css` - Dark theme base
3. `frontend/src/layouts/DashboardLayout.tsx` - Header brand

### Colori Sesto Grado:
```css
/* Background */
--bg-dark: #1C1C1E;
--bg-card: #2C2C2E;
--border: #38383A;

/* Brand */
--orange: #E97E21;    /* CTA, highlights */
--brown: #7D3125;     /* Hover, accents */
--green-light: #B1B073; /* Tags */

/* Text */
--text-primary: #FFFFFF;
--text-secondary: #9B9BA5;
```

---

## FASE 2B: SEMPLIFICARE FLOW (Oggi)

### File da modificare:
1. `frontend/src/App.tsx` - Rimuovere ProtectedRoute
2. `frontend/src/layouts/DashboardLayout.tsx` - Rimuovere auth check

### Logica:
- Accesso diretto alla dashboard (/)
- No login/register necessario
- Rimuovere pagine Login.tsx e Register.tsx

---

## FASE 2C: STRUTTURA 5 MENU (Oggi/Domani)

### Design (da Marketing):
```
SIDEBAR 240px:
├── BISTROT LEGGERO (12)
├── BISTROT UNCONVENTIONAL (12)
├── DESSERT (5)
├── KIDS (4)
└── PIZZA (10)

EDITOR (fluid):
└── Form piatto con allergeni

PREVIEW (320px):
└── Mobile preview live
```

### File da creare/modificare:
1. `frontend/src/components/MenuSidebar.tsx` - Nuova sidebar
2. `frontend/src/pages/Dashboard.tsx` - Layout 3 colonne

---

## FASE 3A: SEED 43 PIATTI (Domani)

### Struttura dati per ogni piatto:
```json
{
  "name_it": "Selezione Salumi e Formaggi",
  "name_en": "Selection of Cured Meats and Cheeses",
  "description": "Carne salada di cervo, Speck...",
  "price": 18.00,
  "allergens": [7, 10, 12],
  "tags": ["GF"],
  "menu": "BISTROT_LEGGERO",
  "position": 1
}
```

### Metodo:
1. Creare script seed in backend
2. Inserire tutti 43 piatti documentati in stato.md
3. Verificare con query

---

## FASE 3B: ALLERGENI EU (Domani)

### 14 Allergeni da visualizzare:
| Cod | Nome | Icona |
|-----|------|-------|
| 1 | Glutine | - |
| 2 | Crostacei | - |
| ... | ... | ... |

### Implementazione:
- Backend: campo JSON array [1, 3, 7]
- Frontend: Pills selezionabili [1] [3] [7]
- Menu pubblico: Icone + legenda

---

## FASE 4: FUNZIONALITA (Post-seed)

- [ ] Export PDF con brand
- [ ] QR codes personalizzati
- [ ] Preview live aggiornata

---

## FASE 5: TEST

- [ ] Rafa testa l'applicazione
- [ ] Iterazioni su feedback
- [ ] Polish finale

---

## ORDINE DI ESECUZIONE

```
OGGI (Sessione 199):
1. [x] Verificare stato codice
2. [x] Creare questa roadmap
3. [ ] FASE 2A - Colori brand
4. [ ] FASE 2B - Semplificare flow
5. [ ] Avviare frontend e testare

DOMANI (Sessione 200):
6. [ ] FASE 2C - Struttura 5 menu
7. [ ] FASE 3A - Seed 43 piatti
8. [ ] FASE 3B - Allergeni

DOPO (Sessione 201+):
9. [ ] FASE 4 - PDF, QR
10. [ ] FASE 5 - Test con Rafa
```

---

*"Una cosa alla volta, standard 100000%!"*
*"Ultrapassar os proprios limites!"*
