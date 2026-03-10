from app import create_app
from flask_cors import CORS

# Import a new routes/blueprint file here
# Format:
# from [module] import bp as [name]bp
from auth.routes import bp as authbp
from profile.routes import bp as ppbp

app = create_app()

# What is a blueprint?
# For our purporses, a blueprint allows us to point to a file that holds routes that contains endpoints for our API

# What is url_prefix?
# Puts a prefix before every route inside the blueprint

app.register_blueprint(authbp, url_prefix="/api")
app.register_blueprint(ppbp, url_prefix="/api")

if __name__ == "__main__":
    app.run(host=app.config["HOST"], debug=app.config["DEBUG"], port=app.config["PORT"])