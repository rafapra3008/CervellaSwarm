# RICERCA RT - Registratore Telematico per Hotel (PARTE 3/3)

**Data**: 16 Gennaio 2026
**Ricercatrice**: Cervella Researcher
**Progetto**: Miracollo PMS

*Continua da PARTE 2*

---

## 7. RACCOMANDAZIONI PER MIRACOLLO PMS

### 7.1 Strategia Raccomandata

**APPROCCIO IBRIDO - Massima Flessibilità**

```
┌─────────────────────────────────────────────────────────────┐
│  MIRACOLLO PMS - ARCHITETTURA RT MODULARE                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐                                          │
│  │  PMS Core    │                                          │
│  │  (FastAPI)   │                                          │
│  └──────┬───────┘                                          │
│         │                                                   │
│    ┌────▼────────────────────────────┐                    │
│    │  RT Abstraction Layer           │                    │
│    │  (Plugin Architecture)          │                    │
│    └────┬────────────┬───────────┬───┘                    │
│         │            │           │                         │
│    ┌────▼────┐  ┌───▼─────┐ ┌──▼──────┐                  │
│    │ Plugin  │  │ Plugin  │ │ Plugin  │                  │
│    │ Epson   │  │ API     │ │ Custom  │                  │
│    │ HTTP/XML│  │ Cloud   │ │ Protocol│                  │
│    └─────────┘  └─────────┘ └─────────┘                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Vantaggi**:
- Cliente sceglie provider RT (Epson fisico, API Cloud, altro)
- Zero lock-in
- Facile aggiungere nuovi provider
- Testing semplice (mock plugin)

### 7.2 Architettura Codice

**1. Interfaccia Astratta**

```python
# miracollo/integrations/fiscal/base.py

from abc import ABC, abstractmethod
from typing import List, Dict
from dataclasses import dataclass

@dataclass
class FiscalDocument:
    """Documento fiscale standard Miracollo"""
    items: List[Dict]
    payments: List[Dict]
    total: float
    metadata: Dict

@dataclass
class FiscalReceipt:
    """Scontrino fiscale emesso"""
    number: str
    date: str
    device_id: str
    total: float
    fiscal_data: Dict  # Dati specifici provider

class FiscalDeviceProvider(ABC):
    """Interfaccia astratta per provider RT"""

    @abstractmethod
    async def emit_receipt(self, document: FiscalDocument) -> FiscalReceipt:
        """Emette scontrino fiscale"""
        pass

    @abstractmethod
    async def cancel_receipt(self, receipt_number: str, reason: str) -> FiscalReceipt:
        """Annulla scontrino esistente"""
        pass

    @abstractmethod
    async def daily_closure(self) -> Dict:
        """Chiusura giornaliera"""
        pass

    @abstractmethod
    async def search_receipt(self, receipt_number: str) -> FiscalReceipt:
        """Cerca scontrino in memoria"""
        pass

    @abstractmethod
    async def health_check(self) -> bool:
        """Verifica stato dispositivo"""
        pass
```

**2. Plugin Epson HTTP/XML**

```python
# miracollo/integrations/fiscal/providers/epson_http.py

import httpx
from ..base import FiscalDeviceProvider, FiscalDocument, FiscalReceipt

class EpsonHTTPProvider(FiscalDeviceProvider):
    """Provider per Epson FP-81II/90III RT via HTTP/XML"""

    def __init__(self, config: Dict):
        self.ip = config["ip"]
        self.port = config.get("port", 80)
        self.endpoint = f"http://{self.ip}:{self.port}/cgi-bin/fpmate.cgi"
        self.timeout = config.get("timeout", 10)

    async def emit_receipt(self, document: FiscalDocument) -> FiscalReceipt:
        """Emette scontrino tramite Epson HTTP/XML"""

        # Costruisci XML Epson
        xml = self._build_epson_xml(document)

        # Invia a RT
        async with httpx.AsyncClient(timeout=self.timeout) as client:
            response = await client.post(
                self.endpoint,
                content=xml,
                headers={"Content-Type": "application/xml"}
            )

        # Parsea risposta
        receipt_data = self._parse_epson_response(response.text)

        return FiscalReceipt(
            number=receipt_data["numero"],
            date=receipt_data["data"],
            device_id=receipt_data["id_rt"],
            total=document.total,
            fiscal_data=receipt_data
        )

    def _build_epson_xml(self, document: FiscalDocument) -> str:
        """Costruisce XML compatibile Epson"""
        # Logica specifica Epson
        xml = f"""<?xml version="1.0"?>
        <printerFiscal>
          <printReceipt>
            <beginFiscalReceipt operator="1"/>
            {''.join([
                f'<printRecItem description="{item["descrizione"]}" '
                f'quantity="1" unitPrice="{item["importo"]}" '
                f'department="{item.get("reparto", 1)}" />'
                for item in document.items
            ])}
            {''.join([
                f'<printRecTotal payment="{self._map_payment_type(p["tipo"])}" '
                f'paymentAmount="{p["importo"]}" />'
                for p in document.payments
            ])}
            <endFiscalReceipt/>
          </printReceipt>
        </printerFiscal>
        """
        return xml

    def _map_payment_type(self, tipo: str) -> str:
        """Mappa tipi pagamento Miracollo → Epson"""
        mapping = {
            "contante": "0",
            "carta": "1",
            "bancomat": "1",
            "elettronico": "1"
        }
        return mapping.get(tipo, "0")

    async def daily_closure(self) -> Dict:
        """Chiusura giornaliera Epson"""
        xml = """<?xml version="1.0"?>
        <printerFiscal>
          <printZReport/>
        </printerFiscal>
        """

        async with httpx.AsyncClient(timeout=30) as client:
            response = await client.post(self.endpoint, content=xml)

        return self._parse_closure_response(response.text)

    # ... altri metodi ...
```

**3. Plugin API Cloud (Effatta/Fiskaly)**

```python
# miracollo/integrations/fiscal/providers/cloud_api.py

import httpx
from ..base import FiscalDeviceProvider, FiscalDocument, FiscalReceipt

class CloudAPIProvider(FiscalDeviceProvider):
    """Provider per soluzioni cloud (Effatta, Fiskaly, etc)"""

    def __init__(self, config: Dict):
        self.api_key = config["api_key"]
        self.base_url = config["base_url"]
        self.organization_id = config.get("organization_id")

    async def emit_receipt(self, document: FiscalDocument) -> FiscalReceipt:
        """Emette scontrino tramite API Cloud"""

        # Formato JSON standard provider
        payload = {
            "items": [
                {
                    "name": item["descrizione"],
                    "price": item["importo"],
                    "vat_rate": item["iva"],
                    "quantity": 1
                }
                for item in document.items
            ],
            "payments": [
                {
                    "type": self._map_payment_type(p["tipo"]),
                    "amount": p["importo"]
                }
                for p in document.payments
            ]
        }

        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.base_url}/receipts",
                json=payload,
                headers={"Authorization": f"Bearer {self.api_key}"}
            )

        data = response.json()

        return FiscalReceipt(
            number=data["receipt_number"],
            date=data["timestamp"],
            device_id=self.organization_id,
            total=document.total,
            fiscal_data=data
        )

    async def daily_closure(self) -> Dict:
        """Chiusura giornaliera (automatica per API cloud)"""
        # Molti provider cloud gestiscono automaticamente
        # Ritorna solo statistiche
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{self.base_url}/daily-summary",
                headers={"Authorization": f"Bearer {self.api_key}"}
            )
        return response.json()

    # ... altri metodi ...
```

**4. Factory e Configurazione**

```python
# miracollo/integrations/fiscal/factory.py

from .providers.epson_http import EpsonHTTPProvider
from .providers.cloud_api import CloudAPIProvider
from .providers.mock import MockProvider

class FiscalProviderFactory:
    """Factory per creare provider RT"""

    PROVIDERS = {
        "epson_http": EpsonHTTPProvider,
        "cloud_api": CloudAPIProvider,
        "mock": MockProvider,  # Per testing
    }

    @staticmethod
    def create(provider_type: str, config: Dict):
        """Crea provider in base a configurazione"""
        provider_class = FiscalProviderFactory.PROVIDERS.get(provider_type)

        if not provider_class:
            raise ValueError(f"Provider {provider_type} non supportato")

        return provider_class(config)

# Uso in PMS
from miracollo.config import settings

fiscal_provider = FiscalProviderFactory.create(
    provider_type=settings.FISCAL_PROVIDER_TYPE,
    config=settings.FISCAL_PROVIDER_CONFIG
)

# Checkout
receipt = await fiscal_provider.emit_receipt(document)
```

**5. Configurazione Hotel (database)**

```python
# Database: hotels table
{
    "id": "hotel_001",
    "name": "Hotel Bella Vista",
    "fiscal_config": {
        "provider": "epson_http",
        "config": {
            "ip": "192.168.1.100",
            "port": 80,
            "timeout": 10,
            "auto_daily_closure": True,
            "closure_time": "23:55"
        }
    }
}

# Altro hotel, altro provider
{
    "id": "hotel_002",
    "name": "Hotel Cloud",
    "fiscal_config": {
        "provider": "cloud_api",
        "config": {
            "api_key": "sk_live_...",
            "base_url": "https://api.effatta.it/v1",
            "organization_id": "org_123"
        }
    }
}
```

### 7.3 Roadmap Implementazione

**FASE 1: Foundation (Sprint 1-2) - 2 settimane**

```
✅ Obiettivi:
- [ ] Definire interfaccia FiscalDeviceProvider
- [ ] Creare MockProvider per testing
- [ ] Implementare factory pattern
- [ ] Test suite per interfaccia astratta

📦 Deliverables:
- File: miracollo/integrations/fiscal/base.py
- File: miracollo/integrations/fiscal/providers/mock.py
- File: miracollo/integrations/fiscal/factory.py
- Tests: 100% coverage interfaccia

🎯 Success Criteria:
- Checkout usa MockProvider
- Test completi passano
- Documentazione API chiara
```

**FASE 2: Provider Epson HTTP/XML (Sprint 3-4) - 2 settimane**

```
✅ Obiettivi:
- [ ] Studio documentazione Epson FP-81II RT
- [ ] Implementare EpsonHTTPProvider
- [ ] Gestione errori Epson-specific
- [ ] Testing con Epson simulato (docker?)

📦 Deliverables:
- File: miracollo/integrations/fiscal/providers/epson_http.py
- Docker: epson_rt_simulator (opzionale)
- Docs: EPSON_INTEGRATION.md

🎯 Success Criteria:
- Emissione scontrino funziona
- Annullo documenti funziona
- Chiusura giornaliera funziona
- Gestione errori robusta
```

**FASE 3: Provider Cloud API (Sprint 5) - 1 settimana**

```
✅ Obiettivi:
- [ ] Valutare provider (Effatta vs Fiskaly vs altri)
- [ ] Implementare CloudAPIProvider
- [ ] Configurazione multi-tenant

📦 Deliverables:
- File: miracollo/integrations/fiscal/providers/cloud_api.py
- Docs: CLOUD_API_SETUP.md

🎯 Success Criteria:
- Hotel può scegliere cloud vs fisico
- Onboarding cloud < 5 minuti
```

**FASE 4: POS Integration (Sprint 6-7) - 2 settimane**

```
✅ Obiettivi:
- [ ] Studio Protocollo 17 (POS-RT)
- [ ] Implementare POS integration layer
- [ ] Configurazione abbinamento POS-RT
- [ ] Testing con POS simulato

📦 Deliverables:
- File: miracollo/integrations/pos/base.py
- File: miracollo/integrations/pos/protocol17.py
- Docs: POS_RT_INTEGRATION.md

⏰ Timing:
- Implementare DOPO Marzo 2026 (portale AdE disponibile)
- Preparare architettura ORA
- Testing con mock fino a portale ready
```

**FASE 5: Production Hardening (Sprint 8) - 1 settimana**

```
✅ Obiettivi:
- [ ] Monitoring & alerting RT offline
- [ ] Fallback offline mode robusto
- [ ] Task chiusura automatica giornaliera
- [ ] Dashboard stato fiscale

📦 Deliverables:
- Monitoring: Grafana dashboard RT
- Alerts: RT offline, chiusura mancata
- Admin panel: Stato documenti fiscali

🎯 Success Criteria:
- Zero perdita documenti
- Recovery automatico da errori
- Notifiche proattive problemi
```

**Timeline Totale: 8-9 settimane (2 mesi)**

### 7.4 Priorità Sviluppo

**MUST HAVE (P0) - Per Launch**:
- ✅ Interfaccia astratta + MockProvider
- ✅ EpsonHTTPProvider (80% hotel usa Epson)
- ✅ Emissione scontrino checkout
- ✅ Chiusura giornaliera automatica
- ✅ Gestione errori base

**SHOULD HAVE (P1) - 3 Mesi Post-Launch**:
- ✅ CloudAPIProvider (per hotel nuovi)
- ✅ Annullo documenti
- ✅ Fallback offline robusto
- ✅ Monitoring avanzato

**COULD HAVE (P2) - 6 Mesi Post-Launch**:
- ✅ POS Integration (obbligo da 2026)
- ✅ Multi-provider per hotel
- ✅ Dashboard analytics fiscali
- ✅ Export dati per commercialista

**WON'T HAVE (Fuori Scope)**:
- ❌ Supporto fatturazione elettronica B2B (modulo separato)
- ❌ Gestione magazzino (non pertinente hotel)
- ❌ Contabilità completa (integrazione con software esterno)

---

## 8. COSTI E ROI

### 8.1 Confronto Opzioni per Hotel Tipo

**Hotel Indipendente - 40 Camere - 70% Occupancy**

| Opzione | Anno 1 | Anni 2-5 (totale) | Totale 5 anni |
|---------|--------|-------------------|---------------|
| **RT Fisico Epson** | €850 | €600 | €1.450 |
| **API Cloud** | €480 | €1.920 | €2.400 |
| **Server RT** | N/A (solo catene) | N/A | N/A |

**Raccomandazione**: RT Fisico Epson (costo totale inferiore, funziona offline).

---

**Catena 5 Hotel - Media 50 Camere**

| Opzione | Anno 1 | Anni 2-5 (totale) | Totale 5 anni |
|---------|--------|-------------------|---------------|
| **5 RT Fisici** | €4.250 | €3.000 | €7.250 |
| **Server RT Centralizzato** | €2.800 | €1.200 | €4.000 |
| **5 API Cloud** | €2.400 | €9.600 | €12.000 |

**Raccomandazione**: Server RT (€3.250 risparmio vs RT fisici, €8.000 risparmio vs cloud).

---

**Startup PMS SaaS - 20 Clienti Anno 1 → 100 Anno 5**

| Opzione | Anno 1 (20 hotel) | Anno 5 (100 hotel) | Totale 5 anni |
|---------|-------------------|--------------------| --------------|
| **RT Fisici** (clienti comprano) | €0 PMS | €0 PMS | €0* |
| **API Cloud** (incluso abbonamento PMS) | €9.600 | €48.000 | ~€150.000** |
| **Ibrido** (cliente sceglie) | Variabile | Variabile | Ottimale |

*PMS non paga hardware, ma clienti pagano €850/hotel
**PMS include costo nel pricing SaaS

**Raccomandazione**: Architettura ibrida (cliente sceglie). PMS offre integrazione con entrambi, cliente paga provider fiscale.

### 8.2 Pricing Suggerito Miracollo

**Modello Subscription SaaS**:

```
┌─────────────────────────────────────────────────────┐
│  MIRACOLLO PMS - PRICING                            │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Piano Base: €X/camera/mese                        │
│    ✅ PMS completo                                 │
│    ✅ Integrazione RT (interfaccia)                │
│    ❌ Provider RT NON incluso                      │
│                                                     │
│  Piano Plus: €Y/camera/mese                        │
│    ✅ Tutto del Base                               │
│    ✅ API Cloud RT inclusa                         │
│    ✅ Zero hardware fiscale                        │
│    ✅ Conformità garantita                         │
│                                                     │
│  Piano Enterprise: Custom                          │
│    ✅ Server RT centralizzato                      │
│    ✅ Multi-property                               │
│    ✅ SLA garantito                                │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Esempio Numeri**:

- Base: €2/camera/mese (hotel 40 camere = €80/mese)
- Plus: €3/camera/mese (include API Cloud RT = €120/mese)
- Enterprise: €200-500/mese flat per catena

**Value Proposition Plus**:
- Hotel paga €40/mese in più (€120 vs €80 Base)
- Evita acquisto RT fisico €700
- Evita canoni assistenza €150/anno
- **ROI hotel: Break-even in 6 mesi**

---

## 9. FAQ E TROUBLESHOOTING

### 9.1 Domande Frequenti

**Q: Posso usare Miracollo PMS senza RT?**

A: **No**. Dal 1 Gennaio 2020, emissione corrispettivi telematici è obbligatoria per hotel. Miracollo offre integrazione RT, ma il provider fiscale (fisico o cloud) è necessario per legge.

---

**Q: Cosa succede se internet cade durante checkout?**

A: Dipende dal provider:

- **RT Fisico**: Continua a funzionare, memorizza localmente, trasmette entro 12 giorni quando internet torna.
- **API Cloud**: Fallback offline mode → Miracollo salva documento in coda, riemette quando internet OK.

**Raccomandazione**: RT fisico per zone con internet instabile.

---

**Q: Devo emettere scontrino per prenotazioni OTA (Booking.com)?**

A: **Sì**, se l'ospite paga direttamente l'hotel al check-out. **No**, se Booking.com fattura tutto all'hotel (modello Virtual Credit Card) - in quel caso serve fattura elettronica B2B a Booking.com.

---

**Q: Come gestisco ospiti che vogliono fattura aziendale?**

A: All'inizio soggiorno, chiedi se necessita fattura. Se sì:
- NON emettere scontrino
- Emetti fattura elettronica B2B al check-out
- Fattura va in SdI (Sistema Interscambio), non RT

**Miracollo**: Implementare flag "richiede_fattura" in prenotazione.

---

**Q: Quanto tempo richiede integrazione RT in Miracollo?**

A: Secondo roadmap:
- **MockProvider** (testing): 1 settimana
- **EpsonHTTPProvider** (produzione): 2 settimane
- **CloudAPIProvider**: 1 settimana
- **Total**: 4-5 settimane per integrazione completa

---

**Q: Cosa cambia con obbligo POS-RT dal 2026?**

A: Dal 1 Gennaio 2026:
1. Hotel deve abbinare POS a RT su portale AdE (operazione una tantum)
2. POS invia importi elettronici a RT automaticamente (Protocollo 17)
3. RT verifica coerenza pagamenti in chiusura giornaliera
4. **Miracollo**: Update integrazione per supportare POS (Fase 4 roadmap)

**No panic**: Portale AdE disponibile Marzo 2026, 45 giorni per adeguamento.

---

**Q: Miracollo supporta anche fatturazione elettronica B2B?**

A: **Fuori scope RT** (modulo separato). RT gestisce solo corrispettivi B2C (scontrini). Per fatture elettroniche B2B (agenzie, aziende):
- Modulo separato integrazione SdI
- Oppure integrazione con software fatturazione terzo (TeamSystem, Aruba, etc)

**Raccomandazione**: Fase 1 = RT (obbligatorio). Fase 2 = Fatturazione B2B (nice-to-have).

---

**Q: Posso cambiare provider RT dopo setup iniziale?**

A: **Sì**, grazie ad architettura plugin:
```python
# Cambio configurazione hotel
hotel.fiscal_config = {
    "provider": "cloud_api",  # Prima era "epson_http"
    "config": {...}
}
```

Nessun cambio codice PMS. **Vantaggio architettura astratta**.

---

### 9.2 Troubleshooting Comuni

**Problema: RT non risponde**

```
Errore: ConnectionRefused http://192.168.1.100

Diagnosi:
1. RT acceso? Check LED frontale
2. Rete raggiungibile? ping 192.168.1.100
3. IP corretto? Verificare etichetta RT
4. Firewall? Porta 80 aperta?

Soluzione:
- Riavvia RT (power cycle)
- Verifica cavo Ethernet
- Check configurazione IP statico RT
- Fallback offline mode PMS
```

---

**Problema: Chiusura giornaliera non trasmette**

```
Errore: Chiusura OK, ma AdE non riceve dati

Diagnosi:
1. RT ha internet? Check LED connessione
2. Certificato RT valido? Verifica scadenza
3. File XML corrotto? Check log RT

Soluzione:
- Verifica connessione internet RT
- Se certificato scaduto: chiamata assistenza
- Forza ritrasmissione manuale
```

---

**Problema: Importo POS non corrisponde a RT**

```
Errore: POS €150, RT registra €0 (dal 2026)

Diagnosi:
1. Abbinamento POS-RT fatto su portale AdE?
2. Protocollo 17 attivo su POS?
3. IP RT configurato su POS?

Soluzione:
- Registrare abbinamento su portale AdE
- Configurare POS con IP RT
- Test transazione €1 per verifica
```

---

## 10. CONCLUSIONI E NEXT STEPS

### 10.1 Sintesi Decisioni Chiave

**Per Miracollo PMS**:

1. ✅ **Architettura Plugin**: Supportare RT fisico E API Cloud
2. ✅ **Provider Prioritario**: Epson HTTP/XML (mercato maggioritario)
3. ✅ **Provider Cloud**: Effatta o Fiskaly (per hotel innovativi)
4. ✅ **Timeline**: 8-9 settimane per integrazione completa
5. ✅ **Obbligo 2026**: Preparare architettura POS-RT ora, implementare post-Marzo 2026

**Per Hotel Clienti**:

| Scenario | Hardware Consigliato | Motivazione |
|----------|---------------------|-------------|
| Hotel singolo < 50 camere | Epson FP-81II RT | Costo totale minore, offline-ready |
| Catena 3-10 hotel | Epson RT-90 SERVER | Risparmio manutenzione 60% |
| Catena 10+ hotel | Server RT + API Cloud ibrido | Massima flessibilità |
| Hotel tech-savvy | API Cloud (Effatta) | Zero hardware, sempre aggiornato |
| Hotel zona internet instabile | RT Fisico obbligatorio | Fallback offline |

### 10.2 Prossimi Step Immediati

**Per Development Team**:

```
SETTIMANA 1-2: Foundation
├─ Definire interfaccia FiscalDeviceProvider ✅
├─ Implementare MockProvider ✅
├─ Setup test suite ✅
└─ Documentazione API ✅

SETTIMANA 3-4: Provider Epson
├─ Studio docs Epson FP-81II RT ✅
├─ Implementare EpsonHTTPProvider ✅
├─ Testing integrazione ✅
└─ Gestione errori ✅

SETTIMANA 5: Provider Cloud
├─ Valutare Effatta vs Fiskaly ✅
├─ Implementare CloudAPIProvider ✅
└─ Test onboarding hotel ✅

SETTIMANA 6-7: Chiusura Automatica
├─ Task scheduler chiusura 23:55 ✅
├─ Monitoring & alerts ✅
└─ Dashboard admin ✅

SETTIMANA 8: Production Hardening
├─ Load testing ✅
├─ Security audit ✅
└─ Docs finali ✅
```

**Per Business/Sales**:

1. **Contatto Epson Italia**: Partnership rivenditore RT (sconti clienti)
2. **Contatto Effatta**: Partnership API Cloud (pricing dedicato)
3. **Materiale Marketing**: "Miracollo PMS - Fiscalmente Conforme 2026"
4. **Webinar Hotel**: "Come prepararsi all'obbligo POS-RT 2026"

### 10.3 Risorse Utili

**Documentazione Ufficiale**:

- [Specifiche Tecniche RT V11.1 - Agenzia Entrate](https://www.agenziaentrate.gov.it/portale/documents/20143/5852274/Specifiche_Tecniche_RT_V11.1_24-01-26.pdf)
- [Corrispettivi Telematici - Agenzia Entrate](https://www.agenziaentrate.gov.it/portale/schede/comunicazioni/fatture-e-corrispettivi/fatture-e-corrispettivi-st/st-invio-corrispettivi-registratori-telematici-temp)
- [Provvedimento POS-RT - Agenzia Entrate](https://www.agenziaentrate.gov.it/portale/documents/20143/5852274/Provvedimento+POS-RT+31+ottobre+2025.pdf)

**Provider Hardware**:

- [Epson Registratori Telematici](https://www.epson.it/it_IT/verticals/business-solutions-for-retail/fiscal)
- [Epson FP-81II RT - Manuale Utente](https://www.tuttufficio.biz/wp-content/uploads/2020/04/Epson-FP81II-FP90III-RT-Manuale-Utente.pdf)

**Provider Cloud**:

- [Effatta - API Scontrino Elettronico](https://effatta.it/integra-il-tuo-software-con-le-api-scontrino-elettronico/)
- [Fiskaly - Corrispettivi Telematici Cloud](https://www.fiskaly.com/blog/corrispettivi-telematici-software-as-an-alternative-to-telematic-registers)

**PMS Competitor (per reference)**:

- [Bedzzle - Corrispettivi Hotel](https://www.bedzzle.com/it/pms/corrispettivi-elettronici-hotel-stampante-fiscale)
- [Hotel in Cloud - Requisiti RT](https://guide.hotelincloud.com/it/articles/4747518-requisiti-per-il-collegamento-a-un-registratore-telematico-rt)

---

## APPENDICE A: Glossario Termini

| Termine | Definizione |
|---------|-------------|
| **RT** | Registratore Telematico - Dispositivo fiscale per emissione corrispettivi |
| **Corrispettivi** | Incassi giornalieri B2C (cliente finale senza P.IVA) |
| **AdE** | Agenzia delle Entrate |
| **B2C** | Business to Consumer (cliente finale) |
| **B2B** | Business to Business (azienda/agenzia con P.IVA) |
| **Chiusura giornaliera** | Operazione RT che sigilla e trasmette corrispettivi del giorno |
| **Protocollo 17** | Standard comunicazione POS → RT per importi elettronici |
| **Server RT** | RT centralizzato che raccoglie dati da più casse |
| **API Cloud** | Soluzione software cloud alternativa a RT fisico |
| **XML 7.0** | Formato standard trasmissione corrispettivi ad AdE |
| **SdI** | Sistema di Interscambio - per fatture elettroniche B2B |

---

## APPENDICE B: Checklist Implementazione

**Per Developer che implementa integrazione RT**:

```
SETUP INIZIALE
├─ [ ] Studiare docs Agenzia Entrate RT V11.1
├─ [ ] Studiare manuale Epson FP-81II RT
├─ [ ] Setup ambiente test (Mock RT)
└─ [ ] Definire test cases

CODICE
├─ [ ] Creare interfaccia astratta FiscalDeviceProvider
├─ [ ] Implementare MockProvider (per CI/CD)
├─ [ ] Implementare EpsonHTTPProvider
├─ [ ] Implementare CloudAPIProvider (opzionale fase 1)
├─ [ ] Implementare Factory pattern
├─ [ ] Gestione errori e retry logic
├─ [ ] Task chiusura giornaliera automatica
└─ [ ] Logging e monitoring

TESTING
├─ [ ] Unit tests interfaccia (100% coverage)
├─ [ ] Integration tests con Mock RT
├─ [ ] Integration tests con Epson RT reale
├─ [ ] Test workflow completo checkout
├─ [ ] Test gestione errori (RT offline, carta esaurita, etc)
├─ [ ] Test annullo documenti
├─ [ ] Test chiusura giornaliera
└─ [ ] Load testing (100 checkout/ora)

DOCUMENTAZIONE
├─ [ ] README integrazione RT
├─ [ ] Docs API FiscalDeviceProvider
├─ [ ] Guida configurazione Epson
├─ [ ] Guida configurazione Cloud API
├─ [ ] Troubleshooting guide
└─ [ ] Video tutorial setup

DEPLOYMENT
├─ [ ] Configurazione production (IP RT, API keys)
├─ [ ] Setup monitoring Grafana/Prometheus
├─ [ ] Alerts (RT offline, chiusura fallita)
├─ [ ] Backup plan (fallback offline)
└─ [ ] Rollout graduale (1 hotel test → tutti)
```

---

**FINE RICERCA RT**

**Ricercatrice**: Cervella Researcher
**Tempo Ricerca**: ~3 ore (web search + analisi + strutturazione)
**Pagine Totali**: 3 parti, ~1500 righe documentazione
**Fonti Consultate**: 50+ (Agenzia Entrate, produttori RT, PMS competitor, normativa)

**Raccomandazione Finale per Miracollo**:

> **Architettura plugin con supporto Epson HTTP/XML e API Cloud. Priorità Epson per mercato maggioritario, Cloud per innovatori. Timeline 8 settimane, ROI immediato per conformità normativa obbligatoria.**

---

## FONTI E RIFERIMENTI

### Normativa e Obblighi
- [ANBBA - Pagamenti elettronici e attività ricettive 2026](https://www.anbba.it/pagamenti-elettronici-pos-registratore-telematico-extra-alberghiero-2026/)
- [Qualitytravel - Collegamento POS-RT 2026](https://www.qualitytravel.it/collegamento-obbligatorio-tra-registratore-di-cassa-e-pos-dal-1-gennaio-2026-guida-completa/180691)
- [ASAT - Nuovo obbligo POS e RT](https://www.asat.it/nuovo-obbligo-pos-e-registratore-telematico/53-6641/)
- [Slope - POS e RT 2026 hotel](https://www.slope.it/2025/11/05/pos-e-registratori-telematici-2026-cosa-deve-fare-hotel/)

### Corrispettivi Telematici
- [Agenzia Entrate - Specifiche Tecniche RT V11.1](https://www.agenziaentrate.gov.it/portale/documents/20143/5852274/Specifiche_Tecniche_RT_V11.1_24-01-26.pdf)
- [Agenzia Entrate - Corrispettivi da RT](https://www.agenziaentrate.gov.it/portale/schede/comunicazioni/fatture-e-corrispettivi/fatture-e-corrispettivi-st/st-invio-corrispettivi-registratori-telematici-temp)
- [Studio Bogoni - Tracciato XML 7.0](https://www.studiobogoni.it/corrispettivi-telematici-lagenzia-chiarisce-il-nuovo-tracciato-7-0/)
- [Studiocom - Circolare corrispettivi telematici](https://www.studiocom.it/2023/03/31/circolare-n-16-2023-corrispettivi-telematici-anomalie-in-sede-di-invio-e-chiarimenti-agenzia-entrate/)

### Hardware e Provider
- [Epson Italia - Registratori Telematici](https://www.epson.it/it_IT/verticals/business-solutions-for-retail/fiscal)
- [Epson FP-81II/90III RT - Manuale Utente](https://www.tuttufficio.biz/wp-content/uploads/2020/04/Epson-FP81II-FP90III-RT-Manuale-Utente.pdf)
- [Terya - RT e Server RT per GDO](https://www.terya.com/blog-retail/tutto-su-registratore-di-cassa-telematico-e-server-rt-per-la-gdo)
- [Fiskaly - Corrispettivi Cloud](https://www.fiskaly.com/blog/corrispettivi-telematici-software-as-an-alternative-to-telematic-registers)

### Integrazione e Protocolli
- [Omnitekstore - FAQ POS e RT Compatibilità](https://www.omnitekstore.it/blog/post/pos-e-registratori-rt-compatibilita-comunicazione-protocollo-17.html)
- [Effatta - API Scontrino Elettronico](https://effatta.it/integra-il-tuo-software-con-le-api-scontrino-elettronico/)
- [OpenAPI - Tax Receipt API](https://openapi.com/blog/tax-receipt-api)

### PMS Integration
- [Bedzzle - Corrispettivi elettronici hotel](https://www.bedzzle.com/it/pms/corrispettivi-elettronici-hotel-stampante-fiscale)
- [Hotel in Cloud - Requisiti RT](https://guide.hotelincloud.com/it/articles/4747518-requisiti-per-il-collegamento-a-un-registratore-telematico-rt-stampante-fiscale-degli-scontrini-documenti-commerciali)
- [Slope - Scontrino elettronico hotel](https://www.slope.it/2019/10/31/scontrino-elettronico-hotel-come-funziona-e-come-gestirlo-in-hotel/)

### Gestione Errori e Workflow
- [Pierluca e Associati - Scontrino errato](https://www.pierlucaeassociati.it/sp/scontrino-elettronico-errato.3sp)
- [Alias Digital - Annullo scontrino](https://aliasdigital.it/blog/come-annullare-uno-scontrino-elettronico-errato/)
- [Studio Pastorelli - Errori scontrini](https://www.studioassociatopastorelli.it/errori-nella-battitura-degli-scontrini-telematici-resi-e-annullamenti/)

### Fatturazione Hotel
- [TeamSystem - Corrispettivo o fattura hotel](https://www.teamsystem.com/magazine/horeca/prestazioni-alberghiere-corrispettivo-o-fattura/)
- [InformazioneFiscale - Corrispettivi ristoranti alberghi](https://www.informazionefiscale.it/corrispettivi-ristoranti-alberghi-scontrino-fattura-elettronica)
- [TeamSystem - Scontrino o ricevuta fiscale](https://www.teamsystem.com/magazine/horeca/scontrino-o-ricevuta-fiscale/)

### Pagamenti e Costi
- [SiteMinder - Pagamento online hotel](https://www.siteminder.com/it/r/pagamento-online-dellhotel/)
- [Wubook - Metodi pagamento hotel](https://wubook.net/blog/metodi-di-pagamento-per-hotel-e-strutture-ricettive)
- [EasyCassa - Sistema franchising](https://www.easycassa.it/punto-cassa-franchising)
