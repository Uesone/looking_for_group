import 'package:flutter/material.dart';
import '../../services/event_create_service.dart';

class EventCreateScreen extends StatefulWidget {
  final VoidCallback? onEventCreated;

  const EventCreateScreen({super.key, this.onEventCreated});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _activityType = '';
  String _location = '';
  String? _notes;
  DateTime? _date;
  int _maxParticipants = 5;
  String _joinMode = 'AUTO';

  bool _loading = false;
  String? _error;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_date == null) {
      setState(() => _error = 'Scegli una data');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await EventCreateService().createEvent(
        title: _title,
        activityType: _activityType,
        location: _location,
        notes: _notes,
        date: _date!,
        maxParticipants: _maxParticipants,
        joinMode: _joinMode,
      );
      if (!mounted) return;
      // ⚠️ Qui sotto: il warning "use_build_context_synchronously" è solo un avviso.
      // Con il controllo "mounted", l'uso di context è sicuro e documentato come best practice.
      // Se vuoi sopprimere il warning, puoi aggiungere la riga commentata sotto:
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
      // (Opzionale: se vuoi notificare il parent via callback)
      widget.onEventCreated?.call();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crea evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Titolo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obbligatorio' : null,
                onChanged: (v) => _title = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Attività'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obbligatorio' : null,
                onChanged: (v) => _activityType = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Luogo'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Campo obbligatorio' : null,
                onChanged: (v) => _location = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Note'),
                maxLines: 2,
                onChanged: (v) => _notes = v.isEmpty ? null : v,
              ),
              ListTile(
                title: Text(
                  _date == null
                      ? 'Scegli una data'
                      : '${_date!.day.toString().padLeft(2, '0')}/'
                            '${_date!.month.toString().padLeft(2, '0')}/'
                            '${_date!.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _date = picked;
                    });
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Max partecipanti',
                ),
                initialValue: '5',
                keyboardType: TextInputType.number,
                validator: (v) {
                  final val = int.tryParse(v ?? '');
                  if (val == null || val < 2) return 'Minimo 2 partecipanti';
                  return null;
                },
                onChanged: (v) => _maxParticipants = int.tryParse(v) ?? 5,
              ),
              DropdownButtonFormField<String>(
                value: _joinMode,
                decoration: const InputDecoration(
                  labelText: 'Modalità iscrizione',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'AUTO',
                    child: Text('Ingresso automatico'),
                  ),
                  DropdownMenuItem(
                    value: 'MANUAL',
                    child: Text('Richiesta approvazione'),
                  ),
                ],
                onChanged: (v) => setState(() => _joinMode = v ?? 'AUTO'),
              ),
              const SizedBox(height: 24),
              if (_loading) const Center(child: CircularProgressIndicator()),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loading ? null : _submitForm,
                child: const Text('Crea evento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
