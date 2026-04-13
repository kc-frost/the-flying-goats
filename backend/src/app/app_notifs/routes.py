from flask import Blueprint, jsonify, request
from flask_login import login_required, current_user

from .service import get_upcoming_flights, get_new_assignments_amount

bp = Blueprint("app_notifs", __name__)

@bp.route('/upcoming-flights', methods=['GET'])
@login_required
def upcoming_flights():
    user_id = current_user.get_id()

    result = get_upcoming_flights(user_id)

    return jsonify(result), 200

@bp.route('/new-assignments-amount', methods=['GET'])
@login_required
def new_assignments_amount():
    since = request.args.get("since")
    until = request.args.get("until")
    staff_email = current_user.email

    if since is None:
        return jsonify({"err": "since parameter is required"}), 400
    if until is None:
        return jsonify({"err": "until parameter is required"}), 400

    result = get_new_assignments_amount(since, until, staff_email)

    if isinstance(result, dict) and 'err' in result:
        return jsonify(result), 500
    
    return jsonify({"amount": result}), 200
