# NOTE: Sign up and sign in functions currently function if limited to 
# console input only. Adapting to HTTP will come at a later point. 
# This is just to set up logic.

import re
import hashlib
import os
from dotenv import load_dotenv
import mysql.connector

def connect_to_db():
    """Attempts to connect to the database using user variables from the
    hidden .env file, and returns a connection object if successful

    Returns:
        _type_: A object that's connected to the db and can do queries
    """

    # database login credentials
    load_dotenv()
    USER = os.getenv("USER")
    PASSWORD = os.getenv("PASSWORD")
    HOST = os.getenv("HOST")
    DATABASE = os.getenv("DATABASE")

    return mysql.connector.connect(
        user=USER,
        password=PASSWORD,
        host=HOST,
        database=DATABASE
        )

# NOTE: This function only ever runs upon
# validation of it being a good password
def hash_password(password: str) -> str:
    """Using SHA224, returns a hashed password to be used
    to insert into the database

    Args:
        password (str): Unhashed password

    Returns:
        str: A hashed version of a validated password
    """
    encoded_pass = password.encode()
    hashed_pass = hashlib.sha224(encoded_pass).hexdigest()

    return hashed_pass

# TODO (not immediate): Ensure that domains don't have hyphens as its
# last character
def validate_email(email: str) -> bool:
    """Validates email according to specified regex pattern
    Local Part (part before the @): 
        Can have any alphanumeric characters and special characters
    Domain (part after the @):
        Can have any alphanumeric character

    Args:
        email (str): Inputted email of a user trying to authenticate 

    Returns:
        bool: If the email matches the pattern or not
    """

    VALID_PATTERN = r"[a-zA-Z0-9\.\*\+\?\$\^\/\\]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+"
    search = re.fullmatch(VALID_PATTERN, email.strip())

    return search is not None

def validate_password(password: str) -> bool:
    is_valid = False

    return is_valid


# TODO: Add Flask support
def register(email: str, password: str):
    info_message = ""



    return info_message, email, password

# TODO: Add Flask support
def login(email: str, password: str):
    pass

def main():
    connect_to_db()

if __name__ == '__main__':
    main()