import re
import hashlib
import os
from dotenv import load_dotenv
import mysql.connector

def connect_to_db():
    # database login credentials
    load_dotenv()
    USER = os.getenv("USER")
    PASSWORD = os.getenv("PASSWORD")
    HOST = os.getenv("HOST")
    DATABASE = os.getenv("DATABASE")

    try:
        conn = mysql.connector.connect(
            user=USER,
            password=PASSWORD,
            host=HOST,
            database=DATABASE
        )

        print("Connection established")
        return conn
    except mysql.connector.Error as err:
        print("\nConnection error:", err)


def hash_password():
    pass

def main():
    connect_to_db()

if __name__ == '__main__':
    main()