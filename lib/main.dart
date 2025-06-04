import 'package:flutter/material.dart';
import 'package:looking_for_group/screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/check_auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/complete_profile_screen.dart';

void main() {
  runApp(const LFGApp());
}

class LFGApp extends StatelessWidget {
  const LFGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Looking For Group',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CheckAuthScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/complete-profile': (context) => const CompleteProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
