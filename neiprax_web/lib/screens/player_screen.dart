import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'dart:convert';
import '../widgets/cassette_widget.dart';
import '../widgets/walkman_button.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  // --- 1. State Variables ---
  bool isPlaying = false;
  bool isThinking = false;
  String statusText = "INSERT CASSETTE";
  String currentEmotion = "default";
  String tamilMeaning = "";
  final AudioPlayer _audioPlayer = AudioPlayer();

  // --- 2. Dynamic Color Logic (The "Emotion" Skin) ---
  Color getWalkmanColor() {
    switch (currentEmotion.toLowerCase()) {
      case 'happy':
      case 'energetic':
        return const Color(0xFFFFD700); // Sony Sports Yellow
      case 'sad':
      case 'calm':
      case 'peaceful':
        return const Color(0xFF003399); // Original Royal Blue
      case 'romantic':
      case 'vivid':
        return const Color(0xFFD81B60); // Limited Edition Pink
      default:
        return const Color(0xFFC0C0C0); // Classic Brushed Silver
    }
  }

@override
void dispose() {
  _audioPlayer.dispose();
  super.dispose();
}
  // --- 3. Communication with Python Backend ---
Future<void> handlePlay() async {
  if (isPlaying) {
    await _audioPlayer.pause();
    setState(() => isPlaying = false);
    return;
  }

  setState(() {
    isThinking = true;
    statusText = "FETCHING AUDIO...";
  });

  try {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/get-song-info'));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      // Construct the URL exactly like your browser test
      // Ensure your DB 'title' matches the actual filename in assets/mp3
      String filename = data['title']; 
      if (!filename.endsWith(".mp3")) filename += ".mp3";
      
      String audioUrl = "http://127.0.0.1:8000/songs/$filename";
      
      // Load and Play
      await _audioPlayer.setUrl(audioUrl);
      _audioPlayer.play();

      setState(() {
        isPlaying = true;
        isThinking = false;
        currentEmotion = data['emotion'] ?? "default";
        statusText = data['title']?.toUpperCase() ?? "PLAYING";
        tamilMeaning = data['meaning_ta'] ?? "";
      });
    }
  } catch (e) {
    print("Audio Error: $e");
    setState(() {
      isThinking = false;
      statusText = "LOAD FAILED";
    });
  }
}
  @override
  Widget build(BuildContext context) {
    final bodyColor = getWalkmanColor();

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: bodyColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bodyColor, bodyColor.withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),
              
              // Branding
              Text("NEIPRAX", style: TextStyle(
                color: Colors.black.withOpacity(0.3),
                letterSpacing: 8,
                fontSize: 22,
                fontWeight: FontWeight.w900
              )),

              const Spacer(),

              // Cassette Window (Recessed look without "inset" parameter)
              Container(
                width: 320,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F0F),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white24, width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10)
                  ],
                ),
                child: Center(
                  child: CassetteWidget(isPlaying: isPlaying), 
                ),
              ),

              const SizedBox(height: 25),

              // LCD Status Screen
              Container(
                width: 280,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      statusText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'Courier', // Ensure this matches your pubspec.yaml
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    if (tamilMeaning.isNotEmpty) ...[
                      const Divider(color: Colors.green, height: 20, thickness: 0.5),
                      Text(
                        tamilMeaning,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.green, fontSize: 13),
                      ),
                    ]
                  ],
                ),
              ),

              const Spacer(),

              // Physical Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WalkmanButton(
                    icon: Icons.stop, 
                    color: Colors.grey[400], 
                    onTap: () => setState(() => isPlaying = false)
                  ),
                  const SizedBox(width: 20),
                  WalkmanButton(
                    icon: isPlaying ? Icons.pause : Icons.play_arrow, 
                    color: Colors.orange[400], 
                    onTap: handlePlay
                  ),
                  const SizedBox(width: 20),
                  WalkmanButton(
                    icon: Icons.mic, 
                    color: Colors.red[400], 
                    onTap: () => print("Listening...")
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}