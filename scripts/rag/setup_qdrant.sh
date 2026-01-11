#!/bin/bash
# Setup Qdrant + Embedding per Cervella RAG
# Eseguire su: cervella-gpu
# Created: 11 Gennaio 2026 - Sprint 3.2

set -e

echo "=========================================="
echo "  CERVELLA RAG - Setup Qdrant"
echo "  Sprint 3.2 - CervellaSwarm"
echo "=========================================="
echo ""

# Directory setup
RAG_DIR=~/rag-setup
mkdir -p $RAG_DIR
cd $RAG_DIR

# 1. Verifica Ollama
echo "[1/6] Verifico Ollama..."
if ! command -v ollama &> /dev/null; then
    echo "ERRORE: Ollama non installato!"
    exit 1
fi
echo "      Ollama OK"

# 2. Pull embedding model
echo "[2/6] Pull nomic-embed-text..."
if ! ollama list | grep -q "nomic-embed-text"; then
    ollama pull nomic-embed-text
else
    echo "      Gia' presente"
fi

# 3. Test embedding
echo "[3/6] Test embedding..."
EMBED_TEST=$(ollama embeddings --model nomic-embed-text --prompt "test" 2>&1)
if echo "$EMBED_TEST" | grep -q "embedding"; then
    echo "      Embedding OK"
else
    echo "ERRORE: Embedding non funziona"
    echo "$EMBED_TEST"
    exit 1
fi

# 4. Verifica Docker
echo "[4/6] Verifico Docker..."
if ! command -v docker &> /dev/null; then
    echo "      Docker non trovato, installo..."
    sudo apt update && sudo apt install -y docker.io docker-compose
    sudo usermod -aG docker $USER
    echo "      Docker installato. Potrebbe servire logout/login."
fi
echo "      Docker OK"

# 5. Setup Qdrant
echo "[5/6] Setup Qdrant..."

# Crea docker-compose.yml
cat > docker-compose.yml << 'EOF'
services:
  qdrant:
    image: qdrant/qdrant:latest
    restart: always
    container_name: qdrant
    ports:
      - "127.0.0.1:6333:6333"
      - "127.0.0.1:6334:6334"
    volumes:
      - ./qdrant_data:/qdrant/storage
    environment:
      - QDRANT__SERVICE__API_KEY=${QDRANT_API_KEY}
EOF

# Genera API key se non esiste
if [ ! -f .env ]; then
    echo "      Genero API key..."
    echo "QDRANT_API_KEY=$(openssl rand -hex 32)" > .env
fi

# Avvia Qdrant
echo "      Avvio container..."
docker compose up -d

# 6. Attendi e verifica
echo "[6/6] Verifico Qdrant..."
sleep 5
until curl -s http://localhost:6333/healthz > /dev/null 2>&1; do
    echo "      Attendo Qdrant..."
    sleep 2
done

HEALTH=$(curl -s http://localhost:6333/healthz)
echo "      Qdrant Health: $HEALTH"

echo ""
echo "=========================================="
echo "  SETUP COMPLETATO!"
echo "=========================================="
echo ""
echo "  Qdrant: http://localhost:6333"
echo "  API Key: $(cat .env)"
echo ""
echo "  Prossimi step:"
echo "    1. python create_collection.py"
echo "    2. python test_rag.py"
echo ""
