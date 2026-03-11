import os
import sqlite3
from mutagen.easyid3 import EasyID3
from mutagen.mp3 import MP3

def scan_assets_folder():
    # Path to your mp3 folder
    folder_path = '../assets/mp3' 
    db_path = 'neiprax.db'
    
    if not os.path.exists(folder_path):
        print(f"Error: Folder {folder_path} not found!")
        return

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    print(f"--- Scanning: {folder_path} ---")
    
    for file in os.listdir(folder_path):
        if file.endswith(".mp3"):
            full_path = os.path.abspath(os.path.join(folder_path, file))
            
            # Extract basic info from the filename first
            title = file.replace(".mp3", "")
            
            # Try to get real ID3 tags if they exist
            try:
                audio = MP3(full_path, id3=EasyID3)
                title = audio.get('title', [title])[0]
            except Exception:
                pass # Fallback to filename if no tags

            # Save to Database
            try:
                cursor.execute("""
                    INSERT OR IGNORE INTO songs (file_path, title) 
                    VALUES (?, ?)
                """, (full_path, title))
                print(f"✓ Added to DB: {title}")
            except Exception as e:
                print(f"Error saving {file}: {e}")

    conn.commit()
    conn.close()
    print("--- Scan Finished ---")

if __name__ == "__main__":
    scan_assets_folder()