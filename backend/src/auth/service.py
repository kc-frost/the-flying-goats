from typing import Any
from unittest import result
from db import get_connection
from .security import get_hashed_password
from datetime import datetime

def check_ifadmin(email: str) -> bool:
    """THIS IS NOT THE FINAL IMPLEMENTATION. Does a simple check if
    the user is an admin

    Args:
        email (str): User email
        password (str): User password

    Returns:
        bool: If user is an admin or not
    """

    if email == "admin@gmail.com":
        return True
    else:
        return False
    
def find_user(email: str, password: str) -> dict[str, Any] | None:
    """Query the database if a user with the passed argument exists.
    Expected to be used for login/register validation.

    Args:
        email (str): A user's email
        password (str): A user's password
        conn (_type_): A connection object that can communicate to the database

    Returns:
        dict[str, Any] | None: An existing user's email and password, if it exists
    """
    conn = get_connection()

    true_password = get_hashed_password(password)
    with conn.cursor() as cursor:
        query = "SELECT `username`, `email`, `password` FROM `users` WHERE `email`=%s AND `password`=%s"
        cursor.execute(query, (email, true_password))
        result = cursor.fetchone()

    return result

def insert_user(data: dict) -> dict:
    """Insert a new user into the database

    Args:
        data (dict): The request in JSON format, received by the server
        conn (_type_): A connection object that can communicate to the database

    Returns:
        dict: Contains success state, and an error messsage if the insert failed
    """
    conn = get_connection()
    
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
    return {"success": True, "data": result}

def book_a_flight(data: dict):
    booking_date = datetime.strptime(data['reservationDate'], "%a %b %d %Y").strftime("%Y-%m-%d")

    conn = get_connection()
    
    with conn.cursor() as cursor:
        try:
            cursor.execute("SELECT userID FROM users WHERE email = %s", (data['username'],))
            user = cursor.fetchone()
            if user is None:
                return {"error": "User not found"}
            query = "INSERT INTO booking(userID, flightID, seat, bookingDate) VALUES (%s, %s, %s, %s)"
            cursor.execute(query, (
                user['userID'],
                data['flightID'],
                data['seatNumber'],
                booking_date
            ))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"error": str(e)}

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

# Update seat function. I don't have a single "update" function, because it would get messy with admin perms coming soon. Restrictions to updating seat is already in SQL db
def update_booking_seat(conn, data):
    query = """
    update booking set seat = %s where bookingID = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['seatNumber'], data['bookingID']))
            conn.commit()
            result = cursor.fetchall()
            return {"success": True,
                    "data": result}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}

# Currently no restrictions on updating booking status. Will change later, but for now just getting the method out. Most likely going to add restrictions on monday.
def update_booking_status(conn, data):
    query = """
    update booking set status = %s where bookingID = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['status'], data['bookingID']))
            conn.commit()
            return {"success": True,
                    "data": result}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}
# Gunna change I gotta ask about Kai's table cause she didn't push it
# def getairportsorsomethingjlkajsdflkjklsas():

# Collects from the view I made pilotSchedule, check db for returns
def get_pilot_schedule(conn):
    query = """select * from pilotScheduleInfo"""
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            result = cursor.fetchall()
            return {"success": True, 
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}
    return {"success": True, "data": result}

# This will create a plane and insert it into the plane table
# On the sql side, it will automatically insert into the hanger
# The hanger is a sort of "memory" table.
def create_planes(conn, data):
    query = """
    insert into plane(ICAO) values (%s)"""
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['ICAO'],))
            conn.commit()
            result = cursor.fetchall()
            return {"success": True,
                    "data": result}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}
    return {"success": True, "data": result}

# This gets the planes from the planeStatus view, not hanger.
def get_planes(conn):
    query = """
    select * from planeStatus
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
    return {"success": True, "data": result}

# This is for getting available planes. Currently don't have a use for it, but might need it later.
def get_available_planes(conn):
    query = """
    select * from plane where ICAO in (select ICAO from hanger where status = "Available")
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
    return {"success": True, "data": result}

# For updating the plane ICAO between "In Use" and "Available".
def update_plane_ICAO(conn, data):
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
def delete_plane(conn, data):
    query = """
    delete from plane where ICAO = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['ICAO'],))
            conn.commit()
            result = cursor.fetchall()
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
def clear_all_expired_schedules(conn):
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
        

# Auth stuff for pilot view, putting it here for now may move to profile if I think it fits later

def check_ifpilot(email: str) -> bool:
    conn = get_connection()
    with conn.cursor() as cursor:
        query = """
        select 1 from users join staff on staff.staffID = users.userID where users.email = %s and users.isStaff = true and staff.positionID = 2
        """
        cursor.execute(query, (email,))
        result = cursor.fetchone()
        return result is not None

def search_user_data(conn, searchKey):
    query = "select * from userreservationsummary where cast(userID as char) = %s or email = %s or username = %s"
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (searchKey, searchKey, searchKey))
            result = cursor.fetchall()
            return {"success": True, "data": result}
        except Exception as e:
            return {"success": False, "error": str(e)}