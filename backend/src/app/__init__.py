import os
from config import Config
from flask import Flask

from app.extensions import cors, login_manager
from app.db import get_connection

from _models.user import User

def create_app(config_class=Config):
    """Instatiates app.
    
    By default, uses `Config` class from `config.py`, otherwise uses passed `Config` object

    Args:
        config_class (Config): Defines app's configuration settings. 
        Defaults to Config.

    Returns:
        app: A Flask instance of our app
    """

    # basic setup
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_object(config_class)
    os.makedirs(app.instance_path, exist_ok=True)

    register_extensions(app)

    return app

def register_extensions(app):
    login_manager.init_app(app)


# utils
@login_manager.user_loader
def load_user(user_id: str):
    conn = get_connection()
    with conn.cursor() as cursor:
        query = """
            SELECT `userID`, `username`, `email` 
            FROM `users`
            WHERE `userID` = %s
        """
        cursor.execute(query, (user_id))
        result = cursor.fetchone()

    # TODO: Update isAdmin() function. Default to False for now
    if result is not None:
        return User(str(result['userID']), result['username'], result['email'], False)