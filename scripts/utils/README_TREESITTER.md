# TreesitterParser - Documentation

> Parser multi-language basato su tree-sitter per repository mapping

**Version:** 1.0.0
**Date:** 2026-01-19
**Author:** Cervella Backend

---

## Overview

`TreesitterParser` è un wrapper Python per tree-sitter che fornisce:
- ✅ Parsing multi-language (Python, TypeScript, JavaScript, JSX, TSX)
- ✅ Caching automatico per performance
- ✅ Error handling robusto (gestisce codice incompleto)
- ✅ API semplice e intuitiva
- ✅ Type hints completi

## Installation

```bash
pip install tree-sitter-language-pack
```

## Quick Start

### Basic Usage

```python
from scripts.utils.treesitter_parser import TreesitterParser

# Create parser
parser = TreesitterParser()

# Parse a Python file
tree = parser.parse_file("app/main.py")

# Access AST
print(tree.root_node.type)  # "module"
print(tree.root_node.has_error)  # False

# Iterate children
for child in tree.root_node.children:
    print(f"{child.type} at line {child.start_point[0]}")
```

### Convenience Function

```python
from scripts.utils.treesitter_parser import parse_file

# One-off parsing (no need to create parser instance)
tree = parse_file("app/main.py")
```

### Multi-Language Support

```python
parser = TreesitterParser()

# Python
py_tree = parser.parse_file("app/main.py")

# TypeScript
ts_tree = parser.parse_file("src/app.tsx")

# JavaScript
js_tree = parser.parse_file("src/utils.js")

# All parsers are cached automatically
stats = parser.get_cache_stats()
print(stats)  # {'parsers': 3, 'trees': 3, 'languages': 3}
```

## Supported Languages

| Language | Extension | Tree-sitter Grammar |
|----------|-----------|---------------------|
| Python | `.py` | ✅ |
| TypeScript | `.ts` | ✅ |
| TSX | `.tsx` | ✅ |
| JavaScript | `.js` | ✅ |
| JSX | `.jsx` | ✅ |

## API Reference

### TreesitterParser

#### `__init__()`

Create a new parser instance with empty caches.

```python
parser = TreesitterParser()
```

#### `parse_file(file_path: str) -> Optional[Tree]`

Parse a source file and return its AST.

**Args:**
- `file_path`: Path to source file (absolute or relative)

**Returns:**
- `Tree` object containing the parsed AST
- `None` if parsing failed

**Raises:**
- `FileNotFoundError`: If file doesn't exist
- `ValueError`: If file extension not supported

**Example:**
```python
tree = parser.parse_file("app/main.py")
if tree:
    print(f"Parsed successfully: {tree.root_node.type}")
```

#### `detect_language(file_path: str) -> str`

Detect programming language from file extension.

**Args:**
- `file_path`: Path to the source file

**Returns:**
- Language name (e.g., 'python', 'typescript')

**Raises:**
- `ValueError`: If extension not supported

**Example:**
```python
lang = parser.detect_language("app.tsx")  # 'tsx'
```

#### `get_parser(language: str) -> Optional[Parser]`

Get or create a parser for the specified language.

Parsers are cached after first creation.

**Args:**
- `language`: Language name (e.g., 'python')

**Returns:**
- `Parser` object, or `None` if creation failed

**Example:**
```python
py_parser = parser.get_parser('python')
```

#### `get_language(language: str) -> Optional[object]`

Get or create a Language object for queries.

**Args:**
- `language`: Language name

**Returns:**
- `Language` object, or `None` if creation failed

**Example:**
```python
lang = parser.get_language('python')
```

#### `invalidate_file(file_path: str) -> None`

Invalidate cached tree for a specific file.

Use when file has been modified externally.

**Example:**
```python
parser.invalidate_file("app/main.py")
tree = parser.parse_file("app/main.py")  # Will re-parse
```

#### `clear_cache() -> None`

Clear all cached parsers and trees.

**Example:**
```python
parser.clear_cache()  # Free memory
```

#### `get_cache_stats() -> Dict[str, int]`

Get statistics about cache usage.

**Returns:**
```python
{
    'parsers': 2,    # Number of cached parsers
    'trees': 5,      # Number of cached AST trees
    'languages': 2   # Number of cached language objects
}
```

## Working with AST

### Node Properties

```python
tree = parser.parse_file("app.py")
root = tree.root_node

# Basic properties
root.type              # Node type (e.g., 'module', 'function_definition')
root.start_point       # (row, column) tuple
root.end_point         # (row, column) tuple
root.text              # Source code bytes
root.has_error         # True if parse errors

# Structure
root.children          # All child nodes
root.named_children    # Only "named" children (excludes punctuation)
root.child_count       # Number of children
```

### Traversing the Tree

```python
def traverse(node, depth=0):
    """Recursively traverse AST."""
    indent = "  " * depth
    print(f"{indent}{node.type} at line {node.start_point[0]}")

    for child in node.children:
        traverse(child, depth + 1)

tree = parser.parse_file("app.py")
traverse(tree.root_node)
```

### Finding Specific Nodes

```python
def find_functions(node):
    """Find all function definitions."""
    functions = []

    def visit(n):
        if n.type == 'function_definition':
            functions.append(n)
        for child in n.children:
            visit(child)

    visit(node)
    return functions

tree = parser.parse_file("app.py")
funcs = find_functions(tree.root_node)

for func in funcs:
    name_node = func.child_by_field_name('name')
    print(f"Function: {name_node.text.decode()}")
```

## Error Handling

### Incomplete Code

Tree-sitter handles incomplete/malformed code gracefully:

```python
# File: broken.py
# def incomplete(
#     # Missing closing paren

parser = TreesitterParser()
tree = parser.parse_file("broken.py")

if tree.root_node.has_error:
    print("⚠️ Parse errors found, but tree is still usable")
    # Tree will contain ERROR nodes where parsing failed
```

### Unsupported Files

```python
try:
    tree = parser.parse_file("file.xyz")
except ValueError as e:
    print(f"Error: {e}")
    # Error: Unsupported file extension: .xyz
```

### Non-existent Files

```python
try:
    tree = parser.parse_file("/nonexistent/file.py")
except FileNotFoundError:
    print("File not found")
```

## Performance Tips

### Use Caching

```python
# GOOD: Reuse parser instance
parser = TreesitterParser()
for file in files:
    tree = parser.parse_file(file)
    # ... process tree ...

# BAD: Create new parser each time
for file in files:
    parser = TreesitterParser()  # Wasteful!
    tree = parser.parse_file(file)
```

### Invalidate Only When Needed

```python
parser = TreesitterParser()

# Parse
tree1 = parser.parse_file("app.py")

# File modified externally
# ... edit app.py ...

# Invalidate and re-parse
parser.invalidate_file("app.py")
tree2 = parser.parse_file("app.py")
```

### Clear Cache for Memory Management

```python
parser = TreesitterParser()

# Process large batch
for file in large_batch:
    tree = parser.parse_file(file)
    process(tree)

# Free memory before next batch
parser.clear_cache()
```

## CLI Usage

Test the parser from command line:

```bash
python scripts/utils/treesitter_parser.py <file_path>
```

**Example:**
```bash
$ python scripts/utils/treesitter_parser.py app/main.py

✅ Successfully parsed: app/main.py
Root node type: module
Has errors: False
Number of children: 12

First 5 child nodes:
  1. import_from_statement at line 0
  2. import_statement at line 1
  3. function_definition at line 3
  4. class_definition at line 10
  5. expression_statement at line 25

Cache stats: {'parsers': 1, 'trees': 1, 'languages': 1}
```

## Testing

Run the test suite:

```bash
pytest tests/test_treesitter_parser.py -v
```

**Test coverage:**
- ✅ Python, TypeScript, JavaScript parsing
- ✅ Language detection
- ✅ Error handling (unsupported files, non-existent files)
- ✅ Incomplete/malformed code
- ✅ Caching behavior
- ✅ Cache invalidation
- ✅ Multi-language caching

## Integration with Repo Mapper

This parser is the foundation for CervellaSwarm's repository mapping system:

```python
from scripts.utils.treesitter_parser import TreesitterParser
from scripts.utils.symbol_extractor import SymbolExtractor  # Coming next

parser = TreesitterParser()
extractor = SymbolExtractor(parser)

# Extract symbols from file
symbols = extractor.extract_symbols("app/main.py")

# Build repository map
from scripts.utils.repo_mapper import RepoMapper
mapper = RepoMapper('.')
repo_map = mapper.build_map(token_budget=2000)
```

## Logging

Enable debug logging to see parser operations:

```python
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

parser = TreesitterParser()
tree = parser.parse_file("app.py")
# Will log: parser creation, language detection, parsing, caching
```

## Troubleshooting

### "ModuleNotFoundError: No module named 'tree_sitter_language_pack'"

Install the package:
```bash
pip install tree-sitter-language-pack
```

### Parse Errors on Valid Code

Check if the language grammar is up to date:
```bash
pip install --upgrade tree-sitter-language-pack
```

### Memory Issues with Large Files

Use `clear_cache()` periodically:
```python
parser = TreesitterParser()

for i, file in enumerate(large_file_list):
    tree = parser.parse_file(file)
    process(tree)

    if i % 100 == 0:
        parser.clear_cache()  # Free memory every 100 files
```

## Next Steps

- **Symbol Extraction:** See `symbol_extractor.py` (coming next)
- **Repository Mapping:** See `repo_mapper.py` (coming next)
- **Study:** Read `.sncp/progetti/cervellaswarm/studi/STUDIO_TREE_SITTER_REPO_MAPPING.md`

---

**Questions?** Check the study document or ask Cervella Backend! 🐍
