from flask import jsonify, request, Blueprint
from flask_login import login_user, login_required, current_user, logout_user

from app.models import User

from .service import find_user, if_admin, insert_user, check_ifpilot, check_role
from .validators import validate_email, validate_password

# first param: name of parent folder
# second param: __name__
bp = Blueprint("auth", __name__)

# In a Flask project that doesn't have Blueprints, we would normally put
# @app.route()
# This would also require us to import app from main
# With Blueprints, you can replace "app" with the name of the bp VARIABLE

@bp.route('/check-session', methods=['GET'])
def check_session():
    """A general check if a session exists, implying a logged-in user.
    Use check-authenticated for route protection

    Returns:
        Tuple(bool, int): If user is authenticated, and an HTTP status code
    """
    if current_user.is_authenticated:
        return jsonify({
            "authenticated": True,
            "is_admin": current_user.is_admin,
            "is_staff": current_user.is_staff,
            "username": current_user.username,
            "email": current_user.email,
            "role": current_user.role
        }), 200
    else:
        return jsonify({
            "authenticated": False,
        }), 401

@bp.route('/logout', methods=['GET'])
@login_required
def logout():
    logout_user()
    
    # Redirect handled by Angular
    return jsonify({
        "message": "Logged out"
    }), 200

@bp.route('/login', methods=['POST'])
def login():
    # obtain request data
    # transforms json into python dict
    data = request.json
    email = data['email']
    password = data['password']

    result = find_user(email, password)
    if result is not None:
        # check if theyre an admin
        is_admin = if_admin(result['email'])

        # only check for role if they're staff
        role_value = "none"
        if result['isStaff']:
            role = check_role(result['email'])
            role_value = str(role.get('role')) if 'err' not in role else "none"

        user = User(
            str(result['userID']), 
            result['username'], 
            result['email'], 
            is_admin,
            result['isStaff'],
            role_value)

        login_user(user)

        # user exist
        return jsonify({
            "authenticated": True,
            "is_admin": current_user.is_admin,
            "is_staff": current_user.is_staff,
            "username": current_user.username,
            "role": role_value
            }), 200
    else:
        # user doesn't exist
        return jsonify({
            "authenticated": False,
            "message": "User doesn't exist/Incorrect password"
        }), 400

@bp.route('/register', methods=['POST'])
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

@bp.route('/check-pilot')
@login_required
def check_pilot():
    if check_ifpilot(current_user.get_id()):
        return jsonify({
            "isPilot": True
        }), 200
    else:
        return jsonify({
            "isPilot": False
        }), 403
    