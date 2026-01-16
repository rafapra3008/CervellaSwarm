# OUTPUT BACKEND: Gmail Sent Endpoint

**Data**: 20260116 | **Worker**: cervella-backend
**Task**: Creare endpoint GET /gmail/sent per Miracallook

---

## File Modificati

- `miracollogeminifocus/miracallook/backend/gmail/api.py` (+41 righe)

---

## Endpoint Creato

```python
@router.get("/sent")
async def get_sent(max_results: int = 20):
    """Ottieni email inviate"""
    # Pattern identico a /inbox ma con labelIds=["SENT"]
```

### Caratteristiche

- **Pattern**: Identico a `/inbox` (righe 592-632)
- **Filtro**: `labelIds=["SENT"]` invece di `["INBOX"]`
- **Risposta**: Stesso formato (count + lista emails con id, threadId, snippet, from, to, subject, date, isUnread)
- **Parametri**: `max_results` (default 20)

---

## Snippet Codice

```python
# Lista messaggi inviati
results = service.users().messages().list(
    userId="me",
    labelIds=["SENT"],
    maxResults=max_results
).execute()

messages = results.get("messages", [])

# Prendi dettagli per ogni messaggio
emails = []
for msg in messages[:max_results]:
    msg_data = service.users().messages().get(
        userId="me",
        id=msg["id"],
        format="metadata",
        metadataHeaders=["From", "To", "Subject", "Date"]
    ).execute()

    headers = {h["name"]: h["value"] for h in msg_data.get("payload", {}).get("headers", [])}

    emails.append({
        "id": msg["id"],
        "threadId": msg["threadId"],
        "snippet": msg_data.get("snippet", ""),
        "from": headers.get("From", ""),
        "to": headers.get("To", ""),
        "subject": headers.get("Subject", "(nessun oggetto)"),
        "date": headers.get("Date", ""),
        "isUnread": "UNREAD" in msg_data.get("labelIds", [])
    })

return {
    "count": len(emails),
    "emails": emails
}
```

---

## Test

```bash
# Dopo autenticazione Google OAuth
curl http://localhost:8000/gmail/sent

# Con limite
curl http://localhost:8000/gmail/sent?max_results=10
```

---

## Note

- ✅ Pattern collaudato riutilizzato da `/inbox`
- ✅ Formato risposta coerente con altri endpoint
- ✅ Error handling ereditato da `get_gmail_service()`
- ✅ Nessuna dipendenza da autenticazione modificata

---

*Cervella Backend - "I dettagli fanno sempre la differenza!"*
