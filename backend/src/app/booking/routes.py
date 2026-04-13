from flask import jsonify, request, Blueprint
from flask_login import login_required

from .service import cancel_reservation, get_taken_seats, get_airports, filtered_airports, get_available_flights, book_a_flight, update_reservation_seat, user_details_match

bp = Blueprint("booking", __name__)

@bp.route('/taken-seats', methods=['GET'])
def taken_seats():
    """Gets all the taken seats of a scheduled flight via their scheduleID

    Returns:
        dict: Taken seats for the matched flight or an error message
    """    
    scheduleID = request.args.get("scheduleID")

    taken_seats = get_taken_seats(scheduleID)
    if "error" in taken_seats:
        return jsonify(taken_seats), 500

    return jsonify(taken_seats), 200

@bp.route('/airports', methods=['GET'])
def airports():
    """Gets all matching airports based on search term

    Returns:
        dict: Airports and their attributes
    """    

    search_term = request.args.get('search_term')
    airports = get_airports(search_term)

    if isinstance(airports, dict) and "error" in airports:
        return jsonify(airports), 500
    
    return jsonify(airports), 200

@bp.route('/filter-airports', methods=['GET'])
def filter_airports():
    region_id = request.args.get('regionID')
    airports = filtered_airports(region_id)

    if isinstance(airports, dict) and "error" in airports:
        return jsonify(airports), 500
    
    return jsonify(airports), 200

# Changed, now accepts departure and return dates
@bp.route('/available-flights', methods=['GET'])
def available_flights():
    """Gets the available flights between two dates

    Returns:
        flights (dict(str, Any)): Valid flights for those dates or an error message from pymsql
    """
    origin = request.args.get('user_origin')
    destination = request.args.get('user_destination')
    departureDate = request.args.get('departure_date')
    # wtf you can do this?
    returnDate = request.args.get('return_date') or request.args.get('arrival_date')


    flights = get_available_flights(origin, destination, departureDate, returnDate)

    if "error" in flights:
        return jsonify(flights), 500
    
    return jsonify(flights), 200


@bp.route("/book-flight", methods=["POST"])
@login_required
def book_flight():
    """Book a flight

    Returns:
        dict: A confirmation or error message
    """    
    data = request.get_json()
    outboundFlight = data['outbound']
    inboundFlight = data['inbound']

    # this is an insane edge case that hopefully never happens ever
    if (user_details_match(outboundFlight, inboundFlight) == False):
        return jsonify({"message": "User details don't match"}), 500

    result = book_a_flight(outboundFlight, inboundFlight)
    if result and "error" in result:
        return jsonify(result), 500
    return jsonify({"message": "booking confirmed"}), 200


@bp.route("/user-update-reservation", methods=["POST"])
@login_required
def update_reservation():
    data = request.json
    bookingID = data.get("bookingID")
    departSeat = data.get("departSeat")
    returnSeat = data.get("returnSeat")

    result = update_reservation_seat(departSeat, returnSeat, bookingID)
    if isinstance(result, dict) and "error" in result:
        return jsonify({"success": False, "message": result.get("error")}), 500
    return jsonify({"success": True, "message": "Reservation successfully updated"}), 200

@bp.route("/user-cancel-reservation", methods=["POST"])
@login_required
def cancel_reservation_route():
    data = request.json
    bookingID = data.get("bookingID")

    result = cancel_reservation(bookingID)
    if isinstance(result, dict) and "error" in result:
        return jsonify({"success": False, "message": result.get("error")}), 500
    return jsonify({"success": True, "message": "Reservation successfully cancelled"}), 200
