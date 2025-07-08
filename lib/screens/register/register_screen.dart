import 'package:flutter/material.dart';
import '../../models/register_request.dart';
import '../../services/auth_service.dart';
import '../feed/feed_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final req = RegisterRequest(
      username: _username,
      email: _email,
      password: _password,
    );
    final success = await AuthService().register(req);
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
        _error = "Registrazione fallita. Username o email già usati?";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrati')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  onChanged: (val) => _username = val,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Richiesto' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (val) => _email = val,
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
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: const Text('Registrati'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
