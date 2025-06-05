import 'package:flutter/material.dart';
import '../services/user_service.dart';

class EditProfileBottomSheet extends StatefulWidget {
  final String? initialUsername;
  final String? initialCity;
  final String? initialBio;
  final VoidCallback onProfileUpdated;

  const EditProfileBottomSheet({
    super.key,
    this.initialUsername,
    this.initialCity,
    this.initialBio,
    required this.onProfileUpdated,
  });

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController cityController;
  late TextEditingController bioController;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(
      text: widget.initialUsername ?? "",
    );
    cityController = TextEditingController(text: widget.initialCity ?? "");
    bioController = TextEditingController(text: widget.initialBio ?? "");
  }

  @override
  void dispose() {
    usernameController.dispose();
    cityController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final userService = UserService();
    final success = await userService.updateProfile(
      username: usernameController.text.trim(),
      city: cityController.text.trim(),
      bio: bioController.text.trim(),
    );
    setState(() {
      _loading = false;
    });
    if (!mounted) return;
    if (success) {
      widget.onProfileUpdated();
      Navigator.of(context).pop();
    } else {
      setState(() {
        _error = "Errore nell'aggiornamento del profilo.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Profile',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Username richiesto'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: bioController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  prefixIcon: Icon(Icons.info_outline),
                ),
              ),
              const SizedBox(height: 16),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _loading ? null : _saveProfile,
                    child: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
