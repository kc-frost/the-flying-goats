from flask import jsonify, request, Blueprint

from app.auth import admin_required

from .service import find_inventory, insert_into_inventory, delete_from_inventory, update_inventory, create_planes, get_planes, get_available_planes, update_plane_ICAO, delete_plane, clear_all_expired_schedules

# first param: name of parent folder
# second param: __name__
bp = Blueprint("inventory", __name__)


@bp.get("/inventory")
@admin_required
def getInventory():
    result = find_inventory()
    return jsonify(result)

"""
constaints/checks/validations for inventory is handled in my sql (hopefully)
"""
@bp.post("/inventory/add")
@admin_required
def addItemToInventory():
    data = request.json
    result = insert_into_inventory(data)
    if result.get("success"):
        return jsonify({"success": True})
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

@bp.post("/inventory/delete")
@admin_required
def deleteItemFromInventory():
    data = request.json
    # Fixed this, no idea why data wasn't in the argument anymore
    result = delete_from_inventory(data)
    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Item deleted from inventory FOREVER" #Items are NOT deleted from item, only from inventory
        }), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

@bp.post("/inventory/edit")
@admin_required
def editInventory():
    data = request.json
    result = update_inventory(data)
    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Inventory successfully updated"}), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
         }), 500


@bp.post('/planes/add')
@admin_required
def create_plane():
    data = request.json
    result = create_planes(data)

    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Plane successfully created",
            "data": result.get("data")
        }), 201
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

@bp.get('/planes')
@admin_required
def planes():
    result = get_planes()

    if result.get("success"):
        return jsonify(result["data"]), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

# Again, these are seperate. Probably going to display this for something else later,
# but for now atleast, in inventory, planes will be called, not available planes.
@bp.get('/planes/available')
@admin_required
def available_planes():
    result = get_available_planes()

    if result.get("success"):
        return jsonify(result["data"]), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

@bp.post('/planes/update-ICAO')
@admin_required
def updatePlaneStatus():
    data = request.json
    result = update_plane_ICAO(data)

    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Plane ICAO successfully updated"
        }), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

@bp.post('/planes/delete')
@admin_required
def deletePlane():
    data = request.json
    result = delete_plane(data)

    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Plane successfully deleted"
        }), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500

# Read how this works in service.py
@bp.post('/planes/clear-finished')
@admin_required
def clear_finished_flights():
    result = clear_all_expired_schedules()

    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Cleared all finished flight availabilities."
        }), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
        }), 500
