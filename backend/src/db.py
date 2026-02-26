from dotenv import load_dotenv
import os
import pymysql.cursors

def get_connection():
    """Attempts to connect to the database using user variables from the
    hidden .env file, and returns a connection object if successful

    Returns:
        _type_: A object that's connected to the db and can do queries
    """

    # database login credentials
    # .env NEEDS to be on the same level as t his file
    load_dotenv()
    USER = os.getenv("USER") or ""
    PASSWORD = os.getenv("PASSWORD") or ""
    HOST = os.getenv("HOST") or ""
    DATABASE = os.getenv("DATABASE") or ""

    # ensures all database variables are properly instantiated
    # before establishing a connection
    # all(): bool where True if params are not "", None, or False
    if not all([USER, PASSWORD, HOST, DATABASE]):
        raise ValueError("One or more database variables are missing.")

    return pymysql.connect(
        user=USER,
        password=PASSWORD,
        host=HOST,
        database=DATABASE,
        charset="utf8mb4",
        cursorclass=pymysql.cursors.DictCursor
        )