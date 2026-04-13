from flask import jsonify, Blueprint
from flask_login import login_required

from .service import get_cancelleable_reservations

bp = Blueprint("r_override", __name__)

@bp.route('/cancelleable-reservations')
@login_required
def cancelleable_reservations():
    result = get_cancelleable_reservations()
    
    if 'err' in result:
        return jsonify(result), 500
    
    return jsonify(result), 200