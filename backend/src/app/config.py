import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    # database credentials
    USER = os.getenv("USER")
    PASSWORD = os.getenv("PASSWORD")
    HOST = os.getenv("HOST")
    DATABASE = os.getenv("DATABASE")
    
    # for sessions, return "dev" if none set
    SECRET_KEY = os.getenv("SECRET_KEY", "dev")
    
    # for flask run
    FLASK_HOST = "0.0.0.0"
    FLASK_PORT = 5000
    FLASK_DEBUG = True

    # for cors
    CORS_WHITELISTED_ORIGINS = [
        "http://localhost:4200",
        "http://localhost",
        "http://127.0.0.1",
        "http://127.0.0.1:4200",
        "http://159.65.100.137"
    ]
