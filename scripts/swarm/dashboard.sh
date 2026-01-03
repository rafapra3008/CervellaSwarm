#!/bin/bash
#
# CervellaSwarm Dashboard - Wrapper Bash
#
# Questo script è un semplice wrapper per dashboard.py
# che assicura di essere nella directory corretta.
#

__version__="1.0.0"
__version_date__="2026-01-03"

# Trova la directory dello script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Esegui dashboard.py passando tutti gli argomenti
exec python3 "${SCRIPT_DIR}/dashboard.py" "$@"
