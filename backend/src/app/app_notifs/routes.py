from flask import Blueprint, jsonify, request
from flask_login import login_required, current_user

from .service import get_upcoming_flights, get_new_assignments_amount, acknowledge_cancellation_notification, acknowledge_pilot_assignment_notification, get_cancellation_notifications, get_pilot_assignment_notifications


bp = Blueprint("app_notifs", __name__)

@bp.route('/upcoming-flights', methods=['GET'])
@login_required
def upcoming_flights():
    user_id = current_user.get_id()

    result = get_upcoming_flights(user_id)

    # If there's an error and a bad dictionary is returned, send a 500 response instead. Better for catching and displaying the errors for debugging.
    if isinstance(result, dict) and 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

@bp.route('/new-assignments-amount', methods=['GET'])
@login_required
def new_assignments_amount():
    user_id = current_user.get_id()
    result = get_new_assignments_amount(user_id)

    if isinstance(result, dict) and 'err' in result:
        return jsonify(result), 500
    
    return jsonify({"amount": result}), 200

@bp.route('/pilot-assignment-notifs', methods=['GET'])
@login_required
def pilot_assignment_notifications():
    # Return the actual pending pilot-assignment notification rows for this user.
    user_id = current_user.get_id()
    result = get_pilot_assignment_notifications(user_id)

    # Guard against accidentally returning a service error dict as if it were valid notification data, return a 500 instead 
    if isinstance(result, dict) and 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

@bp.route('/pilot-assignment-notifs', methods=['DELETE'])
@login_required
def delete_pilot_assignment_notification():
    user_id = current_user.get_id()
    flight_id = request.args.get("flightID")

    if flight_id is None:
        return jsonify({"err": "flightID parameter is required"}), 400

    result = acknowledge_pilot_assignment_notification(user_id, flight_id)

    # Missing row/notif is treated separately from other errors for better debugging and user clarity, i.e we know who to blame
    if isinstance(result, dict) and result.get('err') == "notification not found":
        return jsonify(result), 404

    # Treat misc errors as a 500 so they don't interfere with success catching
    if isinstance(result, dict) and 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

@bp.route('/cancellation-notifs', methods=['GET'])
@login_required
def cancellation_notifications():
    # Return the pending cancellation notification rows for the logged-in user.
    user_id = current_user.get_id()
    result = get_cancellation_notifications(user_id)

    # Guard against accidentally returning a service error dict as if it were valid notification data, return a 500 instead 
    if isinstance(result, dict) and 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200

@bp.route('/cancellation-notifs', methods=['DELETE'])
@login_required
def delete_cancellation_notification():
    # Keep the route path fixed and read the target booking ID from the query string.
    user_id = current_user.get_id()
    booking_id = request.args.get("bookingID")

    if booking_id is None:
        return jsonify({"err": "bookingID parameter is required"}), 400

    booking_id = int(booking_id)
    result = acknowledge_cancellation_notification(user_id, booking_id)

    # Missing row/notif is treated separately from other errors for better debugging and user clarity, i.e we know who to blame
    if isinstance(result, dict) and result.get('err') == "notification not found":
        return jsonify(result), 404

    # Treat misc errors as a 500 so they don't interfere with success catching
    if isinstance(result, dict) and 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200
