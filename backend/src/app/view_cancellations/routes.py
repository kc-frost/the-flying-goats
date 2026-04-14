from flask import jsonify, Blueprint

from app.auth import admin_required
from .service import get_all_connections

bp = Blueprint("view_cancellations", __name__)

@bp.route('/all-cancellations', methods=['GET'])
@admin_required
def all_cancellations():
    result = get_all_connections()

    if 'err' in result:
        return jsonify(result), 500

    return jsonify(result), 200