# TASK: Studio Architettura Multi-Progetto

**Assegnato a:** cervella-ingegnera
**Stato:** ready
**Priorita:** ALTA - Architettura Futura
**Data:** 6 Gennaio 2026

---

## CONTESTO

Oggi abbiamo visto worker lavorare su DUE progetti contemporaneamente:
- CervellaSwarm: researcher + scienziata
- Miracollo: backend + researcher (in coda)

Funziona per COINCIDENZA, non per DESIGN. Vogliamo capire come
renderlo un sistema ORCHESTRATO.

---

## SITUAZIONE ATTUALE

```
COSA FUNZIONA:
- Ogni progetto ha .swarm/tasks/ proprio
- spawn-workers lavora nel progetto corrente
- Finestre Terminal separate = isolamento

COSA MANCA:
- Vista unificata di tutti i progetti
- Coordinamento risorse (se worker occupato)
- Dashboard centralizzata
- Comunicazione tra Regine
```

---

## OBIETTIVO

Analizzare e proporre COME costruire un sistema multi-progetto:

1. **Analisi stato attuale**
   - Come funziona spawn-workers ora
   - Dove sono i limiti
   - Cosa si romperebbe con multi-progetto

2. **Opzioni architetturali**
   - Opzione A: swarm-global-status (solo visibilita)
   - Opzione B: Coordinatore centrale
   - Opzione C: Regine che comunicano (p2p)
   - Pro/contro di ogni approccio

3. **Quick Win possibile?**
   - Qual e' la cosa PIU semplice per iniziare?
   - swarm-global-status che legge tutti i .swarm/?

4. **Rischi e complessita**
   - Cosa puo andare storto?
   - Quanto e' complesso?

---

## OUTPUT ATTESO

File: `docs/studio/STUDIO_MULTI_PROGETTO.md`

Contenuto:
- Analisi stato attuale
- Opzioni architetturali con pro/contro
- Raccomandazione
- Quick win proposto
- Rischi identificati

---

## CRITERI DI SUCCESSO

- [ ] Capisco i limiti attuali
- [ ] Ho almeno 3 opzioni architetturali
- [ ] Ho un quick win concreto
- [ ] Raccomandazione chiara

---

## NOTE

- Tu ANALIZZI, non modifichi
- Guarda scripts/spawn-workers, watcher-regina.sh
- Pensa a scalabilita (3 progetti? 10?)
- "MAI FRETTA! SEMPRE ORGANIZZAZIONE!"

---

*"Ultrapassar os proprios limites!"*
