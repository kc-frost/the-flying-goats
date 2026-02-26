from flask import Flask, jsonify, request
from main import app

@app.route('/api/register')
def register():
    return f"asd"

@app.route('/api/login')
def login():
    return f"asd"
