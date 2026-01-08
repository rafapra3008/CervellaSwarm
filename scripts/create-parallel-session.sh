#!/bin/bash
# create-parallel-session.sh - Setup completo sessione parallela
# Crea worktrees, dipendenze, e prepara tutto per il lavoro
#
# Uso: create-parallel-session.sh PROJECT_PATH SESSION_NAME [WORKERS...]
#
# Esempi:
#   create-parallel-session.sh ~/Developer/miracollo feature-auth frontend backend
#   create-parallel-session.sh . api-refactor backend tester
#
# CervellaSwarm Multi-Instance Coordination v2.0

set -e

# Colori
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m'

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parametri
PROJECT_PATH="${1:-}"
SESSION_NAME="${2:-}"
shift 2 2>/dev/null || true
WORKERS=("$@")

# Validazione
if [ -z "$PROJECT_PATH" ] || [ -z "$SESSION_NAME" ] || [ ${#WORKERS[@]} -eq 0 ]; then
    echo -e "${RED}ERRORE: Parametri mancanti${NC}"
    echo ""
    echo "Uso: create-parallel-session.sh PROJECT_PATH SESSION_NAME WORKERS..."
    echo ""
    echo "Parametri:"
    echo "  PROJECT_PATH  - Path al progetto"
    echo "  SESSION_NAME  - Nome della sessione (es: feature-auth)"
    echo "  WORKERS       - Lista workers (es: frontend backend tester)"
    echo ""
    echo "Esempio:"
    echo "  create-parallel-session.sh ~/Developer/miracollo feature-auth frontend backend"
    exit 1
fi

# Setup paths
PROJECT_PATH=$(cd "$PROJECT_PATH" && pwd)
PROJECT_NAME=$(basename "$PROJECT_PATH")
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Header
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}   CREATE PARALLEL SESSION${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${BLUE}Progetto:${NC}     $PROJECT_NAME"
echo -e "${BLUE}Path:${NC}         $PROJECT_PATH"
echo -e "${BLUE}Sessione:${NC}     $SESSION_NAME"
echo -e "${BLUE}Workers:${NC}      ${WORKERS[*]}"
echo -e "${BLUE}Data:${NC}         $DATE"
echo ""

# Step 1: Verifica git repo
echo -e "${YELLOW}[1/5] Verifico repository Git...${NC}"
if ! git -C "$PROJECT_PATH" rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}ERRORE: $PROJECT_PATH non e' un repository Git${NC}"
    exit 1
fi
echo -e "${GREEN}  OK - Repository Git valido${NC}"
echo ""

# Step 2: Crea struttura .swarm se non esiste
echo -e "${YELLOW}[2/5] Preparo struttura .swarm...${NC}"
SWARM_DIR="$PROJECT_PATH/.swarm"
mkdir -p "$SWARM_DIR"/{segnali,dipendenze,stato,messaggi,logs,tasks}

# Pulisci segnali vecchi
rm -f "$SWARM_DIR/segnali/"*.signal.json 2>/dev/null || true

echo -e "${GREEN}  OK - Struttura .swarm pronta${NC}"
echo ""

# Step 3: Crea worktrees
echo -e "${YELLOW}[3/5] Creo worktrees...${NC}"

# Usa lo script esistente
"$SCRIPT_DIR/setup-parallel-worktrees.sh" "$PROJECT_PATH" "${WORKERS[@]}"

echo ""

# Step 4: Crea file dipendenze
echo -e "${YELLOW}[4/5] Creo file dipendenze...${NC}"

DEPS_FILE="$SWARM_DIR/dipendenze/sessione_corrente.md"
TASK_NUM=1

cat > "$DEPS_FILE" << EOF
# Dipendenze Sessione: $SESSION_NAME

> **Data:** $DATE
> **Progetto:** $PROJECT_NAME
> **Status:** IN_PROGRESS

---

## Task Definiti

EOF

for worker in "${WORKERS[@]}"; do
    TASK_ID=$(printf "TASK-%03d" $TASK_NUM)

    # Prima task non ha dipendenze, gli altri dipendono dal precedente
    if [ $TASK_NUM -eq 1 ]; then
        DEPS="nessuno"
        PRIORITY=1
    else
        PREV_TASK=$(printf "TASK-%03d" $((TASK_NUM - 1)))
        DEPS="$PREV_TASK"
        PRIORITY=$TASK_NUM
    fi

    cat >> "$DEPS_FILE" << EOF
### $TASK_ID: Task $worker
- **Assegnato a:** cervella-$worker
- **Worktree:** ${PROJECT_NAME}-${worker}
- **Dipende da:** $DEPS
- **Produce:** ${TASK_ID}-complete.signal.json
- **Priorita:** $PRIORITY

EOF

    TASK_NUM=$((TASK_NUM + 1))
done

# Aggiungi sezione grafo
cat >> "$DEPS_FILE" << EOF
---

## Grafo Dipendenze

\`\`\`
EOF

# Costruisci grafo visuale
PREV=""
for worker in "${WORKERS[@]}"; do
    if [ -n "$PREV" ]; then
        echo "$PREV --> $worker" >> "$DEPS_FILE"
    fi
    PREV="$worker"
done

cat >> "$DEPS_FILE" << EOF
\`\`\`

---

## Istruzioni per le Cervelle

Ogni Cervella deve:
1. Leggere questo file per capire le dipendenze
2. Se ha dipendenze, usare: \`wait-for-dependencies.sh TASK-XXX\`
3. Quando finisce, creare segnale: \`create-signal.sh TASK-XXX success "descrizione"\`

---

*Sessione creata: $TIMESTAMP*
EOF

echo -e "${GREEN}  OK - File dipendenze creato: $DEPS_FILE${NC}"
echo ""

# Step 5: Crea file stato per ogni worker
echo -e "${YELLOW}[5/5] Creo file stato workers...${NC}"

TASK_NUM=1
for worker in "${WORKERS[@]}"; do
    TASK_ID=$(printf "TASK-%03d" $TASK_NUM)
    STATO_FILE="$SWARM_DIR/stato/${worker}.md"

    cat > "$STATO_FILE" << EOF
# Stato Cervella: $worker

> **Ultimo aggiornamento:** $TIMESTAMP
> **Worktree:** ${PROJECT_NAME}-${worker}
> **Task assegnato:** $TASK_ID
> **Status:** READY

---

## Status

READY - In attesa di istruzioni

## Task Corrente

$TASK_ID - Da iniziare

## Note

(nessuna)

---

*Aggiornare questo file durante il lavoro*
EOF

    echo -e "  ${GREEN}OK${NC} stato/${worker}.md"
    TASK_NUM=$((TASK_NUM + 1))
done

echo ""

# Sommario finale
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   SESSIONE PRONTA!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${CYAN}Sessione:${NC} $SESSION_NAME"
echo -e "${CYAN}Workers:${NC}  ${#WORKERS[@]}"
echo ""
echo -e "${YELLOW}Worktrees creati:${NC}"
for worker in "${WORKERS[@]}"; do
    WORKTREE_PATH=$(dirname "$PROJECT_PATH")/${PROJECT_NAME}-${worker}
    echo -e "  - $WORKTREE_PATH"
done
echo ""
echo -e "${YELLOW}Prossimi passi:${NC}"
echo ""
echo "1. Apri un terminale per ogni worker:"
for worker in "${WORKERS[@]}"; do
    WORKTREE_PATH=$(dirname "$PROJECT_PATH")/${PROJECT_NAME}-${worker}
    echo "   cd $WORKTREE_PATH && claude"
done
echo ""
echo "2. In ogni terminale, dai il task specifico alla Cervella"
echo ""
echo "3. Le Cervelle con dipendenze useranno:"
echo "   wait-for-dependencies.sh TASK-XXX"
echo ""
echo "4. Quando finiscono, creeranno segnale:"
echo "   create-signal.sh TASK-XXX success \"descrizione\" COMMIT"
echo ""
echo "5. Quando tutti hanno finito:"
echo "   $SCRIPT_DIR/merge-parallel-worktrees.sh $PROJECT_PATH"
echo "   $SCRIPT_DIR/cleanup-parallel-worktrees.sh $PROJECT_PATH"
echo ""
echo -e "${GREEN}Buon lavoro parallelo!${NC}"
echo ""
