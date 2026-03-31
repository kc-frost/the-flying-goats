from flask import jsonify
from unittest import result
from app.db import get_connection
from datetime import timedelta

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
            cursor.execute(query, (user['userID']))
            result = cursor.fetchall()
            
            for row in result:
                for key in row:
                    if isinstance(row[key], timedelta):
                        row[key] = str(row[key])

        except Exception as e:
            return jsonify({"err": str(e)}), 500

    return result

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

# Update seat function. I don't have a single "update" function, because it would get messy with admin perms coming soon. Restrictions to updating seat is already in SQL db
def update_booking_seat(data):
    conn = get_connection()
    query = """
    update booking set seat = %s where bookingID = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['seatNumber'], data['bookingID']))
            conn.commit()
            result = cursor.fetchall()
            return {"success": True,
                    "data": result}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}

# Currently no restrictions on updating booking status. Will change later, but for now just getting the method out. Most likely going to add restrictions on monday.
def update_booking_status(data):
    conn = get_connection()
    query = """
    update booking set status = %s where bookingID = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['status'], data['bookingID']))
            conn.commit()
            return {"success": True,
                    "data": result}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}
