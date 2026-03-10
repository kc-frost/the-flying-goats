from flask import jsonify, request, Blueprint

from app.db import get_connection
from app.auth import admin_required

from .service import find_inventory, insert_into_inventory, delete_from_inventory, update_inventory

# first param: name of parent folder
# second param: __name__
bp = Blueprint("inventory", __name__)


@bp.get("/inventory")
@admin_required
def getInventory():
    conn = get_connection()
    result = find_inventory(conn)
    return jsonify(result)

"""
constaints/checks/validations for inventory is handled in my sql (hopefully)
"""
@bp.post("/inventory/add")
@admin_required
def addItemToInventory():
    conn = get_connection()
    data = request.json
    result = insert_into_inventory(conn, data)
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
    conn = get_connection()
    data = request.json
    itemID = data['itemID']
    result = delete_from_inventory(conn, itemID)
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
    
# def update inventory(conn, data):

@bp.post("/inventory/edit")
@admin_required
def editInventory():
    conn = get_connection()
    data = request.json
    result = update_inventory(conn, data)
    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Inventory successfully updated"}), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
         }), 500