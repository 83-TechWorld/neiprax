import sqlite3

def init_db():
    # This creates the file 'neiprax.db' if it doesn't exist
    conn = sqlite3.connect('neiprax.db')
    cursor = conn.cursor()

    # Create table for songs and their AI-generated metadata
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS songs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_path TEXT UNIQUE,
            title TEXT,
            emotion TEXT,        -- e.g., 'Happy', 'Melancholic'
            meaning_en TEXT,     -- English explanation
            meaning_ta TEXT,     -- Tamil explanation
            is_karaoke_ready INTEGER DEFAULT 0
        )
    ''')

    conn.commit()
    conn.close()
    print("✓ neiprax.db initialized successfully.")

if __name__ == "__main__":
    init_db()