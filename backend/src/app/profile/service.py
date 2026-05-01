from flask import jsonify, current_app
from unittest import result
from app.db import get_connection
from datetime import timedelta
import serpapi

def get_user_reservations(userID: str):
    conn = get_connection()
    with conn.cursor() as cursor:
        try:
            query = """
                SELECT `userID`
                FROM `users`
                WHERE userID = %s
            """
            cursor.execute(query, (userID,))
            user = cursor.fetchone()
            if user is None:
                return jsonify({"err": "User not found"}), 404
            
            query = """
                SELECT *
                FROM `reservationticket`
                WHERE `userID` = %s
            """
            cursor.execute(query, (user['userID'],))
            result = cursor.fetchall()

            for row in result:
                for key in row:
                    if isinstance(row[key], timedelta):
                        row[key] = str(row[key])

            # dedup by bookingNumber
            seen = set()
            unique_result = []
            for row in result:
                if row['bookingNumber'] not in seen:
                    seen.add(row['bookingNumber'])
                    unique_result.append(row)

        except Exception as e:
            return jsonify({"err": str(e)}), 500

    return unique_result

def get_profile_picture(user_id: str):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT `profilePicture`
                FROM `users`
                WHERE `userID` = %s
            """

            cursor.execute(query, (user_id,))
            profile_picture = cursor.fetchone()
            if profile_picture is None:
                return {"err": "User not found"}
            
        except Exception as e:
            return {"err": str(e)}
    
    return profile_picture

def save_profile_picture(url: str, user_id: str):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                UPDATE `users`
                SET `profilePicture` = %s
                WHERE `userID` = %s
            """
            cursor.execute(query, (url, user_id))
            conn.commit()
            return {"message": "profile picture uploaded"}
        except Exception as e:
            conn.rollback()
            return {"err": str(e)}

# booking now has depart and return seat attributes, so had to change this
def update_booking_seat(data):
    conn = get_connection()
    query = """
    update booking
    set departSeat = coalesce(%s, departSeat),
        returnSeat = coalesce(%s, returnSeat)
    where bookingNumber = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (
                data.get('departSeat'),
                data.get('returnSeat'),
                data['bookingID']
            ))
            conn.commit()
            return {"success": True}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}

# Booking doesn't have status anymore, that's in bookinghistory
def update_booking_status(data):
    conn = get_connection()
    query = """
    update bookinghistory set bookingStatus = %s where bookingNumber = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['status'], data['bookingID']))
            conn.commit()
            return {"success": True}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}
        
# Look into adding leftover service files over the weekend

def retrieve_tourist_destinations(userID: str):
    """Retrieves all cities that the user corresponding to `userID` is going to, then calls Serpapi API to get all the top sights at those cities. Returns a dict of those destinations with its city in the format of "{City}, {State/Country}" as its key.

    WARNING: DO NOT REPEATEDLY CALL THIS FUNCTION WITHOUT REASON. IT MIGHT WASTE REQUESTS

    Args:
        userID (str): ID of user in the database

    Returns:
        dict: Dictionary of different tourist sites
    """    

    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT DISTINCT a.place as userDestinations
                FROM booking  b
                JOIN schedule sd ON b.departScheduleID = sd.scheduleID
                JOIN flight f ON sd.flightID = f.IATA
                JOIN airports a ON f.destination = a.airportID
                WHERE userID = %s;
            """
            cursor.execute(query, (userID,))
            dests = cursor.fetchall()

            client = serpapi.Client(api_key=current_app.config.get("SERPAPI_KEY"))
            sights = {}

            for arr in dests:
                dest = arr.get("userDestinations")
                if dest:
                    results = client.search({
                        "engine": "google",
                        "q": f"{dest} top sights"
                    })

                    sights[dest] = results['top_sights']

            return sights
        
        except Exception as e:
            return {'err': str(e)}
        