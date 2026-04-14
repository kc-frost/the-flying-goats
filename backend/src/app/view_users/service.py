from app.db import get_connection

def get_user_data():
    conn = get_connection()
    query = "select * from userreservationsummary"
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            result = cursor.fetchall()
            return {"success": True, 
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}

def search_user_data(searchKey):
    conn = get_connection()
    query = "select * from userreservationsummary where cast(userID as char) = %s or email = %s or username = %s"
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (searchKey, searchKey, searchKey))
            result = cursor.fetchall()
            return {"success": True, "data": result}
        except Exception as e:
            return {"success": False, "error": str(e)}
