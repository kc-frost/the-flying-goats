from flask_login import UserMixin 

class User(UserMixin):
    """Used as a representation of a user, doesn't actually do anything
    with the database

    Args:
        UserMixin (_type_): From flask_login docs: The class that you 
        use to represent users needs to implement 
        these properties and methods

    """
    def __init__(self, user_id: str, username: str, email: str, is_admin: bool, is_staff: bool, role: str) -> None:
        self.id = user_id
        self.email = email
        self.username = username
        self.is_admin = is_admin
        self.is_staff = is_staff
        self.role = role
