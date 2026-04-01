from app.db import get_connection
from app.auth.security import staff_required

def get_upcoming_flights(user_id: str):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            # # flights within 30 minutes
            query = """
                SELECT `bookingNumber`, `userID`, `departOrigin` as origin, `departLift` as liftOff, 'outbound' as leg
                FROM `reservationticket`
                WHERE `userID` = %s
                AND TIMEDIFF(`departLift`, NOW()) <= '00:30:00'
                AND TIMEDIFF(`departLift`, NOW()) > '00:00:00'

                UNION

                SELECT `bookingNumber`, `userID`, `returnOrigin` as origin, `returnLift` as liftOff, 'inbound' as leg
                FROM `reservationticket`
                WHERE `userID` = %s
                AND TIMEDIFF(`returnLift`, NOW()) <= '00:30:00'
                AND TIMEDIFF(`returnLift`, NOW()) > '00:00:00'

            """
            cursor.execute(query, (user_id, user_id))
            rows = cursor.fetchall()

            if rows is None:
                return {"err": "no flights found"}

        except Exception as e:
            return {"err": str(e)}
    
    return rows

def get_new_assignments_amount(last_checked: str, staff_email: str):
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
            JOIN schedule s on b.departSchedule = s.scheduleID
            JOIN flight f on s.flightID = f.IATA
            JOIN staff st on f.assignedPilot = st.staffID
            WHERE b.bookingDate >= %s AND st.email = %s
            
            UNION
            
            SELECT b.bookingDate, s.scheduleID, f.assignedPilot, st.email
            FROM booking b
            JOIN schedule s on b.returnSchedule = s.scheduleID
            JOIN flight f on s.flightID = f.IATA
            JOIN staff st on f.assignedPilot = st.staffID
            WHERE b.bookingDate >= %s AND st.email = %s
            """

            cursor.execute(query, (last_checked, staff_email, last_checked, staff_email,))
            rows = cursor.fetchall()

        except Exception as e:
            return {"err": str(e)}
    
    return len(rows)