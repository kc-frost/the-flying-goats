import re

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