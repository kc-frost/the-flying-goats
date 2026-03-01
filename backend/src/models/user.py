from flask_login import UserMixin

class User(UserMixin):
    """Used as a representation of a user, doesn't actually do anything
    with the database

    Args:
        UserMixin (_type_): From flask_login docs: The class that you 
        use to represent users needs to implement 
        these properties and methods

    """
    def __init__(self, username: str, email: str) -> None:
        self.username = username
        self.id = email