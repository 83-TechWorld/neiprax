import whisper_timestamped as whisper
import json

def get_lyric_timestamp(audio_path, target_lyric):
    # Load model on your M4 GPU
    model = whisper.load_model("tiny", device="mps") 
    audio = whisper.load_audio(audio_path)
    
    # Get word-level timestamps
    result = whisper.transcribe(model, audio, language="en") # Or "ta" for Tamil
    
    for segment in result['segments']:
        for word in segment['words']:
            if target_lyric.lower() in word['text'].lower():
                return word['start'], word['end']
    return None