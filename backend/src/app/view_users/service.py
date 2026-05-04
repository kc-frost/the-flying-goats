from app.db import get_connection
from app.auth.service import check_ifpilot, check_role, if_admin
from app.profile.service import reassign_wheel_pilot_flights

def get_user_data():
    conn = get_connection()
    query = "select * from userreservationsummary"
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            result = cursor.fetchall()
            return {"success": True, 
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}

def search_user_data(searchKey):
    conn = get_connection()
    query = "select * from userreservationsummary where cast(userID as char) = %s or email = %s or username = %s"
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (searchKey, searchKey, searchKey))
            result = cursor.fetchall()
            return {"success": True, "data": result}
        except Exception as e:
            return {"success": False, "error": str(e)}

def cancel_user_reservations(cursor, userID, deleted_by):
    cursor.execute("""
        select bookingNumber
        from booking
        where userID = %s
    """, (userID,))
    bookings = cursor.fetchall()

    for booking in bookings:
        bookingNumber = booking["bookingNumber"]
        cursor.execute("delete from booking where bookingNumber = %s", (bookingNumber,))
        cursor.execute("""
            update bookinghistory
            set cancelledBy = %s,
                reason = %s
            where bookingNumber = %s
        """, (deleted_by, "Cancelled by admin user deletion.", bookingNumber))

    return len(bookings)

def delete_user(userID, deleted_by):
    conn = get_connection()
    findUserQuery = """
    select userID, email, isStaff
    from users
    where userID = %s
    """

    with conn.cursor() as cursor:
        try:
            cursor.execute(findUserQuery, (userID,))
            user = cursor.fetchone()

            if user is None:
                return {"success": False, "error": "User not found.", "status": 404}

            if str(user["userID"]) == str(deleted_by):
                return {"success": False, "error": "You cannot delete your own admin account.", "status": 400}

            role = check_role(user["email"]) if user["isStaff"] else {"role": "Customer"}
            if if_admin(user["email"]) or role.get("role") == "Admin":
                return {"success": False, "error": "Admin accounts cannot be deleted from this dashboard.", "status": 403}

            if check_ifpilot(user["userID"]):
                reassign_wheel_pilot_flights(cursor, user["userID"])

            cancel_user_reservations(cursor, user["userID"], deleted_by)
            cursor.execute("delete from cancellationnotifs where userID = %s", (user["userID"],))
            cursor.execute("delete from pilotassignmentnotifs where userID = %s", (user["userID"],))
            cursor.execute("delete from users where userID = %s", (user["userID"],))

            if cursor.rowcount == 0:
                conn.rollback()
                return {"success": False, "error": "User not found.", "status": 404}

            conn.commit()
            return {"success": True}
        except Exception as e:
            conn.rollback()
            return {"success": False, "error": str(e)}
