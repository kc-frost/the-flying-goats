from flask import Blueprint, jsonify

from .service import get_pilot_schedule

bp = Blueprint("pilot_view", __name__)

# Should work, hopefully (praying) no reason for it not to ngl
# But I'm not testing this rn cause for some reason my mains messed up
@bp.get('/pilot-schedule')
def getPilotSchedule():
    result = get_pilot_schedule()
    if result.get("success"):
        return jsonify(result["data"]), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500
