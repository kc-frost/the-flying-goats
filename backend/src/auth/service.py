from typing import Any
from .security import get_hashed_password

def find_user(email: str, conn) -> dict[str, Any] | None:
    """Query the database if a user with the passed argument exists.
    Expected to be used for login/register validation.

    Args:
        email (str): A user's email
        conn (_type_): A connection object that can communicate to the database

    Returns:
        dict[str, Any] | None: An existing user's email, if it exists
    """

    with conn.cursor() as cursor:
        query = "SELECT `email` FROM `users` WHERE `email`=%s"
        cursor.execute(query, (email))
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

    query = "INSERT INTO `users` VALUES (%s, %s, %s, %s, %s, %s)"    
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (
                data['phoneNum'],
                data['fname'],
                data['lname'],
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