# Istruzioni: Aprire Porta 8002 su GCP Firewall

**Data**: 2026-01-10
**VM**: miracollo-cervella (34.27.179.164)
**Servizio**: Cervella AI
**Porta**: 8002 (TCP)

---

## Stato Attuale

- ✅ Cervella AI: UP e healthy INTERNAMENTE (docker container attivo)
- ✅ SSH: funziona (porta 22 aperta)
- ❌ Porta 8002: BLOCCATA dal firewall GCP esterno

---

## Operazione: Creare Regola Firewall

### Metodo 1: GCP Console (Consigliato)

1. **Accedi a GCP Console**:
   - Vai a: https://console.cloud.google.com
   - Seleziona il progetto corretto (quello della VM miracollo-cervella)

2. **Vai alle Firewall Rules**:
   - Menu ☰ → VPC Network → Firewall
   - Oppure: https://console.cloud.google.com/networking/firewalls/list

3. **Crea Nuova Regola**:
   - Click su **"CREATE FIREWALL RULE"**

4. **Configurazione Regola**:
   ```
   Nome: allow-cervella-ai-8002
   Descrizione: Allow external access to Cervella AI on port 8002

   Logs: Off (o On se vuoi logging)

   Network: default (o la rete della tua VM)

   Priority: 1000 (default)

   Direction of traffic: Ingress

   Action on match: Allow

   Targets: Specified target tags
   Target tags: cervella-ai

   Source filter: IPv4 ranges
   Source IPv4 ranges: 0.0.0.0/0
   (oppure IP specifici se vuoi restringere l'accesso)

   Protocols and ports:
   - Seleziona: "Specified protocols and ports"
   - TCP: 8002
   ```

5. **Crea la regola**:
   - Click su **"CREATE"**
   - Attendi conferma (pochi secondi)

6. **Aggiungi Tag alla VM** (se non presente):
   - Menu ☰ → Compute Engine → VM instances
   - Click sulla VM **miracollo-cervella**
   - Click su **EDIT** (in alto)
   - Nella sezione "Network tags", aggiungi: **cervella-ai**
   - Click su **SAVE** (in fondo alla pagina)

---

### Metodo 2: gcloud CLI (Se disponibile)

Se in futuro installi gcloud CLI:

```bash
# Verifica autenticazione
gcloud auth list
gcloud config set project [PROJECT_ID]

# Crea regola firewall
gcloud compute firewall-rules create allow-cervella-ai-8002 \
  --allow tcp:8002 \
  --source-ranges 0.0.0.0/0 \
  --target-tags cervella-ai \
  --description "Allow external access to Cervella AI on port 8002"

# Aggiungi tag alla VM
gcloud compute instances add-tags miracollo-cervella \
  --tags cervella-ai \
  --zone [ZONA_VM]
```

---

## Verifica Funzionamento

Dopo aver creato la regola firewall:

```bash
# Test da locale
curl http://34.27.179.164:8002/health

# Risposta attesa:
# {"status":"healthy"}
```

Se funziona, potrai anche accedere da browser:
- Health check: http://34.27.179.164:8002/health
- Swagger docs: http://34.27.179.164:8002/docs

---

## Sicurezza (Opzionale)

Se vuoi restringere l'accesso solo a IP specifici invece di 0.0.0.0/0:

1. **Trova il tuo IP pubblico**: https://whatismyip.com
2. **Modifica la regola firewall**:
   - Source IPv4 ranges: [TUO_IP]/32

Esempio: `203.0.113.42/32` (solo il tuo IP)

---

## Rollback

Se vuoi rimuovere la regola:

**GCP Console**:
- VPC Network → Firewall → allow-cervella-ai-8002 → DELETE

**gcloud CLI**:
```bash
gcloud compute firewall-rules delete allow-cervella-ai-8002
```

---

## Note Cervella DevOps 🚀

- ✅ Regola SOLO per porta 8002 (nessun'altra porta toccata)
- ✅ Target tags usati per sicurezza (solo VM con tag cervella-ai)
- ✅ Operazione reversibile (facile rollback)
- ⚠️ Source 0.0.0.0/0 = accesso pubblico (considera IP specifici se sensibile)

**Status**: READY (istruzioni complete)
**Next**: Rafa esegue su GCP Console → Test con curl
