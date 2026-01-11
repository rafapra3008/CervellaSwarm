# Ricerca: Setup Qdrant per RAG con Ollama

**Data**: 11 Gennaio 2026
**Researcher**: Cervella Researcher
**Contesto**: Integrazione RAG per Cervella AI su cervella-gpu (Tesla T4 16GB)

---

## TL;DR - Raccomandazioni Esecutive

| Decisione | Cosa | Perché |
|-----------|------|--------|
| **Vector DB** | Qdrant via Docker | Setup più semplice, production-ready |
| **Embedding** | `nomic-embed-text` | 1024 dim, 8k context, gratis, veloce |
| **Architettura** | Tutto su cervella-gpu | T4 16GB sufficiente per embedding + inference |
| **Chunking** | 512 token, 15% overlap | Best practice per query miste |
| **Sicurezza** | API key + bind localhost | No esposizione pubblica |

**Stima Risorse per 1000 documenti:**
- Qdrant: ~200-500 MB RAM, ~1-2 GB disco
- Ollama embedding: ~1-2 GB VRAM
- Totale VRAM con qwen3:4b + embed: ~6-8 GB (T4 16GB OK!)

---

## 1. Qdrant Setup

### Docker vs Native

**RACCOMANDAZIONE: Docker** ✅

| Criterio | Docker | Native (compilato) |
|----------|--------|-------------------|
| Setup | 1 comando | Richiede Rust toolchain |
| Aggiornamenti | `docker pull` | Ricompilare |
| Portabilità | Cross-platform | Dipende da arch |
| Prod-ready | Si | Si |
| Windows | Problemi con WSL mounts | N/A |

**Fonte:** [Qdrant Installation Guide](https://qdrant.tech/documentation/guides/installation/)

### Comandi Setup Esatti

```yaml
# docker-compose.yml
services:
  qdrant:
    image: qdrant/qdrant:latest
    restart: always
    container_name: qdrant
    ports:
      - "127.0.0.1:6333:6333"  # REST API (solo localhost!)
      - "127.0.0.1:6334:6334"  # gRPC API (solo localhost!)
    volumes:
      - ./qdrant_data:/qdrant/storage
    environment:
      # Sicurezza: API key obbligatoria
      - QDRANT__SERVICE__API_KEY=${QDRANT_API_KEY}
```

**IMPORTANTE:**
- `127.0.0.1:6333:6333` = bind SOLO localhost, non esposto a internet
- Volume persistente: `./qdrant_data` per non perdere dati
- API key in `.env` file, NON hardcoded

**Comando avvio:**
```bash
# Crea .env con API key
echo "QDRANT_API_KEY=$(openssl rand -hex 32)" > .env

# Avvia Qdrant
docker compose up -d

# Verifica
curl http://localhost:6333/healthz
```

**Fonte:** [Qdrant Docker Image](https://hub.docker.com/r/qdrant/qdrant)

---

## 2. Embedding con Ollama

### Modelli Disponibili

| Modello | Dimensioni | Context | Pro | Contro |
|---------|-----------|---------|-----|--------|
| **nomic-embed-text** | 1024 | 8192 | Veloce, ottimo per query corte | Meno preciso su query lunghe |
| **nomic-embed-text-v2-moe** | 1024 | - | Multilingua, MoE | Più lento |
| **mxbai-embed-large** | 1024 | - | Migliore su query lunghe (82.5%) | Più lento del 15-20% |

**RACCOMANDAZIONE: nomic-embed-text** ✅

**Perché:**
1. Supera OpenAI text-embedding-ada-002 su molti task
2. 8192 token context = documenti lunghi OK
3. Veloce su T4 (piccolo modello)
4. Gratis, locale, privacy totale

**Alternativa:** Se vedi performance scarse su query lunghe → `mxbai-embed-large`

**Fonte:** [Ollama Embedding Models](https://ollama.com/library/nomic-embed-text)

### Installazione e Test

```bash
# Su cervella-gpu
ssh cervella-gpu

# Pull modello embedding
ollama pull nomic-embed-text

# Test embedding
ollama embeddings --model nomic-embed-text --prompt "Test embedding generation"

# Output: array di 1024 float
```

---

## 3. Integrazione Qdrant + Ollama

### Python Client Setup

```bash
pip install ollama qdrant-client
```

### Codice Base Completo

```python
from qdrant_client import QdrantClient, models
import ollama
import os

# Configurazione
QDRANT_URL = "http://localhost:6333"
QDRANT_API_KEY = os.getenv("QDRANT_API_KEY")
OLLAMA_HOST = "http://localhost:11434"
COLLECTION_NAME = "cervella_docs"

# Client inizializzati
oclient = ollama.Client(host=OLLAMA_HOST)
qclient = QdrantClient(
    url=QDRANT_URL,
    api_key=QDRANT_API_KEY
)

# 1. Genera embedding di un testo
def generate_embedding(text: str) -> list[float]:
    """Genera embedding usando Ollama"""
    response = oclient.embeddings(
        model="nomic-embed-text",
        prompt=text
    )
    return response["embedding"]

# 2. Crea collection Qdrant (una volta sola)
def create_collection():
    """Crea collection con dimensioni corrette"""
    # Ottieni dimensione embedding dal modello
    sample_embedding = generate_embedding("test")

    if not qclient.collection_exists(COLLECTION_NAME):
        qclient.create_collection(
            collection_name=COLLECTION_NAME,
            vectors_config=models.VectorParams(
                size=len(sample_embedding),  # 1024 per nomic-embed-text
                distance=models.Distance.COSINE  # COSINE similarity
            ),
        )
        print(f"Collection '{COLLECTION_NAME}' creata!")

# 3. Inserisci documento
def add_document(doc_id: int, text: str, metadata: dict):
    """Aggiungi documento a Qdrant"""
    embedding = generate_embedding(text)

    qclient.upsert(
        collection_name=COLLECTION_NAME,
        points=[
            models.PointStruct(
                id=doc_id,
                vector=embedding,
                payload={
                    "text": text,
                    **metadata  # es: {"source": "manual.pdf", "page": 5}
                }
            )
        ],
    )

# 4. Ricerca semantica
def search_similar(query: str, limit: int = 5):
    """Cerca documenti simili alla query"""
    query_embedding = generate_embedding(query)

    results = qclient.search(
        collection_name=COLLECTION_NAME,
        query_vector=query_embedding,
        limit=limit,
        with_payload=True
    )

    return [
        {
            "score": hit.score,
            "text": hit.payload["text"],
            "metadata": {k: v for k, v in hit.payload.items() if k != "text"}
        }
        for hit in results
    ]

# Esempio uso
if __name__ == "__main__":
    create_collection()

    # Aggiungi documenti
    add_document(
        doc_id=1,
        text="Cervella è un sistema multi-agent basato su Claude",
        metadata={"source": "README.md", "section": "intro"}
    )

    # Cerca
    results = search_similar("come funziona il sistema agent?", limit=3)
    for i, r in enumerate(results, 1):
        print(f"{i}. Score: {r['score']:.3f}")
        print(f"   {r['text'][:100]}...")
```

**Fonte:** [Qdrant Ollama Integration](https://qdrant.tech/documentation/embeddings/ollama/)

---

## 4. RAG Pipeline Semplice

### Architettura Completa

```
┌─────────────┐
│  Documento  │
└──────┬──────┘
       │
       v
┌─────────────┐
│  Chunking   │ ← 512 token, 15% overlap
└──────┬──────┘
       │
       v
┌─────────────┐
│  Embedding  │ ← Ollama nomic-embed-text
└──────┬──────┘
       │
       v
┌─────────────┐
│   Qdrant    │ ← Store vectors
└─────────────┘

USER QUERY:
       │
       v
┌─────────────┐
│  Embedding  │ ← Query → vector
└──────┬──────┘
       │
       v
┌─────────────┐
│  Retrieval  │ ← Top-K similarity search
└──────┬──────┘
       │
       v
┌─────────────┐
│  Context +  │ ← Retrieved chunks + user query
│  LLM Call   │
└──────┬──────┘
       │
       v
┌─────────────┐
│  Response   │ ← Generated answer
└─────────────┘
```

### Chunking Strategy

**RACCOMANDAZIONE: 512 token, 15% overlap** ✅

**Perché:**
- 512 token = sweet spot per query miste (factoid + analitiche)
- 15% overlap = preserva contesto senza ridondanza eccessiva
- nomic-embed-text supporta fino a 8192 token, ma chunk più piccoli = retrieval più preciso

**Fonte:** [Chunking Best Practices](https://unstructured.io/blog/chunking-for-rag-best-practices)

**Codice Chunking:**

```python
from typing import List

def chunk_text(text: str, chunk_size: int = 512, overlap_pct: float = 0.15) -> List[str]:
    """
    Chunk testo con overlap.

    Args:
        text: Testo da chunkare
        chunk_size: Dimensione chunk in token (approssimato: 4 char = 1 token)
        overlap_pct: Percentuale overlap (0.15 = 15%)

    Returns:
        Lista di chunk
    """
    # Approssimazione: 4 caratteri ≈ 1 token
    chunk_chars = chunk_size * 4
    overlap_chars = int(chunk_chars * overlap_pct)

    chunks = []
    start = 0

    while start < len(text):
        end = start + chunk_chars
        chunk = text[start:end]

        # Non spezzare parole
        if end < len(text) and not text[end].isspace():
            last_space = chunk.rfind(' ')
            if last_space > 0:
                chunk = chunk[:last_space]
                end = start + last_space

        chunks.append(chunk.strip())
        start = end - overlap_chars

    return chunks

# Uso
doc_text = "..." # lungo documento
chunks = chunk_text(doc_text, chunk_size=512, overlap_pct=0.15)
```

**Per chunking più intelligente (preservare paragrafi, sezioni):**
- Usa `langchain.text_splitter.RecursiveCharacterTextSplitter`
- Splitter semantico: `semantic-text-splitter` library

### Retrieval Strategy

**RACCOMANDAZIONE: Top-5 chunks, score threshold > 0.7** ✅

```python
def rag_retrieve(query: str, top_k: int = 5, min_score: float = 0.7):
    """
    Retrieval con filtering per qualità.

    Args:
        query: User query
        top_k: Quanti chunk recuperare
        min_score: Score minimo (0-1, cosine similarity)

    Returns:
        Lista chunk rilevanti
    """
    results = search_similar(query, limit=top_k)

    # Filtra per score minimo
    filtered = [r for r in results if r["score"] >= min_score]

    if not filtered:
        return None  # Nessun risultato rilevante

    return filtered
```

**Perché Top-5:**
- Bilancia contesto (più info) vs noise (troppo contesto confonde LLM)
- 5 chunk × 512 token = ~2500 token context = OK per qwen3:4b (128k context!)

**Threshold 0.7:**
- Cosine similarity 0.7 = abbastanza rilevante
- Evita hallucination da chunk non pertinenti

**Fonte:** [RAG Implementation Guide](https://medium.com/@spandanmaity58/implementing-rag-using-langchain-ollama-and-qdrant-8b7b832fc3da)

### RAG Complete Function

```python
def rag_query(user_query: str, llm_model: str = "qwen3:4b") -> dict:
    """
    RAG completo: retrieve + generate.

    Returns:
        {
            "answer": str,
            "sources": List[dict],
            "num_chunks": int
        }
    """
    # 1. Retrieve context
    chunks = rag_retrieve(user_query, top_k=5, min_score=0.7)

    if not chunks:
        return {
            "answer": "Non ho trovato informazioni rilevanti per rispondere.",
            "sources": [],
            "num_chunks": 0
        }

    # 2. Build context
    context = "\n\n".join([
        f"[Fonte {i+1}]: {c['text']}"
        for i, c in enumerate(chunks)
    ])

    # 3. Build prompt
    prompt = f"""Rispondi alla domanda usando SOLO le informazioni fornite nel contesto.
Se il contesto non contiene la risposta, dillo chiaramente.

CONTESTO:
{context}

DOMANDA: {user_query}

RISPOSTA:"""

    # 4. Generate con Ollama
    response = oclient.generate(
        model=llm_model,
        prompt=prompt
    )

    return {
        "answer": response["response"],
        "sources": [
            {
                "text": c["text"][:200] + "...",  # Preview
                "score": c["score"],
                "metadata": c["metadata"]
            }
            for c in chunks
        ],
        "num_chunks": len(chunks)
    }

# Uso
result = rag_query("Come funziona il sistema di spawning worker?")
print(result["answer"])
print(f"\nBasato su {result['num_chunks']} fonti")
```

---

## 5. Risorse Necessarie

### Stima per 1000 Documenti

**Assunzioni:**
- 1000 documenti × 5 pagine/doc = 5000 pagine
- 1 pagina ≈ 500 token
- 500 token → ~1 chunk → 1 embedding (1024 dim)
- Totale: ~5000 chunk/embedding

#### Spazio Disco

| Componente | Calcolo | Spazio |
|-----------|---------|--------|
| Embedding vettori | 5000 × 1024 float32 × 4 byte = 20 MB | 20 MB |
| HNSW index | ~2-3× dimensione vettori | 40-60 MB |
| Payload (testo) | 5000 chunk × 2KB avg = 10 MB | 10 MB |
| Metadata | ~10% payload | 1 MB |
| **TOTALE** | | **~70-100 MB** |

**Con safety margin × 10:** 1-2 GB disco per 1000 documenti.

**Fonte:** [Qdrant Memory Consumption](https://qdrant.tech/articles/memory-consumption/)

#### RAM Qdrant

**Configurazione consigliata: memmap (on-disk)**

```yaml
# config/config.yaml per Qdrant
storage:
  # Vettori su disco, caricati in RAM on-demand
  on_disk_vectors: true

  # Payload in RAM (piccolo)
  # Index HNSW in RAM per performance
```

Con memmap:
- RAM minima: ~50-100 MB per 5000 vettori
- RAM consigliata: ~200-500 MB (include HNSW index in RAM)

**Trade-off:**
- Tutto in RAM = velocissimo, ma richiede ~500 MB per 5000 vettori
- Memmap = 90% performance, ~50 MB RAM

**RACCOMANDAZIONE:** Memmap per iniziare, tutto in RAM se serve più velocità.

**Fonte:** [Qdrant Storage Configuration](https://qdrant.tech/documentation/concepts/storage/)

#### VRAM GPU (Tesla T4 16GB)

| Processo | VRAM | Note |
|----------|------|------|
| qwen3:4b (inference) | ~4-5 GB | Modello base |
| nomic-embed-text | ~1-2 GB | Durante embedding generation |
| **Concorrente (worst case)** | **~6-7 GB** | LLM + embedding insieme |
| **Disponibile** | **16 GB** | |
| **Margine** | **9-10 GB** | ✅ Ampio margine! |

**IMPLICAZIONI:**
1. ✅ Tutto può girare su cervella-gpu (LLM + embedding)
2. ✅ Possibile gestire richieste concorrenti (3-4 simultanee OK)
3. ⚠️ Se scala a >10 utenti concorrenti → considera separare embedding su CPU

**Nota:** Embedding è veloce (~50-100ms per chunk), quindi raramente concorrente con inference.

**Fonte:** [Tesla T4 GPU Workloads](https://github.com/ollama/ollama/issues/13580)

#### CPU e RAM Sistema

| Componente | CPU | RAM |
|-----------|-----|-----|
| Qdrant (memmap) | Basso (~5-10%) | 200-500 MB |
| Ollama embedding | Medio (~20-30%) durante gen | ~500 MB |
| FastAPI backend | Basso (~5%) | ~200 MB |
| **TOTALE** | | **~1-1.5 GB RAM** |

cervella-gpu (probabilmente 32-64 GB RAM) = ✅ più che sufficiente!

---

## 6. Setup Completo Raccomandato

### Architettura Deployment

```
cervella-gpu (10.128.0.9)
├── Ollama (port 11434)
│   ├── qwen3:4b (inference)
│   └── nomic-embed-text (embedding)
├── Qdrant (port 6333, 6334) - solo localhost
│   └── Volume: ~/qdrant_data
└── Backend comunica via localhost

miracollo-cervella (34.27.179.164)
├── FastAPI backend
│   ├── Endpoint pubblico /api/chat
│   └── Connessione INTERNA a cervella-gpu
└── Frontend React
```

**SICUREZZA:**
- Qdrant bind su 127.0.0.1 (SOLO localhost)
- Backend FastAPI su miracollo chiama cervella-gpu via rete interna GCP
- Qdrant API key in env variables
- NO esposizione diretta Qdrant a internet

**Fonte:** [Qdrant Security Best Practices](https://qdrant.tech/documentation/guides/security/)

### File Struttura

```
~/rag-setup/
├── docker-compose.yml          # Qdrant
├── .env                        # QDRANT_API_KEY
├── config/
│   └── qdrant_config.yaml     # Configurazione Qdrant
├── qdrant_data/               # Volume persistente
├── scripts/
│   ├── setup_qdrant.sh        # Init Qdrant
│   ├── ingest_docs.py         # Chunk + embed + store
│   └── test_rag.py            # Test query
└── src/
    ├── rag_pipeline.py        # Codice RAG completo
    ├── chunking.py
    └── retrieval.py
```

### Script Setup Completo

```bash
#!/bin/bash
# setup_qdrant.sh

set -e

echo "🚀 Setup Qdrant + Ollama RAG..."

# 1. Verifica Ollama
echo "📡 Verifico Ollama..."
if ! ollama list | grep -q "nomic-embed-text"; then
    echo "📥 Scarico nomic-embed-text..."
    ollama pull nomic-embed-text
fi

# 2. Genera API key
if [ ! -f .env ]; then
    echo "🔑 Genero API key Qdrant..."
    echo "QDRANT_API_KEY=$(openssl rand -hex 32)" > .env
fi

# 3. Avvia Qdrant
echo "🐳 Avvio Qdrant..."
docker compose up -d

# 4. Attendi che Qdrant sia pronto
echo "⏳ Attendo Qdrant..."
sleep 5
until curl -s http://localhost:6333/healthz > /dev/null; do
    echo "   Attendo..."
    sleep 2
done

echo "✅ Qdrant pronto!"

# 5. Crea collection
echo "📚 Creo collection..."
python3 -c "
from qdrant_client import QdrantClient, models
import ollama
import os

oclient = ollama.Client()
qclient = QdrantClient(url='http://localhost:6333', api_key=os.getenv('QDRANT_API_KEY'))

# Sample embedding per dimensioni
sample = oclient.embeddings(model='nomic-embed-text', prompt='test')
dim = len(sample['embedding'])

if not qclient.collection_exists('cervella_docs'):
    qclient.create_collection(
        collection_name='cervella_docs',
        vectors_config=models.VectorParams(size=dim, distance=models.Distance.COSINE)
    )
    print(f'✅ Collection creata (dim={dim})')
else:
    print('ℹ️  Collection già esistente')
"

echo "🎉 Setup completato!"
echo ""
echo "📝 Prossimi step:"
echo "   1. Modifica ingest_docs.py con i tuoi documenti"
echo "   2. Esegui: python scripts/ingest_docs.py"
echo "   3. Testa: python scripts/test_rag.py"
```

---

## 7. Integrazione con FastAPI Backend

### Esempio Endpoint

```python
# backend/app/routers/rag.py
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from src.rag_pipeline import rag_query

router = APIRouter(prefix="/api/rag", tags=["RAG"])

class RAGRequest(BaseModel):
    query: str
    top_k: int = 5
    min_score: float = 0.7

class RAGResponse(BaseModel):
    answer: str
    sources: list[dict]
    num_chunks: int

@router.post("/query", response_model=RAGResponse)
async def rag_chat(request: RAGRequest):
    """
    RAG-enhanced chat endpoint.

    Ricerca documenti rilevanti e genera risposta contestualizzata.
    """
    try:
        result = rag_query(
            user_query=request.query,
            top_k=request.top_k,
            min_score=request.min_score
        )
        return RAGResponse(**result)

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/collections")
async def list_collections():
    """Lista collection Qdrant disponibili"""
    from src.rag_pipeline import qclient

    collections = qclient.get_collections()
    return {
        "collections": [c.name for c in collections.collections]
    }
```

### Test con curl

```bash
# Test RAG query
curl -X POST http://localhost:8000/api/rag/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Come funziona il sistema di spawning worker?",
    "top_k": 5,
    "min_score": 0.7
  }'

# Response:
{
  "answer": "Il sistema di spawning worker utilizza...",
  "sources": [
    {
      "text": "I worker vengono spawnat tramite...",
      "score": 0.89,
      "metadata": {"source": "DNA_FAMIGLIA.md"}
    }
  ],
  "num_chunks": 3
}
```

---

## 8. Metriche e Monitoring

### Metriche da Tracciare

```python
import time
from dataclasses import dataclass

@dataclass
class RAGMetrics:
    query_time: float  # Tempo totale query (ms)
    retrieval_time: float  # Tempo retrieval (ms)
    llm_time: float  # Tempo LLM generation (ms)
    num_chunks: int  # Chunk recuperati
    avg_score: float  # Score medio chunk

def rag_query_with_metrics(user_query: str) -> tuple[dict, RAGMetrics]:
    """RAG con metriche di performance"""
    start = time.time()

    # Retrieval
    retrieval_start = time.time()
    chunks = rag_retrieve(user_query)
    retrieval_time = (time.time() - retrieval_start) * 1000

    # LLM
    llm_start = time.time()
    # ... generate ...
    llm_time = (time.time() - llm_start) * 1000

    total_time = (time.time() - start) * 1000

    metrics = RAGMetrics(
        query_time=total_time,
        retrieval_time=retrieval_time,
        llm_time=llm_time,
        num_chunks=len(chunks),
        avg_score=sum(c["score"] for c in chunks) / len(chunks)
    )

    return result, metrics
```

**Target Performance:**
- Retrieval: < 50ms
- LLM generation: 500-2000ms (dipende da lunghezza risposta)
- **Totale**: < 2.5s per risposta completa

---

## 9. Troubleshooting Comune

| Problema | Causa | Soluzione |
|----------|-------|-----------|
| Qdrant connection refused | Non avviato o bind errato | `docker compose up -d`, verifica ports |
| Embedding molto lenti | Ollama usa CPU invece GPU | Verifica `nvidia-smi`, riavvia Ollama |
| Score sempre bassi (< 0.5) | Embedding model mismatch | Usa STESSO model per ingest e query |
| Out of memory GPU | Troppi processi concorrenti | Limita `OLLAMA_NUM_PARALLEL` |
| Collection not found | Mai creata | Esegui `create_collection()` |

---

## 10. Prossimi Step Consigliati

### Fase 1: Setup Base (1-2 giorni)
- [ ] Installa Qdrant via Docker Compose
- [ ] Pull nomic-embed-text su Ollama
- [ ] Test connessione Qdrant + Ollama
- [ ] Crea prima collection

### Fase 2: Ingest Pipeline (2-3 giorni)
- [ ] Script chunking documenti
- [ ] Script batch embedding + store
- [ ] Ingest documenti CervellaSwarm (README, DNA, docs/)
- [ ] Test retrieval qualità

### Fase 3: RAG Integration (3-4 giorni)
- [ ] Implementa `rag_query()` function
- [ ] Endpoint FastAPI `/api/rag/query`
- [ ] Test end-to-end
- [ ] Metriche e logging

### Fase 4: Optimization (ongoing)
- [ ] Tune chunking strategy (test 256, 512, 1024)
- [ ] Test mxbai-embed-large se nomic non basta
- [ ] Implement semantic chunking
- [ ] A/B test retrieval strategies

---

## Fonti e Riferimenti

### Documentazione Ufficiale
- [Qdrant Installation Guide](https://qdrant.tech/documentation/guides/installation/)
- [Qdrant Ollama Integration](https://qdrant.tech/documentation/embeddings/ollama/)
- [Qdrant Security Best Practices](https://qdrant.tech/documentation/guides/security/)
- [Ollama Embedding Models](https://ollama.com/library/nomic-embed-text)
- [Qdrant Memory Consumption](https://qdrant.tech/articles/memory-consumption/)
- [Qdrant Storage Configuration](https://qdrant.tech/documentation/concepts/storage/)

### Guide e Tutorial
- [Building Local RAG API with FastAPI](https://otmaneboughaba.com/posts/local-rag-api/)
- [RAG with LangChain, Ollama, Qdrant](https://medium.com/@spandanmaity58/implementing-rag-using-langchain-ollama-and-qdrant-8b7b832fc3da)
- [Chunking Best Practices for RAG](https://unstructured.io/blog/chunking-for-rag-best-practices)
- [Embedding Models Comparison 2026](https://elephas.app/blog/best-embedding-models)

### GitHub Resources
- [Local Qdrant RAG](https://github.com/XinBow99/Local-Qdrant-RAG)
- [RAG Assistant with Ollama](https://github.com/sourabhmarne777/rag-assistant-ollama)

### Performance e Hardware
- [Tesla T4 GPU Workloads](https://github.com/ollama/ollama/issues/13580)
- [Qdrant Capacity Planning](https://qdrant.tech/documentation/guides/capacity-planning/)

---

## Conclusioni

**DECISIONI CHIAVE:**

1. **Qdrant via Docker** - Setup semplice, production-ready
2. **nomic-embed-text** - Veloce, gratis, 1024 dim, 8k context
3. **Tutto su cervella-gpu** - T4 16GB sufficiente per LLM + embedding
4. **Chunking 512 token, 15% overlap** - Best practice industry
5. **Bind localhost + API key** - Sicurezza senza esposizione pubblica

**STIMA RISORSE (1000 documenti):**
- Disco: 1-2 GB
- RAM Qdrant: 200-500 MB (memmap)
- VRAM: 6-8 GB (LLM + embedding concorrente)
- **Totale VRAM usato: ~50% della T4** ✅

**TEMPO IMPLEMENTAZIONE STIMATO:**
- Setup base: 1-2 giorni
- Ingest pipeline: 2-3 giorni
- RAG integration: 3-4 giorni
- **TOTALE: ~1-2 settimane** per sistema production-ready

**NEXT ACTION:**
1. Leggi questa ricerca con Regina
2. Decide se procedere
3. Io (researcher) → delego a backend worker setup scripts

---

*Ricerca completata da Cervella Researcher - 11 Gennaio 2026*

*"Non reinventiamo la ruota - studiamo chi l'ha già fatta!"* 🔬
