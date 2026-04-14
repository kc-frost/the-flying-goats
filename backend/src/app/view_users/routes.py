from flask import jsonify, Blueprint, request
from .service import get_user_data, search_user_data

bp = Blueprint("view_users", __name__)


@bp.get('/users')
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
        }), 500
