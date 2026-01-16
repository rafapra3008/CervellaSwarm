# RICERCA RT - Registratore Telematico per Hotel (PARTE 2/3)

**Data**: 16 Gennaio 2026
**Ricercatrice**: Cervella Researcher
**Progetto**: Miracollo PMS

*Continua da PARTE 1*

---

## 4. INTEGRAZIONE PMS-RT: WORKFLOW E BEST PRACTICES

### 4.1 Momento di Emissione Scontrino in Hotel

**Quando Emettere il Corrispettivo?**

Secondo normativa fiscale italiana, il **momento di effettuazione** per servizi alberghieri è:

> "Al termine della prestazione del servizio, ovvero al momento del checkout."

**Workflow Standard Hotel**:

```
1. CHECK-IN
   ↓
   [Nessuno scontrino fiscale]
   - Registrazione ospite
   - Eventuale caparra (nota interna, non fiscale)
   - Pre-autorizzazione carta di credito

2. SOGGIORNO
   ↓
   [Accumulo servizi nel PMS]
   - Pernottamenti
   - Extras (minibar, ristorante, spa)
   - Servizi aggiuntivi

3. CHECK-OUT ⭐ MOMENTO EMISSIONE
   ↓
   [PMS calcola totale → Invia a RT → Stampa scontrino]
   - Totale soggiorno calcolato
   - Metodi pagamento applicati
   - Scontrino fiscale emesso
   - Documento consegnato all'ospite

4. POST CHECK-OUT
   ↓
   [RT chiude giornata e trasmette]
   - Chiusura giornaliera RT (entro mezzanotte)
   - Trasmissione automatica AdE (entro 12 giorni)
```

**Eccezione - Pagamenti Anticipati**:

Se l'hotel incassa in anticipo (es. pagamento online non rimborsabile):
- Scontrino alla data di incasso, non di soggiorno
- Oppure: trattare come caparra, scontrino al checkout
- Consulenza commercialista necessaria per policy aziendale

### 4.2 Workflow Tecnico PMS → RT

**Sequenza Completa Checkout**:

```python
# Pseudocodice workflow integrazione PMS-RT

async def checkout_ospite(prenotazione_id):
    # 1. CALCOLO TOTALE
    prenotazione = await db.get_prenotazione(prenotazione_id)
    totale = calcola_totale_soggiorno(prenotazione)

    # 2. GESTIONE PAGAMENTI
    pagamenti = {
        "contante": prenotazione.pagamenti.contante,
        "carta": prenotazione.pagamenti.carta,
        "bancomat": prenotazione.pagamenti.bancomat,
        "altro": prenotazione.pagamenti.altro
    }

    # 3. PREPARAZIONE DOCUMENTO RT
    documento = {
        "items": [
            {
                "descrizione": f"Soggiorno {prenotazione.notti} notti",
                "importo": prenotazione.totale_camere,
                "iva": 10,  # Aliquota IVA ospitalità
                "reparto": 1  # Codice reparto hotel
            },
            # Extras
            *[{
                "descrizione": extra.descrizione,
                "importo": extra.importo,
                "iva": extra.aliquota_iva,
                "reparto": extra.reparto
            } for extra in prenotazione.extras]
        ],
        "pagamenti": pagamenti,
        "totale": totale
    }

    # 4. INVIO A RT
    try:
        scontrino = await rt_client.emetti_scontrino(documento)

        # 5. SALVA RIFERIMENTO FISCALE
        await db.salva_riferimento_fiscale(
            prenotazione_id=prenotazione_id,
            numero_scontrino=scontrino.numero,
            data_emissione=scontrino.data,
            numero_rt=scontrino.id_dispositivo,
            importo_totale=totale
        )

        # 6. AGGIORNA STATO PRENOTAZIONE
        await db.update_prenotazione(
            prenotazione_id,
            stato="checked_out_fiscale",
            scontrino_numero=scontrino.numero
        )

        return {
            "success": True,
            "scontrino": scontrino,
            "pdf_url": genera_pdf_ricevuta(prenotazione, scontrino)
        }

    except RTError as e:
        # Gestione errori (vedi sezione 4.4)
        return await gestisci_errore_rt(e, prenotazione)
```

### 4.3 Gestione Pagamenti Multipli

**Scenario Tipico Hotel**:

Ospite paga parte in contanti, parte con carta:
- Totale: €450,00
- Contante: €200,00
- Carta: €250,00

**Implementazione RT**:

```python
# Documento con pagamenti multipli
documento = {
    "items": [
        {"descrizione": "Soggiorno 3 notti", "importo": 450.00, "iva": 10}
    ],
    "pagamenti": [
        {"tipo": "contante", "importo": 200.00},
        {"tipo": "elettronico", "importo": 250.00}
    ],
    "totale": 450.00
}

# Il RT registra ENTRAMBI i metodi nello stesso scontrino
# Importante per verifica futura POS-RT (obbligo 2026)
```

**Validazione Pre-invio**:

```python
def valida_pagamenti(documento):
    totale_items = sum(item["importo"] for item in documento["items"])
    totale_pagamenti = sum(pag["importo"] for pag in documento["pagamenti"])

    if totale_items != totale_pagamenti:
        raise ValueError(
            f"Totale items ({totale_items}) != "
            f"Totale pagamenti ({totale_pagamenti})"
        )

    if totale_items != documento["totale"]:
        raise ValueError("Totale documento non corrisponde")
```

### 4.4 Gestione Errori RT

**Errori Comuni e Soluzioni**:

| Errore | Causa | Soluzione |
|--------|-------|-----------|
| **RT non raggiungibile** | Rete, RT spento | Retry automatico, fallback offline |
| **Carta esaurita** | Rotolo scontrino finito | Notifica operatore, stampa dopo ricarica |
| **Memoria piena** | Chiusura non fatta da giorni | Forzare chiusura giornaliera |
| **Errore trasmissione AdE** | Connessione internet | RT riprova automatico, monitorare |
| **Numero documento duplicato** | Bug PMS, retry | Gestire idempotenza |
| **Importo negativo non permesso** | Logica annullo errata | Usare documento di reso |

**Pattern Retry con Exponential Backoff**:

```python
async def emetti_scontrino_con_retry(documento, max_tentativi=3):
    for tentativo in range(max_tentativi):
        try:
            return await rt_client.emetti_scontrino(documento)
        except RTNetworkError as e:
            if tentativo == max_tentativi - 1:
                # Ultimo tentativo fallito
                raise

            # Exponential backoff
            wait_seconds = 2 ** tentativo
            logger.warning(
                f"RT non raggiungibile, retry {tentativo+1}/{max_tentativi} "
                f"tra {wait_seconds}s"
            )
            await asyncio.sleep(wait_seconds)
        except RTBusinessError as e:
            # Errori business (es. memoria piena) non ritentare
            raise
```

**Fallback Offline (Scenario Emergenza)**:

```python
async def checkout_con_fallback(prenotazione_id):
    try:
        # Tentativo normale
        return await checkout_ospite(prenotazione_id)
    except RTError as e:
        # RT non disponibile - modalità emergenza
        logger.error(f"RT fallito: {e}, attivo fallback offline")

        # 1. Salva documento in coda offline
        await db.salva_documento_offline(
            prenotazione_id=prenotazione_id,
            documento=documento,
            motivo_offline=str(e),
            timestamp=datetime.now()
        )

        # 2. Genera ricevuta non fiscale temporanea
        ricevuta_temp = genera_ricevuta_temporanea(prenotazione)

        # 3. Notifica staff
        await notify_staff(
            "⚠️ RT offline - documento in coda",
            f"Prenotazione {prenotazione_id} - ricevuta temporanea emessa"
        )

        # 4. Task background riprova
        asyncio.create_task(
            riprova_documenti_offline_periodicamente()
        )

        return {
            "success": True,
            "offline_mode": True,
            "ricevuta_temporanea": ricevuta_temp,
            "warning": "Scontrino fiscale sarà emesso appena RT disponibile"
        }
```

### 4.5 Annullo e Ristampa Scontrini

**Caso 1: Errore PRIMA dell'Emissione**

```python
# Documento non ancora confermato → Annulla e ricrea
if not documento_confermato:
    # Modifica documento
    documento.items[0].importo = importo_corretto
    scontrino = await rt_client.emetti_scontrino(documento)
```

**Caso 2: Errore DOPO l'Emissione**

```python
# Documento già emesso → Serve documento di RESO/ANNULLO

async def annulla_scontrino(numero_scontrino_originale, motivo):
    # 1. Recupera documento originale
    doc_originale = await db.get_documento_fiscale(numero_scontrino_originale)

    # 2. Crea documento di ANNULLO (importi positivi!)
    documento_annullo = {
        "tipo": "annullo",
        "riferimento": {
            "numero": doc_originale.numero,
            "data": doc_originale.data,
            "importo": doc_originale.totale
        },
        "items": [
            {
                "descrizione": f"Annullo scontrino {numero_scontrino_originale}",
                "importo": doc_originale.totale,  # Positivo!
                "iva": 10,
                "tipo": "annullo"
            }
        ],
        "totale": doc_originale.totale
    }

    # 3. Emetti documento di annullo
    scontrino_annullo = await rt_client.emetti_documento_annullo(documento_annullo)

    # 4. Emetti nuovo scontrino corretto
    scontrino_corretto = await rt_client.emetti_scontrino(documento_corretto)

    # 5. Salva correlazione
    await db.salva_annullo(
        originale=numero_scontrino_originale,
        annullo=scontrino_annullo.numero,
        corretto=scontrino_corretto.numero,
        motivo=motivo
    )

    return {
        "annullo": scontrino_annullo,
        "corretto": scontrino_corretto
    }
```

**IMPORTANTE**: Il documento di annullo ha importi **POSITIVI** (non negativi), ma il RT lo tratta come storno che **diminuisce** i corrispettivi giornalieri.

**Caso 3: Ristampa Scontrino (Copia)**

```python
async def ristampa_scontrino(numero_scontrino):
    # Ricerca in memoria RT
    scontrino = await rt_client.ricerca_documento(numero_scontrino)

    if scontrino:
        # Stampa copia (non nuovo documento fiscale)
        await rt_client.stampa_copia(scontrino.numero)
    else:
        # Non trovato in RT, genera da DB PMS
        doc_db = await db.get_documento_fiscale(numero_scontrino)
        pdf = genera_copia_non_fiscale(doc_db)
        return pdf
```

### 4.6 Chiusura Giornaliera Automatica

**Problema**: Operatore dimentica chiusura giornaliera → corrispettivi non trasmessi → problemi fiscali.

**Soluzione**: Task automatico PMS.

```python
import asyncio
from datetime import datetime, time

async def chiusura_giornaliera_automatica():
    """
    Task che gira 24/7, chiude RT automaticamente alle 23:55
    """
    while True:
        now = datetime.now()

        # Calcola prossima chiusura (23:55)
        target_time = datetime.combine(
            now.date(),
            time(23, 55)  # 5 minuti prima di mezzanotte
        )

        if now > target_time:
            # Già passata oggi, schedula per domani
            target_time += timedelta(days=1)

        # Aspetta fino a target_time
        wait_seconds = (target_time - now).total_seconds()
        await asyncio.sleep(wait_seconds)

        # CHIUSURA GIORNALIERA
        try:
            logger.info("🔄 Chiusura giornaliera automatica RT...")
            result = await rt_client.chiusura_giornaliera()

            logger.info(
                f"✅ Chiusura completata: "
                f"{result.numero_documenti} documenti, "
                f"totale €{result.totale_corrispettivi}"
            )

            # Notifica staff (opzionale)
            await notify_staff(
                "✅ Chiusura giornaliera RT completata",
                f"Documenti: {result.numero_documenti}\n"
                f"Totale: €{result.totale_corrispettivi}"
            )

        except Exception as e:
            logger.error(f"❌ Errore chiusura giornaliera: {e}")

            # Notifica urgente staff
            await notify_staff_urgente(
                "⚠️ ERRORE chiusura RT",
                f"Chiusura giornaliera fallita: {e}\n"
                "AZIONE RICHIESTA: Chiudere manualmente RT"
            )

# Avvio task all'avvio PMS
asyncio.create_task(chiusura_giornaliera_automatica())
```

**Configurazione Hotel 24h**:

Per hotel aperti oltre mezzanotte (reception notturna):

```python
# Configurazione in config.py
CHIUSURA_RT_CONFIG = {
    "orario": "23:55",  # Prima chiusura
    "hotel_24h": True,
    "seconda_chiusura": None,  # Opzionale: chiusura notturna 05:00
}

# Se hotel_24h = True:
# - Chiusura alle 23:55 per corrispettivi del giorno
# - Check-in dopo mezzanotte vanno nel giorno successivo
# - Nuova chiusura opzionale mattino seguente
```

---

## 5. CASI PRATICI E SCENARI HOTEL

### 5.1 Scenario A: Hotel Indipendente (30 Camere)

**Configurazione Raccomandata**:

- **Hardware**: Epson FP-81II RT (€700)
- **Connessione**: Ethernet cablata (più affidabile)
- **Integrazione**: HTTP/XML custom Python
- **Chiusura**: Automatica 23:55
- **Backup**: Documento offline se RT down

**Costi Annui**:
- Acquisto RT: €700 (una tantum)
- Canone assistenza: €150/anno
- Verifiche biennali: €80-100 (ogni 2 anni)
- **Totale primo anno**: €850
- **Totale anni successivi**: €150/anno

**ROI**: Conformità normativa + automazione vs multa €1.000-4.000.

### 5.2 Scenario B: Catena Regionale (5 Hotel)

**Configurazione Raccomandata**:

- **Hardware**: Epson RT-90 SERVER (centralizzato)
- **Casse periferiche**: Software PMS emette documenti
- **Server RT**: Raccoglie, sigilla, trasmette
- **Gestione**: Centralizzata da sede

**Costi Annui**:
- Server RT: €2.500 (una tantum)
- Canone assistenza: €300/anno (server unico)
- Verifiche biennali: €100 (ogni 2 anni)
- **Totale primo anno**: €2.800
- **Totale anni successivi**: €300/anno

**Confronto con 5 RT Fisici**:
- 5 x €700 = €3.500 acquisto
- 5 x €150 = €750/anno assistenza
- 5 x €50 = €250 verifiche biennali

**Risparmio Server RT**:
- Anno 1: €1.450 risparmio
- Anni successivi: €450/anno risparmio

### 5.3 Scenario C: Startup PMS Multi-Hotel (SaaS)

**Configurazione Raccomandata**:

- **Nessun hardware**: API Cloud (es. Effatta)
- **Abbonamento**: €40/mese per hotel
- **Integrazione**: SDK Python (2-4 ore dev)
- **Scalabilità**: Immediata (nuovo hotel = nuovo abbonamento)

**Costi per Hotel**:
- Setup: €0
- Abbonamento: €40/mese x 12 = €480/anno
- Manutenzione: €0 (automatica)

**Vantaggi**:
- Zero capitale iniziale
- Onboarding hotel istantaneo
- Nessuna gestione hardware
- Conformità sempre aggiornata

**Svantaggi**:
- Dipendenza internet critica
- Costi ricorrenti vs una tantum
- Lock-in provider

**Quando Conviene**:
- Startup senza capitale iniziale
- Modello SaaS con molti clienti
- Crescita rapida prevista
- Focus su software, non hardware

---

## 6. INTEGRAZIONE POS-RT (OBBLIGO 2026)

### 6.1 Come Funzionerà il Collegamento

**Dal 1° Gennaio 2026**: POS e RT devono comunicare.

**Meccanismo**:

1. **Ospite paga con carta** → POS processa pagamento
2. **POS invia importo a RT** → Protocollo 17 o API
3. **RT riceve conferma importo** → Registra nel documento
4. **Chiusura giornaliera** → File XML include:
   - Totale corrispettivi
   - Totale pagamenti elettronici
   - **Correlazione importi POS**
5. **Agenzia Entrate verifica** → Coerenza POS-RT

**Protocollo 17**:

Standard di comunicazione POS → RT:

```
POS: "Ho incassato €150,00 con carta"
  ↓
RT: "Ricevuto, lo includo nel documento corrente"
  ↓
Scontrino finale: Include €150 come pagamento elettronico
```

### 6.2 Impatto su PMS

**Workflow Modificato**:

```python
async def checkout_con_pos_integrato(prenotazione_id):
    totale = calcola_totale(prenotazione_id)

    # 1. AVVIA TRANSAZIONE POS
    pos_transaction = await pos_client.init_transaction(totale)

    # 2. OSPITE PAGA CON CARTA
    # (POS gestisce chip/contactless/PIN)
    pos_result = await pos_client.wait_payment()

    if pos_result.success:
        # 3. POS INVIA AUTOMATICAMENTE IMPORTO A RT
        # (Protocollo 17 - trasparente per PMS)

        # 4. PMS EMETTE SCONTRINO
        # RT già ha ricevuto importo elettronico da POS
        documento = {
            "items": [...],
            "totale": totale,
            "pagamenti": [
                {
                    "tipo": "elettronico",
                    "importo": totale,
                    # RT correla con importo POS
                    "pos_transaction_id": pos_result.transaction_id
                }
            ]
        }

        scontrino = await rt_client.emetti_scontrino(documento)

    return scontrino
```

**Configurazione Iniziale (Post Marzo 2026)**:

```python
# 1. Registrare abbinamento su portale AdE
# (Operazione manuale web)

# 2. Configurare POS per inviare a RT
pos_config = {
    "rt_ip": "192.168.1.100",
    "rt_protocol": "protocol_17",
    "auto_send_amount": True
}

# 3. Configurare RT per ricevere da POS
rt_config = {
    "accept_pos_amounts": True,
    "pos_ip_whitelist": ["192.168.1.50"],  # IP POS
    "validate_amounts": True
}
```

### 6.3 Gestione Multi-POS

**Hotel con Più POS** (reception + ristorante + bar):

```python
# Ogni POS deve essere abbinato al RT
POS_DEVICES = [
    {
        "id": "POS_RECEPTION",
        "ip": "192.168.1.50",
        "location": "Reception",
        "rt_mapping": "192.168.1.100"
    },
    {
        "id": "POS_RESTAURANT",
        "ip": "192.168.1.51",
        "location": "Ristorante",
        "rt_mapping": "192.168.1.100"  # Stesso RT
    }
]

# RT riceve importi da tutti i POS
# Chiusura giornaliera: Somma tutti i pagamenti elettronici
```

---

*Continua in PARTE 3: Raccomandazioni Finali, Roadmap Implementazione, FAQ*
