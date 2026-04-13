from datetime import timedelta

""" For now we're going to ASSUME that the user exists becauseee I don't wanna prevent insertion onto reservation based on "user doesn't exist" when we only got like 2 users and such, and I don't know how users is lookin
So I'ma add that validation later (tomorrow), I'll explain more through messages"""
def get_reservations(conn):
    # user_id = data['userID']
    # userExistsQuery = "select * from `users` where userID=%s"
    # with conn.cursor() as cursor:
    #     cursor.execute(userExistsQuery, (user_id,))
    #     userExists = cursor.fetchone()

    """ 
    getting data from reservationticket view 
    """
    query = """ 
    select * from reservationticket
    """
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            result = cursor.fetchall()

            for row in result:
                for key in row:
                    if isinstance(row[key], timedelta):
                        row[key] = str(row[key])
                        
            return {"success": True, 
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}
    return {"success": True, "data": result}
