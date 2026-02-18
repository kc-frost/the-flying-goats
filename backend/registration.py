# NOTE: Sign up and sign in functions currently function if limited to 
# console input only. Adapting to HTTP will come at a later point. 
# This is just to set up logic.

import re
import hashlib
import os
from dotenv import load_dotenv
import mysql.connector
from mysql.connector.pooling import PooledMySQLConnection
from mysql.connector.abstracts import MySQLConnectionAbstract


def connect_to_db() -> PooledMySQLConnection | MySQLConnectionAbstract:
    """
    Attempts to connect to the database using user variables from the
    hidden .env file, and returns a connection object if successful.    
    :return: Description
    :rtype: PooledMySQLConnection | MySQLConnectionAbstract
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
    """
    Returns a 
    
    :param password: Unhashed password
    :type password: str
    :return: A hashed version of a validated password
    :rtype: str
    """
    encoded_pass = password.encode()
    hashed_pass = hashlib.sha224(encoded_pass).hexdigest()

    return hashed_pass

def validate_email(email: str) -> bool:
    is_valid = False
    
    return is_valid

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