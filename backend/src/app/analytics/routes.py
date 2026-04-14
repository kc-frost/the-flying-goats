from flask import Blueprint, jsonify

from app.auth import admin_required

from .service import get_most_active_users, get_reservations_this_month, get_per_month_reservations, get_longest_registered_users, get_active_users_this_month, get_top_staff_this_month, get_total_cancellations, get_total_cancellations_this_month, get_cancellations_this_month_by_category, get_total_reservations_this_year
bp = Blueprint("analytics", __name__)

# This route gets the top 3 most active users, as defined by how many reservations they've made in total
@bp.route('/most-active-users', methods=['GET'])
@admin_required
def most_active_users():
    result = get_most_active_users()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

@bp.route('/longest-registered-users', methods=['GET'])
@admin_required
def longest_registered_users():
    result = get_longest_registered_users()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200 

@bp.route('/active-users-this-month', methods=['GET'])
@admin_required
def active_users_this_month():
    result = get_active_users_this_month()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200


# This route gets how many reservations were made this month
@bp.route('/reservations-this-month', methods=['GET'])
@admin_required
def reservations_this_month():
    result = get_reservations_this_month()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

# This route gets per-month reservation count for the current year
@bp.route('/per-month-reservations', methods=['GET'])
@admin_required
def per_month_reservations():
    result = get_per_month_reservations()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

# Queries are self-explanatory (and all the same basically)
@bp.route('/top-staff-this-month', methods=['GET'])
@admin_required
def top_staff_this_month():
    result = get_top_staff_this_month()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

@bp.route('/total-cancellations', methods=['GET'])
@admin_required
def total_cancellations():
    result = get_total_cancellations()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

@bp.route('/total-cancellations-this-month', methods=['GET'])
@admin_required
def total_cancellations_this_month():
    result = get_total_cancellations_this_month()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

@bp.route('/cancellations-this-month-by-category', methods=['GET'])
@admin_required
def cancellations_this_month_by_category():
    result = get_cancellations_this_month_by_category()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

@bp.route('/total-reservations-this-year', methods=['GET'])
@admin_required
def total_reservations_this_year():
    result = get_total_reservations_this_year()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200
