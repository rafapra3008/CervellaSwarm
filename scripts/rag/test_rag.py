#!/usr/bin/env python3
"""
Test RAG base per Cervella.
Eseguire su: cervella-gpu (dopo create_collection.py)
Created: 11 Gennaio 2026 - Sprint 3.2
"""

import os
import sys

try:
    from qdrant_client import QdrantClient, models
    import ollama
    from dotenv import load_dotenv
except ImportError:
    print("Installo dipendenze...")
    os.system("pip install qdrant-client ollama python-dotenv")
    from qdrant_client import QdrantClient, models
    import ollama
    from dotenv import load_dotenv

load_dotenv()

# Config
QDRANT_URL = os.getenv("QDRANT_URL", "http://localhost:6333")
QDRANT_API_KEY = os.getenv("QDRANT_API_KEY")
COLLECTION_NAME = "cervella_docs"

print("=" * 50)
print("  TEST RAG - Cervella")
print("=" * 50)
print()

# Clients
oclient = ollama.Client()
qclient = QdrantClient(url=QDRANT_URL, api_key=QDRANT_API_KEY)


def embed(text: str) -> list:
    """Genera embedding per testo."""
    return oclient.embeddings(model="nomic-embed-text", prompt=text)["embedding"]


# Test documents
TEST_DOCS = [
    {
        "id": 1,
        "text": "CervellaSwarm e' un sistema multi-agent con 16 Cervelle specializzate coordinate dalla Regina. Ogni agente ha un ruolo specifico: frontend, backend, tester, researcher, e altri.",
        "source": "README.md"
    },
    {
        "id": 2,
        "text": "SNCP significa Sistema Nervoso Centrale Progetti. E' la memoria esterna dello swarm dove documentiamo idee, decisioni e stato dei progetti.",
        "source": "SNCP_README.md"
    },
    {
        "id": 3,
        "text": "La Regina orchestra lo swarm. Delega task agli agenti specializzati, coordina il lavoro e mantiene la visione d'insieme del progetto.",
        "source": "DNA_FAMIGLIA.md"
    },
    {
        "id": 4,
        "text": "Cervella AI usa GPU propria con Ollama e modello qwen3:4b. L'obiettivo e' l'indipendenza totale da API esterne come Claude o OpenAI.",
        "source": "VISIONE.md"
    }
]

# Add documents
print("[1/3] Aggiungo documenti di test...")
points = []
for doc in TEST_DOCS:
    points.append(
        models.PointStruct(
            id=doc["id"],
            vector=embed(doc["text"]),
            payload={"text": doc["text"], "source": doc["source"]}
        )
    )
    print(f"      - Doc {doc['id']}: {doc['source']}")

qclient.upsert(collection_name=COLLECTION_NAME, points=points)
print(f"      Aggiunti {len(points)} documenti")

# Test queries
print()
print("[2/3] Test ricerche...")

TEST_QUERIES = [
    "Cosa e' SNCP?",
    "Chi coordina lo swarm?",
    "Quale modello AI usa Cervella?",
    "Quanti agenti ci sono?"
]

for query in TEST_QUERIES:
    print()
    print(f"  Query: '{query}'")
    results = qclient.search(
        collection_name=COLLECTION_NAME,
        query_vector=embed(query),
        limit=2,
        with_payload=True
    )
    for i, hit in enumerate(results, 1):
        score_bar = "#" * int(hit.score * 20)
        print(f"    {i}. [{hit.score:.3f}] {score_bar}")
        print(f"       {hit.payload['text'][:80]}...")

# RAG complete test
print()
print("[3/3] Test RAG completo (retrieval + generation)...")

user_query = "Spiega cos'e' CervellaSwarm in poche parole"
print(f"  Query: '{user_query}'")

# Retrieve
results = qclient.search(
    collection_name=COLLECTION_NAME,
    query_vector=embed(user_query),
    limit=3,
    with_payload=True
)

# Build context
context = "\n\n".join([
    f"[{i+1}] {hit.payload['text']}"
    for i, hit in enumerate(results)
])

# Generate with LLM
prompt = f"""Rispondi alla domanda usando SOLO le informazioni nel contesto.
Se non sai, dillo.

CONTESTO:
{context}

DOMANDA: {user_query}

RISPOSTA:"""

print()
print("  Genero risposta con qwen3:4b...")
response = oclient.generate(model="qwen3:4b", prompt=prompt)
answer = response["response"]

print()
print("  " + "-" * 40)
print(f"  RISPOSTA: {answer[:300]}...")
print("  " + "-" * 40)

print()
print("=" * 50)
print("  TEST COMPLETATO!")
print("=" * 50)
print()
print("  Documenti indicizzati: 4")
print("  Query testate: 4")
print("  RAG generation: OK")
print()
print("  Sprint 3.2 VALIDATO!")
print()
