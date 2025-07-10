import 'package:flutter/material.dart';
import '../../models/user_public_profile.dart';
import '../../services/user_service.dart';
import '../../utils/user_utils.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userId;
  Future<UserPublicProfile>? _futureProfile;
  String? myUserId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initUser();
  }

  Future<void> _initUser() async {
    // Ricava userId (route arg o prefs)
    final Object? arg = ModalRoute.of(context)?.settings.arguments;
    final String? id = (arg != null && arg is String && arg.isNotEmpty)
        ? arg
        : await getUserId();

    if (id == null || id.isEmpty) {
      setState(() {
        userId = null;
        _futureProfile = null;
      });
      return;
    }

    final String? currentUser = await getUserId();

    setState(() {
      userId = id;
      myUserId = currentUser;
      _futureProfile = UserService().fetchUserPublicProfile(id);
    });
  }

  Future<void> _refreshProfile() async {
    if (userId != null) {
      setState(() {
        _futureProfile = UserService().fetchUserPublicProfile(userId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(body: Center(child: Text('User ID mancante!')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profilo utente')),
      body: FutureBuilder<UserPublicProfile>(
        future: _futureProfile,
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
                  // Immagine profilo
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
                  // Username
                  Text(
                    user.username,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // Città
                  Text(user.city, style: TextStyle(color: Colors.grey[600])),
                  // BIO (opzionale)
                  if (user.bio != null && user.bio!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        user.bio!,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  // GEO (lat/lon) - Mostra solo se disponibili!
                  if (user.latitude != null && user.longitude != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Lat: ${user.latitude!.toStringAsFixed(5)}, Lon: ${user.longitude!.toStringAsFixed(5)}",
                        style: TextStyle(
                          color: Colors.blueGrey[700],
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Pulsante modifica profilo SOLO se è il proprio profilo
                  if (userId == myUserId)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text("Modifica profilo"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        minimumSize: const Size.fromHeight(42),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              initialUsername: user.username,
                              initialCity: user.city,
                              initialBio: user.bio,
                              initialProfileImage: user.profileImage,
                              initialLatitude:
                                  user.latitude, // <--- aggiungi questi!
                              initialLongitude:
                                  user.longitude, // <--- e questi!
                            ),
                          ),
                        );
                        // Dopo modifica, aggiorna il profilo pubblico
                        if (result != null) {
                          await _refreshProfile();
                        }
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
