import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_profile_update.dart';
import '../../services/user_service.dart';
import '../../services/location_device.dart'; // <-- Import SOLO la funzione!
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  final String initialUsername;
  final String initialCity;
  final String? initialBio;
  final String? initialProfileImage;

  const EditProfileScreen({
    super.key,
    required this.initialUsername,
    required this.initialCity,
    this.initialBio,
    this.initialProfileImage,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _cityController;
  late TextEditingController _bioController;

  File? _selectedImage;
  String? _uploadedImageUrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.initialUsername);
    _cityController = TextEditingController(text: widget.initialCity);
    _bioController = TextEditingController(text: widget.initialBio ?? "");
    _uploadedImageUrl = widget.initialProfileImage;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _cityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  /// PICK IMAGE dalla galleria
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  /// SALVA PROFILO
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
    });

    try {
      // Upload image first (if changed)
      String? imageUrl = _uploadedImageUrl;
      if (_selectedImage != null) {
        imageUrl = await UserService().uploadProfileImage(_selectedImage!);
        if (!mounted) return;
      }

      final update = UserProfileUpdate(
        username: _usernameController.text.trim(),
        city: _cityController.text.trim(),
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        // latitude: ...,
        // longitude: ...,
      );

      await UserService().updateUserProfile(update);
      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      // Torna indietro passando anche la nuova immagine, se aggiornata
      Navigator.of(context).pop({
        "username": _usernameController.text.trim(),
        "city": _cityController.text.trim(),
        "bio": _bioController.text.trim(),
        "profileImage": imageUrl,
      });

      // Mostra conferma SOLO se ancora montato
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profilo aggiornato!')));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Errore: ${e.toString()}')));
    }
  }

  /// --- AUTOFILL CITTÀ tramite GEOLOCALIZZAZIONE ---
  Future<void> _autofillCity() async {
    try {
      // 1. Ottieni posizione
      final position = await getCurrentPosition(); // <-- Funzione diretta!
      if (!mounted) return;
      // 2. Reverse geocoding con Nominatim (OpenStreetMap)
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}',
      );
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'LookingForGroupApp', // Importante per evitare blocchi!
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final city =
            data['address']['city'] ??
            data['address']['town'] ??
            data['address']['village'] ??
            data['address']['municipality'] ??
            '';
        if (city.isNotEmpty) {
          setState(() {
            _cityController.text = city;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Città trovata: $city")));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Città non trovata!")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Errore nella geolocalizzazione.")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Errore: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifica profilo')),
      body: _saving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    /// IMMAGINE PROFILO
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (_uploadedImageUrl != null &&
                                      _uploadedImageUrl!.isNotEmpty
                                  ? NetworkImage(_uploadedImageUrl!)
                                  : const AssetImage(
                                          'assets/default_avatar.png',
                                        )
                                        as ImageProvider),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 22,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    /// USERNAME
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Username obbligatorio'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    /// CITTÀ CON AUTOFILL GEO
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cityController,
                            decoration: const InputDecoration(
                              labelText: 'Città',
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Città obbligatoria'
                                : null,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.my_location),
                          tooltip: 'Rileva città',
                          onPressed: _autofillCity,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// BIO
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(labelText: 'Bio'),
                      minLines: 2,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),

                    /// SALVA
                    ElevatedButton.icon(
                      onPressed: _saving ? null : _saveProfile,
                      icon: const Icon(Icons.save),
                      label: const Text('Salva'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
