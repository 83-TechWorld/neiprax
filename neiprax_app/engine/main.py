from fastapi import FastAPI
from brain import NeipraxBrain
from karoke import create_karaoke
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
import os
import random
import sqlite3

app = FastAPI()
# CRITICAL: Allow Flutter Web to talk to Python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
brain = NeipraxBrain()
os.makedirs("assets/mp3", exist_ok=True)
app.mount("/songs", StaticFiles(directory="../assets/mp3"), name="songs")

@app.get("/get-song-info")
def get_song_info():
    try:
        conn = sqlite3.connect('neiprax.db')
        cursor = conn.cursor()
        
        # Get a random song that has already been processed by your AI enricher
        cursor.execute("SELECT title, emotion, meaning_ta, meaning_en FROM songs WHERE emotion IS NOT NULL")
        songs = cursor.fetchall()
        conn.close()

        if not songs:
            return {
                "title": "NO ANALYZED SONGS",
                "emotion": "default",
                "meaning_ta": "டேட்டாபேஸில் பாடல்கள் இல்லை",
                "meaning_en": "No songs found in database."
            }

        selected = random.choice(songs)
        return {
            "title": selected[0],
            "emotion": selected[1],
            "meaning_ta": selected[2],
            "meaning_en": selected[3]
        }
    except Exception as e:
        return {"error": str(e)}

@app.get("/explain")
async def explain(lyrics: str, query: str):
    explanation = brain.explain_lyric(lyrics, query)
    return {"status": "success", "explanation": explanation}

@app.get("/karaoke")
async def get_karaoke(path: str):
    # Triggers the Demucs process we built in Phase 2
    karaoke_path = create_karaoke(path)
    return {"karaoke_url": karaoke_path}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)