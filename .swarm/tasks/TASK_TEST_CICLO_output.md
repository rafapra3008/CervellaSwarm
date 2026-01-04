# Report: task_manager.py

## Funzioni Trovate

- **validate_task_id**: Valida task_id per sicurezza (no path traversal, solo alfanumerici)
- **ensure_tasks_dir**: Crea la directory .swarm/tasks se non esiste
- **create_task**: Crea un nuovo task con template markdown
- **list_tasks**: Lista tutti i task con stato, ACK e agent assegnato
- **mark_ready**: Segna task come pronto (.ready)
- **mark_working**: Segna task come in lavorazione (.working)
- **mark_done**: Segna task come completato (.done)
- **ack_received**: Segna ACK che worker ha ricevuto il task
- **ack_understood**: Segna ACK che worker ha capito il task
- **get_task_status**: Ritorna stato: done/working/ready/created/not_found
- **get_ack_status**: Ritorna stringa R/U/D con stato ACK
- **cleanup_task**: Rimuove tutti i marker files di un task

## Note

- Versione: 1.1.0 (2026-01-03)
- Usa file marker (.ready, .working, .done) per sincronizzazione
- Include validazione sicurezza per prevenire path traversal
- CLI completa con tutti i comandi necessari
