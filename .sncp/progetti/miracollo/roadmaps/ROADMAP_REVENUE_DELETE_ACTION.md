# Roadmap: Revenue Fix - Cancellare Azione

> Data: 12 Gennaio 2026 - Sessione 175
> Priorità: Media
> Stima: 4 step

---

## Obiettivo

Aggiungere la possibilità di **cancellare** un'azione (suggestion application) in Revenue Intelligence.

---

## Analisi Struttura Esistente

**Backend:**
- `routers/action_tracking_api.py` - Endpoint API
- `routers/action_tracking_service.py` - Business logic
- `routers/action_tracking_rollback.py` - Operazioni rollback/pause/resume

**Frontend:**
- `action-history.html` - Vista timeline azioni
- `js/action-history.js` - Logica UI (500+ righe)

**Database:**
- `suggestion_applications` - Tabella principale
- Status esistenti: active, paused, rolled_back, completed

**Endpoint esistenti:**
- POST /apply - Applica suggerimento
- GET /applications - Lista
- POST /undo - Undo (entro 10s)
- POST /pause - Pausa
- POST /resume - Riprende
- POST /rollback - Rollback
- POST /restore - Ripristina

---

## Piano Implementazione

### STEP 1: Migration Database

**File:** `backend/database/migrations/035_action_soft_delete.sql`

```sql
-- Soft delete field per suggestion_applications
ALTER TABLE suggestion_applications
ADD COLUMN deleted_at TEXT DEFAULT NULL;

-- Index per query performance
CREATE INDEX IF NOT EXISTS idx_applications_deleted
ON suggestion_applications(deleted_at);
```

**Perché soft delete:**
- Audit trail (quando è stato cancellato)
- Possibilità futura di "restore from deleted"
- Non modifica logica status esistenti

---

### STEP 2: Backend - Endpoint DELETE

**File:** `routers/action_tracking_api.py`

```python
@router.delete("/applications/{application_id}")
async def delete_application(
    application_id: int,
    db: Session = Depends(get_db)
):
    """Soft delete un'applicazione."""
    # Verifica esiste
    # Verifica status (solo rolled_back o completed possono essere cancellati)
    # Update deleted_at = CURRENT_TIMESTAMP
    # Return success
```

**File:** `routers/action_tracking_service.py`

```python
def soft_delete_application(db, application_id: int) -> dict:
    """Soft delete con audit trail."""
    # Verifica applicazione esiste e non già cancellata
    # Verifica status è cancellabile (rolled_back, completed, paused)
    # NON cancellare se status = 'active' (deve prima fare rollback)
    # Update deleted_at
    # Return info cancellazione
```

---

### STEP 3: Frontend - Bottone + Modale

**File:** `action-history.html`

Aggiungere modale conferma:
```html
<div class="modal-overlay" id="delete-modal" style="display: none;">
  <div class="modal-content">
    <h3>Conferma Cancellazione</h3>
    <p>Sei sicuro di voler cancellare questa azione?</p>
    <p class="warning">Questa operazione non può essere annullata.</p>
    <div class="modal-actions">
      <button id="delete-cancel">Annulla</button>
      <button id="delete-confirm" class="danger">Cancella</button>
    </div>
  </div>
</div>
```

**File:** `js/action-history.js`

Aggiungere:
```javascript
// Bottone delete per status rolled_back, completed, paused
function renderDeleteButton(application) {
  if (['rolled_back', 'completed', 'paused'].includes(application.status)) {
    return `<button class="btn-delete" onclick="openDeleteModal(${application.id})">🗑️ Cancella</button>`;
  }
  return '';
}

// Modale conferma
function openDeleteModal(applicationId) { ... }
function closeDeleteModal() { ... }

// API call
async function handleDelete(applicationId) {
  const response = await fetch(`/api/suggestions/applications/${applicationId}`, {
    method: 'DELETE'
  });
  if (response.ok) {
    showToast('Azione cancellata');
    loadApplications(); // Refresh lista
  }
}
```

---

### STEP 4: Aggiornare Query Lista

**File:** `routers/action_tracking_service.py`

Tutte le query devono filtrare:
```python
WHERE deleted_at IS NULL
```

---

## Regole Business

1. **Chi può cancellare:**
   - Status `rolled_back` - Sì (già annullata)
   - Status `completed` - Sì (monitoraggio finito)
   - Status `paused` - Sì (sospesa)
   - Status `active` - NO! Deve prima fare rollback

2. **Audit trail:**
   - `deleted_at` registra timestamp cancellazione
   - Futuro: `deleted_by` per user ID

3. **Soft delete:**
   - Record rimane in DB
   - Non appare nelle liste
   - Recuperabile in futuro se serve

---

## Test

1. Cancellare azione con status `rolled_back` - OK
2. Cancellare azione con status `completed` - OK
3. Cancellare azione con status `paused` - OK
4. Tentare cancellare azione `active` - ERRORE (deve fare rollback prima)
5. Verificare azione non appare più in lista dopo cancellazione
6. Verificare modale conferma funziona

---

## File da Modificare

| File | Modifica |
|------|----------|
| `migrations/035_action_soft_delete.sql` | NUOVO - Aggiunge campo |
| `routers/action_tracking_api.py` | Aggiunge endpoint DELETE |
| `routers/action_tracking_service.py` | Aggiunge logica soft delete + filtro query |
| `action-history.html` | Aggiunge modale conferma |
| `js/action-history.js` | Aggiunge bottone + handler |

---

*"I dettagli fanno SEMPRE la differenza!"*
