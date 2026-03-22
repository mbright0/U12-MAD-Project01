import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const Soundscapes());
}

class Soundscapes extends StatefulWidget {
  const Soundscapes({super.key});

  @override
  State<Soundscapes> createState() => _SoundscapesState();
}

class _SoundscapesState extends State<Soundscapes> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soundscapes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}
