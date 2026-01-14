# MenuMaster - Stato Progetto

> **Ultimo aggiornamento:** 14 Gennaio 2026 - Sessione 1
> **Status:** PROTOTIPO MVP FUNZIONANTE

---

## VISIONE

```
+================================================================+
|                                                                |
|   MenuMaster = Sistema Gestione Menu Digitali Ristoranti       |
|                                                                |
|   "Menu digitale professionale in 5 minuti"                    |
|   "Il Canva dei menu digitali"                                 |
|                                                                |
|   Target: Ristoranti piccoli/medi (5-50 coperti)               |
|   USP: Zero commissioni, AI translations, self-hosted option   |
|                                                                |
+================================================================+
```

---

## COSA ABBIAMO (Sessione 1)

### Ricerca Completata (2800+ righe)
- `research/COMPETITOR_ANALYSIS.md` - Leggimenu, Plateform, Toast, Menubly
- `docs/ARCHITETTURA_STUDIO.md` - FastAPI + PostgreSQL + React
- `research/UX_RESEARCH.md` - Mobile-first, best practices
- `research/VALIDATION_REPORT.md` - 8.3/10 dalla Guardiana

### Backend Funzionante
```
Stack: FastAPI + PostgreSQL 15 + SQLAlchemy 2.0

API Endpoints:
- POST /auth/register ✓
- POST /auth/login ✓
- GET /auth/me ✓
- CRUD /categories ✓ (con tenant isolation)
- CRUD /dishes ✓ (con tenant isolation)
- /qr/* (implementato, da testare)
- /public/menu/{slug} (implementato)

Migrations:
- 20260114_0001_initial_schema (tenants, users)
- 20260114_0002_add_qr_codes
- 20260114_0003_add_categories_dishes
```

### Frontend Strutturato
```
Stack: Vite + React 18 + TypeScript + Tailwind CSS

Pagine:
- Login, Register
- Dashboard
- MenuEditor
- PublicMenu

Build: OK (296KB JS, 17KB CSS)
```

### Docker Pronto
```
docker-compose.yml - Dev environment
docker-compose.prod.yml - Production
Makefile - 20+ comandi
```

---

## BUG FIXATI

| Bug | Fix |
|-----|-----|
| Enum case `FREE` vs `free` | `values_callable` in SQLAlchemy Enum |
| Doppia creazione enum | `create_type=False` in migration |
| bcrypt/passlib conflict | Pin `bcrypt==4.0.1` |
| Tabelle categories/dishes mancanti | Migration `20260114_0003` |
| Manca tenant_id nelle query | Aggiornati models e API |

---

## COME AVVIARE

```bash
cd /Users/rafapra/Developer/MenuMaster

# Prima volta
make setup

# Avvio normale
make dev
# oppure
docker-compose up -d

# Migrations (se necessario)
cd backend
DATABASE_URL="postgresql://menumaster:menumaster@localhost:5432/menumaster" alembic upgrade head

# API Docs
open http://localhost:8000/docs

# Frontend
cd frontend && npm run dev
open http://localhost:5173
```

---

## PROSSIMI STEP (Sprint 2)

1. **Frontend collegato a API reali**
   - authApi, menuApi, dishApi funzionanti
   - React Query per data fetching
   - Zustand per state management

2. **QR Code completo**
   - Test endpoint /qr/*
   - Download PNG/SVG/PDF
   - Public menu view

3. **Image upload**
   - Cloudflare R2 setup
   - Upload foto piatti
   - Resize automatico

4. **Test completo**
   - Unit tests backend
   - E2E tests frontend

---

## DECISIONI PRESE

| Decisione | Perché |
|-----------|--------|
| FastAPI + PostgreSQL | Performance, ecosistema Python AI |
| Schema-per-tenant (futuro) | Isolamento dati forte |
| Public schema (MVP) | Velocità prototipo |
| bcrypt==4.0.1 | Compatibilità passlib |
| Tailwind CSS | Rapid prototyping, mobile-first |

---

## CERVELLE USATE

- **Researcher** - Competitor analysis
- **Ingegnera** - Architettura studio
- **Marketing** - UX research
- **Guardiana Ricerca** - Validazione 8.3/10
- **Backend** - API + Models + Migrations
- **Frontend** - React + Tailwind
- **Guardiana Ops** - Docker setup
- **Tester** - Bug finding
- **Guardiana Qualità** - Quality report

---

## PATH PROGETTO

```
/Users/rafapra/Developer/MenuMaster/
├── backend/
│   ├── app/           # FastAPI app
│   ├── alembic/       # Migrations
│   ├── requirements.txt
│   └── Dockerfile
├── frontend/
│   ├── src/           # React app
│   └── package.json
├── research/          # Analisi competitor, UX
├── docs/              # Architettura, roadmap
└── docker-compose.yml
```

---

*"Menu digitale professionale in 5 minuti"*
*MenuMaster - Sessione 1 completata con successo!*
