import os
from flask import Flask

from app.config import Config
from app.extensions import cors, login_manager
from app.db import get_connection

# blueprints
from app import auth, profile

from app.models import User
from auth.service import if_admin

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
    register_blueprints(app)

    return app

def register_extensions(app):
    login_manager.init_app(app)

def register_blueprints(app):
    origins = app.config.get("CORS_WHITELISTED_ORIGINS")
    cors.init_app(app, 
                  supports_credentials=True,
                  resources={r"/api/": {"origins": origins}})
    
    app.register_blueprint(auth.routes.bp, url_prefix="/api")
    app.register_blueprint(profile.routes.bp, url_prefix="/api")


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

    if result is not None:
        return User(
            str(result['userID']), 
            result['username'], 
            result['email'], 
            if_admin(result['email']))
    else:
        return None