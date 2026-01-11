# RICERCA: Come Controllare Cache Invalidation in Claude Code

**Data:** 11 Gennaio 2026
**Ricercatrice:** Cervella Researcher
**Status:** ✅ Completata
**Criticità:** 🔥 ALTA - Game changer per workflow

---

## TL;DR - SCOPERTE CHIAVE

```
✅ CACHE LIFETIME: 5 minuti di inattività (recentemente ridotto a ~3 min)
✅ HIERARCHY: tools → system → messages (cascade invalidation)
✅ METODI TRIGGER: Modificare CLAUDE.md, tool changes, aspettare timeout
⚠️ /clear NON INVALIDA CACHE (bug noto!)
💡 KEEPALIVE PINGS: Tecnica usata da Aider per mantenere cache attiva
```

---

## 1. COME FUNZIONA LA CACHE (Hierarchy)

### Struttura Gerarchica

```
┌─────────────────────────────────────┐
│  TOOLS (livello 1)                  │  ← Modifica qui invalida TUTTO
├─────────────────────────────────────┤
│  SYSTEM (livello 2)                 │  ← Modifica qui invalida System + Messages
├─────────────────────────────────────┤
│  MESSAGES (livello 3)               │  ← Modifica qui invalida solo Messages
└─────────────────────────────────────┘
```

**REGOLA CASCADE:**
- Cambio TOOLS → invalida Tools + System + Messages
- Cambio SYSTEM → invalida System + Messages
- Cambio MESSAGES → invalida solo Messages

### Cache Breakpoints

- Puoi definire MAX 4 breakpoints con `cache_control`
- Sistema controlla automaticamente ~20 blocchi prima del breakpoint
- Ogni breakpoint può essere invalidato indipendentemente

---

## 2. COSA INVALIDA LA CACHE

### A. Modifiche al Contenuto

| Livello | Trigger | Effetto |
|---------|---------|---------|
| **Tools** | Cambio definizione tool | Invalida TUTTO |
| **Tools** | Cambio ordine tools | Invalida TUTTO |
| **Tools** | Cambio `tool_choice` | Invalida TUTTO |
| **Tools** | Presenza/assenza immagini | Invalida TUTTO |
| **System** | Modifica CLAUDE.md | Invalida System + Messages |
| **System** | Cambio system prompt | Invalida System + Messages |
| **Messages** | Nuovo messaggio user | Invalida Messages |

### B. Timeout / Inattività

**UFFICIALE:** 5 minuti senza richieste
**REALE (2026):** ~3 minuti (bug report recente)

### C. Cambio Parametri

- Cambio budget thinking → invalida Messages
- Cambio model → invalida TUTTO
- Abilitare/disabilitare extended thinking → invalida Messages

---

## 3. METODI PER TRIGGERARE INVALIDATION

### 🟢 METODO 1: Modificare CLAUDE.md (CONSIGLIATO)

**Come funziona:**
- CLAUDE.md è parte del system prompt
- Modificare = invalidare system cache
- Effetto: cache scende da 70% → ~50% (core base)

**Procedura:**
```bash
# 1. Aggiungi/rimuovi uno spazio in CLAUDE.md
# 2. Salva
# 3. Manda un messaggio qualsiasi
# Result: Cache invalidata!
```

**PRO:**
- Controllo preciso
- Ripetibile
- No side effects

**CONTRO:**
- Richiede edit manuale file
- Invalida anche system (non solo messages)

---

### 🟢 METODO 2: Timeout Naturale (5 min)

**Come funziona:**
- Aspetta 5 minuti senza inviare messaggi
- Cache scade automaticamente
- Prossimo messaggio = cache write nuovo

**Procedura:**
```bash
# 1. Stop interazione con Claude
# 2. Aspetta 5 minuti (o 3 min per sicurezza)
# 3. Manda un messaggio
# Result: Cache invalidata!
```

**PRO:**
- Zero sforzo
- Automatico
- Garantito

**CONTRO:**
- Richiede tempo (5 min)
- Non controllabile con precisione
- Interrompe workflow

---

### 🟡 METODO 3: DISABLE_PROMPT_CACHING (DRASTICO)

**Come funziona:**
- Environment variable che disabilita TUTTA la cache
- Riavvio Claude Code necessario

**Procedura:**
```bash
# Disabilita cache
export DISABLE_PROMPT_CACHING=1
# Riavvia Claude Code

# Re-abilita cache
unset DISABLE_PROMPT_CACHING
# Riavvia Claude Code
```

**PRO:**
- Controllo totale
- Ideale per debug

**CONTRO:**
- Richiede riavvio Claude
- Disabilita cache completamente (costa di più!)
- Bug noto: può causare 401 Unauthorized

---

### 🔴 METODO 4: /clear Command (NON FUNZIONA!)

**Status:** ⚠️ BUG NOTO

**Cosa DOVREBBE fare:**
- Reset context window
- Invalidare cache

**Cosa FA DAVVERO:**
- Nasconde conversazione dalla vista
- NON reset token count
- NON invalida cache
- Context ritorna dopo pochi prompt!

**CONCLUSIONE:** NON USARE per cache invalidation!

---

### 💡 METODO 5: Keepalive Pings (ANTI-INVALIDATION)

**Fonte:** Aider AI coding assistant

**Problema da risolvere:**
- Cache scade dopo 5 min
- Costi aumentano (cache write vs cache read)

**Soluzione Aider:**
```bash
aider --cache-keepalive-pings 5
```

**Come funziona:**
1. Ogni 5 minuti Aider manda un "ping" (richiesta minimale)
2. Questo resetta il timer di 5 min
3. Cache rimane attiva per N*5 minuti

**Esempio:**
- `--cache-keepalive-pings 5` = cache attiva per 25 minuti dopo ogni tuo messaggio
- Costi: ping costa molto meno di cache rewrite completo

**APPLICABILE A NOI?**
🤔 Da studiare! Potrebbe essere utile per:
- Sessioni lunghe con pause
- Mantenere cache calda durante deleghe a worker
- Evitare cache expiration durante ricerche lunghe

**TODO:** Verificare se Claude Code espone API per implementare keepalive

---

## 4. ESPERIMENTO: Cache Reduction Pattern

### Scenario Osservato (11 Gen 2026)

```
PRIMA invalidation:
- Context: 70% (145k tokens)
- Cache read: ~45%

DOPO invalidation (modificato CLAUDE.md):
- Context: 50% (102k tokens)
- Cache read: ~40%
- DIFFERENZA: -43k tokens = -30%!

CORE BASE (sempre presente):
- ~19,365 tokens
- System + tools + CLAUDE.md base
```

### Pattern Scoperto

```
Cache = CORE + CONVERSAZIONE

CORE (~19k tokens):
- System instructions
- CLAUDE.md base
- Tools definitions
- Agent DNA

CONVERSAZIONE (variabile):
- Messages history
- Previous responses
- Context accumulato

INVALIDATION → Pulisce CONVERSAZIONE, mantiene CORE
```

---

## 5. METODI PRATICI PER CERVELLASWARM

### A. Invalidation Manuale Pre-Task

**Quando usare:**
- Prima di task importante con worker
- Quando context > 70%
- Prima di deleghe multiple

**Script suggerito:**
```bash
# scripts/swarm/invalidate-cache.sh
#!/bin/bash

echo "🔄 Invalidating cache..."
echo " " >> ~/.claude/CLAUDE.md
echo "Modifica temporanea per cache invalidation" >> ~/.claude/CLAUDE.md
echo "Aspetta 10 secondi..."
sleep 10
git checkout ~/.claude/CLAUDE.md
echo "✅ Cache invalidata! Pronto per nuova sessione."
```

### B. Auto-Invalidation su Timeout

**Quando usare:**
- Tra sessioni di ricerca lunga
- Durante pause naturali

**Procedura:**
1. Finisci task corrente
2. Salva tutto in SNCP
3. Aspetta 5+ minuti (pausa caffè)
4. Riprendi con cache pulita

### C. Monitor Cache Status

**Idea per futura implementazione:**
```typescript
// Extension che monitora cache usage
if (cacheUsage > 70%) {
  showNotification("Cache alta! Considera invalidation?");
  offerQuickInvalidation();
}
```

---

## 6. LIMITAZIONI E BUG NOTI

### Bug /clear (Issue #2538, #10035, #4629)

**Problema:**
- `/clear` non resetta realmente il context
- Token count continua ad accumularsi
- Context ritorna sopra la linea /clear

**Workaround:**
- NON fare affidamento su /clear per cache management
- Usare timeout o CLAUDE.md modification invece

### Reduced TTL (Issue #14628)

**Problema:**
- Dicembre 2025: TTL ridotto da 5 min a ~3 min
- Non documentato ufficialmente
- Comportamento inconsistente

**Workaround:**
- Assumere 3 min come timeout sicuro
- Implementare keepalive se serve sessioni lunghe

### DISABLE_PROMPT_CACHING 401 Error (Issue #8632)

**Problema:**
- Setting `DISABLE_PROMPT_CACHING=1` può causare 401 Unauthorized
- Richiede unset + riavvio per risolvere

**Workaround:**
- Usare solo per debug
- Preferire metodi meno invasivi

---

## 7. RACCOMANDAZIONI FINALI

### Per CervellaSwarm

**QUICK WIN (implementabile subito):**
```
1. Script: `invalidate-cache.sh` (modifica CLAUDE.md temporanea)
2. Regola: Invalidare cache prima di spawn-workers massiccio
3. Monitor: Controllare context usage prima di task critici
```

**LONG TERM (da studiare):**
```
1. Implementare keepalive ping pattern (come Aider)
2. Extension che auto-invalida cache su threshold
3. Integrare cache management in swarm protocols
```

### Best Practices

| Scenario | Metodo Consigliato | Frequenza |
|----------|-------------------|-----------|
| **Context > 70%** | CLAUDE.md modification | Subito |
| **Pre-spawn workers** | Timeout naturale (5 min) | Ogni volta |
| **Debug cache issue** | DISABLE_PROMPT_CACHING | Raro |
| **Sessione lunga (>30 min)** | Keepalive pings (futuro) | Automatico |

---

## 8. PROSSIMI STEP

### Immediate (da fare oggi)

- [ ] Creare `scripts/swarm/invalidate-cache.sh`
- [ ] Testare CLAUDE.md modification pattern
- [ ] Documentare in workflow swarm

### Short Term (questa settimana)

- [ ] Studiare implementazione keepalive pattern
- [ ] Testare cache behavior con worker spawns
- [ ] Misurare impact su costi API

### Long Term (prossimo sprint)

- [ ] Extension per cache monitoring
- [ ] Auto-invalidation su threshold
- [ ] Integrare in dashboard swarm

---

## 9. FONTI

### Documentazione Ufficiale

- [Prompt Caching - Claude Docs](https://platform.claude.com/docs/en/build-with-claude/prompt-caching)
- [Prompt Caching - Anthropic Docs](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
- [Model Configuration - Claude Code](https://code.claude.com/docs/en/model-config)

### Community & Issues

- [Issue #2538: /clear keeps context](https://github.com/anthropics/claude-code/issues/2538)
- [Issue #10035: /clear fails to reset](https://github.com/anthropics/claude-code/issues/10035)
- [Issue #14628: Cache TTL reduced](https://github.com/anthropics/claude-code/issues/14628)
- [Issue #8632: DISABLE_PROMPT_CACHING 401](https://github.com/anthropics/claude-code/issues/8632)

### Tools & Examples

- [Aider Prompt Caching](https://aider.chat/docs/usage/caching.html)
- [Spring AI Anthropic Prompt Caching](https://spring.io/blog/2025/10/27/spring-ai-anthropic-prompt-caching-blog/)
- [Practical Guide to Claude Prompt Caching](https://medium.com/@mcraddock/unlocking-efficiency-a-practical-guide-to-claude-prompt-caching-3185805c0eef)

---

## CONCLUSIONE

**SCOPERTA PRINCIPALE:**
> Cache invalidation è TRIGGERABILE volontariamente!

**METODO CONSIGLIATO:**
> Modificare temporaneamente CLAUDE.md = invalidation pulita e controllata

**GAME CHANGER:**
> Possiamo "liberare" context a comando senza aspettare auto-compact al 77%!

**PROSSIMO OBIETTIVO:**
> Implementare script automatico + studiare keepalive pattern per sessioni infinite

---

*Ricerca completata: 11 Gennaio 2026, 21:40*
*Cervella Researcher - CervellaSwarm* 🔬🐝
