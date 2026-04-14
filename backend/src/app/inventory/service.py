from app.db import get_connection
from unittest import result

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
    insert into item(itemID, itemName, itemDescription, type) values (%s, %s, %s, %s);
    """
    inventoryQuery = """
    insert into inventory(itemID, quantity) values (%s, %s)
    on duplicate key update quantity = quantity + values(quantity);
    """

    with conn.cursor() as cursor:
        try:
            cursor.execute(itemInsertQuery, (
                data.get("itemID"), # Incase itemID isn't given, auto increment kicks in, so it's an optional field
                data['itemName'],
                data['itemDescription'],
                data['type']
            ))

            cursor.execute(inventoryQuery, (
                data.get("itemID") or cursor.lastrowid, # If itemID isn't given, we use the auto incremented id instead from item
                data['quantity']
            ))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"success": False, "error": str(e)}

    return {"success": True}

def delete_from_inventory(data):
    conn = get_connection()
    deleteQuery = "delete from `inventory` where itemID=%s"
    with conn.cursor() as cursor:
        try:
            cursor.execute(deleteQuery, (data['itemID'],))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"success": False,
                    "error": str(e)}
    return {"success": True}

"""
Updates both item itself, and inventory quantity.
"""
def update_inventory(data):
    conn = get_connection()
    inventoryQuery = "Update inventory set quantity = %s where itemID=%s"
    itemQuery = "Update item set type = %s where itemID = %s"
    with conn.cursor() as cursor:
        try:
            cursor.execute(inventoryQuery, 
                           (data['quantity'], 
                            data['itemID']))
            cursor.execute(itemQuery, 
                           (data['type'], 
                            data['itemID']))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"success": False,
                    "error": str(e)}
        return{"success": True}


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
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['ICAO'],))
            conn.commit()
            result = [dict(row) for row in cursor.fetchall()]
            return {"success": True,
                    "data": result}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}
    return {"success": True, "data": result}

# This gets the planes from the planestatus view, not hanger.
def get_planes():
    conn = get_connection()
    query = """
    select * from planestatus
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            result = [dict(row) for row in cursor.fetchall()]
            return {"success": True,
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}
    return {"success": True, "data": result}

# Changed inherently cause of DB changes. Still not used, but might as well be consistent.
def get_available_planes():
    conn = get_connection()
    query = """
    select * from plane where ICAO in (select ICAO from hanger where planeStatus = "Available")
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            result = [dict(row) for row in cursor.fetchall()]
            return {"success": True,
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}
    return {"success": True, "data": result}

# For updating the plane ICAO between "In Use" and "Available".
def update_plane_ICAO(data):
    conn = get_connection()
    query = """
    update plane set ICAO = %s where ICAO = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['ICAO'], data['old_ICAO']))
            conn.commit()
            return {"success": True,
                    "data": result}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}
    return {"success": True, "data": result}

# This will delete the plane from the plane table, but not the hanger. 
def delete_plane(data):
    conn = get_connection()
    query = """
    delete from plane where ICAO = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['ICAO'],))
            conn.commit()
            result = [dict(row) for row in cursor.fetchall()]
            return {"success": True,
                    "data": result}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}
    return {"success": True, "data": result}

# This loops through all flights, and calls the function I created in MySQL
# The function clears all pilots and planes from flights that are considered "completed"
# "Completed" means the landing datetime is before the current moment of calling the function.
def clear_all_expired_schedules():
    conn = get_connection()
    funcCallQuery = """
    call clearpilotandflightavailability()
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute("select IATA from flight")
            flights = cursor.fetchall()
            for f in flights:
                cursor.execute(funcCallQuery)
            conn.commit()
            return {"success": True}
        except Exception as e:
            conn.rollback()
            return {"success": False, "error": str(e)}
        
