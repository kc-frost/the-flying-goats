from flask import jsonify, request, Blueprint
from flask_login import login_required, current_user
from auth.service import get_reservations
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


@bp.route("/load-reservations")
@login_required
def get_user_reservations():
    db = get_connection()
    # get_reservations()
    return jsonify(), 200