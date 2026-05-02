import datetime
from datetime import timedelta
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

            # Queries already account for partial matches
            cursor.execute(query, (f'%{search_term}%', f'%{search_term}%'))
            rows = cursor.fetchall()

            airports = []
            for row in rows:
                airports.append(row)
            
        except Exception as e:
            return {"error": str(e)}
        
    return airports

def filtered_airports(regionID):
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT place, IATA
                FROM `airports`
                WHERE `regionID` = %s
            """

            cursor.execute(query, (regionID,))
            rows = cursor.fetchall()

            airports = []
            for row in rows:
                airports.append(row)
        except Exception as e:
            return {"error": str(e)}
    
    return airports

# Needs to be updated
def get_available_flights(origin, destination, departureDate, returnDate):
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
            # Added a helper method cause it was getting super long
            departFlights = get_matching_schedules(cursor, origin, destination, departureDate)
            returnFlights = get_matching_schedules(cursor, destination, origin, returnDate)
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"error": str(e)}
    print("OUTBOUND SEARCH:", origin, destination, departureDate)
    print("RETURN SEARCH:", destination, origin, returnDate)
    print("DEPART FLIGHTS:", departFlights)
    print("RETURN FLIGHTS:", returnFlights)
    return {"depart": departFlights,
            "return": returnFlights}

# Added more queries, updated update query, checks and cleanup added
def update_reservation_seat(departSeat, returnSeat, bookingID):
    conn = get_connection()
    findBookingQuery = """
        select departSeat, returnSeat, departScheduleID, returnScheduleID
        from booking
        where bookingNumber = %s
        for update;
    """
    isSeatTakenQuery = """
        select 1 from planeseat where seatNumber = %s and scheduleID = %s;
    """
    insertPlaneSeatQuery = """
        insert into planeseat(seatNumber, scheduleID) values(%s, %s);
    """
    updateSeatQuery = """
        update booking set departSeat = coalesce(%s, departSeat), returnSeat = coalesce(%s, returnSeat)
        where bookingNumber = %s;
    """
    # I'll turn this one into a trigger... someday
    cleanUpSeatQuery = """
        delete from planeseat where seatNumber = %s and scheduleID = %s;    
    """

    try:
        with conn.cursor() as cursor:
            cursor.execute(findBookingQuery, (bookingID,))
            booking = cursor.fetchone()
            if not booking:
                conn.rollback()
                return {"error": f"Booking {bookingID} not found or doesn't exist"}

            # get booking details for cleanup later before reassignment
            oldDepartSeat = booking["departSeat"]
            oldReturnSeat = booking["returnSeat"]
            departScheduleID = booking["departScheduleID"]
            returnScheduleID = booking["returnScheduleID"]

            # Get rid of whitespace between seat characters like 1A
            if departSeat is not None:
                departSeat = departSeat.strip().upper()
                if departSeat == "":
                    departSeat = None

            if returnSeat is not None:
                returnSeat = returnSeat.strip().upper()
                if returnSeat == "":
                    returnSeat = None

            # Depart seat check and insert portion
            if departSeat and departSeat != oldDepartSeat:
                cursor.execute(isSeatTakenQuery, (departSeat, departScheduleID))
                isTaken = cursor.fetchone()
                if isTaken:
                    conn.rollback()
                    return {"error": f"Depart seat {departSeat} is already taken. Pick a new seat."}
                
                cursor.execute(insertPlaneSeatQuery, (departSeat, departScheduleID))

            # Return seat check and insert portion
            if returnSeat and returnSeat != oldReturnSeat:
                cursor.execute(isSeatTakenQuery, (returnSeat, returnScheduleID))
                isTaken = cursor.fetchone()
                if isTaken:
                    conn.rollback()
                    return {"error": f"Return seat {returnSeat} is already taken. Pick a new seat."}
                
                cursor.execute(insertPlaneSeatQuery, (returnSeat, returnScheduleID))

            # Clean up old seats
            cursor.execute(updateSeatQuery, (departSeat, returnSeat, bookingID))

            if departSeat and departSeat != oldDepartSeat:
                cursor.execute(cleanUpSeatQuery, (oldDepartSeat, departScheduleID))

            if returnSeat and returnSeat != oldReturnSeat:
                cursor.execute(cleanUpSeatQuery, (oldReturnSeat, returnScheduleID))

            conn.commit()
            return {"success": f"Booking {bookingID} updated successfully. Enjoy your flight!"}

    except Exception as e:
        conn.rollback()
        return {"error": str(e)}

# If a user wants to change their reservation time, they just gotta cancel and rebook, ggs :100:, will implement a better version later
def cancel_reservation(bookingID):
    conn = get_connection()
    query = """
        delete from booking where bookingNumber = %s;
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (bookingID,))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"error": str(e)}

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
    seatTakenQuery = """
        select 1 from planeseat where seatNumber = %s and scheduleID = %s
    """
    
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

            # This is where the changes begin

            departSchedule = outboundFlight.get("scheduleID")
            returnSchedule = inboundFlight.get("scheduleID")

            if departSchedule is None:
                raise ValueError("Depart ScheduleID can't be found")
            if returnSchedule is None:
                raise ValueError("Return ScheduleID can't be found")
            
            # find scheduleID based on scheduleID
            query = """
                select scheduleID from schedule where scheduleID = %s
            """
            cursor.execute(query, (departSchedule,))
            row = cursor.fetchone()
            # if this error pops up fml
            if row is None:
                raise ValueError("Depart Schedule can't be found")

            cursor.execute(query, (returnSchedule,))
            row = cursor.fetchone()
            # if this error pops up fml (2)
            if row is None:
                raise ValueError("Return Schedule can't be found")
            
            outboundSeat = outboundFlight.get("seatNumber")
            inboundSeat = inboundFlight.get("seatNumber")

            cursor.execute(seatTakenQuery, (outboundSeat, departSchedule))
            if cursor.fetchone():
                return {"error": f"Depart seat {outboundSeat} is taken buddy. Pick a new seat."}

            cursor.execute(seatTakenQuery, (inboundSeat, returnSchedule))
            if cursor.fetchone():
                return {"error": f"Return seat {inboundSeat} is taken buddy. Pick a new seat."}


            # Commented out for now, this is the old stuff, doesn't work anymore but I'ma preserve just in case.

            # # find flight schedule user booked
            # query = """
            #     SELECT `scheduleID`
            #     FROM `schedule`
            #     WHERE `flightID` = %s AND
            #         TIME_FORMAT(liftOff, '%%H:%%i') LIKE DATE_FORMAT(%s, '%%H:%%i') AND
            #         TIME_FORMAT(landing, '%%H:%%i') LIKE DATE_FORMAT(%s, '%%H:%%i')
            # """

            # cursor.execute(query, 
            #                (outboundFlightID,
            #                 outboundFlight.get("departureDate"),
            #                 outboundFlight.get("arrivalDate")))
            # row = cursor.fetchone()
            
            # departSchedule = row.get("scheduleID")

            # cursor.execute(query, 
            #                (inboundFlightID,
            #                 inboundFlight.get("departureDate"),
            #                 inboundFlight.get("arrivalDate")))
            # row = cursor.fetchone()
        
            # returnSchedule = row.get("scheduleID")

            # # if this error pops up fml (3)
            # if (outboundFlight['reservationDate'] != inboundFlight['reservationDate']):
            #     raise ValueError("Reservation dates don't match")
            
            # insert into planeseat
            # Changes basically stop here
            insert_planeseat(
                outboundFlight.get("seatNumber"),
                departSchedule,
                outboundFlight.get("seatClass"))
            insert_planeseat(
                inboundFlight.get("seatNumber"),
                returnSchedule,
                inboundFlight.get("seatClass"))

            # insert into booking
            # Booking no longer has departDate, departSchedule, returnDate, returnSchedule. Changed to IDs, views should still work the same though. :thumbsup:
            query = """
                INSERT INTO `booking`(bookingDate, userID,
                departSeat, returnSeat,
                departScheduleID, returnScheduleID)
                VALUES (now(), %s,
                %s, %s,
                %s, %s)
            """

            cursor.execute(query, (
                userID,
                outboundFlight.get("seatNumber"),
                inboundFlight.get("seatNumber"),
                departSchedule,
                returnSchedule,
            ))

            conn.commit()
        except Exception as e:
            conn.rollback()
            return {"error": str(e)}

def user_details_match(outboundFlight: dict, inboundFlight: dict) -> bool:
    """Checks if user details for both flights match

    Args:
        outboundFlight (dict): Outbound flight detailsE
        inboundFlight (dict): Inbound flight details

    Returns:
        bool: If credentials match across flights or not
    """    
    return (outboundFlight['username'] == inboundFlight['username']
            and outboundFlight['email'] == inboundFlight['email'])

# This method, like the name suggests, is to find schedules matching what the user wants. It also accounts for partial matches, though I might get rid of that.
# Helper method for get_available_flights, though it still ended up pretty long
def get_matching_schedules(cursor, origin, destination, requestedDate):
    query = """
    select s.scheduleID, aorigin.IATA as origin_IATA, adestination.IATA as destination_IATA, f.IATA, f.capacity, s.liftOff, s.landing,
        concat(timestampdiff(hour, s.liftOff, s.landing), "h ", mod(timestampdiff(minute, s.liftOff, s.landing), 60), "m") as duration
    from flight f
    join airports aorigin on f.origin = aorigin.airportID
    join airports adestination on f.destination = adestination.airportID
    join schedule s on s.flightID = f.IATA
    where aorigin.IATA = %s
    and adestination.IATA = %s
    and date(s.liftOff) = %s
    order by s.liftOff
    """
    cursor.execute(query, (origin, destination, requestedDate))
    rows = cursor.fetchall()
    flights = [dict(row) for row in rows]
    if flights:
      return flights

    new_schedule = check_schedule_exists(cursor, origin, destination, requestedDate)
    if new_schedule is None:
        return []

    # This accounts for partial matches
    cursor.execute(query, (f'%{origin}%', f'%{destination}%', f'{requestedDate}'))
    rows = cursor.fetchall()
    flights = [dict(row) for row in rows]
    return flights

# Helper method for matching schedules
def check_schedule_exists(cursor, origin, destination, requestedDate):
    query = """
    select f.IATA, s.liftOff, s.landing from flight f
    join schedule s on s.flightID = f.IATA
    join airports aorigin on aorigin.airportID = f.origin
    join airports adestination on adestination.airportID = f.destination
    where aorigin.IATA = %s and adestination.IATA = %s
    order by s.liftOff limit 1
    """
    cursor.execute(query, (origin, destination))
    row = cursor.fetchone()
    print("CHECK TEMPLATE:", origin, destination, requestedDate)
    print("TEMPLATE ROW:", row)
    if row is None:
        return None
    return create_schedules(cursor, row, requestedDate)

# No idea how datetime import works, we ball fr. Other than that, just like the name suggests, create a new schedule and insert into the schedule table
def create_schedules(cursor, row, requestedDate):
    liftOff = row["liftOff"]
    landing = row["landing"]
    # Don't ask me how this specific part works
    requestedDate = datetime.datetime.strptime(str(requestedDate), "%Y-%m-%d")
    newLiftOff = requestedDate.replace(hour=liftOff.hour, minute=liftOff.minute, second=liftOff.second)
    newLanding = requestedDate.replace(hour=landing.hour, minute=landing.minute, second=landing.second)
    if newLanding <= newLiftOff:
        newLanding = newLanding + timedelta(days=1)

    queryTwo = """
    select scheduleID from schedule where flightID = %s and liftOff = %s and landing = %s
    """

    cursor.execute(queryTwo, (row["IATA"], newLiftOff, newLanding))
    exists = cursor.fetchone()
    if exists is not None:
        return exists["scheduleID"]
    
    queryThree = """
    insert into schedule (flightID, liftOff, landing) values (%s, %s, %s)
    """
    cursor.execute(queryThree, (row["IATA"], newLiftOff, newLanding))
    return cursor.lastrowid
