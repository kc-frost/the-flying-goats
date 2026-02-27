import hashlib

# NOTE: This function only ever runs upon
# validation of it being a good password
def get_hashed_password(password: str) -> str:
    """Using SHA224, returns a hashed password to be used
    to insert a new user or validate an existing one into the database

    Args:
        password (str): Unhashed password

    Returns:
        str: A hashed version of a validated password
    """

    encoded_pass = password.encode()
    hashed_pass = hashlib.sha224(encoded_pass).hexdigest()

    return hashed_pass
