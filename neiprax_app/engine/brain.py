import requests
import sqlite3

class NeipraxBrain:
    def __init__(self, model="mervinpraison/llama3.2-tamil"):
        self.url = "http://localhost:11434/api/chat"
        self.model = model

    def explain_lyric(self, lyrics, context_query):
        # The System Prompt is key to getting the right 'emotion'
        prompt = f"""
        You are NEIPRAX, an emotional music agent. 
        Analyze these lyrics: "{lyrics}"
        The user asks: "{context_query}"
        Explain the emotional meaning deeply in both English and Tamil.
        Keep it poetic but clear.
        """
        
        payload = {
            "model": self.model,
            "messages": [{"role": "user", "content": prompt}],
            "stream": False
        }
        
        response = requests.post(self.url, json=payload)
        return response.json()['message']['content']
    def get_explanation_from_db_or_ai(self, song_id, lyrics, query):
        conn = sqlite3.connect('neiprax.db')
        cursor = conn.cursor()
        
        # 1. Check if we already have this meaning
        cursor.execute("SELECT meaning_en, meaning_ta FROM songs WHERE title=?", (lyrics[:20],))
        result = cursor.fetchone()
        
        if result:
            conn.close()
            return f"EN: {result[0]}\nTA: {result[1]}"
        
        # 2. If not found, call Ollama (Your Tamil Model)
        # Note: Llama 3.2 Tamil can still explain English songs perfectly!
        explanation = self.call_ollama_brain(lyrics, query)
        
        # 3. Save for next time
        cursor.execute("INSERT OR REPLACE INTO songs (title, meaning_en) VALUES (?, ?)", (lyrics[:20], explanation))
        conn.commit()
        conn.close()
        
        # Removed the misplaced return statement

    def call_ollama_brain(self, lyrics, query):
        # Placeholder for the actual implementation of the call to the model
        return f"Generated explanation for: {lyrics} with query: {query}"
    # Removed misplaced return statement

# Test it:
# brain = NeipraxBrain()
# print(brain.explain_lyric("Unna nenacha nenju kuzhiyila...", "What is the emotion here?"))