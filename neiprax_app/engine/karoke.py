import subprocess
import os

def create_karaoke(song_path):
    # --two-stems=vocals splits it into 'vocals' and 'no_vocals' (Instrumental)
    # -d mps uses your Mac's Neural Engine/GPU
    command = [
        "demucs", 
        "--two-stems", "vocals", 
        "-d", "mps", 
        song_path, 
        "-o", "output/karaoke"
    ]
    
    print(f"Generating Karaoke for: {os.path.basename(song_path)}...")
    subprocess.run(command)
    
    # The output will be in: output/karaoke/htdemucs/[song_name]/no_vocals.wav
    return f"output/karaoke/htdemucs/{os.path.basename(song_path).split('.')[0]}/no_vocals.wav"