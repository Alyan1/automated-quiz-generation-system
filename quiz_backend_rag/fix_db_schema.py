from sqlalchemy import text
from api.database import engine

def fix_schema():
    with engine.connect() as conn:
        print("Connected to database.")
        
        # 1. Fix Attempts table
        try:
            print("Attempting to add teacher_feedback to attempts...")
            conn.execute(text("ALTER TABLE attempts ADD COLUMN teacher_feedback TEXT;"))
            print("SUCCESS: Added teacher_feedback.")
        except Exception as e:
            if "Duplicate column" in str(e) or "1060" in str(e):
               print("teacher_feedback already exists.")
            else:
               print(f"FAILED to add teacher_feedback: {e}")

        try:
            print("Attempting to add submitted_at to attempts...")
            conn.execute(text("ALTER TABLE attempts ADD COLUMN submitted_at TIMESTAMP NULL;"))
            print("SUCCESS: Added submitted_at.")
        except Exception as e:
            if "Duplicate column" in str(e) or "1060" in str(e):
               print("submitted_at already exists.")
            else:
               print(f"FAILED to add submitted_at: {e}")

        # 2. Fix Assignments table (just in case)
        try:
            print("Attempting to add assigned_at to assignments...")
            conn.execute(text("ALTER TABLE assignments ADD COLUMN assigned_at TIMESTAMP NULL;"))
            print("SUCCESS: Added assigned_at.")
        except Exception as e:
            if "Duplicate column" in str(e) or "1060" in str(e):
               print("assigned_at already exists.")
            else:
               print(f"FAILED to add assigned_at: {e}")
               
        conn.commit()
        print("Schema update check complete.")

if __name__ == "__main__":
    fix_schema()
