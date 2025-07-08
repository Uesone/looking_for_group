import 'package:flutter/material.dart';
import '../../models/login_request.dart';
import '../../services/auth_service.dart';
import '../feed/feed_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _usernameOrEmail = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final req = LoginRequest(
      usernameOrEmail: _usernameOrEmail,
      password: _password,
    );
    final success = await AuthService().login(req);
    setState(() {
      _loading = false;
    });
    if (success) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FeedScreen()),
      );
    } else {
      setState(() {
        _error = "Login fallito. Controlla username o email e password!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username o Email',
                  ),
                  onChanged: (val) => _usernameOrEmail = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Richiesto' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  onChanged: (val) => _password = val,
                  obscureText: true,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Richiesto' : null,
                ),
                const SizedBox(height: 24),
                if (_error != null) ...[
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                ],
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) _submit();
                        },
                        child: const Text('Login'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
