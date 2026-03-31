from flask import Blueprint, jsonify
from flask_login import login_required, current_user

from .service import get_upcoming_flights

bp = Blueprint("app_notifs", __name__)

@bp.route('/upcoming-flights', methods=['GET'])
@login_required
def upcoming_flights():
    user_id = current_user.get_id()

    result = get_upcoming_flights(user_id)

    return jsonify(result), 200