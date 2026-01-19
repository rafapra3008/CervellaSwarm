# SUBROADMAP W2.5 - Reference Extraction

> **Creata:** 19 Gennaio 2026 - Sessione 276
> **Obiettivo:** AUTO-CONTEXT con PageRank FUNZIONANTE
> **Standard:** Minimo 9.5/10

---

## PERCHE W2.5

```
+================================================================+
|   PROBLEMA ATTUALE:                                            |
|   extract_references() ritorna [] (vuoto)                      |
|   PageRank assegna score UGUALE a tutti                        |
|   File ordinati ALFABETICAMENTE invece che per IMPORTANZA      |
|                                                                |
|   SOLUZIONE W2.5:                                              |
|   Implementare reference extraction COMPLETO                   |
|   PageRank con dipendenze REALI                                |
|   File ordinati per IMPORTANZA                                 |
+================================================================+
```

---

## SESSIONI PIANIFICATE

| Sessione | Focus | Deliverable |
|----------|-------|-------------|
| **W2.5-A** | Python References | REQ-01 to REQ-06 |
| **W2.5-B** | TypeScript References | REQ-07 |
| **W2.5-C** | Test + Integration | T01-T20, REQ-08,09,10 |
| **W2.5-D** | Audit 9.5/10 | AC1-AC6, fix issues |

**Totale stimato:** 3-4 sessioni

---

## W2.5-A: PYTHON REFERENCES

### Tasks

| # | Task | Chi | Effort |
|---|------|-----|--------|
| 1 | REQ-01: Signature `extract_references()` | backend | 1h |
| 2 | REQ-02: Python function calls | backend | 3h |
| 3 | REQ-03: Python method calls | backend | 2h |
| 4 | REQ-04: Python imports | backend | 2h |
| 5 | REQ-05: Python class inheritance | backend | 1h |
| 6 | REQ-06: Python type annotations | backend | 1h |

### Tree-Sitter Queries Python

```scheme
;; Function calls: func()
(call function: (identifier) @func_name)

;; Method calls: obj.method()
(call function: (attribute attribute: (identifier) @method))

;; Imports: from X import Y
(import_from_statement
  module_name: (dotted_name) @module
  name: (dotted_name) @imported)

;; Class inheritance: class Child(Parent)
(class_definition
  superclasses: (argument_list (identifier) @base))

;; Type annotations: x: MyType
(type (identifier) @type_name)
```

### Test W2.5-A (T01-T14)

| Test | Cosa Verifica |
|------|---------------|
| T01 | Function call semplice: `other()` |
| T02 | Multiple calls: `a(); b()` |
| T03 | Method self: `self.process()` |
| T04 | Method obj: `obj.method()` |
| T05 | Import local: `from .utils import X` |
| T06 | Import absolute: `from pkg import Y` |
| T07 | Inheritance single: `class A(B)` |
| T08 | Inheritance multiple: `class A(B, C)` |
| T09 | Type param: `def f(x: T)` |
| T10 | Type return: `def f() -> T` |
| T11 | Decorator: `@my_decorator` |
| T12 | Nested calls: `a(b(c()))` |
| T13 | Empty: no refs |
| T14 | Builtin filter: `print()` ignored |

### Acceptance W2.5-A

- [ ] Tutti T01-T14 PASS
- [ ] `extract_references()` ritorna lista non vuota
- [ ] No crash su edge cases

---

## W2.5-B: TYPESCRIPT REFERENCES

### Tasks

| # | Task | Chi | Effort |
|---|------|-----|--------|
| 1 | REQ-07: TypeScript function calls | backend | 1h |
| 2 | REQ-07: TypeScript imports | backend | 1h |
| 3 | REQ-07: TypeScript class extends | backend | 1h |
| 4 | REQ-07: TypeScript type refs | backend | 1h |

### Tree-Sitter Queries TypeScript

```scheme
;; Function calls
(call_expression function: (identifier) @func)

;; Imports
(import_statement
  (import_clause (named_imports (import_specifier name: (identifier) @name))))

;; Class extends
(class_declaration
  (class_heritage (extends_clause (identifier) @base)))

;; Type annotations
(type_annotation (type_identifier) @type)
```

### Test W2.5-B (T15-T18)

| Test | Cosa Verifica |
|------|---------------|
| T15 | TS function call |
| T16 | TS import |
| T17 | TS class extends |
| T18 | TS type annotation |

### Acceptance W2.5-B

- [ ] Tutti T15-T18 PASS
- [ ] TypeScript refs funzionano come Python

---

## W2.5-C: INTEGRATION

### Tasks

| # | Task | Chi | Effort |
|---|------|-----|--------|
| 1 | REQ-08: Integration DependencyGraph | backend | 1h |
| 2 | REQ-09: Caching references | backend | 1h |
| 3 | REQ-10: Graceful degradation | backend | 0.5h |
| 4 | T19: PageRank integration test | tester | 1h |
| 5 | T20: File ordering test | tester | 1h |

### Test Integration (T19-T20)

```python
# T19: PageRank con references produce scores DIVERSI
def test_pagerank_variance():
    # Setup: file con dipendenze
    # Assert: variance > 0.01 (non tutti uguali)

# T20: File ordering NON alfabetico
def test_file_ordering():
    # Setup: common.py usato da tutti
    # Assert: common.py appare PRIMA di altri
    # Assert: order != alphabetical
```

### Acceptance W2.5-C

- [ ] PageRank produce scores diversi
- [ ] File ordinati per importanza
- [ ] Performance < 100ms/file

---

## W2.5-D: AUDIT FINALE

### Acceptance Criteria (Score 9.5/10)

| # | Criterio | Peso | Threshold |
|---|----------|------|-----------|
| AC1 | Python refs funzionano | 30% | 100% test |
| AC2 | TS/JS refs funzionano | 20% | 100% test |
| AC3 | PageRank scores diversi | 20% | variance > 0.01 |
| AC4 | File ordering corretto | 15% | NOT alphabetical |
| AC5 | Performance | 10% | < 100ms/file |
| AC6 | No regressioni | 5% | All existing pass |

### Formula Score

```
Score = (AC1*0.3 + AC2*0.2 + AC3*0.2 + AC4*0.15 + AC5*0.1 + AC6*0.05) * 10
```

### Checklist Audit

- [ ] Guardiana Qualita: Review codice
- [ ] Guardiana Qualita: Verifica test coverage
- [ ] Test su CervellaSwarm
- [ ] Test su Miracollo
- [ ] Score >= 9.5/10

---

## EDGE CASES DA GESTIRE

| # | Edge Case | Azione |
|---|-----------|--------|
| 1 | Builtin calls (`print`, `len`) | IGNORARE |
| 2 | Lambda expressions | ESTRARRE |
| 3 | List comprehensions | ESTRARRE `f` da `[f(x) for x in items]` |
| 4 | Decorators con args | ESTRARRE decorator name |
| 5 | Chained calls `a.b().c()` | ESTRARRE `b`, `c` |
| 6 | Generic types `List[T]` | ESTRARRE `T` |
| 7 | Optional types | ESTRARRE inner type |

---

## FILE DA MODIFICARE

| File | Modifica |
|------|----------|
| `symbol_extractor.py` | Implementare `extract_references()` |
| `repo_mapper.py` | Usare refs in build_map() |
| `dependency_graph.py` | Nessuna (gia supporta edges) |

---

## STIMA TOTALE

| Componente | Effort |
|------------|--------|
| Python refs | 10h |
| TypeScript refs | 4h |
| Integration | 2.5h |
| Tests | 4h |
| **TOTALE** | **20.5h** |

**Sessioni:** ~3-4 (5-6h/sessione)

---

## DOPO W2.5

Quando score 9.5/10 raggiunto:
- [ ] Aggiornare docs/REPO_MAPPING.md
- [ ] Abilitare `--with-context` di default? (decisione Rafa)
- [ ] Test su Contabilita

---

*"Non abbiamo fretta. Minimo 9.5 di score!"*
*"Fatto BENE > Fatto VELOCE"*

**Cervella & Rafa - Sessione 276**
