import os
from dotenv import load_dotenv
from flask import Flask
from flask_cors import CORS
from flask_login import LoginManager
from db import get_connection
from _models.user import User

load_dotenv()
# Import a new routes/blueprint file here
# Format:
# from [module] import bp as [name]bp
from auth.routes import bp as authbp
from profile.routes import bp as ppbp

app = Flask(__name__)

# check Flask docs on how to create this
app.secret_key = os.getenv("SECRET_KEY")

login_manager = LoginManager()
login_manager.init_app(app)
cors = CORS(app, supports_credentials=True, resources={r"/api/*": {"origins": "http://localhost:4200"}})

# TODO: THIS IS BADLY PLACED, but figuring out where to properly place it is trickier. will do post sprint 3
@login_manager.user_loader
def load_user(email: str) -> User | None:
    """Reloads User object stored in the session based on their email

    Args:
        email (str): Email of a user

    Returns:
        User | None: A User if email has a match, otherwise None
    """
    conn = get_connection()
    with conn.cursor() as cursor:
        query = "SELECT `username`, `email` FROM `users` WHERE `email`=%s"
        cursor.execute(query, (email))
        result = cursor.fetchone()
    
    if result is not None:
        return User(result['username'], result['email'])
    else:
        return None

# What is a blueprint?
# For our purporses, a blueprint allows us to point to a file that holds routes that contains endpoints for our API

# What is url_prefix?
# Puts a prefix before every route inside the blueprint

app.register_blueprint(authbp, url_prefix="/api")
app.register_blueprint(ppbp, url_prefix="/api")

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=5000)