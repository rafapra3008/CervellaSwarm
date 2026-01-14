# MenuMaster per Sesto Grado - Stato Progetto

> **Ultimo aggiornamento:** 14 Gennaio 2026 - Sessione 199 (Checkpoint)
> **Status:** IMPLEMENTAZIONE 70% - CORS da fixare

---

## VISIONE

```
+================================================================+
|                                                                |
|   STRUMENTO INTERNO per gestire il menu di SESTO GRADO         |
|                                                                |
|   - Niente casino di Excel/Canva                               |
|   - Facile aggiornare piatti e prezzi                          |
|   - Generare PDF/QR per stampa                                 |
|   - USO INTERNO famiglia Pra                                   |
|                                                                |
+================================================================+
```

---

## SESSIONE 199 - COSA ABBIAMO FATTO

### FASE 2A: Brand Colors - COMPLETATA
- `tailwind.config.js` - Palette Sesto Grado aggiunta
  - #E97E21 (arancio brand)
  - #7D3125 (marrone logotipo)
  - #B1B073, #776E1E (verdi varianti)
  - Dark theme: #1C1C1E, #2C2C2E, #38383A
- `index.css` - CSS variables dark theme

### FASE 2B: Simplified Flow - COMPLETATA
- `App.tsx` - Rimosso ProtectedRoute
- `DashboardLayout.tsx` - Accesso diretto, header "6° SESTO GRADO"

### FASE 2C: Dark Theme - COMPLETATA
Tutti i componenti aggiornati:
- `Dashboard.tsx` - Dark background
- `MenuEditor.tsx` - Full dark theme
- `Button.tsx` - Brand orange/brown
- `Card.tsx` - Dark card style
- `Input.tsx` - Dark inputs
- `CategoryCard.tsx` - Dark theme
- `DishCard.tsx` - Dark theme + brand accents
- `DishForm.tsx` - Dark form elements

### FASE 3A: Database Categories - COMPLETATA
- Tenant "sesto-grado" creato
- 5 categorie create (BISTROT LEGGERO, BISTROT UNCONVENTIONAL, DESSERT, KIDS, PIZZA)

### FASE 3B: Database Dishes - COMPLETATA
- `seed_sesto_grado.py` - Script seed creato
- 43 piatti REALI inseriti con:
  - Nome IT/EN (translations JSONB)
  - Descrizioni complete
  - Prezzi reali
  - Allergeni EU corretti
  - Tag dietetici (GF, VEG, VEGAN)

### FASE 3C: API Connection - COMPLETATA
- `public.py` - Endpoint filtrato per tenant_id
- `useMenu.ts` - Hook connesso a public API con slug 'sesto-grado'

---

## PROBLEMA PENDENTE: CORS

```
Access to XMLHttpRequest at 'http://localhost:8000/api/v1/public/menu/sesto-grado/categories'
from origin 'http://localhost:5174' has been blocked by CORS policy
```

### Causa Probabile
Il backend e stato riavviato dopo le modifiche a `public.py` e il CORS middleware potrebbe non essere configurato correttamente per la nuova porta frontend (5174).

### Fix da Applicare (Sessione 200)
Verificare in `backend/app/main.py` il CORSMiddleware:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5174", "http://localhost:5173"],  # <-- porta 5174!
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## FILE MODIFICATI (da committare in MenuMaster)

### Frontend
- `frontend/tailwind.config.js` - Brand colors
- `frontend/src/index.css` - Dark theme CSS
- `frontend/src/App.tsx` - No auth
- `frontend/src/layouts/DashboardLayout.tsx` - Brand header
- `frontend/src/pages/Dashboard.tsx` - Dark theme
- `frontend/src/pages/MenuEditor.tsx` - Dark theme
- `frontend/src/components/ui/Button.tsx` - Brand colors
- `frontend/src/components/ui/Card.tsx` - Dark card
- `frontend/src/components/ui/Input.tsx` - Dark inputs
- `frontend/src/components/menu/CategoryCard.tsx` - Dark theme
- `frontend/src/components/menu/DishCard.tsx` - Dark theme
- `frontend/src/components/menu/DishForm.tsx` - Dark form
- `frontend/src/hooks/useMenu.ts` - Public API connection

### Backend
- `backend/app/api/v1/public.py` - Tenant filtering
- `backend/seed_sesto_grado.py` - Seed script (NUOVO)

---

## ROADMAP AGGIORNATA

### FASE 1: DESIGN - COMPLETATA
- [x] Design specs
- [x] Brand identity
- [x] Approvazione Rafa

### FASE 2: FRONTEND - COMPLETATA
- [x] Colori brand (#E97E21, #7D3125)
- [x] Dark theme su tutto
- [x] Semplificato flow (no login)
- [ ] Font Abolition (non ancora)

### FASE 3: DATI - COMPLETATA
- [x] Seed 5 menu
- [x] Seed 43 piatti reali
- [x] Sistema allergeni EU
- [x] Multi-lingua IT/EN

### FASE 4: INTEGRAZIONE - 50%
- [x] API pubblica per tenant
- [ ] FIX CORS (prossimo step!)
- [ ] Test integrazione completa

### FASE 5: FUNZIONALITA - 0%
- [ ] Export PDF con brand
- [ ] QR codes personalizzati
- [ ] Preview menu pubblico

### FASE 6: TEST E POLISH - 0%
- [ ] Test con Rafa
- [ ] Iterazioni
- [ ] Deploy (se serve)

---

## PROSSIMO STEP (Sessione 200)

**1. FIX CORS - PRIORITA MASSIMA**
```bash
# Verificare CORSMiddleware in main.py
# Porta 5174 deve essere in allow_origins
```

**2. TEST INTEGRAZIONE**
- Frontend carica categorie da API
- Frontend carica piatti da API
- CRUD funziona

**3. SE TEMPO**
- Export PDF
- QR codes

---

## DECISIONI PRESE

| Data | Decisione | Perche |
|------|-----------|--------|
| 14 Gen 2026 | Uso INTERNO senza login | Solo famiglia Pra |
| 14 Gen 2026 | 5 menu separati | Struttura reale Sesto Grado |
| 14 Gen 2026 | Porta 5174 | Non conflitto altri progetti |
| 14 Gen 2026 | Dark theme | Eleganza brand |
| 14 Gen 2026 | Public API con slug | Multi-tenancy senza auth |

---

## DATABASE (Docker)

```bash
# Containers
docker ps
# menumaster-backend, menumaster-db

# Reset seed
docker exec -i menumaster-backend python seed_sesto_grado.py

# Verificare dati
curl http://localhost:8000/api/v1/public/menu/sesto-grado/categories
curl http://localhost:8000/api/v1/public/menu/sesto-grado/dishes
```

---

*"Fatto BENE > Fatto VELOCE"*
*"Una cosa alla volta, standard 100000%!"*
