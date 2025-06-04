import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/check_auth_screen.dart';
import '/screens/home_screen.dart'; // schermata dopo login (puoi cambiarla più avanti)

void main() {
  runApp(LFGApp());
}

class LFGApp extends StatelessWidget {
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
        '/': (context) => CheckAuthScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        // aggiungerai altre schermate qui (es. user_profile_screen)
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
