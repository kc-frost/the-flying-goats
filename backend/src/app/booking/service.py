from app.db import get_connection

def get_taken_seats(scheduleID):
    """Gets all taken seats of a flight per its scheduleID

    Args:
        scheduleID (int): scheduleID to identify a flight

    Raises:
        ValueError: No seats are found/No seats have been booked yet

    Returns:
        (list | dict): A list of taken_seats, or a dict containing an error message
    """    
    conn = get_connection()
    
    with conn.cursor() as cursor:
        try:
            query = """
                SELECT `seatNumber`
                FROM `planeseat`
                WHERE `scheduleID` = %s
            """

            cursor.execute(query, (scheduleID,))
            rows = cursor.fetchall()

            if rows is None:
                raise ValueError("No seats found!")
            
            taken_seats = [row['seatNumber'] for row in rows]

        except Exception as e:
            return {"error": str(e)}
    
    return taken_seats

def get_airports(search_term):
    """Get all airports based on if it matches the `search_term`

    Args:
        search_term (str): To search the airports by

    Returns:
        list: All airports that match the passed `search_term`
    """    
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT place, IATA
                FROM `airports`
                WHERE place LIKE %s OR IATA LIKE %s
            """

            # Accounts for partial matches
            cursor.execute(query, (f'%{search_term}%', f'%{search_term}%'))
            rows = cursor.fetchall()

            airports = []
            for row in rows:
                airports.append(row)
            
        except Exception as e:
            return {"error": str(e)}
        
    return airports

def get_available_flights(origin, destination):
    """Get all available flights according to their airport of origin and destination

    Args:
        origin (str): The airport where a plane is departing from
        destination (str): The airport where a plane is headed towards

    Returns:
        dict: A dict with keys 'depart' and 'return', each containing a list of matching flights. Otherwise,
        a dict with an error key if the query fails
    """    
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT *
                FROM `available_flights`
                WHERE `origin_IATA` LIKE %s AND `destination_IATA` LIKE %s
            """

            # This accounts for partial matches

            cursor.execute(query, (f'%{origin}', f'%{destination}%'))
            rows = cursor.fetchall()
            departFlights = [dict(row) for row in rows]

            cursor.execute(query, (f'%{destination}%', f'%{origin}%'))
            rows = cursor.fetchall()
            returnFlights = [dict(row) for row in rows]

        except Exception as e:
            return {"error": str(e)}
    
    return {"depart": departFlights,
            "return": returnFlights}

def insert_planeseat(seatNumber, scheduleID, classID):
    """Insert an occupied seat into the planeseat table

    Args:
        seatNumber (str): The new booked seat
        scheduleID (int): The scheduleID of a flight
        classID (int): The class of the seat

    Returns:
        (dict | None): A dict containing an error message, or nothing
    """    
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                INSERT INTO `planeseat`
                VALUES (%s, %s, %s)
            """

            cursor.execute(query, (seatNumber, scheduleID, classID))

            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"error": str(e)}

def book_a_flight(outboundFlight: dict, inboundFlight: dict):
    """Create a booking with an outbound and inbound flight

    Args:
        outboundFlight (dict): Details for an outbound flight
        inboundFlight (dict): Details for an inbound flight

    Raises:
        ValueError: User can't be found
        ValueError: Depart scheduleID can't be found
        ValueError: Return scheduleID can't be found
        ValueError: Reservation dates don't match

    Returns:
        dict: A dict containing an error message if the op fails 
    """    
    conn = get_connection()
    
    with conn.cursor() as cursor:
        try:
            # find user via their username and email
            query = """
                SELECT `userID`
                FROM `users`
                WHERE `username` = %s and `email` = %s
            """
            cursor.execute(query, 
                           (outboundFlight['username'], outboundFlight['email']))
            row = cursor.fetchone()
            if row is None:
                raise ValueError("User not found")
            
            userID = row.get("userID")
            
            # find flightID based on IATA
            query = """
                SELECT `flightID` FROM `flight` WHERE `IATA` = %s
            """
            cursor.execute(query, (outboundFlight.get("flightID"),))
            row = cursor.fetchone()
            if row is None:
                raise ValueError("Plane not found")

            outboundFlightID = row.get("flightID")

            cursor.execute(query, (inboundFlight.get("flightID")))
            row = cursor.fetchone()
            if row is None:
                raise ValueError("Plane not found")
            
            inboundFlightID = row.get("flightID")

            # find flight schedule user booked
            query = """
                SELECT `scheduleID`
                FROM `schedule`
                WHERE `flightID` = %s AND
                    TIME_FORMAT(liftOff, '%%H:%%i') LIKE DATE_FORMAT(%s, '%%H:%%i') AND
                    TIME_FORMAT(landing, '%%H:%%i') LIKE DATE_FORMAT(%s, '%%H:%%i')
            """

            cursor.execute(query, 
                           (outboundFlightID,
                            outboundFlight.get("departureDate"),
                            outboundFlight.get("arrivalDate")))
            row = cursor.fetchone()
            # if this error pops up fml
            if row is None:
                raise ValueError("Depart ScheduleID can't be found")
            
            departSchedule = row.get("scheduleID")

            cursor.execute(query, 
                           (inboundFlightID,
                            inboundFlight.get("departureDate"),
                            inboundFlight.get("arrivalDate")))
            row = cursor.fetchone()
            # if this error pops up fml (2)
            if row is None:
                raise ValueError("Return ScheduleID can't be found")
        
            returnSchedule = row.get("scheduleID")

            # if this error pops up fml (3)
            if (outboundFlight['reservationDate'] != inboundFlight['reservationDate']):
                raise ValueError("Reservation dates don't match")
            
            # insert into planeseat
            insert_planeseat(
                outboundFlight.get("seatNumber"),
                departSchedule,
                outboundFlight.get("seatClass"))
            insert_planeseat(
                inboundFlight.get("seatNumber"),
                returnSchedule,
                inboundFlight.get("seatClass"))

            # insert into booking
            query = """
                INSERT INTO `booking`(userID, departSchedule, returnSchedule, departSeat, returnSeat, bookingDate)
                VALUES (%s, %s, %s, %s, %s, now())
            """
            cursor.execute(query, (
                userID,
                departSchedule,
                returnSchedule,
                outboundFlight.get("seatNumber"),
                inboundFlight.get("seatNumber")
            ))

            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"error": str(e)}

def user_details_match(outboundFlight: dict, inboundFlight: dict) -> bool:
    """Checks if user details for both flights match

    Args:
        outboundFlight (dict): Outbound flight details
        inboundFlight (dict): Inbound flight details

    Returns:
        bool: If credentials match across flights or not
    """    
    return (outboundFlight['username'] == inboundFlight['username']
            and outboundFlight['email'] == inboundFlight['email'])