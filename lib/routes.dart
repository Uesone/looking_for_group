import 'screens/welcome/welcome_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/register/register_screen.dart';
import 'screens/user_dashboard_screen/user_dashboard_screen.dart';
import 'screens/feed/feed_screen.dart';
import 'screens/profile_screen/profile_screen.dart';
import 'screens/event_create/event_create_screen.dart'; // Nuova importazione
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> appRoutes = {
  '/welcome': (context) => const WelcomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/feed': (context) => const FeedScreen(),
  '/user_dashboard': (context) => const UserDashboardScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/event_create': (context) => const EventCreateScreen(), // Nuova route
};
