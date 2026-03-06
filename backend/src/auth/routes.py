from flask import jsonify, request, Blueprint, session
from db import get_connection
from .service import delete_from_inventory, find_user, get_reservations, insert_into_inventory, insert_user, find_inventory
from .validators import validate_email, validate_password

# This is where you setup the Blueprint on the respective roues file.
# First argument is the name of the Blueprint, but I think this matters more for if you're using Flask as more than just an API (which we are not)
# Second param: __name__
bp = Blueprint("auth", __name__)

# In a Flask project that doesn't have Blueprints, we would normally put
# @app.route()
# This would also require us to import app from main
# With Blueprints, you can replace "app" with the name of the bp VARIABLE
@bp.post('/login')
def login():
    # obtain request data
    # transforms json into python dict
    data = request.json
    email = data['email']
    password = data['password']

    conn = get_connection()
    result = find_user(email, password, conn)

    if result is not None:
        # user exists
        return jsonify({
            "success": True,
            "message": "You're logged in!"
        }), 200
    else:
        # user doesn't exist
        return jsonify({
            "success": False,
            "message": "User doesn't exist/Incorrect password"
        }), 400

@bp.post('/register')
def register():
    # obtain data
    data = request.json
    email = data['email']
    password = data['password']

    conn = get_connection()

    # check for:
    # if user already exists
    user_exist = find_user(email, password, conn)
    if user_exist is not None:
        return jsonify({
            "success": False,
            "message": "User already exists. Try logging in?"
        }), 400
    
    # if user's email is formatted wrong
    # if user's password is also formatted wrong
    is_valid_email = validate_email(email=email)
    is_valid_password = validate_password(password=password)
    if not all([is_valid_email, is_valid_password]):
        return jsonify({
            "success": False,
            "message": "Invalid email/password"
        }), 400

    # assuming all checks passed
    result = insert_user(data=data, conn=conn)

    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "User registered"
        }), 201
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

@bp.get("/inventory")
def getInventory():
    conn = get_connection()
    result = find_inventory(conn)
    return jsonify(result)

"""
constaints/checks/validations for inventory is handled in my sql (hopefully)
"""
@bp.post("/inventory/add")
def addItemToInventory():
    conn = get_connection()
    data = request.json
    result = insert_into_inventory(conn, data)
    if result.get("success"):
        return jsonify({"success": True})
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

@bp.post("/inventory/delete")
def deleteItemFromInventory():
    conn = get_connection()
    data = request.json
    itemID = data['itemID']
    result = delete_from_inventory(conn, itemID)
    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Item deleted from inventory FOREVER" #Items are NOT deleted from item, only from inventory
        }), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500
    
# def update inventory(conn, data):

# Reservation logic
@bp.get("/reservations")
def viewReservations():
    query = "select * from 'booking'"
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute(query)
        result = cursor.fetchall()
    return jsonify(result)

@bp.post("/reservations/make")
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
    