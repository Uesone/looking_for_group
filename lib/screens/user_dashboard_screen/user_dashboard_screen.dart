import 'package:flutter/material.dart';
import '../../models/user_dashboard.dart';
import '../../services/user_service.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  late Future<UserDashboard> _futureDashboard;

  @override
  void initState() {
    super.initState();
    _futureDashboard = UserService().fetchDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Utente"), centerTitle: true),
      body: FutureBuilder<UserDashboard>(
        future: _futureDashboard,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Nessun dato trovato.'));
          }

          final user = snapshot.data!;
          final int xpNext = (user.level * 100);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Avatar + Nome utente
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundImage:
                          user.profileImage != null &&
                              user.profileImage!.isNotEmpty
                          ? NetworkImage(user.profileImage!)
                          : const AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                      backgroundColor: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.username,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(user.city, style: TextStyle(color: Colors.grey[600])),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                    // Se vuoi anche la bio:
                    if (user.bio != null && user.bio!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          user.bio!,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // XP e livello
              Card(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Livello ${user.level}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: user.xp / (xpNext == 0 ? 1 : xpNext),
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text("XP: ${user.xp} / $xpNext"),
                    ],
                  ),
                ),
              ),
              // Statistiche
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statTile(Icons.event, 'Creati', user.eventsCreated ?? 0),
                    _statTile(
                      Icons.group,
                      'Partecipati',
                      user.eventsJoined ?? 0,
                    ),
                    _statTile(
                      Icons.star,
                      'Feedback',
                      user.feedbackReceived ?? 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Azioni rapide
              Text(
                "Azioni rapide",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _actionButton(
                icon: Icons.person,
                label: "Profilo pubblico",
                color: Colors.deepPurple,
                onTap: () {
                  // PASSA user.id come arguments e controlla che non sia null/empty
                  if (user.id.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      '/profile',
                      arguments: user.id,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ID utente non disponibile!'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              _actionButton(
                icon: Icons.add_circle,
                label: "Crea evento",
                color: Colors.green,
                onTap: () {
                  Navigator.pushNamed(context, '/event_create');
                },
              ),
              const SizedBox(height: 8),
              _actionButton(
                icon: Icons.event_note,
                label: "I miei eventi",
                color: Colors.blue,
                onTap: () {
                  Navigator.pushNamed(context, '/my_events');
                },
              ),
              const SizedBox(height: 8),
              _actionButton(
                icon: Icons.reviews,
                label: "Feedback ricevuti",
                color: Colors.orange,
                onTap: () {
                  Navigator.pushNamed(context, '/feedback');
                },
              ),
              const SizedBox(height: 8),
              _actionButton(
                icon: Icons.logout,
                label: "Logout",
                color: Colors.red,
                onTap: () {
                  // Logica logout qui!
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statTile(IconData icon, String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, size: 30, color: Colors.blueGrey),
          const SizedBox(height: 5),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
