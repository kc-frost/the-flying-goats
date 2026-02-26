from flask import Flask, jsonify, request, Blueprint, session
from flask_cors import CORS
from db import get_connection

bp = Blueprint("auth", __name__)
CORS(bp)

@bp.post('/login')
def login():    
    data = request.json
    email = data['email']
    password = data['password']

    conn = get_connection()
    with conn.cursor() as cursor:
        sql = "SELECT `email`, `password` FROM `users` WHERE `email`=%s AND `password`=%s"
        cursor.execute(sql, (email, password))
        result = cursor.fetchone()

    if result is not None:
        return jsonify(200)
    else:
        return jsonify(404)

@bp.route('/register')
def register():
    conn = get_connection()
    with conn.cursor() as cursor:
        sql = "SELECT * FROM `users`"
        cursor.execute(sql)
        result = cursor.fetchone()

    return f"asd"

