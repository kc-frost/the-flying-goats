from app.db import get_connection
from flask_login import current_user

# Collects from the view I made pilotSchedule, check db for returns
def get_pilot_schedule():
    currentUserID = current_user.get_id()
    conn = get_connection()
    query = """select * from pilotscheduleinfo where staffid=%s"""
    with conn.cursor() as cursor:
        try:
            cursor.execute(query, (currentUserID,))
            rows = cursor.fetchall()
            result = []
            for row in rows:
                row_dict = dict(row)
                for key, value in row_dict.items():
                    if hasattr(value, 'total_seconds'):
                        total_seconds = int(value.total_seconds())
                        hours = total_seconds // 3600
                        minutes = (total_seconds % 3600) // 60
                        row_dict[key] = f"{hours:02d}:{minutes:02d}"
                result.append(row_dict)
            return {"success": True, 
                    "data": result}
        except Exception as e:
            return {"success": False, 
                    "error": str(e)}
