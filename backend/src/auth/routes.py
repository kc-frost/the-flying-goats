from flask import Flask, jsonify, request, Blueprint
from main import app

bp = Blueprint("auth", __name__, url_prefix="/api")

@bp.route('/login')
def register():
    return f"asd"

@app.route('/api/login')
def login():
    return f"asd"
