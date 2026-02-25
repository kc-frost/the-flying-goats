from flask import Flask, request
from flask_cors import CORS
from markupsafe import escape
from dotenv import load_dotenv
from src

load_dotenv()

app = Flask(__name__)
CORS(app)

@app.route('/api/test_response')
def test_response():
    return f"Hello World!"

@app.route('/api/test-db')
def test_db():
    response = connect_to_db()
    if response is not None:
        return f"Database connected!"
    else:
        return f"No connection established."

@app.route('/api/login', methods=['GET', 'POST'])
def getLoginInfo():
    # Angular sends response in JSON
    data = request.get_json()
    email = data['email']
    password = data['password']
    bothValid = validate_email(email=email) & validate_password (password=password)
    
    return f"Login info is {escape(bothValid)}"



if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)