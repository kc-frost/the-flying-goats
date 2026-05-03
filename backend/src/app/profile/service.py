from flask import jsonify, current_app
from unittest import result
from app.db import get_connection
from app.auth.service import check_ifpilot, check_role, if_admin
from app.auth.security import get_hashed_password
from datetime import timedelta
# No idea what this import does but it fixes shit so we ball
import re
import serpapi

def get_user_reservations(userID: str):
    conn = get_connection()
    with conn.cursor() as cursor:
        try:
            query = """
                SELECT `userID`
                FROM `users`
                WHERE userID = %s
            """
            cursor.execute(query, (userID,))
            user = cursor.fetchone()
            if user is None:
                return jsonify({"err": "User not found"}), 404
            
            query = """
                SELECT *
                FROM `reservationticket`
                WHERE `userID` = %s
            """
            cursor.execute(query, (user['userID'],))
            result = cursor.fetchall()

            for row in result:
                for key in row:
                    if isinstance(row[key], timedelta):
                        row[key] = str(row[key])

            # dedup by bookingNumber
            seen = set()
            unique_result = []
            for row in result:
                if row['bookingNumber'] not in seen:
                    seen.add(row['bookingNumber'])
                    unique_result.append(row)

        except Exception as e:
            return jsonify({"err": str(e)}), 500

    return unique_result

def get_profile_picture(user_id: str):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT `profilePicture`
                FROM `users`
                WHERE `userID` = %s
            """

            cursor.execute(query, (user_id,))
            profile_picture = cursor.fetchone()
            if profile_picture is None:
                return {"err": "User not found"}
            
        except Exception as e:
            return {"err": str(e)}
    
    return profile_picture

def save_profile_picture(url: str, user_id: str):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                UPDATE `users`
                SET `profilePicture` = %s
                WHERE `userID` = %s
            """
            cursor.execute(query, (url, user_id))
            conn.commit()
            return {"message": "profile picture uploaded"}
        except Exception as e:
            conn.rollback()
            return {"err": str(e)}

# booking now has depart and return seat attributes, so had to change this
def update_booking_seat(data):
    conn = get_connection()
    query = """
    update booking
    set departSeat = coalesce(%s, departSeat),
        returnSeat = coalesce(%s, returnSeat)
    where bookingNumber = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (
                data.get('departSeat'),
                data.get('returnSeat'),
                data['bookingID']
            ))
            conn.commit()
            return {"success": True}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}

# Booking doesn't have status anymore, that's in bookinghistory
def update_booking_status(data):
    conn = get_connection()
    query = """
    update bookinghistory set bookingStatus = %s where bookingNumber = %s
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (data['status'], data['bookingID']))
            conn.commit()
            return {"success": True}
        except Exception as e:
            conn.rollback()
            return {"success": False, 
                    "error": str(e)}
        
# Hub of wheel outcomes
def apply_fun_wheel_outcome(user_id: str, outcome: str):
    conn = get_connection()

    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                select u.userID, u.email, u.isStaff, s.positionID
                from users u
                left join staff s on s.staffID = u.userID
                where u.userID = %s
                for update
            """, (user_id,))
            user = cursor.fetchone()

            if user is None:
                return {"success": False, "error": "User not found"}

            if outcome == "delete-account":
                return delete_wheel_user(conn, cursor, user)

            if outcome == "demotion":
                return demote_wheel_user(conn, cursor, user)

            if outcome == "become-pilot":
                promote_wheel_user(cursor, user, 2)
                conn.commit()
                return {"success": True, "message": "You're a pilot now, captian."}

            if outcome == "become-admin":
                promote_wheel_user(cursor, user, 6)
                conn.commit()
                return {"success": True, "message": "You're now an admin. Don't break shit, please. -Richard"}

            if outcome == "cancel-reservations":
                cancelled_count = cancel_all_wheel_reservations(cursor, user["userID"], user["userID"])
                conn.commit()
                return {"success": True, "message": f"Cancelled {cancelled_count} reservation(s)."}

            return {"success": True, "message": "Free flights for life! Wait, why is it windy?"}
    except Exception as e:
        conn.rollback()
        return {"success": False, "error": str(e)}

# Deletes the user.
# Admins can't be delted
# Pilots can be deleted, but their flights are reassigned to another pilot
def delete_wheel_user(conn, cursor, user):
    if if_admin(user["email"]) or check_role(user["email"]).get("role") == "Admin":
        conn.commit()
        return {"success": True, "message": "Admin shield activated. You survived... luckily..."}

    if check_ifpilot(user["userID"]):
        reassign_wheel_pilot_flights(cursor, user["userID"])

    cancel_all_wheel_reservations(cursor, user["userID"], user["userID"])
    cursor.execute("delete from cancellationnotifs where userID = %s", (user["userID"],))
    cursor.execute("delete from pilotassignmentnotifs where userID = %s", (user["userID"],))
    cursor.execute("delete from users where userID = %s", (user["userID"],))
    conn.commit()

    return {
        "success": True,
        "message": "LMAOOOO Your account has been deleted by the wheel. GGs we hated you anyways.",
        "loggedOut": True
    }

# Demotes pilots, and deletes customers.
# Admins can't be demoted
def demote_wheel_user(conn, cursor, user):
    if if_admin(user["email"]) or check_role(user["email"]).get("role") == "Admin":
        conn.commit()
        return {"success": True, "message": "Admin shield activated. You can't be demoted by the wheel."}

    if not check_ifpilot(user["userID"]):
        return delete_wheel_user(conn, cursor, user)

    reassigned_pilot_id = reassign_wheel_pilot_flights(cursor, user["userID"])
    cursor.execute("update staff set positionID = %s where staffID = %s", (5, user["userID"]))
    conn.commit()

    return {
        "success": True,
        "message": f"You have been PROMOTED TO CUSTOMER!!! Your flights were reassigned to pilot {reassigned_pilot_id}."
    }

# Promotes customers to pilots. Admins and pilots don't benefit.
def promote_wheel_user(cursor, user, position_id):
    if not user["isStaff"]:
        cursor.execute("update users set isStaff = true where userID = %s", (user["userID"],))

    cursor.execute("""
        insert into staff(staffID, email, positionID)
        values (%s, %s, %s)
        on duplicate key update email = values(email), positionID = values(positionID)
    """, (user["userID"], user["email"], position_id))

# When a pilot is demoted or fired, their flights gotta be reassigned
def reassign_wheel_pilot_flights(cursor, demoted_pilot_id):
    replacement_pilot_id = get_available_wheel_pilot(cursor, demoted_pilot_id)

    if replacement_pilot_id is None:
        replacement_pilot_id = create_spare_wheel_pilot(cursor)

    cursor.execute("""
        select IATA
        from flight
        where assignedPilot = %s
    """, (demoted_pilot_id,))
    flights = cursor.fetchall()

    cursor.execute("""
        update flight
        set assignedPilot = %s
        where assignedPilot = %s
    """, (replacement_pilot_id, demoted_pilot_id))

    for flight in flights:
        cursor.execute("""
            insert ignore into pilotassignmentnotifs(userID, flightID)
            values (%s, %s)
        """, (replacement_pilot_id, flight["IATA"]))

    cursor.execute("delete from pilotassignmentnotifs where userID = %s", (demoted_pilot_id,))
    return replacement_pilot_id

# Helper method
def get_available_wheel_pilot(cursor, excluded_pilot_id):
    cursor.execute("""
        select s.staffID
        from staff s
        where s.positionID = %s
        and s.staffID <> %s
        order by (
            select count(*)
            from flight f
            where f.assignedPilot = s.staffID
        ), s.staffID
        limit 1
    """, (2, excluded_pilot_id))
    pilot = cursor.fetchone()
    return None if pilot is None else pilot["staffID"]

# Creating artificial pilots in the case that after a pilots deletion or demotion, there are no available pilots at the time.
# This should, theoretically, be pretty rare, but just in case.
# I use regex to find the highest numbered SparePilot (General naming scheme for these artificial pilots), then increment that number. Infinite pilots, infinite workers.
def create_spare_wheel_pilot(cursor):
    cursor.execute("""
        select username
        from users
        where username REGEXP '^SparePilot[0-9]+$'
    """)
    # don't ask me how re works :pray:
    spare_numbers = []
    for row in cursor.fetchall():
        match = re.fullmatch(r"SparePilot(\d+)", row["username"])
        if match:
            spare_numbers.append(int(match.group(1)))

    # creates a user on the spot
    next_spare_number = max(spare_numbers, default=0) + 1
    username = f"SparePilot{next_spare_number}"
    email = f"{username}@sparepilot.com"
    phone_number = str(next_spare_number).zfill(10)[-10:]

    cursor.execute("""
        insert into users(phoneNumber, fname, lname, username, email, password, isStaff, registeredDate)
        values (%s, %s, %s, %s, %s, %s, true, now())
    """, (
        phone_number,
        "Spare",
        f"Pilot{next_spare_number}",
        username,
        email,
        get_hashed_password(username)
    ))
    spare_pilot_id = cursor.lastrowid

    # This should be an update. Staff should never be inserted, but only updating their positionID.
    cursor.execute("""
        insert into staff(staffID, email, positionID)
        values (%s, %s, %s)
        on duplicate key update email = values(email), positionID = values(positionID)
    """, (spare_pilot_id, email, 2))

    return spare_pilot_id

# Cancels all user reservations
def cancel_all_wheel_reservations(cursor, user_id, cancelled_by):
    cursor.execute("""
        select bookingNumber
        from booking
        where userID = %s
    """, (user_id,))
    bookings = cursor.fetchall()

    for booking in bookings:
        booking_number = booking["bookingNumber"]
        cursor.execute("delete from booking where bookingNumber = %s", (booking_number,))
        cursor.execute("""
            update bookinghistory
            set cancelledBy = %s,
                reason = %s
            where bookingNumber = %s
        """, (cancelled_by, "Cancelled by the FUN FUN WHEEL OF FUN", booking_number))

    return len(bookings)

# Look into adding leftover service files over the weekend

def create_review(bookingID: str, userID: str, rating: str, review: str):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
             INSERT INTO `reviews`(`bookingID`, `userID`, `rating`, `review`, `creationDate`) VALUES
                (%s, %s, %s, %s, now())
            """

            cursor.execute(query, [bookingID, userID, rating, review,])
            
            conn.commit()
            return {'success': 'ok'}
        except Exception as e:
            conn.rollback()
            return {'err': str(e)}
         
def retrieve_user_dests(userID: str):
  conn = get_connection()
  
  with conn.cursor() as cursor:
    try:
        query = """
            SELECT DISTINCT a.place as userDestinations
            FROM booking  b
            JOIN schedule sd ON b.departScheduleID = sd.scheduleID
            JOIN flight f ON sd.flightID = f.IATA
            JOIN airports a ON f.destination = a.airportID
            WHERE userID = %s;
            """
        
        cursor.execute(query, (userID,))
        dests = cursor.fetchall()

        if dests is None:
            return {'msg': 'user isnt going anywhere'}
            
        return dests
    
    except Exception as e:
        return {'err': str(e)}

def retrieve_tourist_destinations(location: str):
    """Returns the top sights of a given city

    WARNING: DO NOT REPEATEDLY CALL THIS FUNCTION WITHOUT REASON. IT MIGHT WASTE REQUESTS

    Args:
        location (str): City to be queried for

    Returns:
        dict: Top sights of the passsed city with the city as its key
    """

    client = serpapi.Client(api_key=current_app.config.get("SERPAPI_KEY"))
    results = client.search({
        "engine": "google",
        "q": f"{location} top sights"
    })

    if results["top_sights"].get("sights") is None:
        return {'msg': "no sights found"}
    
    print(results['search_metadata'])
    
    return results["top_sights"].get("sights")
        
        
def retrieve_reviews(userID: str):
    conn = get_connection()
    
    with conn.cursor() as cursor:
        try:
            query = """
                SELECT *
                FROM `reviews`
                WHERE `userID` = %s AND
                `deletionDate` IS NULL
            """

            cursor.execute(query, [userID,])
            rows = cursor.fetchall()

            return rows
        
        except Exception as e:
            return {'err': str(e)}
        
def erase_review(ratingID: int):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                UPDATE `reviews`
                SET `deletionDate` = now()
                WHERE `ratingID` = %s
            """

            cursor.execute(query, (ratingID,))
            conn.commit()

            return {'success': 'erased review'}
        except Exception as e:
            conn.rollback()
            return {'err': str(e)}
