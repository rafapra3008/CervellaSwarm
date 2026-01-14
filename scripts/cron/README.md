# CervellaSwarm Cron Jobs

Automazione di task ricorrenti per il sistema di memoria collettiva.

---

## 📅 Weekly Retrospective

Report settimanale automatico con analisi metriche e suggerimenti.

### Setup Cron

```bash
# Apri crontab
crontab -e

# Aggiungi questa riga (venerdì alle 18:00)
0 18 * * 5 cd /Users/rafapra/Developer/CervellaSwarm && python3 scripts/memory/weekly_retro.py --save --quiet >> /Users/rafapra/Developer/CervellaSwarm/data/logs/weekly_retro.log 2>&1
```

### Verifica Cron Attivi

```bash
# Lista cron jobs attivi
crontab -l

# Verifica logs
tail -f ~/Developer/CervellaSwarm/data/logs/weekly_retro.log
```

### Schedule Alternative

```bash
# Ogni lunedì alle 9:00
0 9 * * 1 cd /path && python3 scripts/memory/weekly_retro.py --save --quiet

# Daily retro (ogni giorno alle 23:00)
0 23 * * * cd /path && python3 scripts/memory/weekly_retro.py -d 1 --save --quiet

# Monthly retro (primo del mese alle 10:00)
0 10 1 * * cd /path && python3 scripts/memory/weekly_retro.py -d 30 --save --quiet
```

---

## 📝 Test Manuale

Prima di abilitare il cron, testa il comando:

```bash
cd ~/Developer/CervellaSwarm
python3 scripts/memory/weekly_retro.py --save --quiet
```

Verifica che il report sia stato creato in `data/retro/YYYY-MM-DD.md`.

---

## 📂 File Generati

```
data/
├── retro/
│   ├── 2026-01-01.md          # Report settimanali
│   ├── 2026-01-08.md
│   └── ...
└── logs/
    └── weekly_retro.log       # Logs cron execution
```

---

---

## SNCP Maintenance (Sessione 209)

### Daily Maintenance

Health check automatico + cleanup file temporanei.

```bash
# Ogni giorno alle 8:30
30 8 * * * /Users/rafapra/Developer/CervellaSwarm/scripts/cron/sncp_daily_maintenance.sh
```

**Cosa fa:**
- Esegue health-check.sh e salva report
- Pulisce file temporanei (.DS_Store, *.bak)
- Verifica dimensioni file (warning se > 300 righe)
- Genera statistiche SNCP

**Test manuale:**
```bash
/Users/rafapra/Developer/CervellaSwarm/scripts/cron/sncp_daily_maintenance.sh
```

### Weekly Archive

Archivia file vecchi (> 30 giorni) per mantenere SNCP pulito.

```bash
# Ogni Lunedi alle 6:00
0 6 * * 1 /Users/rafapra/Developer/CervellaSwarm/scripts/cron/sncp_weekly_archive.sh
```

**Cosa fa:**
- Archivia file da idee/, reports/, decisioni/
- Mantiene stato.md e roadmaps/ sempre attivi
- Pulisce archivi > 90 giorni
- Genera report settimanale

**Test manuale:**
```bash
/Users/rafapra/Developer/CervellaSwarm/scripts/cron/sncp_weekly_archive.sh
```

### LAUNCHD (Raccomandato - Nativo Apple)

Meglio di cron! Esegue anche quando apri il Mac.

```bash
# Verifica agents attivi
launchctl list | grep cervellaswarm

# Daily: AL LOGIN + ore 8:30
~/Library/LaunchAgents/com.cervellaswarm.sncp.daily.plist

# Weekly: Lunedi ore 6:00
~/Library/LaunchAgents/com.cervellaswarm.sncp.weekly.plist

# Ricaricare dopo modifiche
launchctl unload ~/Library/LaunchAgents/com.cervellaswarm.sncp.daily.plist
launchctl load ~/Library/LaunchAgents/com.cervellaswarm.sncp.daily.plist
```

### Crontab (Alternativa)

```bash
# Copia e incolla tutto nel crontab (crontab -e)

# CervellaSwarm Weekly Retro - ogni lunedi alle 8:00
0 8 * * 1 /Users/rafapra/Developer/CervellaSwarm/scripts/cron/weekly_retro_cron.sh

# CervellaSwarm Log Rotation - ogni giorno alle 3:00
0 3 * * * /Users/rafapra/Developer/CervellaSwarm/scripts/cron/log_rotate_cron.sh

# SNCP Daily Maintenance - ogni giorno alle 8:30
30 8 * * * /Users/rafapra/Developer/CervellaSwarm/scripts/cron/sncp_daily_maintenance.sh

# SNCP Weekly Archive - ogni lunedi alle 6:00
0 6 * * 1 /Users/rafapra/Developer/CervellaSwarm/scripts/cron/sncp_weekly_archive.sh
```

---

**Created:** 2026-01-01
**Last Updated:** 2026-01-14 (Sessione 209 - SNCP Maintenance)
**Version:** 2.0.0
