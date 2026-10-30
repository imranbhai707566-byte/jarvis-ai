import 'package:flutter/material.dart';

void main() {
  runApp(const JarvisApp());
}

class JarvisApp extends StatelessWidget {
  const JarvisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JARVIS AI',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: AppBar(
        title: const Text('JARVIS AI'),
        backgroundColor: const Color(0xFF10243A),
      ),
      body: const Center(
        child: Text(
          'Hello! I am JARVIS AI.',
          style: TextStyle(
            fontSize: 24,
            color: Colors.cyanAccent,
          ),
        ),
      ),
    );
  }
}
