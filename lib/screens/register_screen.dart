import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final authService = AuthService();
    final success = await authService.register(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _usernameController.text.trim(),
    );
    setState(() {
      _loading = false;
    });
    if (!mounted) return;
    if (success) {
      // Dopo registrazione, controlla se l'utente ha già la città
      final userService = UserService();
      final user = await userService.getCurrentUser();
      if (!mounted) return;
      if (user != null && (user['city'] == null || user['city'].isEmpty)) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } else {
      setState(() {
        _error = "Registrazione fallita, riprova.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrazione')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: "Username"),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Inserisci lo username' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Inserisci la mail' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Inserisci la password' : null,
                ),
                SizedBox(height: 24),
                if (_error != null)
                  Text(_error!, style: TextStyle(color: Colors.red)),
                if (_loading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _register();
                      }
                    },
                    child: Text('Registrati'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
