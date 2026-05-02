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

def create_review(bookingID: str, userID: str, rating: str, review: str):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
             INSERT INTO `reviews`(`bookingID`, `userID`, `rating`, `review`, `creationDate`) VALUES
                (%s, %s, %s, %s, now())
            """

            cursor.execute(query, [bookingID, userID, rating, review,])
            
            conn.commit()
            return {'success': 'ok'}
        except Exception as e:
            conn.rollback()
            return {'err': str(e)}
         
def retrieve_user_dests(userID: str):
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

            if dests is None:
                return {'msg': 'user isnt going anywhere'}
            
            return dests
        except Exception as e:
            return {'err': str(e)}

def retrieve_tourist_destinations(location: str):
    """Returns the top sights of a given city

    WARNING: DO NOT REPEATEDLY CALL THIS FUNCTION WITHOUT REASON. IT MIGHT WASTE REQUESTS

    Args:
        location (str): City to be queried for

    Returns:
        dict: Top sights of the passsed city with the city as its key
    """

    client = serpapi.Client(api_key=current_app.config.get("SERPAPI_KEY"))
    results = client.search({
        "engine": "google",
        "q": f"{location} top sights"
    })

    if results["top_sights"].get("sights") is None:
        return {'msg': "no sights found"}
    
    print(results['search_metadata'])
    
    return results["top_sights"].get("sights")
        
        
def retrieve_reviews(userID: str):
    conn = get_connection()
    
    with conn.cursor() as cursor:
        try:
            query = """
                SELECT *
                FROM `reviews`
                WHERE `userID` = %s AND
                `deletionDate` IS NULL
            """

            cursor.execute(query, [userID,])
            rows = cursor.fetchall()

            return rows
        
        except Exception as e:
            return {'err': str(e)}
        
def erase_review(ratingID: int):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                UPDATE `reviews`
                SET `deletionDate` = now()
                WHERE `ratingID` = %s
            """

            cursor.execute(query, (ratingID,))
            conn.commit()

            return {'success': 'erased review'}
        except Exception as e:
            conn.rollback()
            return {'err': str(e)}
