import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameOrEmailController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _loading = false;
  String? _error;

  void _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _error = null;
      });

      final success = await _authService.login(
        _usernameOrEmailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      if (success) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        setState(() {
          _error = "Login fallito. Controlla le credenziali.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameOrEmailController,
                decoration: const InputDecoration(
                  labelText: 'Username o Email',
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Campo obbligatorio'
                    : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty
                    ? 'Campo obbligatorio'
                    : null,
              ),
              const SizedBox(height: 20),
              if (_loading) const CircularProgressIndicator(),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loading ? null : _submitLogin,
                child: const Text('Accedi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
