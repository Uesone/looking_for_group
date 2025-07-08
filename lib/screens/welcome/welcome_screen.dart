import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import '../register/register_screen.dart';
// (dopo aggiungerai la RegisterScreen!)

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Looking For Group',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Trova subito nuovi amici e attività dal vivo!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Registrati'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
