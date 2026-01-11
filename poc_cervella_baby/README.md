# Cervella Baby POC

> POC per validare Qwen3-4B come alternativa open source a Claude API

## STATO ATTUALE

```
+================================================================+
|                                                                |
|              POC WEEK 1: PASS! | WEEK 2: PASS!                 |
|                                                                |
|   Week 1: 9/10 (90%)  |  Week 2: 8/8 (100%) - Score 89.4%      |
|                                                                |
|         TOTALE: 17/18 task PASS (94.4%)                        |
|                                                                |
|            IL MODELLO HA ASSORBITO LA COSTITUZIONE!            |
|                                                                |
+================================================================+
```

**Week 3 PRONTO:** T19-T20 (Complex tasks) - Documenta GAP

## About

**Obiettivo:** Testare se Qwen3-4B puo eseguire task Cervella con quality accettabile (>=60%).

**Timeline:** 3 settimane (10-31 Gennaio 2026)
**Budget:** $50 (Colab Pro + Vast.ai spot)
**Tech:** Unsloth, Qwen3-4B-Instruct-2507, 4-bit quantization

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
├── poc_notebook.ipynb           # Week 1 notebook (T01-T10) - PASS 9/10
├── poc_notebook_week2.ipynb     # Week 2 notebook (T11-T18) - PASS 8/8
├── poc_notebook_week3.ipynb     # Week 3 notebook (T19-T20) - PRONTO
└── results/                     # Output test
    ├── week1_results.json       # PASS 9/10
    ├── week2_results.json       # PASS 8/8
    └── week3_results.json       # In corso...
```

## Week 2 - Istruzioni

### 1. Upload notebook
```
poc_notebook_week2.ipynb -> Google Colab
```

### 2. Setup GPU
```
Runtime > Change runtime type > T4 GPU
```

### 3. Esegui celle in ordine
- Setup (celle 1-5)
- Load model (cella 6-7)
- Run T11 test (cella 8)
- Run ALL T11-T18 (cella 9)

### 4. Valuta ogni task
```python
results[0] = evaluate_task(results[0], correttezza=4, completezza=4, stile=4, utility=4)
```

### 5. Success Criteria Week 2
- **PASS:** >=5/8 task con score >=75%
- **CONDITIONAL:** 3-4/8 task pass
- **FAIL:** <3/8 task pass

## Week 3 - Istruzioni (FINALE)

### 1. Upload notebook
```
poc_notebook_week3.ipynb -> Google Colab
```

### 2. Setup GPU
```
Runtime > Change runtime type > T4 GPU
```

### 3. Esegui T19 e T20 separatamente
- Run T19 (Strategic Planning)
- Run T20 (Architettura Decision)

### 4. Valuta con gap_notes
```python
results[0] = evaluate_task(results[0], correttezza=4, completezza=3, stile=4, utility=3, gap_notes="Manca X")
```

### 5. NOTA IMPORTANTE
**TIER 3 documenta i LIMITI del modello.**
Il POC e' gia' PASS con Week 1 + Week 2!

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
