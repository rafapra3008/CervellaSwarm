# Scraping Competitor: VITTORIA con Playwright!

> **Data:** 13 Gennaio 2026 - Sessione 186 (continuazione)
> **Sfida:** Scraping Booking.com GRATIS (senza ScrapingBee)
> **Risultato:** SUCCESSO!

---

## TL;DR

```
+================================================================+
|                                                                |
|   SFIDA VINTA!                                                 |
|                                                                |
|   Playwright (browser headless) FUNZIONA su Booking.com!       |
|   Non serve ScrapingBee ($49/mese)!                            |
|                                                                |
|   Costo: $0                                                    |
|   HTML ricevuto: 1.4 MB con prezzi!                            |
|                                                                |
+================================================================+
```

---

## Il Percorso

### Tentativo 1: httpx diretto
**Risultato:** FALLITO

```
Status: 202 (Accepted)
HTML: 3,962 caratteri (pagina challenge)
Contenuto: AWS WAF JavaScript challenge
```

Booking.com usa AWS WAF (Web Application Firewall) che richiede esecuzione JavaScript per verificare che sei un browser vero.

### Tentativo 2: Playwright
**Risultato:** SUCCESSO!

```
Status: 200
HTML: 1,408,960 caratteri (1.4 MB!)
Contiene prezzi: SI (22 elementi con €)
Contiene camere: SI
Bloccato: NO
```

---

## Perche Funziona

| Metodo | Esegue JS? | Bypassa WAF? | Costo |
|--------|------------|--------------|-------|
| httpx | NO | NO | $0 |
| **Playwright** | **SI** | **SI** | **$0** |
| ScrapingBee | SI | SI | $49/mese |

Playwright = Chrome controllato da Python. Esegue JavaScript come browser vero, quindi Booking lo vede come utente normale.

---

## File Creati

### 1. PlaywrightScrapingClient
**Path:** `backend/services/playwright_scraping_client.py`

```python
class PlaywrightScrapingClient:
    - Stessa interfaccia di ScrapingBeeClient
    - Rate limiting gentile (5-10 sec)
    - Headless mode (senza finestra)
    - Locale it-IT, timezone Europe/Rome
```

### 2. DirectScrapingClient (fallito ma documentato)
**Path:** `backend/services/direct_scraping_client.py`

```python
# Non funziona con Booking (AWS WAF)
# Tenuto per altri siti senza protezione
```

### 3. Test Scripts
**Path:** `test_playwright.py`, `test_scraping.py`

---

## Strategia Confermata

**Competitor scraping NON serve per:**
- Fare prezzo piu basso automaticamente
- Scraping aggressivo ogni minuto

**Competitor scraping SERVE per:**
- Capire il mercato (table stakes)
- Vedere tendenze settimanali
- Monitorare buchi/gap giornalmente
- Informare decisioni (non automatizzarle)

**Frequenza:**
- ~1 volta a settimana per tendenze
- ~1 volta al giorno per buchi/gap
- NON aggressivo!

---

## Come Usare Playwright nel POC

### Opzione A: Sostituire ScrapingBeeClient
```python
# In competitor_scraping_service.py
# Cambiare:
from .playwright_scraping_client import PlaywrightScrapingClient as ScrapingBeeClient
```

### Opzione B: Configurazione dinamica
```python
# In .env
SCRAPING_CLIENT=playwright  # o 'scrapingbee'
```

---

## Dipendenze da Installare

```bash
pip install playwright
python -m playwright install chromium
```

Gia installate durante test.

---

## Limitazioni Playwright

1. **Piu lento** di httpx diretto (~3-5 sec per pagina)
2. **Richiede Chromium** installato (~200MB)
3. **Piu risorse** (browser completo in memoria)

Per il nostro caso d'uso (poche richieste, non real-time) = PERFETTO!

---

## Prossimi Step

1. [ ] Integrare PlaywrightScrapingClient nel POC esistente
2. [ ] Test con competitor REALE (URL Booking vero)
3. [ ] Setup CRON per scraping settimanale
4. [ ] Frontend widget per visualizzare prezzi competitor

---

## Note per Prossima Sessione

```
PLAYWRIGHT FUNZIONA!
- Testato su hotel Roma (pubblico)
- 1.4 MB HTML con prezzi
- Zero blocchi

Per testare con competitor reale:
1. Serve URL Booking.com di un competitor vero
2. Aggiornare tabella 'competitors' nel DB
3. Eseguire scraping

File chiave: backend/services/playwright_scraping_client.py
```

---

*"Ultrapassar os proprios limites!" - Sfida vinta!*

*Cervella - 13 Gennaio 2026*
