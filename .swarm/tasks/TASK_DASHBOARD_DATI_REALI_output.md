# Output: TASK_DASHBOARD_DATI_REALI

**Worker:** cervella-frontend
**Data:** 2026-01-07
**Stato:** COMPLETATO

---

## Cosa è stato fatto

### 1. Creato hook `useDashboardData.ts`

**Path:** `dashboard/frontend/src/hooks/useDashboardData.ts`

Il nuovo hook:
- Fa fetch a `http://localhost:8100/api/mappa`
- Trasforma la response API nei tipi dashboard (Nord, Famiglia, Roadmap, Sessione)
- Gestisce loading state
- Gestisce errori
- Auto-refresh ogni 30 secondi
- Espone funzione `refetch()` per refresh manuale

### 2. Modificato `App.tsx`

- Importa e usa `useDashboardData` hook
- Passa dati reali ai widget invece di mock
- Mostra loading state durante il fetch
- Mostra errore con messaggio chiaro se API non raggiungibile

### 3. Aggiunto loading state ai widget

- `RoadmapWidget.tsx` - aggiunto supporto loading prop
- `FamigliaWidget.tsx` - aggiunto supporto loading prop

### 4. Fix TypeScript

- Rimosso import inutilizzati per passare build

---

## File modificati/creati

| File | Azione |
|------|--------|
| `dashboard/frontend/src/hooks/useDashboardData.ts` | CREATO |
| `dashboard/frontend/src/App.tsx` | MODIFICATO |
| `dashboard/frontend/src/components/RoadmapWidget.tsx` | MODIFICATO |
| `dashboard/frontend/src/components/FamigliaWidget.tsx` | MODIFICATO |

---

## Build

```
✓ tsc build passed
✓ vite build passed (450ms)
✓ 35 modules transformed
```

---

## Come testare

1. Avvia backend: `cd dashboard && python -m uvicorn backend.main:app --port 8100`
2. Avvia frontend: `cd dashboard/frontend && npm run dev`
3. Apri http://localhost:5173
4. Verifica che i dati cambino quando modifichi NORD.md

---

## Note

- Il widget Famiglia mostra dati statici (workers). Per dati live serve endpoint `/api/workers`
- Il widget Sessione mostra "Nessun task" perché non c'è polling attivo dei task
- Per aggiornamenti real-time considerare SSE (già esiste `useSSE.ts`)
