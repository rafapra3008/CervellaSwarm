# Symbol Extractor Tests

Test suite completa per `scripts/utils/symbol_extractor.py`.

## Esecuzione

```bash
# Da project root
PYTHONPATH=scripts/utils pytest tests/test_symbol_extractor.py -v

# Da scripts/utils
cd scripts/utils
python3 -m pytest ../../tests/test_symbol_extractor.py -v
```

## Coverage

- **23 test passati, 1 skipped**
- Coverage completa di tutte le funzionalita principali

### Test Suite

#### TestPythonSymbolExtraction (5 test)
- Funzioni con/senza type hints
- Classi con/senza ereditarieta
- File multipli simboli

#### TestTypeScriptSymbolExtraction (4 test)
- Funzioni TypeScript
- Interfacce
- Type aliases
- File multipli simboli

#### TestJavaScriptSymbolExtraction (3 test)
- Funzioni JavaScript
- Classi JavaScript
- JSX (skipped - libreria non disponibile)

#### TestEdgeCases (6 test)
- File vuoto
- Nessun simbolo
- Codice malformato
- Linguaggio non supportato
- File non trovato
- Simboli nidificati

#### TestSymbolMethods (3 test)
- Symbol __repr__
- extract_signature()
- extract_references()

#### TestConvenienceFunction (1 test)
- extract_symbols() standalone

#### TestRealFiles (2 test)
- symbol_extractor.py stesso
- treesitter_parser.py

## Note

- JSX test skipped: tree-sitter language pack non include JSX standalone
- Test usano file temporanei per evitare side effects
- Path assoluti per test real files

## Author

Cervella Tester - 2026-01-19
