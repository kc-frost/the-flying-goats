"""
This specifically searches from the view inventoryNames NOT inventory, because inventory is the container
for the inventory items and is what is going to receive inventory. This finds the names and such for display.
"""

def find_inventory(conn):
    with conn.cursor() as cursor:
        cursor.execute("select * from inventorynames")
        result = cursor.fetchall()
    return result

""" 
inserting into both inventory and item, and with how I did the sql structure, into respective tables as well.
"""
def insert_into_inventory(conn, data):

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

def delete_from_inventory(conn, data):
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
def update_inventory(conn, data):
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
def isAvailable(conn, data):
    query = "select isAvailable from inventoryNames where itemID=%s"
    with conn.cursor() as cursor:
        cursor.execute(query, (data['itemID'],))
        result = cursor.fetchone()
    return result

#def update_inventory(conn, data):
