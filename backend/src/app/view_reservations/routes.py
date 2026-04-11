from flask import jsonify, request, Blueprint

from app.db import get_connection
from app.auth import admin_required

from .service import get_reservations

# first param: name of parent folder
# second param: __name__
bp = Blueprint("view_reservations", __name__)

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
# Updated to match DB
def makeReservation():
    """
    We're taking booking args, meaing:
    
    bookingNumber int primary key auto_increment,
    userID int references users(userID),
    departSeat varchar(3) references planeSeat(seatNumber),
    returnSeat varchar(3) references planeSeat(seatNumber),
    departScheduleID int references schedule(scheduleID),
    returnScheduleID int references schedule(scheduleID)
    """
    data = request.json

    userID = data['userID']
    departSeat = data['departSeat']
    returnSeat = data['returnSeat']
    departScheduleID = data['departScheduleID']
    returnScheduleID = data['returnScheduleID']

    conn = get_connection()
    query = """
    insert into booking (userID, departSeat, returnSeat, departScheduleID, returnScheduleID)
    values (%s, %s, %s, %s, %s)
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (userID, departSeat, returnSeat, departScheduleID, returnScheduleID))
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
