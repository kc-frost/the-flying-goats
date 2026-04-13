from flask import jsonify, Blueprint, request
from flask_login import login_required

from .service import get_cancelleable_reservations, do_override_reservation

bp = Blueprint("r_override", __name__)

@bp.route('/cancelleable-reservations', methods=['GET'])
@login_required
def cancelleable_reservations():
    result = get_cancelleable_reservations()
    
    if 'err' in result:
        return jsonify(result), 500
    
    return jsonify(result), 200

@bp.route('/override-reservation', methods=['POST'])
@login_required
def override_reservation():
    data = request.json

    bookingNumber = data['bookingNumber']
    reason = data['reason']

    result = do_override_reservation(bookingNumber, reason)

    if isinstance(result, dict) and 'err' in result:
        return jsonify(result), 500

    return jsonify({'message': 'booking cancelled!'}), 200