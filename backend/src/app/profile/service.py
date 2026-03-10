from app.db import get_connection

def get_user_reservations(username: str):
    conn = get_connection()
    with conn.cursor() as cursor:
        query = "SELECT * FROM reservationticket WHERE `username`=%s"
        cursor.execute(query, username)
        result = cursor.fetchall()
    
    return result

    