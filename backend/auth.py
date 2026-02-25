import re
import hashlib
import os
from dotenv import load_dotenv
import pymysql.cursors

def connect_to_db():
    """Attempts to connect to the database using user variables from the
    hidden .env file, and returns a connection object if successful

    Returns:
        _type_: A object that's connected to the db and can do queries
    """

    # database login credentials
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
        Can have any alphanumeric characters [a-ZA-Z0-9]
        and special characters (. * + ? $ ^ / '\')
    Domain (part after the @):
        Can have any alphanumeric character

    Args:
        email (str): Inputted email of a user trying to authenticate 

    Returns:
        bool: If this email follows valid structure
    """

    VALID_PATTERN = r"[a-zA-Z0-9\.\*\+\?\$\^\/\\]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+"
    search = re.fullmatch(VALID_PATTERN, email.strip())

    return search is not None

def validate_password(password: str) -> bool:
    """Validates password according to specified regex pattern
    A password requires:
        at least 8 characters                       .{8,}
        at least one upper/lowercase letter         [A-Z][a-z]
        at least one digit                          [0-9]
        at least one special character              [()#?!@$%^&*-]
    
    Regex explanation:
        Further reading: Lookaheads

        (?=.*?[A-Z]) = "Somewhere ahead of the string (?=...) there is
        at least one character of any kind (.) repeated zero or more
        times (*) matched (as few needed to match ?) that is an
        uppercase letter [A-Z]"

    Args:
        password (str): A possible password for a user

    Returns:
        bool: If this password is considered secure enough
    """
    VALID_PATTERN = r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[()#?!@$%^&*-]).{8,}$"
    search = re.fullmatch(VALID_PATTERN, password.strip())

    return search is not None


# TODO: Add Flask support
def register(email: str, password: str):
    info_message = ""



    return info_message, email, password

# TODO: Add Flask support
def login(email: str, password: str):
    pass

def main():
    # connect_to_db()
    pw = input("pw: ")
    print(validate_password(pw))

if __name__ == '__main__':
    main()