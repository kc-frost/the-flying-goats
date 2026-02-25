#!/bin/sh
export FLASK_APP=./main.py
uv run flask --debug run -h 0.0.0.0