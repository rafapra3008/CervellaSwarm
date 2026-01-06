# BUG: Watcher AUTO-SVEGLIA non notifica la Regina

**Rilevato:** 6 Gennaio 2026 - Sessione 108
**Priorità:** MEDIA
**Stato:** da_sistemare

---

## PROBLEMA

Il watcher rileva il file .done ma NON sveglia/notifica la Regina in modo efficace.
Rafa ha visto la notifica 3 minuti dopo il completamento.

---

## COMPORTAMENTO ATTESO

- Worker finisce → crea .done
- Watcher rileva .done → notifica IMMEDIATA alla Regina
- Regina reagisce subito

---

## COMPORTAMENTO ATTUALE

- Worker finisce → crea .done
- Watcher rileva .done → scrive "TASK COMPLETATO"
- Ma la Regina NON viene "svegliata" in tempo reale

---

## POSSIBILI CAUSE

1. Il watcher scrive su stdout ma la Regina non lo vede subito
2. Il meccanismo di notifica non è integrato con Claude Code
3. Serve un sistema di polling o webhook

---

## POSSIBILI SOLUZIONI

1. **Terminal bell** - Suono quando task completa
2. **File marker** - Scrivere in un file che la Regina controlla
3. **Notifica macOS** - osascript per notifica sistema
4. **Polling attivo** - Regina controlla periodicamente .done

---

## NOTE

Per ora la Regina deve controllare manualmente o Rafa avvisa.
Da sistemare in una sessione futura dedicata.

---

*"Documentare sempre i bug per il futuro!"*
