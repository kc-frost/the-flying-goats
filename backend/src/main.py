from flask import Flask
from flask_cors import CORS

# Import a new routes/blueprint file here
# Format:
# from [module] import bp as [name]bp
from auth.routes import bp as authbp

app = Flask(__name__)
cors = CORS(app, resources={r"/api/*": {"origins": "*"}})

# What is a blueprint?
# For our purporses, a blueprint allows us to point to a file that holds routes that contains endpoints for our API
# This is to not clog this file, and be able to divide responsibilities across multiple files.
# By also dividing work like this, it becomes easier to work independently, as we become prone to merge conflicts otherwise.

# What is url_prefix?
# url_prefix does what you think it does
# In order to access any of the routes present in a Blueprint, the client has to make sure their links are prepended with the Blueprint's respective[url_prefix]
# Ex. "localhost:5000/login" will return a 404
# Meanwhile, "localhost:5000/api/login" can potentially return a response

app.register_blueprint(authbp, url_prefix="/api")

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)