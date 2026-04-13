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

# This had a small bug where it was using old column names, idk how it connects to book a flight but that's how I found it, I fixed it
def get_new_assignments_amount(since: str, then:str, staff_email: str):
    """Get all new reservations assigned to a pilot since `last_checked` time

    Args:
        last_checked (str): Time of when new reservations were last checked
        staff_email (str): Staff's email used for identification

    Returns:
        (int | dict): Amount of new reservations, or an error message
    """    
    conn = get_connection()

    with conn.cursor() as cursor:

        try:
            query = """
            SELECT b.bookingDate, s.scheduleID, f.assignedPilot, st.email
            FROM booking b
            JOIN schedule s on b.departScheduleID = s.scheduleID
            JOIN flight f on s.flightID = f.IATA
            JOIN staff st on f.assignedPilot = st.staffID
            WHERE b.bookingDate >= %s AND b.bookingDate <=%s AND st.email = %s
            
            UNION
            
            SELECT b.bookingDate, s.scheduleID, f.assignedPilot, st.email
            FROM booking b
            JOIN schedule s on b.returnScheduleID = s.scheduleID
            JOIN flight f on s.flightID = f.IATA
            JOIN staff st on f.assignedPilot = st.staffID
            WHERE b.bookingDate >= %s AND b.bookingDate <=%s AND st.email = %s
            """

            cursor.execute(query, (since, then, staff_email, since, then, staff_email))
            rows = cursor.fetchall()

        except Exception as e:
            return {"err": str(e)}
    
    return len(rows)