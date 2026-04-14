from app.db import get_connection

def get_all_connections():
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT bh.bookingNumber, u.username, ao.IATA AS `origin`, ad.IATA AS `destination`, bh.cancellationDate, up.username as cancelledBy, bh.reason
                FROM bookinghistory bh
                JOIN users u on bh.userID = u.userID
                JOIN schedule s on bh.departScheduleID = s.scheduleID
                JOIN flight f on s.flightID = f.IATA
                JOIN airports ao on f.origin = ao.airportID
                JOIN airports ad on f.destination = ad.airportID
                JOIN users up on bh.cancelledBy = up.userID
                WHERE bh.bookingStatus = 'Cancelled'
            """

            cursor.execute(query,)
            rows = cursor.fetchall()

            if rows is None:
                return {'message': 'no cancellations so far...'}

        except Exception as e:
            return {'err': str(e)}
        
        return rows