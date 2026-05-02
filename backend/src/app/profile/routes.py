from flask import jsonify, request, Blueprint
from flask_login import login_required, current_user, logout_user
from app.db import get_connection

from .service import get_user_reservations, get_profile_picture, save_profile_picture, update_booking_seat, update_booking_status, retrieve_tourist_destinations, retrieve_user_dests, create_review, retrieve_reviews, erase_review, apply_fun_wheel_outcome

bp = Blueprint("profile", __name__)

@bp.route("/get-active-user")
@login_required
def get_active_user():
    """Get details of active user

    Returns:
        User: A Logged in user
    """
    username = current_user.username
    email = current_user.id
    return jsonify({
        "username": username,
        "email": email
        }), 200

@bp.route('/user-reservations', methods=['GET'])
@login_required
def user_reservations():
    """Gets all flight bookings of a valid user through their userID

    Returns:
        dict: All valid reservations or an error message
    """    

    return jsonify(get_user_reservations(current_user.get_id()))
# FUN WHEEL STUFF
@bp.route('/fun-wheel/outcome', methods=['POST'])
@login_required
def fun_wheel_outcome():
    data = request.get_json()
    outcome = data.get("outcome")

    if outcome is None:
        return jsonify({"success": False, "message": "Missing wheel outcome"}), 400

    result = apply_fun_wheel_outcome(current_user.get_id(), outcome)

    if not result.get("success"):
        return jsonify({"success": False, "message": result.get("error")}), 500

    if result.get("loggedOut"):
        logout_user()

    return jsonify({
        "success": True,
        "message": result.get("message"),
        "loggedOut": result.get("loggedOut", False)
    }), 200
# Route part of FUN FUN WHEEL OF FUN ends here but more stuff later in file

@bp.route('/get-bio', methods=['GET'])
@login_required
def get_bio():
    conn = get_connection()
    with conn.cursor() as cursor:
        cursor.execute("SELECT bio FROM users WHERE userID = %s", (current_user.get_id(),))
        row = cursor.fetchone()
        if row is None:
            return jsonify({"bio": ""}), 200
        return jsonify({"bio": row['bio']}), 200

@bp.route('/save-bio', methods=['POST'])
@login_required
def save_bio():
    data = request.get_json()
    conn = get_connection()
    with conn.cursor() as cursor:
        try:
            cursor.execute("UPDATE users SET bio = %s WHERE userID = %s", (data['bio'], current_user.get_id()))
            conn.commit()
            return jsonify({"message": "Bio saved"}), 200
        except Exception as e:
            conn.rollback()
            return jsonify({"error": str(e)}), 400
        
@bp.route('/get-profile-pic', methods=['GET'])
@login_required
def get_profile_pic():
    result = get_profile_picture(current_user.get_id())

    if ('err' in result):
        return jsonify(result), 500
    
    return jsonify(result), 200

@bp.route('/save-profile-picture', methods=['POST'])
def save_profile_pic():
    data = request.get_json()
    
    profile_url = data['profileURL']
    user_id = current_user.get_id()

    if profile_url is None or user_id is None:
        return jsonify({"err": "url/user_id is null",
                        "profile_url": profile_url,
                        "user_id": user_id}), 400

    result = save_profile_picture(profile_url, user_id)

    if ('err' in result):
        return jsonify(result), 500

    return jsonify(result), 200

@bp.post('/update-seat')
def update_seat():
    data = request.json
    result = update_booking_seat(data)
    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Seat successfully updated"}), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
         }), 500
    
# Again, right now there's no restrictions to this. Need to add restrictions later.
@bp.post('/update-reservation-status')
def update_reservation_status():
    conn = get_connection()
    data = request.json
    result = update_booking_status(data)
    if result.get("success"):
        return jsonify({
            "success": True,
            "message": "Reservation status successfully updated"}), 200
    else:
        return jsonify({
            "success": False,
            "message": result.get("error")
         }), 500

@bp.route('/get-user-dests', methods=['GET'])
@login_required
def get_user_dests():
    results = retrieve_user_dests(current_user.get_id())

    if results is None:
        return jsonify(results), 404
    if 'err' in results:
        return jsonify(results), 500
    
    return jsonify(results), 200

@bp.route('/get-tourist-dests', methods=['GET'])
@login_required
def get_tourist_dests():
    location = request.args.get('location')
    
    if location is None:
        return jsonify({'msg': 'no city passed'})
    
    results = retrieve_tourist_destinations(location)
    
    if results is None:
        return jsonify(results), 404
    
    return jsonify(results), 200
  
@bp.route('/add-review', methods=['POST'])
@login_required
def add_review():
    data = request.json

    bookingID = data['bookingID']
    rating = data['rating']
    review = data['review']

    result = create_review(bookingID, current_user.get_id(), rating, review)

    if 'err' in result:
        return jsonify(result), 500
    
    return jsonify(result), 200

@bp.route('/get-reviews', methods=['GET'])
@login_required
def get_reviews():
    result = retrieve_reviews(current_user.get_id())

    if 'err' in result:
        return jsonify(result), 500
    if 'msg' in result:
        return jsonify(result), 400
    
    return jsonify(result), 200

@bp.route('/delete-review', methods=['POST'])
@login_required
def delete_review():
    ratingID = request.json
    
    result = erase_review(ratingID)

    if 'err' in result:
        return jsonify(result), 500
    
    return jsonify(result), 200
