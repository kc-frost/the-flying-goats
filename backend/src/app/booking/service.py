from app.db import get_connection
from datetime import datetime

def get_airports(search_term):
    """Get all airports based on if it matches the `search_term`

    Args:
        search_term (str): To search the airports by

    Returns:
        list: All airports that match the passed `search_term`
    """    
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT place, IATA
                FROM `airports`
                WHERE place LIKE %s OR IATA LIKE %s
            """

            # Accounts for partial matches
            cursor.execute(query, (f'%{search_term}%', f'%{search_term}%'))
            rows = cursor.fetchall()

            airports = []
            for row in rows:
                airports.append(row)
            
        except Exception as e:
            return {"error": str(e)}
        
    return airports

def get_available_flights(origin, destination):
    """Get all available flights according to their airport of origin and destination

    Args:
        origin (str): The airport where a plane is departing from
        destination (str): The airport where a plane is headed towards

    Returns:
        dict: A dict with keys 'depart' and 'return', each containing a list of matching flights. Otherwise,
        a dict with an error key if the query fails
    """    
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT *
                FROM `available_flights`
                WHERE origin LIKE %s AND destination LIKE %s
            """

            # This accounts for partial matches

            cursor.execute(query, (f'%{origin}', f'%{destination}%'))
            rows = cursor.fetchall()
            departFlights = [dict(row) for row in rows]

            cursor.execute(query, (f'%{destination}%', f'%{origin}%'))
            rows = cursor.fetchall()
            returnFlights = [dict(row) for row in rows]

        except Exception as e:
            return {"error": str(e)}
    
    return {"depart": departFlights,
            "return": returnFlights}

def book_a_flight(data: dict):
    booking_date = datetime.strptime(data['reservationDate'], "%a %b %d %Y").strftime("%Y-%m-%d")

    conn = get_connection()
    
    with conn.cursor() as cursor:
        try:
            # find user via email
            query = """
                SELECT `userID`
                FROM `users`
                WHERE `email` = %s
            """
            cursor.execute(query, (data['email'],))
            user = cursor.fetchone()
            if user is None:
                return {"error": "User not found"}
            
            # use userID to insert into booking
            query = """
                INSERT INTO `booking`(userID, flightID, seat, bookingDate)
                VALUES (%s, %s, %s, %s)
            """
            cursor.execute(query, (
                user['userID'],
                data['flightID'],
                data['seatNumber'],
                booking_date
            ))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"error": str(e)}
