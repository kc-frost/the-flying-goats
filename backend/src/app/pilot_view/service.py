from app.db import get_connection

# Collects from the view I made pilotSchedule, check db for returns
def get_pilot_schedule():
    conn = get_connection()
    query = """select * from pilotScheduleInfo"""
    with conn.cursor() as cursor:
        try:
            cursor.execute(query)
            result = cursor.fetchall()
            return {"success": True, 
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}
    return {"success": True, "data": result}
