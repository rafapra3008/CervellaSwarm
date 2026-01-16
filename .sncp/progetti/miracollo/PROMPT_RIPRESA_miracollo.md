# PROMPT RIPRESA - Miracollo

> **Ultimo aggiornamento:** 16 Gennaio 2026 - Sessione 233
> **FATTO: Dissezionato PMS Core + MAPPA Modulo Finanziario completa**

---

## SESSIONE 233: MODULO FINANZIARIO MAPPATO

### Cosa Abbiamo Fatto
- **Dissezionato PMS Core** - 3 audit paralleli, 15+ moduli analizzati
- **Identificato GAP** - Modulo finanziario al 10%
- **Ricerche complete** - Fatturazione elettronica, RT, competitor
- **MAPPA creata** - Score 9.4/10, pronta per sviluppo
- **NORD aggiornato** - Aggiunto modulo finanziario

### Pattern Vincente Identificato
```
ONE-CLICK CHECKOUT
├── 95% casi = Ricevuta automatica
├── 5% casi = Fattura su richiesta
├── Workflow: 3 step, 90-120 secondi
└── Email PDF sempre inclusa
```

---

## PROSSIMA SESSIONE - SPRINT 1: RICEVUTE PDF

```
PRIORITA MASSIMA - 3-4 giorni sviluppo

[ ] Template HTML ricevuta professionale
[ ] Service PDF (WeasyPrint)
[ ] Endpoint GET /api/receipts/booking/{id}/pdf
[ ] Endpoint POST /api/receipts/booking/{id}/email
[ ] Storage in /data/receipts/{year}/{month}/
[ ] Test con prenotazioni reali
```

### File da Creare
- `backend/services/receipt_pdf_service.py`
- `backend/templates/receipt_template.html`

---

## ROADMAP COMPLETA MODULO FINANZIARIO

| Sprint | Priorita | Tempo |
|--------|----------|-------|
| 1. Ricevute PDF | MAX | 3-4 giorni |
| 2. Checkout UI | ALTA | 2-3 giorni |
| 3. RT Integration | ALTA | 5-7 giorni |
| 4. Fatture XML | MEDIA | 2-3 giorni |

**BLOCKER Sprint 3:** Serve info RT esistente hotel (marca, IP)

---

## FILE CHIAVE

| Cosa | Path |
|------|------|
| **MAPPA Finanziario** | `.sncp/.../moduli/finanziario/MAPPA_MODULO_FINANZIARIO.md` |
| MAPPA Dissezionata | `.sncp/.../reports/MAPPA_DISSEZIONATA_PMS_CORE_20260116.md` |
| Ricerca Competitor | `.sncp/.../idee/RICERCA_PMS_FISCALE_*.md` |
| Ricerca UX Checkout | `.sncp/.../idee/RICERCA_CHECKOUT_FISCALE_UX.md` |
| NORD | `NORD.md` |

---

## ARCHITETTURA ECOSISTEMA

```
MIRACOLLO
├── PMS CORE (:8000)        → 85% - Produzione
├── MODULO FINANZIARIO      → 10% - DA SVILUPPARE
├── MIRACALLOOK (:8002)     → 60% - Parcheggiato
└── ROOM HARDWARE (:8003)   → 10% - Attesa hardware
```

---

## CONTESTO HOTEL

- **Sistema attuale**: Ericsoft (riferimento workflow)
- **Contabilita**: SCP Spring (XML in cartella)
- **RT**: Da verificare marca/modello

---

*"Una cosa alla volta, ROBUSTO e COMPLETO!"*
*"Studiare i grossi, fare meglio per noi!"*
