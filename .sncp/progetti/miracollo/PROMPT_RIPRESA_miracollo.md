# PROMPT RIPRESA - Miracollo

> **Ultimo aggiornamento:** 15 Gennaio 2026 - Sessione 223
> **LEGGI E AGISCI. NON RI-ANALIZZARE.**

---

## STATO IN UNA RIGA

**Room Manager MVP LIVE. VDA hardware ordinato. MIRACOLLOOK: SPRINT 2 COMPLETATO - 80%!**

---

## COSA È LIVE

```
PMS Core (prenotazioni, planning, ospiti, tariffe)
Rateboard AI (meteo, eventi, learning)
Room Manager MVP (grid, housekeeping, activity log)
  URL: https://miracollo.com/room-manager.html
```

---

## SESSIONE 223: MIRACOLLOOK SPRINT 2 COMPLETATO!

```
+================================================================+
|   DUE FEATURE IMPLEMENTATE IN UNA SESSIONE!                    |
|                                                                |
|   1. Upload Attachments                                        |
|      - Backend: POST /gmail/send-with-attachments (FormData)   |
|      - Frontend: useAttachments.ts + AttachmentPicker.tsx      |
|      - Max 25MB, MIME detection, progress bar                  |
|      - Commit: defee72                                         |
|                                                                |
|   2. Thread View                                               |
|      - Backend: GET /gmail/thread/{id}                         |
|      - Frontend: useThread.ts + ThreadView.tsx                 |
|      - Messaggi collapsabili, Expand/Collapse All              |
|      - Commit: 2a5051e                                         |
|                                                                |
|   FASE 1: 50% -> 80% (+30% sessione!)                          |
+================================================================+
```

---

## STATO MIRACOLLOOK

```
FASE 0 (Fondamenta)     100%
  OAuth, Inbox, Send, Reply, Forward, Archive, Trash, Search, AI

FASE 1 (Email Solido)   80%
  Mark Read/Unread
  Drafts Auto-Save
  Upload Attachments    <- Sessione 223!
  Thread View           <- Sessione 223!
  Resizable Panels (3h)
  Bulk Actions (5h)
  Labels Custom (3h)
  Contacts (6h)
  Context Menu (5h)

~19h rimanenti per FASE 1 completa
```

**Docs:** `.sncp/progetti/miracollo/moduli/miracollook/`

---

## VDA - Hardware Ordinato

```
HARDWARE (Amazon.it - arrivo 1-2 giorni):
- USB-RS485 FTDI (DSD TECH SH-U11L) - 19E
- Multimetro Electraline - 12E
- Cacciaviti precisione - 10E
- Cavetti jumper - 8E

PROSSIMO (quando arriva):
1. Setup Mac: driver FTDI + ModbusSniffer
2. Test converter funziona
3. Sniffing passivo in hotel
```

---

## PROSSIMA SESSIONE MIRACOLLOOK

```
Sprint 3 - COMPLETAMENTO (19h):
- Resizable Panels (3h) - ricerca pronta
- Bulk Actions (5h)
- Labels Custom (3h)
- Contacts Autocomplete (6h)
- Context Menu (5h) - ricerca dettagliata!
```

---

## FILE CHIAVE

| Cosa | Path |
|------|------|
| **Miracollook stato** | `.sncp/progetti/miracollo/moduli/miracollook/stato.md` |
| **Roadmap FASE 1** | `.sncp/progetti/miracollo/moduli/miracollook/roadmaps/ROADMAP_FASE1_COMPLETA.md` |

---

## REGOLA ANTI-BUGIE

```
MAI scrivere "FATTO" senza:
1. Codice SCRITTO nel repository
2. Codice COMMITTATO
3. Feature TESTATA

"SU CARTA != REALE"
```

---

*"Un progresso al giorno = 365 progressi all'anno."*
*"Fatto BENE > Fatto VELOCE"*
