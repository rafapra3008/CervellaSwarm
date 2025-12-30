#!/usr/bin/env python3
"""
Endpoint API: Saluto del Giorno
Ritorna un saluto personalizzato basato sull'ora corrente.
"""

__version__ = "1.0.0"
__version_date__ = "2025-12-30"

from datetime import datetime
import json


def get_greeting():
    """
    Ritorna un saluto basato sull'ora corrente.

    Logica:
    - 05:00-12:00 → Buongiorno!
    - 12:00-18:00 → Buon pomeriggio!
    - 18:00-22:00 → Buonasera!
    - 22:00-05:00 → Buonanotte!

    Returns:
        dict: {"greeting": str, "hour": int}
    """
    now = datetime.now()
    current_hour = now.hour

    # Logica saluto basata su ora
    if 5 <= current_hour < 12:
        greeting = "Buongiorno!"
    elif 12 <= current_hour < 18:
        greeting = "Buon pomeriggio!"
    elif 18 <= current_hour < 22:
        greeting = "Buonasera!"
    else:  # 22-5
        greeting = "Buonanotte!"

    return {
        "greeting": greeting,
        "hour": current_hour
    }


def handle_request():
    """
    Handler principale per l'endpoint GET /api/greeting.

    Returns:
        str: JSON response con greeting e hour
    """
    try:
        result = get_greeting()
        response = {
            "status": "success",
            "data": result
        }
        return json.dumps(response, ensure_ascii=False, indent=2)

    except Exception as e:
        error_response = {
            "status": "error",
            "message": str(e)
        }
        return json.dumps(error_response, ensure_ascii=False, indent=2)


# Test manuale (esegui questo file direttamente)
if __name__ == "__main__":
    print("=== Test Endpoint Saluto del Giorno ===\n")

    # Test funzione principale
    response = handle_request()
    print("Response JSON:")
    print(response)

    # Test casi specifici (mostra logica saluti)
    print("\n=== Test Logica Saluti (Reference) ===")
    test_cases = [
        (6, "Buongiorno!"),
        (12, "Buon pomeriggio!"),
        (15, "Buon pomeriggio!"),
        (18, "Buonasera!"),
        (20, "Buonasera!"),
        (23, "Buonanotte!"),
        (2, "Buonanotte!")
    ]

    for hour, expected_greeting in test_cases:
        print(f"Ora {hour:02d}:00 → {expected_greeting}")
