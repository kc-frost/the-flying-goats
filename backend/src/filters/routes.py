from flask import jsonify, request, Blueprint
from flask_login import login_user, login_required, current_user, logout_user
from db import get_connection
from .service import delete_from_inventory, find_user, get_reservations, get_user_data, insert_into_inventory, insert_user, find_inventory, update_inventory, check_ifadmin, book_a_flight
from .validators import validate_email, validate_password
from .security import admin_required
from _models.user import User

# Second param: __name__
bp = Blueprint("auth", __name__)
