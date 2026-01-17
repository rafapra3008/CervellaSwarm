# Ricerca: CLI Update Notification Patterns

**Data**: 17 Gennaio 2026
**Ricercatrice**: Cervella Researcher
**Obiettivo**: Analizzare come CLI tool popolari gestiscono aggiornamenti

---

## TL;DR - Best Practices 2026

```
✅ Check ASINCRONO in background (no performance impact)
✅ Cache risultati 24h - 7 giorni
✅ Notifica DOPO il check (run successivo, non immediato)
✅ Opt-out via env var (NO_UPDATE_NOTIFIER=1)
✅ Auto-disable in CI (CI=true detection)
✅ 2 librerie popolari: update-notifier (3.5M users) vs update-check (minimal)
```

---

## 1. GitHub CLI (gh)

### Come Funziona
- **Check Extensions**: ogni 24h quando un'extension viene eseguita
- **Check CLI**: durante `gh completion` (usato in .bashrc)
- **Display**: messaggio su stderr quando update disponibile
- **Update Mode**: MANUALE (notifica solo, no auto-update)

### Problemi Riscontrati
- Notifiche ogni volta che apri un prompt (se usi completion in .bashrc)
- Noise per utenti che installano via package manager (aspettano update pacchetto)

### Soluzione Implementata
- **Env var opt-out**: `GH_NO_UPDATE_NOTIFIER=1` disabilita check
- **Auto-disable in CI**: rileva variabili `CI`, `BUILD_NUMBER`, `RUN_ID`

**Fonte**: [GitHub Issue #743](https://github.com/cli/cli/issues/743)

---

## 2. Vercel CLI

### Libreria: update-check

**Repository**: [vercel/update-check](https://github.com/vercel/update-check)

**Filosofia**: "Very minimal approach to update checking"

### Caratteristiche
```javascript
const checkForUpdate = require('update-check');
const pkg = require('./package.json');

let update = null;

try {
  update = await checkForUpdate(pkg, {
    interval: 86400000,  // 1 day (default)
    distTag: 'latest'    // o 'canary' per beta
  });
} catch (err) {
  console.error(`Failed to check for updates: ${err}`);
}

if (update) {
  console.log(`The latest version is ${update.latest}. Please update!`);
}
```

### Config
- **interval**: cache duration (default: 1 day = 86400000ms)
- **distTag**: quale tag npm controllare (latest/canary/beta)
- **Return**: package.json della nuova versione, o null se aggiornato

**Fonte**: [GitHub vercel/update-check](https://github.com/vercel/update-check)

---

## 3. npm/Yarn - update-notifier

### Libreria Dominante: update-notifier

**Adoption**: 3.5+ milioni di package dipendenti
**Autore**: Sindre Sorhus (standard de-facto per CLI)

**Repository**: [sindresorhus/update-notifier](https://github.com/sindresorhus/update-notifier)

### Come Funziona (Smart Pattern)

```
1. PRIMO RUN
   - Check in background (unref'd child process)
   - Salva risultato in cache
   - NO notifica immediata (evita fastidio)

2. RUN SUCCESSIVI (dentro interval)
   - Legge da cache
   - Mostra notifica SE update disponibile
   - Zero performance impact

3. DOPO interval (default: 1 settimana)
   - Nuovo check in background
   - Aggiorna cache
```

### Codice Esempio

```javascript
import updateNotifier from 'update-notifier';
import packageJson from './package.json';

// Check + notifica
updateNotifier({
  pkg: packageJson,
  updateCheckInterval: 1000 * 60 * 60 * 24 * 7  // 1 week
}).notify();
```

### Opt-Out (3 modi)

```bash
# 1. Environment variable
export NO_UPDATE_NOTIFIER=1

# 2. Config file
~/.config/configstore/update-notifier-[package-name].json
{ "optOut": true }

# 3. CLI flag
yourcommand --no-update-notifier
```

### Features Chiave
- ✅ **Async**: unref'd child process (non blocca exit)
- ✅ **Zero performance impact**: check in background
- ✅ **Smart delay**: notifica al RUN dopo il check (mai immediata)
- ✅ **Rispetta utente**: 3 modi per opt-out
- ✅ **Auto-disable CI**: rileva ambienti CI

**Fonti**:
- [npm update-notifier](https://www.npmjs.com/package/update-notifier)
- [Generalist Programmer Guide](https://generalistprogrammer.com/tutorials/update-notifier-npm-package-guide)

---

## 4. Best Practices 2026

### Pattern Raccomandato

```
1. CHECK FREQUENCY
   - Default: 24h - 7 giorni
   - Beta/canary: daily
   - Stable release: weekly

2. NOTIFICATION TIMING
   ❌ Check + notify SUBITO (intrusive!)
   ✅ Check run N, notify run N+1 (smooth)

3. PERFORMANCE
   - Async background process (unref'd)
   - Cache su disco (~/.config/)
   - Zero blocking I/O

4. USER CONTROL
   - Env var opt-out (NO_UPDATE_NOTIFIER)
   - Config file opt-out
   - CLI flag opt-out (--no-update-notifier)

5. CI/CD DETECTION
   - Auto-disable se CI=true
   - Rileva BUILD_NUMBER, RUN_ID, etc

6. UPDATE METHOD
   - Manual > Auto-update (rispetta utente)
   - Istruzioni chiare su come aggiornare
   - Link a release notes
```

### Anti-Patterns da Evitare

```
❌ Check sincrono (blocca startup)
❌ Notifica immediata (fastidioso)
❌ Check ad ogni run (spam API)
❌ No opt-out (invasivo)
❌ Auto-update senza consenso
❌ Notifiche in CI (inutile noise)
```

---

## 5. Confronto Librerie

| Feature | update-notifier | update-check |
|---------|----------------|--------------|
| **Adoption** | 3.5M+ packages | 302 packages |
| **Last Update** | Active (2025+) | 6 anni fa |
| **Size** | Full-featured | Minimal |
| **Async** | ✅ unref'd process | ✅ async/await |
| **Cache** | ✅ configurable | ✅ configurable |
| **Opt-out** | ✅ 3 modi | ❌ no built-in |
| **CI detection** | ✅ auto | ❌ manual |
| **Delay notify** | ✅ smart | ❌ immediate |

### Raccomandazione

```
PRODUCTION CLI (2026):
→ update-notifier
  + Mature, battle-tested
  + 3.5M+ dependents
  + Complete opt-out support
  + Smart delayed notification
  + Active maintenance

MINIMAL CLI (tiny bundle):
→ update-check
  + Zero deps overhead
  + Simple API
  - No opt-out built-in
  - No smart delay
  - Maintenance unclear
```

---

## 6. Implementazione per CervellaSwarm CLI

### Proposta Pattern

```javascript
// cli/update-checker.js
import updateNotifier from 'update-notifier';
import pkg from '../package.json';

export function checkForUpdates() {
  const notifier = updateNotifier({
    pkg,
    updateCheckInterval: 1000 * 60 * 60 * 24,  // 24h
    shouldNotifyInNpmScript: false  // no noise in npm scripts
  });

  if (notifier.update && notifier.update.latest !== pkg.version) {
    notifier.notify({
      message: `
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   Update disponibile: {currentVersion} → {latestVersion}   ║
║                                                           ║
║   Run: npm install -g cervellaswarm                       ║
║                                                           ║
║   Release notes:                                          ║
║   https://github.com/rafapra/cervellaswarm/releases       ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
      `.trim(),
      defer: true  // Mostra DOPO run, non prima
    });
  }
}
```

### Where to Call

```javascript
// cli/index.js (entry point)
import { checkForUpdates } from './update-checker.js';

// AFTER commands run (defer pattern)
checkForUpdates();

// Main CLI logic...
```

### Opt-Out per Utenti

```bash
# Disabilita check updates
export NO_UPDATE_NOTIFIER=1

# O in .bashrc/.zshrc
echo 'export NO_UPDATE_NOTIFIER=1' >> ~/.zshrc
```

---

## Fonti Principali

1. [GitHub CLI Issue #743 - Update notifications](https://github.com/cli/cli/issues/743)
2. [Vercel update-check Repository](https://github.com/vercel/update-check)
3. [npm update-notifier Package](https://www.npmjs.com/package/update-notifier)
4. [Update-notifier Guide 2025](https://generalistprogrammer.com/tutorials/update-notifier-npm-package-guide)
5. [Sindre Sorhus update-notifier](https://github.com/sindresorhus/update-notifier)

---

## Next Steps

1. Installare `update-notifier` in CervellaSwarm CLI
2. Implementare pattern sopra in `cli/update-checker.js`
3. Testare con versione fake (simula update disponibile)
4. Documentare opt-out in README
5. Configurare check interval (24h per ora)

---

*Ricerca completata - Pattern validato da 3.5M+ CLI tools*
