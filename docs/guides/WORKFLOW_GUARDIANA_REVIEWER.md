# Workflow: Guardiana vs Reviewer

> **Data:** 10 Gennaio 2026
> **Scopo:** Eliminare overlap e definire chi fa cosa

---

## TL;DR

| Ruolo | Focus | Quando |
|-------|-------|--------|
| **Reviewer** | Codice DETTAGLIO | Dopo implementazione |
| **Guardiana** | Policy STANDARD | Prima di merge |

---

## Il Problema

Entrambi fanno "code review" ma con focus diversi:

- **Reviewer:** Guarda IL CODICE (bug, pattern, naming)
- **Guardiana:** Guarda GLI STANDARD (file size, coverage, policy)

---

## Workflow Sequenziale

```
Task completato (frontend/backend/tester)
           ↓
    [REVIEWER]
    - Logica corretta?
    - Bug potenziali?
    - Pattern rispettati?
    - Naming chiaro?
           ↓
    Fix se necessario
           ↓
    [GUARDIANA]
    - File < 500 righe?
    - Test coverage OK?
    - Security check passato?
    - Standard famiglia rispettati?
           ↓
    APPROVE → Merge
```

---

## Reviewer: Cosa Guarda

### Focus: IL CODICE

```
✅ Logica corretta
✅ Edge cases gestiti
✅ Error handling presente
✅ Naming descrittivo
✅ Pattern del progetto seguiti
✅ DRY rispettato
✅ Performance ragionevole
```

### Output Tipico

```markdown
## Review: auth_service.py

### BLOCKERS
- Linea 45: SQL injection possibile

### MAJOR
- Linea 120: Missing error handling

### MINOR
- Linea 78: Nome variabile poco chiaro

### POSITIVI
- Buona separazione responsabilità
```

---

## Guardiana: Cosa Guarda

### Focus: GLI STANDARD

```
✅ File size < 500 righe
✅ Funzioni < 50 righe
✅ Test coverage presente
✅ No secrets esposti
✅ Versioning presente
✅ Documentazione aggiornata
```

### Output Tipico

```markdown
## Verifica: Sprint Auth

**Verdetto:** CHANGES
**Score:** 7/10

**Issues:**
- auth_service.py: 520 righe (split richiesto)
- test_auth.py: coverage 65% (target 80%)

**Next:** Frontend deve splittare file
```

---

## Quando Usare Chi

| Situazione | Chi Chiamare |
|------------|--------------|
| "Questo codice ha bug?" | Reviewer |
| "Questo file è troppo grande?" | Guardiana |
| "I pattern sono corretti?" | Reviewer |
| "Abbiamo test coverage?" | Guardiana |
| "Logica OK?" | Reviewer |
| "Policy rispettate?" | Guardiana |

---

## Esempio Pratico

```
Sprint: Implementare password reset

1. cervella-backend implementa endpoint
2. cervella-tester scrive test
   ↓
3. spawn-workers --reviewer
   "Review password reset implementation"
   → Output: "APPROVE con 2 minor fix"
   ↓
4. cervella-backend applica fix
   ↓
5. spawn-workers --guardiana-qualita
   "Verifica standard per merge"
   → Output: "APPROVE - tutti standard rispettati"
   ↓
6. MERGE!
```

---

## Casi Speciali

### Code Review Day (Venerdì)

Il Venerdì facciamo review settimanale:

1. **Reviewer** analizza tutto il codice nuovo della settimana
2. **Guardiana** verifica metriche (file size, coverage, tech debt)
3. **Regina** prioritizza fix per settimana prossima

### Hotfix Urgente

Per fix urgenti, possiamo saltare Reviewer:

```
Hotfix → Guardiana (check minimo) → Merge
```

Ma poi Reviewer fa review post-merge.

---

## Quick Reference

```
+------------------------------------------------------------------+
|                                                                  |
|   REVIEWER                      GUARDIANA                        |
|   "Il codice è corretto?"       "Gli standard sono rispettati?" |
|   "Ci sono bug?"                "Il file è troppo grande?"       |
|   "Pattern OK?"                 "Coverage OK?"                   |
|                                                                  |
|   Focus: QUALITÀ CODICE         Focus: POLICY/STANDARD          |
|   Quando: Post-implementazione  Quando: Pre-merge               |
|                                                                  |
+------------------------------------------------------------------+
```

---

*"Fatto BENE > Fatto VELOCE"*
