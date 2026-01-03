"""
Utility functions for CervellaSwarm test orchestration.

Modulo contenente funzioni di utilità per la gestione di date e altri helper.
"""

import re
from datetime import datetime
from typing import Literal, Optional

__version__ = "1.0.0"
__version_date__ = "2026-01-02"


# Type alias per i formati supportati
DateFormat = Literal["DD/MM/YYYY", "YYYY-MM-DD", "human"]


def format_date(
    date: Optional[datetime] = None,
    format: DateFormat = "DD/MM/YYYY"
) -> str:
    """
    Formatta una data secondo il formato specificato.

    Args:
        date: Oggetto datetime da formattare. Se None, ritorna stringa vuota.
        format: Formato desiderato. Opzioni:
            - "DD/MM/YYYY": Es. "02/01/2026"
            - "YYYY-MM-DD": Es. "2026-01-02" (ISO 8601)
            - "human": Es. "2 Gennaio 2026"

    Returns:
        Stringa con la data formattata, o stringa vuota se date è None/invalid.

    Examples:
        >>> dt = datetime(2026, 1, 2, 14, 30)
        >>> format_date(dt, "DD/MM/YYYY")
        '02/01/2026'

        >>> format_date(dt, "YYYY-MM-DD")
        '2026-01-02'

        >>> format_date(dt, "human")
        '2 Gennaio 2026'

        >>> format_date(None)
        ''
    """
    # Gestione None
    if date is None:
        return ""

    # Validazione tipo
    if not isinstance(date, datetime):
        return ""

    try:
        # Formattazione in base al formato richiesto
        if format == "DD/MM/YYYY":
            return date.strftime("%d/%m/%Y")

        elif format == "YYYY-MM-DD":
            return date.strftime("%Y-%m-%d")

        elif format == "human":
            # Mappa dei nomi dei mesi in italiano
            mesi_it = {
                1: "Gennaio", 2: "Febbraio", 3: "Marzo", 4: "Aprile",
                5: "Maggio", 6: "Giugno", 7: "Luglio", 8: "Agosto",
                9: "Settembre", 10: "Ottobre", 11: "Novembre", 12: "Dicembre"
            }

            giorno = date.day
            mese = mesi_it[date.month]
            anno = date.year

            return f"{giorno} {mese} {anno}"

        else:
            # Formato non riconosciuto, fallback a default
            return date.strftime("%d/%m/%Y")

    except (ValueError, AttributeError) as e:
        # In caso di errore nella formattazione, ritorna stringa vuota
        return ""


def validate_email(email: Optional[str]) -> bool:
    """
    Valida un indirizzo email.

    Verifica che l'email abbia un formato valido secondo le convenzioni standard:
    - Contiene esattamente un @
    - Ha una parte locale (prima di @) non vuota
    - Ha un dominio (dopo @) con almeno un punto
    - Non contiene caratteri non validi

    Args:
        email: Stringa contenente l'indirizzo email da validare.
               Accetta None e stringhe vuote (ritorna False).

    Returns:
        True se l'email ha un formato valido, False altrimenti.

    Examples:
        >>> validate_email("user@example.com")
        True

        >>> validate_email("test.user@domain.org")
        True

        >>> validate_email("invalid-email")
        False

        >>> validate_email("")
        False

        >>> validate_email(None)
        False

        >>> validate_email("user@")
        False

        >>> validate_email("@domain.com")
        False
    """
    # Gestione None
    if email is None:
        return False

    # Gestione stringa vuota
    if not isinstance(email, str) or email.strip() == "":
        return False

    # Pattern regex per email valida
    # Basato su RFC 5322 (semplificato per casi comuni)
    email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

    return bool(re.match(email_pattern, email.strip()))
