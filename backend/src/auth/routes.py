from flask import jsonify, request, Blueprint
from flask_login import login_user, login_required, current_user, logout_user
from .service import find_user, insert_user
from .validators import validate_email, validate_password
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
    """Check if a session exists, implying a logged-in user

    Returns:
        Tuple(bool, int): If user is authenticated, and an HTTP status code
    """
    if current_user.is_authenticated:
        return jsonify({
            "authenticated": True
        }), 200
    else:
        return jsonify({
            "authenticated": False
        }), 401

@bp.route('/test')
@login_required
def test():
    return {
        "message": "You're logged in"
    }

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
        user: User = User(result['username'], result['email'])

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