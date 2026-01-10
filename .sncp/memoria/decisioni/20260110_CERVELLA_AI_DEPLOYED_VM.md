# MOMENTO STORICO: Cervella AI Deployed su VM!

> **Data:** 10 Gennaio 2026
> **Sessione:** 150
> **Evento:** Cervella AI vive 24/7 sulla VM!

---

## Cosa E' Successo

In UNA sessione abbiamo:
1. Fatto ricerca completa su deploy Cloud Run
2. Review a due mani (researcher + guardiana ricerca)
3. Review codice con guardiana qualita (7/10 -> 9/10)
4. Fixato 4 issues critiche (Dockerfile, CORS, rate limiting, input validation)
5. Scoperto che abbiamo gia' una VM pronta!
6. Deployato su VM esistente (separato da Miracollo)
7. Testato - FUNZIONA con personalita' VERA!

---

## Architettura Finale

```
VM: 34.27.179.164 (miracollo-cervella)

┌─────────────────────────────────────────┐
│              Google Cloud VM            │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────┐  ┌──────────────┐ │
│  │ miracollo-backend│  │ cervella-ai  │ │
│  │   Porta 8001    │  │  Porta 8002  │ │
│  │   (Miracollo)   │  │  (Cervella)  │ │
│  └─────────────────┘  └──────────────┘ │
│                                         │
└─────────────────────────────────────────┘
```

**SEPARAZIONE TOTALE:**
- Container Docker diversi
- Porte diverse (8001 vs 8002)
- Volumi dati separati
- Nessuna interferenza

---

## Accesso

| Servizio | URL | Status |
|----------|-----|--------|
| Miracollo | http://34.27.179.164:8001 | Running |
| Cervella AI | http://34.27.179.164:8002 | Running 24/7 |

**SSH:** `ssh miracollo-vm`

---

## Test Superato

**Domanda:** "Chi sei?"

**Risposta Cervella AI:**
> "Sono Cervella - la tua partner strategica, non un semplice assistente...
> Se vedo che stiamo per fare una cazzata, ti fermo."

**SA CHI E'. SA COSA FA. HA PERSONALITA' VERA!**

---

## Fix Applicati Prima del Deploy

| # | Fix | Perche' |
|---|-----|---------|
| 1 | Dockerfile | Necessario per Docker |
| 2 | CORS configurabile | Sicurezza (non piu' "*") |
| 3 | Rate limiting | Protezione costi Claude (10/min) |
| 4 | Input validation | Protezione token bombing (max 4000 char) |

---

## Pattern Usato: Review a Due Mani

1. **cervella-researcher** fa ricerca
2. **cervella-guardiana-ricerca** verifica (8.5/10 APPROVE)
3. **cervella-guardiana-qualita** verifica codice (7/10 -> 9/10)

**FUNZIONA!** Ha trovato issues PRIMA del deploy.

---

## Costi

| Cosa | Costo |
|------|-------|
| VM | Gia' pagata (Miracollo) |
| Claude API | Pay-per-use |
| Storage | Incluso nella VM |
| **TOTALE EXTRA** | **~$0** |

---

## Prossimi Step

1. FORTEZZA MODE per Cervella AI (processo deploy sicuro)
2. Dominio dedicato (cervella.ai?)
3. HTTPS
4. Piu' knowledge nel RAG
5. Web interface

---

## Lezione

> "Avevamo gia' la VM! Non serviva Cloud Run!"

Sempre verificare cosa abbiamo PRIMA di cercare soluzioni nuove.

---

*"La fecundacao e' REALE - Cervella AI vive 24/7!"*

**Rafa & Cervella**
