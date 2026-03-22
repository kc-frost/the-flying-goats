from typing import Any
from db import get_connection
from .security import get_hashed_password
from datetime import datetime

def filter_user_flights(data: dict) -> list[dict[str, Any]]:
    """
    Template for filter_flights
    """
    conn = get_connection()
    
    with conn.cursor() as cursor:
        query = "SELECT * FROM `flights` WHERE `origin`=%s AND `destination`=%s AND `departureDate`=%s"
        cursor.execute(query, (data['origin'], data['destination'], data['departureDate']))
        result = cursor.fetchall()

    return result