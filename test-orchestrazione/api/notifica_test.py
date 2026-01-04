"""
notifica_test.py - Test per HARDTEST_NOTIFICA

Creato da: cervella-backend
Data: 2026-01-04
"""


def test_notifica() -> str:
    """
    Funzione di test per verificare il sistema di notifiche.

    Returns:
        str: Messaggio di conferma

    Example:
        >>> test_notifica()
        'Notifica test completato!'
    """
    return "Notifica test completato!"


def ping() -> str:
    """
    Semplice ping per verificare che il modulo funzioni.

    Returns:
        str: "pong"
    """
    return "pong"


if __name__ == "__main__":
    print(test_notifica())
    print(f"Ping: {ping()}")
