from flask import jsonify, Blueprint, request
from flask_login import current_user
from app.auth import admin_required
from .service import get_user_data, search_user_data, delete_user

bp = Blueprint("view_users", __name__)


@bp.get('/users')
@admin_required
def users_data():
    result = get_user_data()
    if result.get("success"):
        return jsonify(result["data"]), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

@bp.get('/search-users')
@admin_required
def search_users():
    searchKey = request.args.get('search')
    result = search_user_data(searchKey)
    print(result)

    if searchKey is None:
        return jsonify({
            "success": False,
            "message": "Need to type something buddy"
        }), 400
    
    # result = search_user_data(searchKey)
    if result.get("success"):
        return jsonify(result["data"]), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), result.get("status", 500)

@bp.post('/users/delete')
@admin_required
def delete_users():
    data = request.json or {}
    result = delete_user(data.get("userID"), current_user.get_id())

    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "User successfully deleted"
        }), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), result.get("status", 500)
