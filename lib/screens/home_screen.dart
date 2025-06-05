import 'package:flutter/material.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _city;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final userService = UserService();
    final user = await userService.getCurrentUser();
    setState(() {
      _city = user != null ? user['city'] : null;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
              await Navigator.pushNamed(context, '/profile');
              _fetchUser(); // Aggiorna dopo eventuali cambi profilo!
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_city == null || _city!.isEmpty)
            MaterialBanner(
              content: Text(
                'Aggiungi la tua città per trovare gruppi nella tua zona!',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/complete-profile',
                    ).then((_) => _fetchUser());
                  },
                  child: Text('Completa profilo'),
                ),
              ],
            ),
          Expanded(
            child: Center(
              child: Text('Home Screen\n(City: ${_city ?? "Non impostata"})'),
            ),
          ),
        ],
      ),
    );
  }
}
