#!/bin/bash
# update-dna-context-smart.sh - Aggiunge sezione CONTEXT-SMART a tutti i DNA
# Versione: 1.0.0

set -e

AGENTS_DIR="$HOME/.claude/agents"
BACKUP_DIR="$HOME/.claude/agents_backup_$(date +%Y%m%d_%H%M%S)"

# Colori
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Sezione da aggiungere
CONTEXT_SMART_SECTION='
## REGOLE CONTEXT-SMART

> "MINIMO in memoria, MASSIMO su disco"

### 1. Non Sprecare Token
- Output CONCISO e strutturato
- Max 500 token per risposta normale
- No narrativa lunga, vai al punto

### 2. Usa SNCP (Memoria Esterna)
Se il progetto ha `.sncp/`:
- Scrivi idee in `.sncp/idee/`
- Scrivi decisioni in `.sncp/memoria/decisioni/`
- NON accumulare tutto nel context

### 3. Regola dei 5 Minuti
- Se il task richiede > 5 minuti, AVVISA
- Potrebbe servire un clone separato
- La Regina decidera come procedere

### 4. Output Strutturato
Formato per risposte:
```
FATTO:
- [completato]

DA FARE:
- [prossimi step]

NOTE:
- [info importanti]
```

'

echo -e "${YELLOW}Creando backup in: $BACKUP_DIR${NC}"
cp -r "$AGENTS_DIR" "$BACKUP_DIR"

echo -e "${YELLOW}Aggiornando DNA...${NC}"

count=0
for file in "$AGENTS_DIR"/cervella-*.md; do
    filename=$(basename "$file")

    # Verifica se la sezione esiste gia
    if grep -q "REGOLE CONTEXT-SMART" "$file"; then
        echo "  [SKIP] $filename - sezione gia presente"
        continue
    fi

    # Trova la riga con "---" dopo "Come Parlo" (prima delle specializzazioni)
    # Inserisci la sezione prima di quella riga

    # Usa awk per inserire la sezione
    awk -v section="$CONTEXT_SMART_SECTION" '
    /^---$/ && found_come_parlo && !inserted {
        print section
        inserted=1
    }
    /### Come Parlo/ { found_come_parlo=1 }
    { print }
    ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"

    echo -e "  ${GREEN}[OK]${NC} $filename"
    ((count++))
done

echo ""
echo -e "${GREEN}Aggiornati $count file!${NC}"
echo "Backup in: $BACKUP_DIR"
