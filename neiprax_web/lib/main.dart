import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/player_screen.dart';

void main() {
  // ProviderScope is required for Riverpod state management
  runApp(const ProviderScope(child: NeipraxApp()));
}

class NeipraxApp extends StatelessWidget {
  const NeipraxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NEIPRAX',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFC0C0C0), // Sony Silver
        textTheme: GoogleFonts.orbitronTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      // This loads the Sony Walkman UI we built
      home: const PlayerScreen(),
    );
  }
}