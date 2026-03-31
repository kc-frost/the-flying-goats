from app.db import get_connection

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