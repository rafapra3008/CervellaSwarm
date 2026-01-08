# SNCP - Sistema Nervoso Centrale del Progetto

> **Versione:** 0.1.0
> **Creato:** 8 Gennaio 2026
> **Studio completo:** `docs/studio/STUDIO_SNCP.md`

---

```
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║   Questa cartella È il cervello di CervellaSwarm.               ║
║                                                                  ║
║   Qui vivono: memoria, idee, perne, stato, futuro.              ║
║   Qui nulla si perde.                                           ║
║                                                                  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## STRUTTURA

```
.sncp/
│
├── README.md              ← Sei qui
│
├── memoria/               # IL PASSATO
│   ├── sessioni/          # Log delle sessioni
│   └── decisioni/         # Decisioni prese (e PERCHÉ)
│
├── idee/                  # LE BOLLE CHE FLUTTUANO
│   ├── in_attesa/         # Da discutere
│   ├── in_studio/         # Sotto analisi (discovery)
│   └── integrate/         # Diventate realtà
│
├── perne/                 # LE DEVIAZIONI
│   ├── attive/            # Sub-roadmap in corso
│   └── archivio/          # Perne rientrate
│
├── stato/                 # IL PRESENTE
│   └── oggi.md            # Cosa sta succedendo ORA
│
└── futuro/                # DOVE ANDIAMO
    └── roadmap.md         # La linea principale
```

---

## COME USARE

### Catturare un'Idea
```bash
# Crea un file in idee/in_attesa/
# Usa il template: _TEMPLATE_IDEA.md
```

### Aprire una Perna
```bash
# Crea un file in perne/attive/
# Usa il template: _TEMPLATE_PERNA.md
```

### Registrare una Decisione
```bash
# Crea un file in memoria/decisioni/
# Usa il template: _TEMPLATE_DECISIONE.md
```

### Aggiornare lo Stato
```bash
# Modifica stato/oggi.md
# Fatto automaticamente a fine sessione
```

---

## CONVENZIONI

### Nomi File

```
IDEA_YYYYMMDD_nome-breve.md
PERNA_YYYYMMDD_nome-breve.md
DECISIONE_YYYYMMDD_nome-breve.md
SESSIONE_NNN.md
```

### Stati delle Idee

| Cartella | Significato |
|----------|-------------|
| `in_attesa` | Catturata, da discutere |
| `in_studio` | Stiamo approfondendo |
| `integrate` | Diventata realtà (merged) |

### Stati delle Perne

| Cartella | Significato |
|----------|-------------|
| `attive` | Sub-roadmap in corso |
| `archivio` | Rientrata nella linea principale |

---

## FILOSOFIA

> "Qui nulla si perde."

Ogni idea catturata è una vittoria.
Ogni perna che rientra è crescita.
Ogni decisione documentata è saggezza.

Il SNCP cresce con noi.

---

*Prima pietra: 8 Gennaio 2026, Sessione 119*
