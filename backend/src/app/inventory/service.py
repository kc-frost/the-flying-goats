from app.db import get_connection

"""
This specifically searches from the view inventorynames NOT inventory, because inventory is the container
for the inventory items and is what is going to receive inventory. This finds the names and such for display.
"""

def find_inventory():
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("select * from inventorynames")
        result = [dict(row) for row in cursor.fetchall()]
    return result
""" 
inserting into both inventory and item, and with how I did the sql structure, into respective tables as well.
"""
def insert_into_inventory(data):
    conn = get_connection()

    itemInsertQuery = """
    insert into item(itemID, itemName, itemDescription, type) values (%s, %s, %s, %s)
    on duplicate key update itemID = itemID;
    """
    inventoryQuery = """
    insert into inventory(itemID, quantity) values (%s, %s)
    on duplicate key update quantity = quantity + values(quantity);
    """

    try:
        with conn.cursor() as cursor:
            cursor.execute(itemInsertQuery, (
                data.get("itemID"),
                data['itemName'],
                data['itemDescription'],
                data['type']
            ))

            cursor.execute(inventoryQuery, (
                data.get("itemID") or cursor.lastrowid, # If itemID isn't given, we use the auto incremented id instead from item
                data['quantity']
            ))
            conn.commit()
            return {"success": True}
    except Exception as e:
        conn.rollback()
        return {"success": False, "error": str(e)}


def delete_from_inventory(data):
    conn = get_connection()
    deleteQuery = "delete from `inventory` where itemID=%s"
    try:
        with conn.cursor() as cursor:
            cursor.execute(deleteQuery, (data['itemID'],))
            if cursor.rowcount == 0:
                conn.rollback()
                return {"success": False, "error": "Inventory item not found.", "status": 404}
            conn.commit()
            return {"success": True}
    except Exception as e:
        conn.rollback()
        return {"success": False,
                "error": str(e)}

"""
Updates both item itself, and inventory quantity.
"""
def update_inventory(data):
    conn = get_connection()
    inventoryQuery = "Update inventory set quantity = %s where itemID=%s"
    itemQuery = "Update item set type = %s where itemID = %s"
    existsQuery = "select 1 from inventory where itemID = %s"
    try:
        with conn.cursor() as cursor:
            cursor.execute(existsQuery, (data['itemID'],))
            if cursor.fetchone() is None:
                return {"success": False,
                        "error": "Inventory item not found.",
                        "status": 404}
            cursor.execute(inventoryQuery, 
                           (data['quantity'], 
                            data['itemID']))
            cursor.execute(itemQuery, 
                           (data['type'],
                            data['itemID']))
            conn.commit()
            return{"success": True}
    except Exception as e:
        conn.rollback()
        return {"success": False,
                "error": str(e)}


"""
Instead of isAvailable being a table attribute before, I decided to make it query function so
that it could be applied universally and changed in real time without need for updating db.
"""
def isAvailable(data):
    conn = get_connection()
    query = "select isAvailable from inventorynames where itemID=%s"
    with conn.cursor() as cursor:
        cursor.execute(query, (data['itemID'],))
        result = cursor.fetchone()
    return result

#def update_inventory(conn, data):


# This will create a plane and insert it into the plane table
# On the sql side, it will automatically insert into the hanger
# The hanger is a sort of "memory" table.
def create_planes(data):
    conn = get_connection()
    query = """
    insert into plane(ICAO) values (%s)"""
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, (data['ICAO'],))
            conn.commit()
            return {"success": True,
                    "data": {"ICAO": data['ICAO']}}
    except Exception as e:
        conn.rollback()
        return {"success": False,
                "error": str(e)}

# This gets the planes from the planestatus view, not hanger.
def get_planes():
    conn = get_connection()
    query = """
    select * from planestatus
    """
    try:
        with conn.cursor() as cursor:
            cursor.execute(query)
            result = [dict(row) for row in cursor.fetchall()]
            return {"success": True,
                    "data": result}
    except Exception as e:
        return {"success": False,
                "error": str(e)}

# Changed inherently cause of DB changes. Still not used, but might as well be consistent.
def get_available_planes():
    conn = get_connection()
    query = """
    select * from plane where ICAO in (select ICAO from hanger where planeStatus = "Available")
    """
    try:
        with conn.cursor() as cursor:
            cursor.execute(query)
            result = [dict(row) for row in cursor.fetchall()]
            return {"success": True,
                    "data": result}
    except Exception as e:
        return {"success": False,
                "error": str(e)}

# For updating the plane ICAO between "In Use" and "Available".
def update_plane_ICAO(data):
    conn = get_connection()
    query = """
    update plane set ICAO = %s where ICAO = %s
    """
    existsQuery = "select 1 from plane where ICAO = %s"
    try:
        with conn.cursor() as cursor:
            if data['ICAO'] == data['old_ICAO']:
                cursor.execute(existsQuery, (data['old_ICAO'],))
                if cursor.fetchone() is not None:
                    return {"success": True}

            cursor.execute(query, (data['ICAO'], data['old_ICAO']))
            if cursor.rowcount == 0:
                conn.rollback()
                return {"success": False, "error": "Plane not found.", "status": 404}
            conn.commit()
            return {"success": True}
    except Exception as e:
        conn.rollback()
        return {"success": False,
                "error": str(e)}

# This will delete the plane from the plane table, but not the hanger. 
def delete_plane(data):
    conn = get_connection()
    query = """
    delete from plane where ICAO = %s
    """
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, (data['ICAO'],))
            if cursor.rowcount == 0:
                conn.rollback()
                return {"success": False, "error": "Plane not found.", "status": 404}
            conn.commit()
            return {"success": True}
    except Exception as e:
        conn.rollback()
        return {"success": False,
                "error": str(e)}

# This loops through all flights, and calls the function I created in MySQL
# The function clears all pilots and planes from flights that are considered "completed"
# "Completed" means the landing datetime is before the current moment of calling the function.
def clear_all_expired_schedules():
    conn = get_connection()
    funcCallQuery = """
    call clearpilotandflightavailability()
    """
    try:
        with conn.cursor() as cursor:
            cursor.execute("select IATA from flight")
            flights = cursor.fetchall()
            for f in flights:
                cursor.execute(funcCallQuery)
            conn.commit()
            return {"success": True}
    except Exception as e:
        conn.rollback()
        return {"success": False, "error": str(e)}
        
