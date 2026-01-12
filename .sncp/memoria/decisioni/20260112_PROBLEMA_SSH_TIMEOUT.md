# Problema: SSH Timeout durante Deploy

> Data: 12 Gennaio 2026
> Tipo: Problema infrastruttura ricorrente

---

## Il Problema

Durante deploy via SSH, a volte appare:
```
timeout: Error: Exit code 1
Waiting... scp /tmp/file.py miracollo-cervella:/path
```

## Possibili Cause

1. **Connessione instabile** - Network issue temporaneo
2. **SSH timeout troppo basso** - Default timeout insufficiente
3. **VM sovraccarica** - Troppi processi
4. **SSH config** - Manca keepalive

## Soluzioni da Provare

### 1. Aumentare timeout SSH
```bash
# In ~/.ssh/config
Host miracollo-cervella
    ServerAliveInterval 60
    ServerAliveCountMax 3
    ConnectTimeout 30
```

### 2. Retry automatico
```bash
# Script con retry
for i in 1 2 3; do
    scp file.py miracollo-cervella:/path && break
    sleep 5
done
```

### 3. Verificare connessione prima
```bash
ssh miracollo-cervella "echo OK" || echo "Connection failed"
```

## Quando Succede

- Deploy di file multipli
- Comandi SSH concatenati
- Periodi di alta latenza

## Workaround Immediato

Se timeout:
1. Aspettare 30 secondi
2. Verificare se file è stato copiato comunque
3. Riprovare singolarmente

## TODO

- [ ] Verificare ~/.ssh/config ha keepalive
- [ ] Aggiungere retry logic agli script deploy
- [ ] Monitorare frequenza errori

---

*Problema noto. Non blocca il lavoro, ma va sistemato.*
