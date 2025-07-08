import 'package:flutter/material.dart';
import 'screens/welcome/welcome_screen.dart';

void main() {
  runApp(const LFGApp());
}

class LFGApp extends StatelessWidget {
  const LFGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Looking For Group',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LFG App')),
      body: const Center(
        child: Text(
          'Benvenuto in LFG!\nProssimamente il feed eventi qui 🎉',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
