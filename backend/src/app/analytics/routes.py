from flask import Blueprint, jsonify

from app.auth import admin_required

from .service import get_most_active_users, get_reservations_this_month

bp = Blueprint("analytics", __name__)

# This route gets the top 3 most active users, as defined by how many reservations they've made in total
@bp.route('/most-active-users', methods=['GET'])
@admin_required
def most_active_users():
    result = get_most_active_users()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(get_most_active_users()), 200

# This route gets how many reservations were made this month
@bp.route('/reservations-this-month', methods=['GET'])
def reservations_this_month():
    result = get_reservations_this_month()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200