from app.db import get_connection
from flask_login import current_user

def get_cancelleable_reservations():
    conn = get_connection()

    with conn.cursor() as cursor:
        # if ure an admin, get ALL booking histories
        if current_user.is_admin == True:
            try:
                query = """
                    SELECT
                        bh.bookingNumber,
                        fd.IATA,
                        u.username,
                        sd.liftOff,
                        sd.landing,
                        ao.IATA as origin,
                        ad.IATA as destination
                    FROM
                        bookinghistory bh
                    INNER JOIN schedule sd ON bh.departScheduleID = sd.scheduleID
                    INNER JOIN flight fd ON sd.flightID = fd.IATA
                    INNER JOIN airports ao ON fd.origin = ao.airportID
                    INNER JOIN airports ad ON fd.destination = ad.airportID
                    INNER JOIN users u ON bh.userID = u.userID 
                    WHERE bh.bookingStatus != 'Cancelled'
                """

                cursor.execute(query,)
                rows = cursor.fetchall()

                if rows is None:
                    return {'message': 'no reservations at all again..........'}

            except Exception as e:
                return {'err': str(e)}
            
            return rows
        
        # if ure a staff, ONLY get flights assigned to you
        elif current_user.role == 'Pilot':
            try:
                query = """
                    SELECT 
                        pf.userID, pf.email as pilotEmail, af.*
                    FROM
                        (SELECT 
                            u.userID, f.IATA, f.assignedPilot, s.email
                        FROM
                            flight f
                        INNER JOIN staff s ON f.assignedPilot = s.staffID
                        INNER JOIN users u ON s.email = u.email
                        WHERE
                            s.positionID = 2) pf
                            INNER JOIN
                        (SELECT 
                            fd.IATA,
                                u.username,
                                sd.liftOff,
                                sd.landing,
                                ao.IATA AS origin,
                                ad.IATA AS destination,
                                bh.bookingNumber
                        FROM
                            bookinghistory bh
                        INNER JOIN schedule sd ON bh.departScheduleID = sd.scheduleID
                        INNER JOIN flight fd ON sd.flightID = fd.IATA
                        INNER JOIN airports ao ON fd.origin = ao.airportID
                        INNER JOIN airports ad ON fd.destination = ad.airportID
                        INNER JOIN users u ON bh.userID = u.userID
                        WHERE bh.bookingStatus != 'Cancelled') af ON pf.IATA = af.IATA
                    WHERE
                        pf.userID = %s;
                """
                cursor.execute(query, (current_user.id,))
                rows = cursor.fetchall()

                if rows is None:
                    return {'message': 'you have no flights. do you even work?'}

            except Exception as e:
                return {'err': str(e)}
            
            return rows
        
        else:
            return {'err': 'you are neither an admin or a pilot. get out of here'}
        
def do_override_reservation(bookingNumber: int, reason: str):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                DELETE FROM `booking`
                WHERE `bookingNumber` = %s
            """

            cursor.execute(query, (bookingNumber,))

            query = """
                UPDATE `bookinghistory`
                SET `cancelledBy` = %s, `reason` = %s
                WHERE `bookingNumber` = %s
            """

            cursor.execute(query, (current_user.id, reason, bookingNumber, ))

            conn.commit()

        except Exception as e:
            conn.rollback()
            return {'err': str(e)}