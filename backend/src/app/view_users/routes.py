from flask import jsonify, Blueprint
from .service import get_user_data

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
