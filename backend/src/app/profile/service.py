from flask import jsonify
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
                return jsonify({"err": "User not found"}), 404
            
        except Exception as e:
            return jsonify({"err": str(e)}), 500
    
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
            cursor.execute(query, (user_id))
            conn.commit()
            return jsonify({"message": "profile picture uploaded!"}), 200
        except Exception as e:
            conn.rollback()
            return jsonify({"err": str(e)}), 500