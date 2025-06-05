import 'package:flutter/material.dart';
import '../services/user_service.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _save() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final userService = UserService();
    final success = await userService.updateProfile(
      city: _cityController.text.trim(),
    );
    setState(() {
      _loading = false;
    });
    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _error = "Errore nel salvataggio. Riprova!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completa il profilo')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Per usare l'app inserisci la tua città:",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 24),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: "Città"),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Inserisci la città' : null,
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
                        _save();
                      }
                    },
                    child: Text('Salva e continua'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
