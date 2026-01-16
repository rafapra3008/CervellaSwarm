# RICERCA: Modulo Finanziario/Fiscale PMS Competitor - INDEX

**Data**: 16 Gennaio 2026
**Ricercatrice**: Cervella Researcher
**Progetto**: Miracollo PMS

---

## Indice Ricerca

Questa ricerca analizza come i principali PMS hotel gestiscono il modulo finanziario/fiscale, con focus sul mercato italiano.

### Documenti della Ricerca

1. **PARTE 1 - Tabella Comparativa Competitor**
   - File: `20260116_RICERCA_PMS_FISCALE_PARTE1.md`
   - Contenuto: Confronto sistematico di 6 PMS (Ericsoft, Protel, Opera, Mews, Cloudbeds, Sysdat)
   - Parametri: Workflow fiscale, fatturazione, RT, UX, export contabilità

2. **PARTE 2 - Best Practices e Pattern**
   - File: `20260116_RICERCA_PMS_FISCALE_PARTE2.md`
   - Contenuto: Pattern comuni, best practices identificate, casi d'uso
   - Focus: Workflow checkout, gestione errori, automazioni

3. **PARTE 3 - Raccomandazioni per Miracollo**
   - File: `20260116_RICERCA_PMS_FISCALE_PARTE3.md`
   - Contenuto: Architettura consigliata, workflow UX, step implementazione
   - Output: Roadmap pratica per il modulo fiscale di Miracollo

---

## Executive Summary

### Competitor Studiati

| PMS | Mercato | Tipo | Focus Fiscale |
|-----|---------|------|---------------|
| **Ericsoft Suite 5°** | Italia | On-premise/Cloud | Completo (RT + SDI) |
| **Protel** | EU/Global | Cloud/On-premise | Billing avanzato |
| **Opera (Oracle)** | Global Enterprise | Cloud | Multi-country compliance |
| **Mews** | Global Cloud-native | Cloud | API-first, integrazioni |
| **Cloudbeds** | Global SMB | Cloud | Fiscalizzazione via API |
| **Sysdat Turismo** | Italia | On-premise | RT + FE italiana |

### Key Findings (Anteprima)

**Workflow Fiscale Standard:**
- 3 approcci principali: integrato, intermediato, API-based
- Checkout → scelta documento → emissione → archiviazione
- Automazione chiusura giornaliera = must-have

**Fatturazione Elettronica:**
- Tutti supportano XML fattura PA
- Split 50/50: invio SDI diretto vs intermediario
- Trend: preferenza intermediari certificati (meno responsabilità)

**Registratore Telematico:**
- Marche comuni: Epson, RCH, Custom
- Integrazione via protocolli specifici (no standard universale)
- Novità 2026: collegamento RT-POS obbligatorio

**UX Checkout:**
- Range: 2-3 click (Opera, sistemi enterprise) → 10+ click (Mews, segnalazioni utenti)
- Pattern vincente: workflow guidato, scelta documento smart, error prevention

**Export Contabilità:**
- Formati: CSV, Excel, XML custom, API
- Integrazioni dirette con ERP dello stesso vendor (es. Ericsoft → Zucchetti)
- Standard USALI per reporting revenue

---

## Fonti Principali

- Documentazione ufficiale: Ericsoft, Protel, Oracle, Mews, Cloudbeds, Sysdat
- Normativa italiana: RT 2026, SDI, corrispettivi elettronici
- Review utenti: Hotel Tech Report, Trustpilot, forum settore
- Ricerca condotta: 16 Gennaio 2026

---

## Prossimi Step

1. Leggere **PARTE 1** per dettagli tecnici di ogni competitor
2. Leggere **PARTE 2** per best practices e pattern
3. Leggere **PARTE 3** per raccomandazioni implementative Miracollo
4. Decidere architettura modulo fiscale basandosi su questa ricerca

---

*"I player grossi hanno già risolto questi problemi - studiamoli!"*
