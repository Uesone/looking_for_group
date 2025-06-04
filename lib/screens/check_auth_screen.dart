import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckAuthScreen extends StatefulWidget {
  const CheckAuthScreen({super.key});

  @override
  State<CheckAuthScreen> createState() => _CheckAuthScreenState();
}

class _CheckAuthScreenState extends State<CheckAuthScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
