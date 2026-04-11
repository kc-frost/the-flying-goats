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

def get_reservations_this_month():
    """Get all reservations that were made within the current month, NOT the last 30 days

    Returns:
        dict: Number of reservations made this month 
    """    """"""
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT COUNT(*) as `monthly_reservations`
                FROM `reservationticket`
                WHERE MONTH(`reservationDate`) = MONTH(CURDATE())
                AND YEAR(`reservationDate`) = YEAR(CURDATE())
            """

            cursor.execute(query,)
            row = cursor.fetchone()

            if row is None:
                return {"message": "no reservations made this month"}

        except Exception as e:
            return {"err": str(e)}
        
        return row