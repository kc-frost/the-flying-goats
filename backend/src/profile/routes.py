from flask import jsonify, request, Blueprint
from flask_login import login_required, current_user
from .service import get_user_reservations
from db import get_connection

bp = Blueprint("profile", __name__)

@bp.route("/get-active-user")
@login_required
def get_active_user():
    username = current_user.username
    email = current_user.id
    return jsonify({
        "username": username,
        "email": email
        }), 200

@bp.route('/get-user-reservations', methods=['GET'])
@login_required
def get_user_reservations():
    conn = get_connection()
    with conn.cursor() as cursor:
        try:
            cursor.execute("SELECT userID FROM users WHERE email = %s", (current_user.get_id(),))
            user = cursor.fetchone()
            print("USER:", user)
            if user is None:
                return jsonify({"error": "User not found"}), 404

            cursor.execute("SELECT * FROM reservationticket WHERE userID = %s", (user['userID'],))
            rows = cursor.fetchall()
            print("ROWS:", rows)
            cursor.execute("SELECT * FROM reservationticket WHERE userID = 9")
            rows = cursor.fetchall()
            print(rows)
            return jsonify(rows), 200
        except Exception as e:
            return jsonify({"error": str(e)}), 400