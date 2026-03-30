from flask import jsonify, request, Blueprint
from flask_login import login_required, current_user
from app.db import get_connection

bp = Blueprint("profile", __name__)

@bp.route("/get-active-user")
@login_required
def get_active_user():
    """Get details of active user

    Returns:
        User: A Logged in user
    """
    username = current_user.username
    email = current_user.id
    return jsonify({
        "username": username,
        "email": email
        }), 200

@bp.route('/get-user-reservations', methods=['GET'])
@login_required
def get_user_reservations():
    """Gets all flight bookings of a valid user through their userID

    Returns:
        dict: All valid reservations or an error message
    """    

    conn = get_connection()
    with conn.cursor() as cursor:
        try:
            query = """
                SELECT `userID`
                FROM `users`
                WHERE userID = %s
            """
            cursor.execute(query, (current_user.get_id(),))
            user = cursor.fetchone()
            if user is None:
                return jsonify({"error": "User not found"}), 404

            cursor.execute("SELECT * FROM reservationticket WHERE userID = %s", (user['userID'],))
            rows = cursor.fetchall()
            return jsonify(rows), 200
        except Exception as e:
            return jsonify({"error": str(e)}), 400
        
@bp.route('/get-bio', methods=['GET'])
@login_required
def get_bio():
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("SELECT bio FROM users WHERE email = %s", (current_user.get_id(),))
        row = cursor.fetchone()
        if row is None:
            return jsonify({"bio": ""}), 200
        return jsonify({"bio": row['bio'] or ""}), 200

@bp.route('/save-bio', methods=['POST'])
@login_required
def save_bio():
    data = request.get_json()
    conn = get_connection()
    with conn.cursor() as cursor:
        try:
            cursor.execute("UPDATE users SET bio = %s WHERE email = %s", (data['bio'], current_user.get_id()))
            conn.commit()
            return jsonify({"message": "Bio saved"}), 200
        except Exception as e:
            conn.rollback()
            return jsonify({"error": str(e)}), 400