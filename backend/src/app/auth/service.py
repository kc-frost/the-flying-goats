from app.db import get_connection
from .security import get_hashed_password

from typing import Any
import re
from datetime import datetime

def if_admin(email: str) -> bool:
    """Checks if a user is an admin

    An `admin` is any user with the domain `@admin.com`

    Args:
        email (str): User email

    Returns:
        bool: If user is an admin or not
    """
    PATTERN = r"^\w+\@admin\.com"
    search = re.fullmatch(PATTERN, email.strip())
    return search is not None
    
def find_user(email: str, password: str) -> dict[str, Any] | None:
    """Query the database if a user with the passed argument exists.
    Expected to be used for login/register validation.

    Args:
        email (str): A user's email
        password (str): A user's password
        conn (_type_): A connection object that can communicate to the database

    Returns:
        dict(str, Any) | None: An existing user's email and password, if it exists
    """
    conn = get_connection()
    true_password = get_hashed_password(password)
    
    with conn.cursor() as cursor:
        try:
            query = """
                SELECT `userID`, `username`, `email`, `password`
                FROM `users`
                WHERE `email`=%s AND `password`=%s
            """
            cursor.execute(query, (email, true_password))
            result = cursor.fetchone()
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {
                "error": str(e)
                }

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
    registered_date = datetime.now()

    with conn.cursor() as cursor:
        try:
            query = """
                INSERT INTO `users`(phoneNumber, fname, lname, username, email, password, registeredDate)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """ 
            cursor.execute(query, (
                data['phoneNum'],
                data['firstName'],
                data['lastName'],
                data['username'],
                data['email'],
                hashed_password,
                registered_date
            ))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {
                "error": str(e)
                }
    
    return {"success": True}

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
