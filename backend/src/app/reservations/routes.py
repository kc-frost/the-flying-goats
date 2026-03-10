from flask import jsonify, request, Blueprint

from app.db import get_connection
from app.auth import admin_required

from .service import get_reservations

# first param: name of parent folder
# second param: __name__
bp = Blueprint("reservations", __name__)

# Reservation logic
@bp.get("/reservations")
@admin_required
def viewReservations():
    conn = get_connection()
    result = get_reservations(conn)

    if result.get("success"):
        return jsonify(result["data"]), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500


# kai comment:
# i'm not sure if this is used anywhere else, 
# but it kinda functionally seems similar to 
# book-a-flight
# i dont wanna fuck this up accidentally tho so here it is tada 

# move this to service properly in the next sprint (kai comment: its here :smiling_imp:)
@bp.post("/reservations/make")
@admin_required
def makeReservation():

    """
    We're taking booking args, meaing:
    
    bookingNumber int primary key auto_increment,
    userID int references users(userID),
    flightID varchar(7) references flight(IATA),
    seat int references planeSeat(seatNumber)

    """
    data = request.json

    # BookingID is auto increment, unlike inventory it's not needed here
    userID = data['userID']
    flightID = data['flightID']
    seat = data['seat']

    conn = get_connection()
    # Right now this assumes user exists in users, flight exists, and seat exists. Wednesday, gunna add more validation and checks, but for now just wanna get it working
    query = "insert into booking (userID, flightID, seat) values (%s, %s, %s)"
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (userID, flightID, seat))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return jsonify({
                "success": False,
                "message": str(e)
            }), 500
    return jsonify({
        "success": True,
        "message": "Reservation successfully made"
    }), 201
