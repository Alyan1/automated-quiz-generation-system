
import sys
import os
from sqlalchemy import text

# Add api directory to path so imports work
current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(current_dir)

from api.database import engine

def add_column():
    print("Adding 'is_published' column to quizzes table...")
    with engine.connect() as conn:
        try:
            conn.execute(text("ALTER TABLE quizzes ADD COLUMN is_published BOOLEAN DEFAULT FALSE"))
            conn.commit()
            print("Column added successfully.")
        except Exception as e:
            print(f"Error adding column (might already exist): {e}")

if __name__ == "__main__":
    add_column()
