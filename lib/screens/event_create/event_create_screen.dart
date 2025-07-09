import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '.././../services/event_create_service.dart';
import '.././../services/location_device.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({super.key});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _activityController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController();
  final _notesController = TextEditingController();
  final _maxParticipantsController = TextEditingController(text: "5");
  String _joinMode = 'AUTO';
  DateTime? _date;
  double? _latitude;
  double? _longitude;

  bool _loading = false;
  Future<String?> getCityFromLatLng(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ??
            placemarks.first.subAdministrativeArea;
      }
    } catch (_) {}
    return null;
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _loading = true);
    try {
      Position pos = await getCurrentPosition();
      String? cityName = await getCityFromLatLng(pos.latitude, pos.longitude);

      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
        _locationController.text =
            'Lat: ${pos.latitude.toStringAsFixed(5)}, Lon: ${pos.longitude.toStringAsFixed(5)}';
        _cityController.text = cityName ?? "";
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore nel rilevamento posizione: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compila tutti i campi obbligatori!')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await EventCreateService().createEvent(
        title: _titleController.text.trim(),
        activityType: _activityController.text.trim(),
        location: _locationController.text.trim(),
        notes: _notesController.text.trim(),
        date: _date!,
        maxParticipants:
            int.tryParse(_maxParticipantsController.text.trim()) ?? 5,
        joinMode: _joinMode,
        latitude: _latitude,
        longitude: _longitude,
        city: _cityController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Errore creazione evento: $e')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crea nuovo evento")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titolo evento'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Richiesto' : null,
              ),
              TextFormField(
                controller: _activityController,
                decoration: const InputDecoration(labelText: 'Tipo attività'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Richiesto' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Luogo/Indirizzo',
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? 'Richiesto' : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.my_location),
                    tooltip: "Usa posizione attuale",
                    onPressed: _loading ? null : _useCurrentLocation,
                  ),
                ],
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Città'),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Note (opzionale)',
                ),
              ),
              TextFormField(
                controller: _maxParticipantsController,
                decoration: const InputDecoration(
                  labelText: 'Max partecipanti',
                ),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: _joinMode,
                items: const [
                  DropdownMenuItem(
                    value: "AUTO",
                    child: Text("Join automatico"),
                  ),
                  DropdownMenuItem(
                    value: "MANUAL",
                    child: Text("Join con approvazione"),
                  ),
                ],
                onChanged: (v) {
                  setState(() => _joinMode = v ?? "AUTO");
                },
                decoration: const InputDecoration(
                  labelText: "Modalità partecipazione",
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _date == null
                          ? "Seleziona data"
                          : "Data: ${_date!.day}/${_date!.month}/${_date!.year}",
                    ),
                  ),
                  TextButton(
                    child: const Text("Scegli data"),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(
                          const Duration(days: 1),
                        ),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 22),
              ElevatedButton.icon(
                onPressed: _loading ? null : _submit,
                icon: const Icon(Icons.check),
                label: const Text("Crea evento"),
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
