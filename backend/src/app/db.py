from flask import current_app
import pymysql.cursors

def get_connection():
    """Attempts to connect to the database using user variables from the
    hidden .env file, and returns a connection object if successful

    Returns:
        _type_: A object that's connected to the db and can do queries
    """
    USER = current_app.config["USER"] or ""
    PASSWORD = current_app.config["PASSWORD"] or ""
    HOST = current_app.config["HOST"] or ""
    DATABASE = current_app.config["DATABASE"] or ""

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