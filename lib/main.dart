import 'package:flutter/material.dart';
import 'screens/gallery_screen.dart';

void main() {
  runApp(const LiveWallsApp());
}

class LiveWallsApp extends StatelessWidget {
  const LiveWallsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveWalls',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFF06B6D4),
        ),
        fontFamily: '.SF Pro Text',
      ),
      home: const GalleryScreen(),
    );
  }
}
