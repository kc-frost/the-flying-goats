from app.db import get_connection
from app.auth.security import staff_required

def get_upcoming_flights(user_id: str):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            # # flights within 30 minutes
            query = """
                SELECT bookingNumber, userID, departOrigin as origin, departLiftOffDate as liftOff, 'outbound' as leg
                FROM reservationticket
                WHERE userID = %s
                AND TIMEDIFF(departLiftOffDate, NOW()) <= '00:30:00'
                AND TIMEDIFF(departLiftOffDate, NOW()) > '00:00:00'

                UNION

                SELECT bookingNumber, userID, returnOrigin as origin, returnLiftOffDate as liftOff, 'inbound' as leg
                FROM reservationticket
                WHERE userID = %s
                AND TIMEDIFF(returnLiftOffDate, NOW()) <= '00:30:00'
                AND TIMEDIFF(returnLiftOffDate, NOW()) > '00:00:00'
            """
            cursor.execute(query, (user_id, user_id))
            rows = cursor.fetchall()

            if rows is None:
                return {"err": "no flights found"}

        except Exception as e:
            return {"err": str(e)}
    
    return rows


def get_new_assignments_amount(user_id: str):
    # Count notifications from the pending pilot-assignment table instead of re-searching bookinghistory table again.
    result = get_pilot_assignment_notifications(user_id)

    if isinstance(result, dict) and 'err' in result:
        return result

    return len(result)\

def get_cancellation_notifications(user_id):
    # Grab every cancellation notification waiting to be received by the logged in user.
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT bookingID
                FROM cancellationnotifs
                WHERE userID = %s
                ORDER BY bookingID
            """
            cursor.execute(query, (user_id,))
            rows = cursor.fetchall()

        except Exception as e:
            return {"err": str(e)}

    return rows

def acknowledge_cancellation_notification(user_id, booking_id):
    # Remove the exact cancellation notification row once the app confirms it was received.
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                DELETE FROM cancellationnotifs
                WHERE userID = %s AND bookingID = %s
            """
            cursor.execute(query, (user_id, booking_id))
            conn.commit()

            # No affected rows means there was no notification matching this user/booking pair.
            if cursor.rowcount == 0:
                return {"err": "notification not found"}

        except Exception as e:
            return {"err": str(e)}

    return {"ok": True}

def get_pilot_assignment_notifications(user_id):
    """Get pilot assignment notifications waiting for acknowledgement.

    Args:
        user_id (str): Logged-in user's ID. Staff IDs mirror user IDs in this schema.

    Returns:
        (list | dict): Pending pilot assignment notifications, or an error message.
    """
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT flightID
                FROM pilotassignmentnotifs
                WHERE userID = %s
                ORDER BY flightID
            """
            cursor.execute(query, (user_id,))
            rows = cursor.fetchall()

        except Exception as e:
            return {"err": str(e)}

    return rows

def acknowledge_pilot_assignment_notification(user_id, flight_id):
    # Remove the exact pilot assignment notification row once the app confirms it was received.
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                DELETE FROM pilotassignmentnotifs
                WHERE userID = %s AND flightID = %s
            """
            cursor.execute(query, (user_id, flight_id))
            conn.commit()

            # No affected rows means there was no notification matching the user and flightID
            if cursor.rowcount == 0:
                return {"err": "notification not found"}

        except Exception as e:
            return {"err": str(e)}

    return {"ok": True}
