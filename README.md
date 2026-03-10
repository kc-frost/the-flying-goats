# The Flying Goats
Book your (goated) flight from anywhere* :)

\*with limitations

## Table of Contents
- [Current State](#current-state)
- [Usage](#usage)
- [Setup](#setup)
- [Developer Notes](#developer-notes)

## Current State

## Usage


## Setup
### Docker Setup

### [Backend] Creation of a new module and registering blueprints
_Initialize directory and files_
```bash
$ mkdir new_module && cd new_module
$ echo import . from routes > __init__.py
$ touch routes.py service.py
```
<br>

_Setup blueprint in module's `routes.py`_
```python
# 📁 ./routes.py

# depending on your use case, request may be optional
from flask import Flask, (request), Blueprint   

# other imports if needed
...

bp = Blueprint("a_name", __name__)

...
# routes and stuff here
```
<br>

_Register blueprint in app_
```python
# 📁 ../__init__.py

...

def register_blueprints(app):

    ...

    # this is grouped by public routes, logged-in routes, and admin routes
    # would be nice if properly grouped, ultimately not too big of a deal 
    from app import ..., new_module, ...

    ...

    # see actual __init__.py file for used url_prefixes
    app.register_blueprint(new_module.routes.bp, url_prefix="/")

```

## Credits