import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/edit_profile_bottom_sheet.dart'; // <-- aggiungi questo import

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? _user;
  bool _loading = true;

  // Controllers per editing (usati solo nel bottom sheet)
  final _bioController = TextEditingController();
  final _cityController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final userService = UserService();
    final user = await userService.getCurrentUser();
    setState(() {
      _user = user;
      _loading = false;
      _bioController.text = user?['bio'] ?? '';
      _cityController.text = user?['city'] ?? '';
      _usernameController.text = user?['username'] ?? '';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
  }

  void _showEditProfile() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => EditProfileBottomSheet(
        initialUsername: _user?['username'] ?? "",
        initialCity: _user?['city'] ?? "",
        initialBio: _user?['bio'] ?? "",
        onProfileUpdated: _fetchUser,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        surface: const Color(0xFF23272A),
        primary: const Color(0xFF5865F2),
        secondary: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF23272A),
    );

    if (_loading) {
      return Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(title: const Text('User Profile')),
          body: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final username = _user?['username'] ?? '';
    final email = _user?['email'] ?? '';
    final city = _user?['city'] ?? '';
    final bio = _user?['bio'] ?? '';

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          backgroundColor: const Color(0xFF23272A),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: _showEditProfile,
              tooltip: "Edit Profile",
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: _logout,
              tooltip: "Logout",
            ),
          ],
        ),
        body: Center(
          child: Card(
            color: const Color(0xFF2C2F33),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF5865F2),
                    child: Text(
                      username.isNotEmpty ? username[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    '@$username',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    email,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_city,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        city.isNotEmpty ? city : 'No city set',
                        style: TextStyle(
                          color: city.isNotEmpty
                              ? Colors.white
                              : Colors.redAccent,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Bio:',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      bio.isNotEmpty
                          ? bio
                          : 'No bio set. Tap the pencil to add one!',
                      style: TextStyle(
                        color: bio.isNotEmpty
                            ? Colors.white
                            : Colors.grey.shade500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit profile'),
                    onPressed: _showEditProfile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
