import 'package:flutter/material.dart';
import '../../models/user_public_profile.dart';
import '../../services/user_service.dart';
import '../../utils/user_utils.dart'; // <--- import util per getUserId()

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<String?> _getUserId(BuildContext context) async {
    // 1. Prova a prenderlo dagli arguments della route
    final Object? arg = ModalRoute.of(context)?.settings.arguments;
    if (arg != null && arg is String && arg.isNotEmpty) {
      return arg;
    }
    // 2. Se non arriva dagli arguments, leggilo da shared preferences
    return await getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserId(context),
      builder: (context, userIdSnapshot) {
        if (userIdSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (!userIdSnapshot.hasData ||
            userIdSnapshot.data == null ||
            userIdSnapshot.data!.isEmpty) {
          return const Scaffold(body: Center(child: Text('User ID mancante!')));
        }

        final userId = userIdSnapshot.data!;

        return Scaffold(
          appBar: AppBar(title: const Text('Profilo utente')),
          body: FutureBuilder<UserPublicProfile>(
            future: UserService().fetchUserPublicProfile(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Errore: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('Profilo non trovato.'));
              }

              final user = snapshot.data!;

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(height: 18),
                      Text(
                        user.username,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        user.city,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (user.bio != null && user.bio!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            user.bio!,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "Livello ${user.level}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
