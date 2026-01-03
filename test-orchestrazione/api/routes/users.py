"""
Users API routes for CervellaSwarm test orchestration.

Endpoint per la gestione degli utenti (mock data per testing).
"""

from typing import List
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr

__version__ = "1.0.0"

router = APIRouter(prefix="/api", tags=["users"])


class User(BaseModel):
    """Schema utente per response API."""
    id: int
    name: str
    email: str


# Mock data per testing
MOCK_USERS: List[User] = [
    User(id=1, name="Mario Rossi", email="mario@test.com"),
    User(id=2, name="Laura Bianchi", email="laura@test.com"),
    User(id=3, name="Giuseppe Verdi", email="giuseppe@test.com"),
]


@router.get("/users", response_model=List[User])
async def get_users() -> List[User]:
    """
    Ottiene la lista di tutti gli utenti.

    Returns:
        List[User]: Lista di utenti con id, name, email.
                    Ritorna lista vuota [] se non ci sono utenti.

    Raises:
        HTTPException: 500 se errore interno del server.

    Examples:
        GET /api/users
        Response 200:
        [
            {"id": 1, "name": "Mario Rossi", "email": "mario@test.com"},
            {"id": 2, "name": "Laura Bianchi", "email": "laura@test.com"}
        ]

        Response 200 (empty):
        []
    """
    try:
        return MOCK_USERS
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Errore interno del server: {str(e)}"
        )


@router.get("/users/{user_id}", response_model=User)
async def get_user_by_id(user_id: int) -> User:
    """
    Ottiene un singolo utente per ID.

    Args:
        user_id: ID dell'utente da cercare.

    Returns:
        User: Utente trovato con id, name, email.

    Raises:
        HTTPException: 404 se utente non trovato.
        HTTPException: 500 se errore interno.

    Examples:
        GET /api/users/1
        Response 200:
        {"id": 1, "name": "Mario Rossi", "email": "mario@test.com"}

        GET /api/users/999
        Response 404:
        {"detail": "Utente non trovato"}
    """
    try:
        for user in MOCK_USERS:
            if user.id == user_id:
                return user
        raise HTTPException(status_code=404, detail="Utente non trovato")
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Errore interno del server: {str(e)}"
        )
