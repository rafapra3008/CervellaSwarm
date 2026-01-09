#!/bin/bash
# create-worker-clone.sh - Crea un clone per worker
# Versione: 1.0.0

set -e

# Colori
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Uso
if [ -z "$1" ]; then
    echo -e "${RED}Uso: $0 <nome-task>${NC}"
    echo "Esempio: $0 feature-login"
    exit 1
fi

TASK_NAME=$1
PROJECT_NAME=$(basename "$(pwd)")
CLONE_PATH="../${PROJECT_NAME}-worker-${TASK_NAME}"

# Verifica che siamo in un repo git
if [ ! -d .git ]; then
    echo -e "${RED}Errore: Non sei in un repository git${NC}"
    exit 1
fi

# Verifica che il clone non esista gia
if [ -d "$CLONE_PATH" ]; then
    echo -e "${RED}Errore: Clone gia esiste: $CLONE_PATH${NC}"
    echo "Usa: rm -rf $CLONE_PATH per rimuoverlo"
    exit 1
fi

# Crea clone
echo -e "${YELLOW}Creando clone: $CLONE_PATH${NC}"
git clone . "$CLONE_PATH"

# Crea TASK.md
cat > "${CLONE_PATH}/TASK.md" << 'EOF'
# Task: [NOME DA COMPILARE]

## Obiettivo
[Descrivi cosa deve fare il worker]

## Context
[Informazioni necessarie per completare il task]

## Cosa Fare
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Output Richiesto
- File da creare/modificare: [lista]
- Formato: [descrizione]

## Quando Finito
1. Crea DONE.md con riepilogo
2. Fai git commit di tutto
3. Il task e completo quando esiste DONE.md
EOF

echo -e "${GREEN}Clone creato con successo!${NC}"
echo ""
echo "Prossimi step:"
echo "  1. Modifica: ${CLONE_PATH}/TASK.md"
echo "  2. Lancia worker: cd ${CLONE_PATH} && claude"
echo "  3. Oppure con tmux: tmux new-session -d -s ${TASK_NAME} \"cd ${CLONE_PATH} && claude\""
echo ""
echo "Per verificare se finito: ls ${CLONE_PATH}/DONE.md"
echo "Per portare risultati: git pull ${CLONE_PATH} main"
echo "Per eliminare clone: rm -rf ${CLONE_PATH}"
