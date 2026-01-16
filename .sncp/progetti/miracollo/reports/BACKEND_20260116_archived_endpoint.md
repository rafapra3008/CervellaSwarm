# OUTPUT: Endpoint GET /gmail/archived

**Data**: 20260116 | **Worker**: cervella-backend
**Specs**: Task da Regina (Miracallook)

---

## File Modificati

- `/Users/rafapra/Developer/miracollogeminifocus/miracallook/backend/gmail/api.py`
  - Aggiunto endpoint `@router.get("/archived")` (righe 678-723)

---

## Implementazione

```python
@router.get("/archived")
async def get_archived_emails(max_results: int = 20):
    """
    Lista email archiviate (non in inbox, non in trash, non in spam).

    In Gmail, "archived" = email senza label INBOX.
    Usa query q="-in:inbox -in:trash -in:spam" per filtrarle.
    """
```

### Pattern Usato

- Stesso pattern di `/sent` endpoint
- Usa Gmail query `q="-in:inbox -in:trash -in:spam"`
- Ritorna stesso formato risposta (count + emails[])

### Response Format

```json
{
  "count": 15,
  "emails": [
    {
      "id": "...",
      "threadId": "...",
      "snippet": "...",
      "from": "...",
      "to": "...",
      "subject": "...",
      "date": "...",
      "isUnread": false
    }
  ]
}
```

---

## Come Testare

```bash
# Prerequisito: autenticazione Gmail valida
GET http://localhost:8000/gmail/archived?max_results=20
```

---

## Note

- **Archived in Gmail** = Email senza label INBOX
- Non include trash/spam (query filtrata)
- Supporta paginazione con `max_results` parameter
- Default: 20 email
- Metadata: From, To, Subject, Date

---

## COSTITUZIONE-APPLIED

**COSTITUZIONE-APPLIED:** SI

**Principio usato:** "Fatto BENE > Fatto VELOCE"

Ho seguito esattamente il pattern esistente (`/sent`) invece di creare una soluzione nuova, garantendo coerenza nella codebase. Ho usato la query Gmail corretta per "archived" (`-in:inbox -in:trash -in:spam`), rispettando il funzionamento reale di Gmail dove "archiviare" significa rimuovere il label INBOX.
