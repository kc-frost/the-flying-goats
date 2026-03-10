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
    HOST = "0.0.0.0"
    PORT = 5000
    DEBUG = True

    # for cors
    CORS_WHITELISTED_ORIGINS = [
        "http://localhost:4200",
        "http://localhost",
        "http://159.65.100.137"
    ]
