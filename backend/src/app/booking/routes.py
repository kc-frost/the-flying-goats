from flask import jsonify, request, Blueprint
from flask_login import login_required

from .service import get_available_flights, book_a_flight

bp = Blueprint("booking", __name__)

@bp.route('/available-flights', methods=['GET'])
def available_flights():
    """Gets the available flights between two dates

    Returns:
        flights (list | dict(str, Any)): Valid flights for those dates or an error message from pymsql
    """
    origin = request.args.get('user_origin')
    destination = request.args.get('user_destination')

    flights = get_available_flights(origin, destination)

    if isinstance(flights, dict) and "error" in flights:
        return jsonify(flights), 500
    
    return jsonify(flights), 200


@bp.route("/book-flight", methods=["POST"])
@login_required
def book_flight():
    data = request.get_json()
    result = book_a_flight(data)
    if result and "error" in result:
        return jsonify(result), 500
    return jsonify({"message": "booking confirmed"}), 200
