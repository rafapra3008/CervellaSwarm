#!/usr/bin/env python3
"""
Crea collection Qdrant per Cervella RAG.
Eseguire su: cervella-gpu (dopo setup_qdrant.sh)
Created: 11 Gennaio 2026 - Sprint 3.2
"""

import os
import sys

try:
    from qdrant_client import QdrantClient, models
    import ollama
except ImportError:
    print("Installo dipendenze...")
    os.system("pip install qdrant-client ollama python-dotenv")
    from qdrant_client import QdrantClient, models
    import ollama

# Load .env
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass  # .env gia' caricato da shell

# Config
QDRANT_URL = os.getenv("QDRANT_URL", "http://localhost:6333")
QDRANT_API_KEY = os.getenv("QDRANT_API_KEY")
OLLAMA_HOST = os.getenv("OLLAMA_HOST", "http://localhost:11434")
COLLECTION_NAME = "cervella_docs"

print("=" * 50)
print("  CREATE COLLECTION - Cervella RAG")
print("=" * 50)
print()

# Verifica API key
if not QDRANT_API_KEY:
    print("ERRORE: QDRANT_API_KEY non trovata!")
    print("Esegui: source .env")
    sys.exit(1)

# Clients
print("[1/4] Connessione clients...")
try:
    oclient = ollama.Client(host=OLLAMA_HOST)
    qclient = QdrantClient(url=QDRANT_URL, api_key=QDRANT_API_KEY)
    print("      OK")
except Exception as e:
    print(f"ERRORE: {e}")
    sys.exit(1)

# Get embedding dimension
print("[2/4] Test embedding dimension...")
try:
    sample = oclient.embeddings(model="nomic-embed-text", prompt="test")
    dim = len(sample["embedding"])
    print(f"      Dimension: {dim}")
except Exception as e:
    print(f"ERRORE embedding: {e}")
    sys.exit(1)

# Create collection
print(f"[3/4] Creo collection '{COLLECTION_NAME}'...")
try:
    if not qclient.collection_exists(COLLECTION_NAME):
        qclient.create_collection(
            collection_name=COLLECTION_NAME,
            vectors_config=models.VectorParams(
                size=dim,
                distance=models.Distance.COSINE
            )
        )
        print("      Collection creata!")
    else:
        print("      Collection gia' esistente")
except Exception as e:
    print(f"ERRORE creazione: {e}")
    sys.exit(1)

# Verify
print("[4/4] Verifica...")
try:
    info = qclient.get_collection(COLLECTION_NAME)
    print(f"      Collection: {COLLECTION_NAME}")
    print(f"      Vectors: {info.points_count}")
    print(f"      Status: {info.status}")
except Exception as e:
    print(f"ERRORE verifica: {e}")
    sys.exit(1)

print()
print("=" * 50)
print("  COLLECTION PRONTA!")
print("=" * 50)
print()
print(f"  Nome: {COLLECTION_NAME}")
print(f"  Dimension: {dim}")
print(f"  Distance: COSINE")
print()
print("  Prossimo: python test_rag.py")
print()
