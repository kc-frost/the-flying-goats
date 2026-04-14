from app.db import get_connection

def get_most_active_users():
    """Queries the database for the top 3 most active users, defined by the total amount of reservations they've made

    Returns:
        dict: A tuple of the top 3 most active users
    """    
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT COUNT(bookingNumber) `bookingAmount`, `userID`, `username`
                FROM `reservationticket`
                GROUP BY `userID`
                ORDER BY `bookingAmount` desc
                LIMIT 3
            """

            cursor.execute(query)
            rows = cursor.fetchall()

            if rows is None:
                return {"message": "no active users!"}

        except Exception as e:
            return {"error": str(e)}
        
        return rows
    
def get_longest_registered_users():
    """Get longest registered users, or the top 10 users who are registered with us the longest (in days)

    Returns:
        dict: Top 10 users who are registered the longest
    """    
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT `userID`, `username`, `registerLengthDays`, 
                RANK() over (ORDER BY `registerLengthDays` DESC) as `user_rank`
                FROM `userreservationsummary`
                LIMIT 10;
            """

            cursor.execute(query,)
            rows = cursor.fetchall()

            if rows is None:
                return {'message': 'no one is registered. thats crazy'}

        except Exception as e:
            return {'err': str(e)}
        
        return rows

def get_active_users_this_month():
    """Get amount of distinct users who made a reservation this month 

    Returns:
        dict: Number of distinct users who made a reservation this month
    """    
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT COUNT(DISTINCT(`userID`)) as `distinct_reservations_this_month`
                FROM `reservationticket`
                WHERE MONTH(`reservationDate`) = MONTH(CURDATE()) and YEAR(`departLiftOffDate`) = YEAR(CURDATE());
            """

            cursor.execute(query,)
            rows = cursor.fetchone()

            if rows is None:
                return {'message': 'no one made a reservation this month'}

        except Exception as e:
            return {'err': str(e)}
        
        return rows

def get_reservations_this_month():

    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT COUNT(*) as `monthly_reservations`
                FROM `reservationticket`
                WHERE MONTH(`reservationDate`) = MONTH(CURDATE())
                AND YEAR(`reservationDate`) = YEAR(CURDATE())
            """

            cursor.execute(query,)
            row = cursor.fetchone()

            if row is None:
                return {"message": "no reservations made this month"}

        except Exception as e:
            return {"err": str(e)}
        
        return row
    
def get_per_month_reservations():
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                SELECT MONTH(`reservationDate`) as `month`, COUNT(*) as `monthly_reservations`
                FROM `reservationticket`
                GROUP BY `month`
                ORDER BY `monthly_reservations` DESC;
            """

            cursor.execute(query)
            rows = cursor.fetchall()

            if rows is None:
                return {'message': 'no reservations at all this year. woah...'}
            
        except Exception as e:
            return {'err': str(e)}
        
        return rows
    
def get_top_staff_this_month():
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                select fname, lname, staffID, bookingCount,
                dense_rank() over (order by bookingCount desc) as staffRank
                from psinfomonthlycounts
                where departMonth = month(curdate())
                and departYear = year(curdate())
                order by bookingCount desc
                limit 3
            """

            cursor.execute(query)
            rows = cursor.fetchall()

            if rows is None:
                return {'message': 'no staff reservations this month'}

        except Exception as e:
            return {'err': str(e)}

        return rows

def get_total_cancellations():
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                select count(*) as total_cancellations
                from bookinghistory
                where bookingStatus = "Cancelled"
            """

            cursor.execute(query)
            row = cursor.fetchone()

            if row is None:
                return {'message': 'no cancellations found'}

        except Exception as e:
            return {'err': str(e)}

        return row

def get_total_cancellations_this_month():
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                select total_cancellations
                from bhcancellationmonthlycounts
                where deletionYear = year(curdate())
                and deletionMonth = month(curdate())
            """

            cursor.execute(query)
            row = cursor.fetchone()

            if row is None:
                return {'message': 'no cancellations this month'}

        except Exception as e:
            return {'err': str(e)}

        return row

def get_cancellations_this_month_by_category():
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                select cancellationCategory, total_cancellations
                from bhcancellationsbywhodoneit
                where deletionYear = year(curdate())
                and deletionMonth = month(curdate())
                order by total_cancellations desc
            """

            cursor.execute(query)
            rows = cursor.fetchall()

            if rows is None:
                return {'message': 'no cancellations this month'}

        except Exception as e:
            return {'err': str(e)}

        return rows

def get_total_reservations_this_year():
    conn = get_connection()

    with conn.cursor() as cursor:
        try:
            query = """
                select count(*) as yearly_reservations
                from reservationticket
                where year(reservationDate) = year(curdate())
            """

            cursor.execute(query)
            row = cursor.fetchone()

            if row is None:
                return {'message': 'no reservations this year'}

        except Exception as e:
            return {'err': str(e)}

        return row
