from flask import jsonify, request, Blueprint, session
from db import get_connection
from .service import find_user, validate_email, validate_password

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
        return jsonify("You're logged in!", 200) # user exists
    else:
        return jsonify("User doesn't exist", 404) # user doesn't exist

@bp.route('/register')
def register():
    data = request.json
    # complete the rest of what registration requires
    phoneNumber = data['phoneNum']
    fName = data['fname']
    lName = data['lname']
    username = data['username']
    email = data['email']
    password = data['password']

    conn = get_connection()
    # check for:
    # if user already exists
    user_exist = find_user(email, password, conn)
    if user_exist is not None:
        return jsonify("User already exists")
    
    # if user's email is formatted wrong
    # if user's password is also formatted wrong
    is_valid_email = validate_email(email=email)
    is_valid_password = validate_password(password=password)
    if not all([is_valid_email, is_valid_password]):
        return jsonify("Invalid email/password")

    # assuming all checks passed
    with conn.cursor() as cursor:
        query = "INSERT INTO `users` VALUES (%s, %s, %s, %s, %s, %s)"
        try:
            cursor.execute(query, (phoneNumber, fName, lName, username, email, password))
            conn.commit()
        
        # in case something happens during insertion
        except Exception as e:
            return jsonify(e)
    

    return jsonify("User registered", 200)

