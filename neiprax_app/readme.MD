brew install portaudio sqlite3 ffmpeg

python3 -m venv venv
source venv/bin/activate

pip install whisper-timestamped
pip install -U demucs