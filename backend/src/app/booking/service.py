from app.db import get_connection
from datetime import datetime

def get_available_flights(origin, departure):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT *
                FROM `available_flights`
                WHERE origin = %s AND destination = %s
            """
            cursor.execute(query, (origin, departure))
            rows = cursor.fetchall()

            flights = []
            for row in rows:
                flights.append(row)

        except Exception as e:
            return {"error": str(e)}
    
    return flights


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
