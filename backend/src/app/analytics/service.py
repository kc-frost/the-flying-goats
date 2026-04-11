from app.db import get_connection

def get_most_active_users():
    """Queries the database for the top 3 most active users, defined by the total amount of reservations they've made

    Returns:
        dict: A tuple of the top 3 most active users
    """    
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
            SELECT COUNT(bookingNumber) `bookingAmount`, `userID`, `username`
            FROM `reservationticket`
            GROUP BY `userID`
            ORDER BY `bookingAmount` desc
            LIMIT 3
            """

            cursor.execute(query)
            rows = cursor.fetchall()

            if rows is None:
                return {"message": "no active users!"}

        except Exception as e:
            return {"error": str(e)}
        
        return rows
