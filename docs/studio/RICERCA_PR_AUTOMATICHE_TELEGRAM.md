# Ricerca: PR Automatiche + Telegram Notifiche

> **Data:** 1 Gennaio 2026
> **Ricercatore:** cervella-researcher
> **Progetto:** CervellaSwarm FASE 10c - Automazione Avanzata

---

## TL;DR - Key Findings

1. **PyGithub** e lo standard de-facto per PR automatiche (Python 3.10+)
2. **Fine-grained tokens** (2025) > classic tokens (sicurezza +90%)
3. **python-telegram-bot v22+** con async/await (pattern moderno)
4. **Rate limits:** GitHub = 5000 req/h, Telegram = 30 msg/s
5. **Big Tech Pattern:** Separate refactoring PRs, auto-merge con guardrails

---

## PARTE 1: PR AUTOMATICHE

### Libreria Raccomandata: PyGithub

```bash
pip install PyGithub
```

### Esempio Codice Base

```python
from github import Github, Auth
import os

# Autenticazione con Fine-Grained Token (SICURO!)
auth = Auth.Token(os.getenv("GITHUB_TOKEN"))
g = Github(auth=auth)
repo = g.get_repo("username/repo-name")

# Creare PR
pr = repo.create_pull(
    base="main",
    head="feature-branch",
    title="[AUTO] Refactor - 2026-01-01",
    body="## Changes\n- File cleanup\n- Duplicates removed"
)
print(f"PR created: {pr.html_url}")
```

### Fine-Grained Token Permissions

Permessi minimi necessari:
```
Repository permissions:
  - Contents: Read & Write
  - Metadata: Read
  - Pull requests: Read & Write
```

### Pattern Big Tech (2025)

1. **Separate Refactoring PRs** - Mai mischiare feature + refactor
2. **Small PRs (< 250 righe)** - Review +60% piu veloce
3. **Auto-Merge con Guardrails** - Solo se CI passa + approved

### Safety Checklist

```python
def safe_auto_merge(pr):
    checks = {
        "mergeable": pr.mergeable,
        "all_reviews_approved": pr.review_decision == "APPROVED",
        "ci_passed": all(c.conclusion == "success" for c in pr.get_checks()),
        "is_auto_pr": "[AUTO]" in pr.title,
    }

    if all(checks.values()):
        pr.merge(merge_method="squash")
        return True
    return False
```

---

## PARTE 2: TELEGRAM BOT

### Setup Rapido

1. Apri Telegram, cerca `@BotFather`
2. Invia `/newbot`
3. Scegli nome: "CervellaSwarm Alerts"
4. Salva il TOKEN

### Codice Minimo (Requests)

```python
import requests

def send_telegram(token, chat_id, message):
    url = f'https://api.telegram.org/bot{token}/sendMessage'
    params = {
        'chat_id': chat_id,
        'text': message,
        'parse_mode': 'Markdown'
    }
    response = requests.get(url, params=params, timeout=10)
    return response.ok

# Uso
send_telegram(TOKEN, CHAT_ID, "*Alert!* PR creata")
```

### Rate Limiting

| Tipo | Limite |
|------|--------|
| Chat singola | 1 msg/secondo |
| Gruppo | 20 msg/minuto |
| Broadcast | 30 msg/secondo |

### Pattern Anti-Spam

```python
import time
from threading import Lock

class TelegramThrottler:
    def __init__(self, max_rate=1.0):
        self.max_rate = max_rate
        self.tokens = max_rate
        self.last_update = time.time()
        self.lock = Lock()

    def wait_if_needed(self):
        with self.lock:
            now = time.time()
            self.tokens = min(self.max_rate, self.tokens + (now - self.last_update))
            self.last_update = now

            if self.tokens < 1:
                time.sleep((1 - self.tokens) / self.max_rate)
                self.tokens = 0
            else:
                self.tokens -= 1
```

---

## PARTE 3: RACCOMANDAZIONI CERVELLASWARM

### Timeline Implementazione

| Settimana | Task |
|-----------|------|
| 1 | Telegram notifier base (50 righe) |
| 2 | Auto-PR creator (100 righe) |
| 3 | Rate limiting + retry (150 righe) |
| 4 | Dashboard + monitoring (100 righe) |

### Classe SwarmNotifier (Production)

```python
import os
import requests
from datetime import datetime

class SwarmNotifier:
    def __init__(self):
        self.token = os.getenv("TELEGRAM_BOT_TOKEN")
        self.chat_id = os.getenv("TELEGRAM_CHAT_ID")

    def send(self, message, silent=False):
        url = f'https://api.telegram.org/bot{self.token}/sendMessage'
        params = {
            'chat_id': self.chat_id,
            'text': message,
            'parse_mode': 'Markdown',
            'disable_notification': silent
        }
        try:
            requests.get(url, params=params, timeout=10)
            return True
        except:
            return False

    def notify_pr_created(self, pr_url):
        self.send(f"*PR Automatica*\n{pr_url}")
```

### Security Checklist

- [ ] Token in .env (MAI hardcoded)
- [ ] .env in .gitignore
- [ ] Fine-grained token con minimal permissions
- [ ] Token expiration <= 90 giorni
- [ ] Rate limiting implementato

---

## FONTI PRINCIPALI

- [PyGithub Documentation](https://pygithub.readthedocs.io/)
- [GitHub Fine-Grained Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [python-telegram-bot](https://github.com/python-telegram-bot/python-telegram-bot)
- [Telegram Rate Limits](https://limits.tginfo.me/en)

---

*Ricerca completata da cervella-researcher per FASE 10c*

*"Lo sciame che MIGLIORA da solo!"* 🐝
