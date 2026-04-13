import os
from flask import Flask

from app.config import Config
from app.extensions import cors, login_manager
from app.db import get_connection

from app.models import User
from app.auth import if_admin, check_role

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
                  resources={
                      r"/api/*": {"origins": origins},
                      r"/admin/*": {"origins": origins}})
    
    # blueprints
    # id appreciate it if we grouped it by public, logged-in, and admin routes, but if this gets out of order its nbd
    from app import auth, profile, app_notifs, booking, pilot_view, inventory, view_reservations, view_users

    # 'public' routes
    app.register_blueprint(auth.routes.bp, url_prefix="/api")
    app.register_blueprint(app_notifs.routes.bp, url_prefix="/api")

    # logged-in routes
    app.register_blueprint(profile.routes.bp, url_prefix="/api")
    app.register_blueprint(booking.routes.bp, url_prefix="/api")
    app.register_blueprint(pilot_view.routes.bp, url_prefix="/api")

    # admin routes
    app.register_blueprint(inventory.routes.bp, url_prefix="/admin")
    app.register_blueprint(view_reservations.routes.bp, url_prefix="/admin")
    app.register_blueprint(view_users.routes.bp, url_prefix="/admin")
# utils
@login_manager.user_loader
def load_user(user_id: str):
    conn = get_connection()
    with conn.cursor() as cursor:
        query = """
            SELECT `userID`, `username`, `email`, `isStaff`
            FROM `users`
            WHERE `userID` = %s
        """
        cursor.execute(query, (user_id,))
        result = cursor.fetchone()

    if result is not None:
        role_value = "none"
        if result['isStaff']:
            role = check_role(result['email'])
            role_value = str(role.get('role')) if 'err' not in role else "none"
    
        return User(
            str(result['userID']), 
            result['username'], 
            result['email'], 
            if_admin(result['email']),
            result['isStaff'],
            role_value)
    
    return None
