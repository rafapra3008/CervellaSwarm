# HANDOFF - Sessione 229

> **Data:** 15 Gennaio 2026
> **Progetto:** Miracallook
> **Prossima Cervella:** Leggi questo PRIMA di iniziare!

---

## COSA È STATO FATTO

### 3 Bug Fixati

1. **Email HTML rendering**
   - File: `miracallook/backend/gmail/api.py` (linee 716-736, 793-813)
   - Fix: Preferisce text/html, plain text converte `\n` in `<br>`

2. **Resize pannelli**
   - File: `miracallook/frontend/src/components/Layout/ThreePanel.tsx`
   - Fix: CSS flexbox con `resize: horizontal` (temporaneo)
   - Nota: react-resizable-panels v4.4.1 NON funziona per noi

3. **Bulk Actions 422 error**
   - File: `miracallook/backend/gmail/api.py`
   - Fix: Aggiunto `embed=True` a tutti gli endpoint Body()
   - Endpoint: archive, trash, untrash, mark-read, mark-unread

---

## COSA DEVI FARE

### Priorita ALTA

1. **Checkbox nei gruppi email**
   - Le email aggregate (es: "System Notifications") non mostrano checkbox
   - Solo il gruppo padre ha checkbox, non le email singole dentro

2. **Barra bulk actions opaca**
   - La barra si sovrappone al contenuto email
   - Serve background blur/opaco, non trasparente

### Priorita MEDIA

3. **Sistema cartelle smart**
   - Archive funziona ma non c'è UI per vedere dove vanno le email
   - Serve sidebar con cartelle (Inbox, Archive, Sent, Trash, etc.)

4. **Drag handles custom**
   - Sostituire CSS resize con drag handles professionali
   - Trascinare il bordo intero, non solo angolino

---

## COME AVVIARE

```bash
cd ~/Developer/miracollogeminifocus/miracallook
./start_dev.sh  # Backend porta 8002
cd frontend && npm run dev  # Frontend porta 5173/5174
```

---

## LEZIONE SESSIONE

> "react-resizable-panels calcola male le dimensioni dal DOM anche con fix v4.3.1"
> "FastAPI Body() singolo senza embed=True si aspetta valore diretto, non oggetto"

---

*Buon lavoro!*
