"""
What-If Properties API - Miracollo Backend
===========================================
API endpoints per What-If Simulator: properties e room types dropdown data.

Endpoints:
- GET /api/v1/properties - Lista strutture hotel
- GET /api/v1/properties/{property_id}/room-types - Tipologie camera per struttura

@version 1.0.0
@date 2026-01-12
@author Cervella Backend
"""

__version__ = "1.0.0"
__version_date__ = "2026-01-12"

from typing import List
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
import logging

from ..core import get_db

# Logger
logger = logging.getLogger("miracollo")

# Create router
router = APIRouter(prefix="/api/v1", tags=["What-If Simulator"])


# ============================================
# PYDANTIC MODELS
# ============================================

class PropertyResponse(BaseModel):
    """Risposta per lista proprietà."""
    id: int
    name: str
    code: str

    class Config:
        from_attributes = True


class RoomTypeResponse(BaseModel):
    """Risposta per tipologia camera."""
    id: int
    name: str
    code: str
    base_occupancy: int
    max_occupancy: int
    total_units: int

    class Config:
        from_attributes = True
        schema_extra = {
            "example": {
                "id": 1,
                "name": "Essentia Room",
                "code": "ESSENTIA",
                "base_occupancy": 2,
                "max_occupancy": 4,
                "total_units": 8
            }
        }


# ============================================
# ENDPOINTS
# ============================================

@router.get("/properties", response_model=List[PropertyResponse])
async def get_properties():
    """
    Lista tutte le proprietà (hotels) attive.

    Returns:
        Lista di proprietà con id, name, code

    Example Response:
        [
            {"id": 1, "name": "Nido Lodge", "code": "NL"},
            {"id": 2, "name": "Hotel Paradise", "code": "HP"}
        ]
    """
    try:
        with get_db() as conn:
            cursor = conn.execute("""
                SELECT id, name, code
                FROM hotels
                WHERE is_active = 1 AND deleted_at IS NULL
                ORDER BY name
            """)

            properties = [dict(row) for row in cursor.fetchall()]

            if not properties:
                logger.warning("Nessuna proprietà attiva trovata nel database")
                # Ritorniamo lista vuota invece di 404 per permettere al frontend di gestire
                return []

            logger.info(f"Trovate {len(properties)} proprietà attive")
            return properties

    except Exception as e:
        logger.error(f"Errore nel recupero proprietà: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Errore nel recupero delle proprietà: {str(e)}"
        )


@router.get("/properties/{property_id}/room-types", response_model=List[RoomTypeResponse])
async def get_property_room_types(property_id: int):
    """
    Lista tutte le tipologie camera per una proprietà specifica.

    Args:
        property_id: ID della proprietà

    Returns:
        Lista tipologie camera con id, name, code, occupancy

    Example Response:
        [
            {
                "id": 1,
                "name": "Essentia Room",
                "code": "ESSENTIA",
                "base_occupancy": 2,
                "max_occupancy": 4,
                "total_units": 8
            },
            {
                "id": 2,
                "name": "Silvae Suite",
                "code": "SILVAE",
                "base_occupancy": 2,
                "max_occupancy": 3,
                "total_units": 6
            }
        ]
    """
    try:
        with get_db() as conn:
            # Verifica esistenza proprietà
            cursor = conn.execute("""
                SELECT id, name, code
                FROM hotels
                WHERE id = ? AND is_active = 1 AND deleted_at IS NULL
            """, (property_id,))

            property_row = cursor.fetchone()
            if not property_row:
                raise HTTPException(
                    status_code=404,
                    detail=f"Proprietà con ID {property_id} non trovata o non attiva"
                )

            # Recupera room types
            cursor = conn.execute("""
                SELECT
                    id,
                    name,
                    code,
                    base_occupancy,
                    max_occupancy,
                    total_units
                FROM room_types
                WHERE hotel_id = ? AND is_active = 1 AND deleted_at IS NULL
                ORDER BY sort_order, name
            """, (property_id,))

            room_types = [dict(row) for row in cursor.fetchall()]

            if not room_types:
                logger.warning(f"Nessuna tipologia camera attiva per property_id={property_id}")
                # Ritorniamo lista vuota invece di 404
                return []

            logger.info(
                f"Trovate {len(room_types)} tipologie camera per "
                f"property '{property_row['name']}' (ID {property_id})"
            )
            return room_types

    except HTTPException:
        # Re-raise HTTPException
        raise
    except Exception as e:
        logger.error(f"Errore nel recupero room types per property_id={property_id}: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Errore nel recupero delle tipologie camera: {str(e)}"
        )


# ============================================
# UTILITY FUNCTIONS (per testing/debug)
# ============================================

def _validate_property_exists(conn, property_id: int) -> dict:
    """
    Valida esistenza proprietà e ritorna dati.

    Args:
        conn: Database connection
        property_id: ID proprietà

    Returns:
        Dict con dati proprietà

    Raises:
        HTTPException: Se proprietà non esiste
    """
    cursor = conn.execute("""
        SELECT id, name, code
        FROM hotels
        WHERE id = ? AND is_active = 1 AND deleted_at IS NULL
    """, (property_id,))

    row = cursor.fetchone()
    if not row:
        raise HTTPException(
            status_code=404,
            detail=f"Proprietà con ID {property_id} non trovata"
        )

    return dict(row)


# ============================================
# NOTES
# ============================================
"""
DESIGN DECISIONS:

1. **Validation Strategy**
   - Input: property_id validato come int (FastAPI automatic)
   - DB: Verifica esistenza + is_active + deleted_at
   - Output: Pydantic models garantiscono struttura corretta

2. **Error Handling**
   - 404: Risorsa non trovata
   - 500: Errori database/server
   - Empty list: Nessun dato disponibile (NON errore)

3. **Logging**
   - Info: Operazioni riuscite + conteggio risultati
   - Warning: Liste vuote (possibile problema configurazione)
   - Error: Eccezioni catturate

4. **Performance**
   - Query ottimizzate (SELECT solo campi necessari)
   - Indici esistenti su hotel_id, is_active
   - Nessuna N+1 query issue

5. **Security**
   - Nessun SQL injection risk (parametrized queries)
   - Filtra deleted_at (soft delete)
   - Espone solo dati pubblici (no secrets)

6. **Future Enhancements**
   - Cache layer (Redis) per properties (dati cambiano raramente)
   - Filtri aggiuntivi (location, amenities)
   - Paginazione (se necessario con molte proprietà)
   - Rate information (base_rate) nei room types
"""
