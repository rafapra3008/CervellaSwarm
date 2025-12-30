# API Endpoints - CervellaSwarm

## GET /api/greeting

Ritorna un saluto personalizzato basato sull'ora corrente.

### Logica Saluti

| Fascia Oraria | Saluto |
|---------------|--------|
| 05:00 - 12:00 | Buongiorno! |
| 12:00 - 18:00 | Buon pomeriggio! |
| 18:00 - 22:00 | Buonasera! |
| 22:00 - 05:00 | Buonanotte! |

### Response Format

```json
{
  "status": "success",
  "data": {
    "greeting": "Buon pomeriggio!",
    "hour": 12
  }
}
```

### Test Locale

```bash
cd /Users/rafapra/Developer/CervellaSwarm/test-orchestrazione
python3 api/greeting.py
```

### Integrazione

```python
from api.greeting import get_greeting, handle_request

# Ottieni solo il saluto
result = get_greeting()
print(result["greeting"])  # "Buongiorno!"

# Ottieni JSON completo
json_response = handle_request()
print(json_response)
```

---

*Creato da: Cervella Backend*
*Versione: 1.0.0*
*Data: 2025-12-30*
