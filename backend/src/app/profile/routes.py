from flask import jsonify, request, Blueprint
from flask_login import login_required, current_user
from app.db import get_connection

from .service import get_user_reservations

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

@bp.route('/user-reservations', methods=['GET'])
@login_required
def user_reservations():
    """Gets all flight bookings of a valid user through their userID

    Returns:
        dict: All valid reservations or an error message
    """    

    return jsonify(get_user_reservations(current_user.get_id()))
        
@bp.route('/get-bio', methods=['GET'])
@login_required
def get_bio():
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("SELECT bio FROM users WHERE userID = %s", (current_user.get_id(),))
        row = cursor.fetchone()
        if row is None:
            return jsonify({"bio": ""}), 200
        return jsonify({"bio": row['bio']}), 200

@bp.route('/save-bio', methods=['POST'])
@login_required
def save_bio():
    data = request.get_json()
    conn = get_connection()
    with conn.cursor() as cursor:
        try:
            cursor.execute("UPDATE users SET bio = %s WHERE userID = %s", (data['bio'], current_user.get_id()))
            conn.commit()
            return jsonify({"message": "Bio saved"}), 200
        except Exception as e:
            conn.rollback()
            return jsonify({"error": str(e)}), 400