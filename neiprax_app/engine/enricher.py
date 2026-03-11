import sqlite3
import requests

# Use your existing Brain logic
def get_ai_analysis(lyrics_snippet):
    url = "http://localhost:11434/api/generate"
    prompt = f"""
    Analyze these lyrics: "{lyrics_snippet}"
    1. Identify the primary emotion (one word like Happy, Sad, Romantic).
    2. Give a 1-sentence English meaning.
    3. Give a 1-sentence Tamil meaning.
    Format your response exactly like this:
    EMOTION: [Emotion]
    ENGLISH: [Meaning]
    TAMIL: [Meaning]
    """
    
    payload = {
        "model": "mervinpraison/llama3.2-tamil",
        "prompt": prompt,
        "stream": False
    }
    
    try:
        response = requests.post(url, json=payload)
        return response.json()['response']
    except:
        return None

def enrich_database():
    conn = sqlite3.connect('neiprax.db')
    cursor = conn.cursor()

    # Find songs that don't have analysis yet
    cursor.execute("SELECT id, title FROM songs WHERE emotion IS NULL")
    songs = cursor.fetchall()

    if not songs:
        print("✓ All songs already have AI analysis!")
        return

    print(f"--- Processing {len(songs)} songs with Ollama ---")

    for song_id, title in songs:
        print(f"Processing: {title}...")
        
        # In a real app, we'd extract lyrics. For now, we use the title to get a general vibe
        analysis = get_ai_analysis(title)
        
        if analysis:
            # Simple parsing of the AI response
            try:
                emotion = analysis.split("EMOTION:")[1].split("\n")[0].strip()
                eng = analysis.split("ENGLISH:")[1].split("\n")[0].strip()
                tam = analysis.split("TAMIL:")[1].split("\n")[0].strip()

                cursor.execute("""
                    UPDATE songs 
                    SET emotion = ?, meaning_en = ?, meaning_ta = ? 
                    WHERE id = ?
                """, (emotion, eng, tam, song_id))
                conn.commit()
                print(f"✓ Saved analysis for {title}")
            except:
                print(f"✗ Failed to parse AI response for {title}")

    conn.close()
    print("--- Enrichment Complete ---")

if __name__ == "__main__":
    enrich_database()