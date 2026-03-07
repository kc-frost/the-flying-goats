from typing import Any
from .security import get_hashed_password

def find_user(email: str, password: str, conn) -> dict[str, Any] | None:
    """Query the database if a user with the passed argument exists.
    Expected to be used for login/register validation.

    Args:
        email (str): A user's email
        password (str): A user's password
        conn (_type_): A connection object that can communicate to the database

    Returns:
        dict[str, Any] | None: An existing user's email and password, if it exists
    """
    true_password = get_hashed_password(password)
    with conn.cursor() as cursor:
        query = "SELECT `email`, `password` FROM `users` WHERE `email`=%s AND `password`=%s"
        cursor.execute(query, (email, true_password))
        result = cursor.fetchone()

    return result

def insert_user(data: dict, conn) -> dict:
    """Insert a new user into the database

    Args:
        data (dict): The request in JSON format, received by the server
        conn (_type_): A connection object that can communicate to the database

    Returns:
        dict: Contains success state, and an error messsage if the insert failed
    """
    hashed_password = get_hashed_password(data['password'])

    query = "INSERT INTO `users`(phoneNumber, fname, lname, username, email, password) VALUES (%s, %s, %s, %s, %s, %s)"    
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (
                data['phoneNum'],
                data['firstName'],
                data['lastName'],
                data['username'],
                data['email'],
                hashed_password
            ))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"success": False,
                    "error": str(e)}
    
    return {"success": True}

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

""" For now we're going to ASSUME that the user exists becauseee I don't wanna prevent insertion onto reservation based on "user doesn't exist" when we only got like 2 users and such, and I don't know how users is lookin
So I'ma add that validation later (tomorrow), I'll explain more through messages"""
def get_reservations(conn):
    # user_id = data['userID']
    # userExistsQuery = "select * from `users` where userID=%s"
    # with conn.cursor() as cursor:
    #     cursor.execute(userExistsQuery, (user_id,))
    #     userExists = cursor.fetchone()

    """ 
    getting data from reservationticket view 
    """
    query = """ 
    select * from reservationticket
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            result = cursor.fetchall()
            return {"success": True, 
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}

def get_user_data(conn):
    query = "select * from userreservationsummary"
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            result = cursor.fetchall()
            return {"success": True, 
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}