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
        cursor.execute("select * from `inventoryNames`")
        result = cursor.fetchall()
    return result

""" 
now THIS is what we use for inserting into inventory. I know I'm doing view inventory and inventory logic, but
just INCASE you touch inventory, look at this for insertions.
"""
def insert_into_inventory(conn, data):

    inventoryQuery = """
    insert into inventory (itemID, quantity) values
    (%s, %s)
    on duplicate key update quantity = quantity + values(quantity)
    """
    itemQuery = """
    insert ignore into item(itemID, equipmentID, transportationID, equipmentName, type) values
    (%s, %s, %s, %s, %s)
    """

    with conn.cursor() as cursor:
        try:
            cursor.execute(inventoryQuery, (
                data['itemID'],
                data['quantity']
            ))
            cursor.execute(itemQuery, (
                data['itemID'],
                data.get('equipmentID'),
                data.get('transportationID'),
                data['equipmentName'],
                data['type']
            ))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"success": False, "error": str(e)}

    return {"success": True}

def delete_from_inventory(conn, itemID):
    deleteQuery = "delete from `inventory` where itemID=%s"
    with conn.cursor() as cursor:
        try:
            cursor.execute(deleteQuery, (itemID,))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"success": False,
                    "error": str(e)}
    
    return {"success": True}
"""
Instead of isAvailable being a table attribute before, I decided to make it query function so
that it could be applied universally and changed in real time without need for updating db.
"""
def isAvailable(conn, itemID):
    query = "select isAvailable from `inventory` where itemID=%s"
    with conn.cursor() as cursor:
        cursor.execute(query, (itemID,))
        result = cursor.fetchone()
    return result

#def update_inventory(conn, data):

""" For now we're going to ASSUME that the user exists becauseee I don't wanna prevent insertion onto reservation based on "user doesn't exist" when we only got like 2 users and such, and I don't know how users is lookin
So I'ma add that validation later (tomorrow), I'll explain more through messages"""
def get_reservations(conn, data):
    # user_id = data['userID']
    # userExistsQuery = "select * from `users` where userID=%s"
    # with conn.cursor() as cursor:
    #     cursor.execute(userExistsQuery, (user_id,))
    #     userExists = cursor.fetchone()
    
    """
    This checks whether userID is even being passed in data/through the json. This is NOT checking whether it exists in users. I commented some code up there, but will keep in commented until we get this working and connected first,
    cause honestly I have no idea if it works, I threw it together in like 5 minutes with other functions as reference. I'm too goated.
    """
    query = "select * from `booking` where userID=%s"
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['userID'],))
            result = cursor.fetchall()
        except Exception as e:
            return {"success": False,
                    "error": str(e)}
    return {"success": True, "data": result}