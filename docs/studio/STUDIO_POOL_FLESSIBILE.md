# STUDIO 2: Pool Flessibile - "I Cugini" 🐝

> *"Dipende dal momento! 2 guardiane? 3? 5? DIPENDE!"* - Rafa

**Data Studio:** 1 Gennaio 2026
**Fase:** 8 - La Corte Reale
**Status:** ✅ COMPLETATO

---

## TL;DR - Executive Summary

**Fattibilità:** ✅ POSSIBILE con Claude Code Task tool
**Complessità:** 🟡 Media (serve orchestrazione intelligente)
**ROI:** 🟢 Alto (riduce tempi di 3-5x per task massicci)

**Il Concept:**
Per task giganti (es: refactor 20 componenti React), la Regina spawna temporaneamente 2-3 "cugini frontend" che lavorano in parallelo su subset di file diversi.

---

## 1. Multi-Agent Scaling (Stato dell'Arte 2024-2025)

### Mercato e Trend
- Mercato agentic AI: da 5.4B$ (2024) a 7.6B$ (2025)
- "Collaborative scaling law": performance cresce logisticamente con numero agenti
- MacNet supporta 1000+ agenti contemporaneamente
- Sfida: 60% dei sistemi multi-agent falliscono oltre fase pilota

### Pattern Emergenti
- **Worker Pool Pattern:** Router permanente + Worker effimeri + Fleet Manager
- **Anthropic Orchestrator-Worker:** Lead agent coordina, subagent lavorano in parallelo
- **Context Refresh:** Quando context limit si avvicina → spawn fresh subagent con context pulito

---

## 2. Actor Model (Erlang/Elixir)

**Principio:** "Let it crash. Restart it clean."

- Supervision trees per fault tolerance
- Ogni agent = processo isolato, no shared memory
- BEAM VM gestisce migliaia di lightweight processes
- Ideale per pattern "one agent per task"

**Applicazione a CervellaSwarm:**
- Ogni cugino = processo isolato
- Se fallisce → restart o escalate a famiglia
- Zero contaminazione di context tra cugini

---

## 3. Kubernetes-Style Autoscaling

- HPA scala pods basandosi su metriche (CPU, custom)
- AI-powered predictive scaling → anticipa demand (risparmio 30-50%)
- NVIDIA RAG: scala dinamicamente da 1 a 6 LLM pods

**Applicazione:**
- Regina decide scaling basandosi su metriche (n. file, complessità)
- Predictive: se vede pattern "mega refactor" → pre-spawna cugini

---

## 4. Conflict Resolution

**REGOLA SACRA:** UN FILE = UNA CERVELLA (già in CervellaSwarm!)

| Strategia | Pro | Contro |
|-----------|-----|--------|
| File Locking | Semplice | Riduce parallelismo |
| Partitioning | Zero conflitti | Richiede pre-planning |
| Merge automatico | Massimo parallelismo | Rischio conflitti |

**Raccomandazione:** PARTITIONING
```
Cugino #1 → file [1-7]
Cugino #2 → file [8-14]
Cugino #3 → file [15-20]

ZERO sovrapposizioni = ZERO conflitti!
```

---

## 5. Claude Code Best Practices

- Context window separato per subagent = no pollution
- Token efficiency: farm out (X+Y)*N, return Z
- "7-parallel-Task method for efficiency"
- Risultati in file .md esterni per mantenere main context clean

---

## 6. Proposta Architettura "I Cugini"

### Quando Spawnare

| Metrica | Soglia | Azione |
|---------|--------|--------|
| File da modificare | > 8 stesso tipo | Spawna cugini |
| Stima tempo | > 45min singolo agent | Spawna cugini |
| Parallelizzabilità | File indipendenti | Spawna cugini |

### Lifecycle

1. **SPAWN** - Regina usa Task tool con agent temporaneo
2. **ASSIGN** - Ogni cugino riceve subset file specifici
3. **EXECUTE** - Cugino lavora SOLO sui suoi file
4. **REPORT** - Scrive risultati in file .md
5. **TERMINATE** - Context dismisso automaticamente

### Limiti Pratici

- **Max 3-5 cugini** in parallelo (oltre = overhead)
- **Solo per task ripetitivi** su file indipendenti
- **NON per debugging** complesso (serve context continuity)

---

## 7. Decisioni da Prendere

| Decisione | Opzione Consigliata |
|-----------|---------------------|
| Naming | `cervella-frontend-cugino-1` |
| Lifecycle | On-demand (non pool fisso) |
| System Prompt | Variante "task-focused" (meno autonomia) |
| Error Handling | Escalate a agent famiglia se blocca |

---

## 8. Piano Implementazione

### FASE 1: PoC (1-2 sessioni)
- Task pilota: refactor 12 file mock React
- Metriche: speedup, qualità, conflitti

### FASE 2: Automation (2-3 sessioni)
- Regina decide automaticamente spawn
- Template prompts + error handling

### FASE 3: Production (FASE 8 roadmap)
- Integrazione completa con La Corte Reale

---

## 9. Metriche di Successo

| Metrica | Target |
|---------|--------|
| **Speedup** | 2.5-3x per task > 10 file |
| **Error Rate** | < 5% vs singolo agent |
| **Cost** | Token < 2x, tempo < 0.4x |

---

## 10. Raccomandazione Finale

✅ **Implementare in FASE 8** (dopo consolidamento)
✅ **Quick Win:** Test pilota immediato per validare concept
✅ **Filosofia:** "Dipende dal momento!" - spawn cugini solo quando SERVE

---

## Fonti

- Multi-agent scaling research 2024-2025
- Anthropic orchestrator-worker documentation
- Actor model (Erlang/Akka) patterns
- Kubernetes HPA autoscaling
- Claude Code Task tool best practices

---

*"Uno sciame è più forte di una singola ape."* 🐝💙

*Studio completato: 1 Gennaio 2026*
