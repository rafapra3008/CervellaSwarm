# Guida: Quando Usare Researcher vs Scienziata

> **Data:** 10 Gennaio 2026
> **Scopo:** Eliminare confusione su quale agente usare per ricerche

---

## TL;DR

| Domanda | Chi Chiamare |
|---------|--------------|
| "COME si fa X?" | **Researcher** |
| "PERCHÉ fare X?" | **Scienziata** |

---

## Researcher = TECNICA

**Focus:** Implementazione, best practices, documentazione tecnica

**Esempi di domande:**
- "Come implementare JWT authentication?"
- "Quali sono le best practices per SSE in FastAPI?"
- "Come funziona il nuovo API di Stripe?"
- "Qual è la libreria migliore per parsing PDF in Python?"

**Output tipico:**
- Tutorial/guide tecniche
- Confronto librerie/framework
- Documentazione API
- Pattern di implementazione

**Fonti principali:**
- Documentazione ufficiale
- Stack Overflow
- Blog tecnici
- GitHub repos

---

## Scienziata = STRATEGICA

**Focus:** Mercato, competitor, opportunità business

**Esempi di domande:**
- "Come fanno i competitor l'authentication?"
- "Cosa dicono gli utenti di Lodgify?"
- "Qual è il trend nel settore PMS?"
- "C'è un gap di mercato per feature X?"

**Output tipico:**
- Analisi competitor
- Review mining (cosa dicono utenti)
- Trend di mercato
- Opportunità business

**Fonti principali:**
- G2, Capterra, ProductHunt
- Reddit, forum utenti
- LinkedIn, Twitter
- Siti competitor

---

## Casi Ambigui

### "Best practices authentication"

| Interpretazione | Chi |
|-----------------|-----|
| Come implementare auth sicura | Researcher |
| Come i competitor fanno auth | Scienziata |

**Regola:** Se la domanda è "come fare", usa Researcher. Se è "come fanno gli altri", usa Scienziata.

### "Pricing strategy"

| Interpretazione | Chi |
|-----------------|-----|
| Come implementare tier/billing | Researcher |
| Come pricizzano i competitor | Scienziata |

---

## Workflow Consigliato

Per decisioni importanti, usa ENTRAMBE in sequenza:

```
1. Scienziata: "Come fanno i competitor?"
   → Capisce il mercato, cosa funziona, cosa no

2. Researcher: "Come implementare la soluzione scelta?"
   → Dettagli tecnici, librerie, pattern
```

**Esempio pratico:**
```
Task: Aggiungere pagamenti a Miracollo

1. spawn-workers --scienziata
   "Come gestiscono i pagamenti Lodgify, Guesty, Hostaway?"
   → Output: Tutti usano Stripe, alcuni hanno PayPal backup

2. spawn-workers --researcher
   "Best practices Stripe integration FastAPI"
   → Output: Tutorial implementazione, librerie, webhook setup
```

---

## Quick Reference

```
+------------------------------------------------------------------+
|                                                                  |
|   RESEARCHER                    SCIENZIATA                       |
|   "Come si fa?"                 "Perché farlo?"                  |
|   "Quale libreria?"             "Cosa fanno gli altri?"          |
|   "Documentazione di X?"        "Cosa vogliono gli utenti?"      |
|   "Best practices per Y?"       "Trend del mercato?"             |
|                                                                  |
|   Focus: TECNICO                Focus: BUSINESS                  |
|   Output: Guide, Tutorial       Output: Analisi, Insight         |
|                                                                  |
+------------------------------------------------------------------+
```

---

*"Nulla è complesso - solo non ancora studiato!"*
