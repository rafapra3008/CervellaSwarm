# Cervella Baby POC

> POC per validare Qwen3-4B come alternativa open source a Claude API

## About

**Obiettivo:** Testare se Qwen3-4B puo eseguire task Cervella con quality accettabile (>=60%).

**Timeline:** 3 settimane (10-31 Gennaio 2026)
**Budget:** $50 (Colab Pro + Vast.ai spot)
**Tech:** Unsloth, Qwen3-4B-Instruct, 4-bit quantization

## Quick Start

### 1. Setup Colab

```bash
# Apri Google Colab
# Runtime > Change runtime type > T4 GPU
```

### 2. Install Dependencies

```python
!pip install unsloth transformers datasets accelerate
```

### 3. Load Model

```python
from unsloth import FastLanguageModel

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name="unsloth/Qwen3-4B-Instruct",
    max_seq_length=2048,
    dtype=None,
    load_in_4bit=True,
)
```

### 4. Run Benchmark

```python
import json

with open("task_dataset.json") as f:
    tasks = json.load(f)

# Test singolo task
task = tasks["tasks"][0]  # T01
# ... run inference
```

## Files

```
poc_cervella_baby/
├── README.md                    # Questo file
├── task_dataset.json            # 20 task benchmark
├── costituzione_compressa.md    # System prompt (1380 tok)
├── poc_notebook.ipynb           # Colab notebook (da creare)
└── results/                     # Output test (da creare)
    └── week1_results.json
```

## Task Tiers

| Tier | Count | Pass Threshold | Description |
|------|-------|----------------|-------------|
| TIER 1 | 10 | 80% score | Simple tasks |
| TIER 2 | 8 | 75% score | Medium tasks |
| TIER 3 | 2 | 70% score | Complex (document gap) |

## Success Criteria

```
PASS POC (>=60% overall):
- TIER 1: >= 6/10 pass
- TIER 2: >= 5/8 pass
- Blind test: <= 70% accuracy

NO-GO (<60% overall):
- Stay Claude API
- Consider larger model
```

## Timeline

```
WEEK 1: Setup + T01-T10 (Simple)
WEEK 2: T11-T18 (Medium)
WEEK 3: T19-T20 + Final + Decision

GO/NO-GO: 1 Febbraio 2026
```

## Links

- [SUB_ROADMAP](../.sncp/idee/SUB_ROADMAP_POC_CERVELLA_BABY.md)
- [FASE_5_CONSOLIDATO](../.sncp/idee/ricerche_cervella_baby/FASE_5_CONSOLIDATO.md)
- [Report 17 Task Benchmark](../.sncp/idee/ricerche_cervella_baby/17_TASK_BENCHMARK_CERVELLA.md)
- [Report 18 COSTITUZIONE Compression](../.sncp/idee/ricerche_cervella_baby/18_COSTITUZIONE_COMPRESSION.md)

---

*POC Cervella Baby v1.0*
*"POC $50 decide tutto. Studiato bene, ora FACCIAMO!"*
