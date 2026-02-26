from flask import jsonify, request, Blueprint, session
from db import get_connection
from .service import get_hashed_password

bp = Blueprint("auth", __name__)

@bp.post('/login')
def login():
    # obtain request data
    # transforms json into python dict
    data = request.json
    email = data['email']
    password = data['password']

    # because it's actually hashed in the db
    true_password = get_hashed_password(password)

    conn = get_connection()
    with conn.cursor() as cursor:
        query = "SELECT `email`, `password` FROM `users` WHERE `email`=%s AND `password`=%s"
        cursor.execute(query, (email, true_password))
        result = cursor.fetchone()

    if result is not None:
        return jsonify(200) # user exists
    else:
        return jsonify(404) # user doesn't exist

@bp.route('/register')
def register():
    conn = get_connection()
    with conn.cursor() as cursor:
        sql = "SELECT * FROM `users`"
        cursor.execute(sql)
        result = cursor.fetchone()

    return f"asd"

