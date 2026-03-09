import os
from config import Config
from flask import Flask

def create_app(test_config=Config):
    """Instatiates app.
    
    By default, uses default `Config` from `config.py`, otherwise uses passed `Config` object

    Args:
        test_config (Config): Config object used for testing. 
        Defaults to Config.

    Returns:
        app: A Flask instance of our app
    """
    app = Flask(__name__, instance_relative_config=True)
    
    app.config.from_object(Config)

    os.makedirs(app.instance_path, exist_ok=True)

    return app