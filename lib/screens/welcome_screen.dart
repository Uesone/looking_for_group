import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Looking For Group',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Trova persone per attività reali vicino a te!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text('Accedi'),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('Registrati'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
