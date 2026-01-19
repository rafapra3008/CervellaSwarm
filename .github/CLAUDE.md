# Regole Review CervellaSwarm

> Questo file guida Claude nelle review automatiche delle PR.

---

## Code Standards

### Python
- Max 500 righe per file
- Max 50 righe per funzione
- snake_case per funzioni e variabili
- PascalCase per classi
- Docstring per funzioni pubbliche

### JavaScript/React
- Max 500 righe per file
- camelCase per funzioni e variabili
- PascalCase per componenti
- PropTypes o TypeScript per props

### Markdown
- Max 1000 righe per file
- Headings gerarchici
- Link funzionanti

---

## Security Checklist

- [ ] No hardcoded secrets o passwords
- [ ] Input sempre validato
- [ ] Query SQL parametrizzate
- [ ] Output HTML sanitizzato
- [ ] HTTPS per chiamate esterne
- [ ] Permessi minimi necessari

---

## Quality Checklist

- [ ] Ogni funzione pubblica ha docstring/JSDoc
- [ ] Test per nuove feature
- [ ] Niente TODO senza issue linkato
- [ ] Error handling specifico (no catch-all)
- [ ] Logging appropriato

---

## Filosofia CervellaSwarm

> "Lavoriamo in PACE! Senza CASINO! Dipende da NOI!"

- Fatto BENE > Fatto VELOCE
- I dettagli fanno la differenza
- Senza ego, testa pulita, cuore leggero
- Precisione > Velocita

---

## Quando Bloccare una PR

1. **Security issues** - Qualsiasi vulnerabilita
2. **Breaking changes** - Senza documentazione
3. **No tests** - Per logica critica
4. **Hardcoded secrets** - Mai accettabile

---

## Tono Review

- Professionale ma amichevole
- Suggerisci, non imporre
- Fornisci esempi di codice
- Celebra le cose fatte bene

*"Siamo una famiglia digitale!"*
