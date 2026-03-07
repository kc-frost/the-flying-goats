from flask import jsonify, request, Blueprint
from flask_login import login_user, login_required, current_user, logout_user
from db import get_connection
from .service import delete_from_inventory, find_user, get_reservations, insert_into_inventory, insert_user, find_inventory, check_ifadmin, book_a_flight
from .service import delete_from_inventory, find_user, get_reservations, get_user_data, insert_into_inventory, insert_user, find_inventory, update_inventory
from .validators import validate_email, validate_password
from .security import admin_required
from _models.user import User

# This is where you setup the Blueprint on the respective roues file.
# First argument is the name of the Blueprint, but I think this matters more for if you're using Flask as more than just an API (which we are not)
# Second param: __name__
bp = Blueprint("auth", __name__)

# In a Flask project that doesn't have Blueprints, we would normally put
# @app.route()
# This would also require us to import app from main
# With Blueprints, you can replace "app" with the name of the bp VARIABLE

@bp.get('/check-session')
def check_session():
    """A general check if a session exists, implying a logged-in user.
    Use check-authenticated for route protection

    Returns:
        Tuple(bool, int): If user is authenticated, and an HTTP status code
    """
    if current_user.is_authenticated:
        return jsonify({
            "authenticated": True,
            "isAdmin": current_user.isAdmin,
            "username": current_user.username
        }), 200
    else:
        return jsonify({
            "authenticated": False,
            "isAdmin": False,
            "username": "null"
        }), 401

@bp.route('/check-authenticated')
@login_required
def check_authenticated():
    """This checks if a user can access a route that requires
    authentication

    Returns:
        Tuple(JSON, int): A userID if successful, error if not. Then an
        HTTP status code.
    """
    if (current_user.is_authenticated):
        return jsonify({
            "userID": current_user.id
        }), 200
    else:
        return jsonify({
            "error": "you're not logged in"
        }), 401

@bp.route('/check-admin')
@admin_required
def check_admin():
    """This checks if a user can access a route that requires admin
    permissions

    Returns:
        Tuple(JSON, int): A userID if successful, error if not. Then an
        HTTP status code.
    """
    if (current_user.isAdmin):
        return jsonify({
            "userID": current_user.email
        }), 200
    else:
        return jsonify({
            "error": "you're not an admin"
        }), 403

@bp.route('/logout')
@login_required
def logout():
    logout_user()
    
    # Redirect handled by Angular
    return jsonify({
        "message": "Logged out"
    }), 200

@bp.post('/login')
def login():
    # obtain request data
    # transforms json into python dict
    data = request.json
    email = data['email']
    password = data['password']

    result = find_user(email, password)
    if result is not None:
        is_admin = check_ifadmin(result['email'])
        user: User = User(result['username'], result['email'], is_admin)

        login_user(user)
        # user exist
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

    # check for:
    # if user already exists
    user_exist = find_user(email, password)
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
    result = insert_user(data=data)

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
    conn = get_connection()
    result = get_reservations(conn)

    if result.get("success"):
        return jsonify(result["data"]), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

# move this to service properly in the next sprint
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

@bp.route('/available-flights', methods=['GET'])
def get_available_flights():
    departure_date = request.args.get('departureDate')
    arrival_date = request.args.get('arrivalDate')
    cursor = get_connection().cursor()

    cursor.execute("""
        SELECT flight FROM schedule
        WHERE DATE(liftOff) = %s AND DATE(landing) = %s
    """, (departure_date, arrival_date))

    rows = cursor.fetchall()
    flights = [{"id": row['flight'], "code": row['flight']} for row in rows]
    return jsonify(flights), 200

@bp.route("/book-flight", methods=["POST"])
@login_required
def book_flight():
    data = request.get_json()
    result = book_a_flight(data)
    if result and "error" in result:
        return jsonify(result), 500
    return jsonify({"message": "booking confirmed"}), 200
    
@bp.post("/inventory/edit")
def editInventory():
    conn = get_connection()
    data = request.json
    result = update_inventory(conn, data)
    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Inventory successfully updated"}), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
         }), 500

@bp.get('/users')
def users_data():
    conn = get_connection()
    result = get_user_data(conn)
    if result.get("success"):
        return jsonify(result["data"]), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500
