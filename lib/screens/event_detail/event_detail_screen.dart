import 'package:flutter/material.dart';
import '../../models/event_feed.dart';
import '../../services/join_request_service.dart';

class EventDetailScreen extends StatefulWidget {
  final EventFeed event;

  const EventDetailScreen({required this.event, super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool joinLoading = false;
  bool joinRequested = false;
  String? joinError;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- dettagli evento come prima...
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text('Lv.${event.creatorLevel}'),
                  backgroundColor: Colors.indigo.withAlpha(31),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.person, size: 18),
                const SizedBox(width: 5),
                Text(
                  event.creatorUsername,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.sports_basketball_outlined, size: 18),
                const SizedBox(width: 7),
                Text(event.activityType),
                const SizedBox(width: 18),
                const Icon(Icons.location_city_outlined, size: 18),
                const SizedBox(width: 3),
                Text(event.city ?? '-'),
              ],
            ),
            const SizedBox(height: 11),
            Row(
              children: [
                const Icon(Icons.event_outlined, size: 18),
                const SizedBox(width: 7),
                Text(_formatDate(event.date)),
                const SizedBox(width: 18),
                const Icon(Icons.group_outlined, size: 18),
                const SizedBox(width: 4),
                Text("${event.maxParticipants} posti"),
              ],
            ),
            if (event.distanceFromUser != null) ...[
              const SizedBox(height: 11),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 18,
                    color: Colors.blueAccent,
                  ),
                  Text(
                    "${event.distanceFromUser!.toStringAsFixed(1)} km da te",
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 25),

            // --- CAMPO MESSAGGIO ---
            Text(
              "Messaggio (opzionale)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _messageController,
              maxLines: 2,
              minLines: 1,
              maxLength: 140,
              decoration: InputDecoration(
                hintText: "Scrivi un messaggio per il creator...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                counterText: "",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              enabled: !joinRequested && !joinLoading,
            ),

            const SizedBox(height: 22),

            // --- BOTTONE JOIN ---
            Center(
              child: joinRequested
                  ? ElevatedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.hourglass_top),
                      label: const Text("Richiesta inviata"),
                    )
                  : ElevatedButton.icon(
                      onPressed: joinLoading ? null : _handleJoinRequest,
                      icon: const Icon(Icons.group_add),
                      label: joinLoading
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text("Richiedi partecipazione"),
                    ),
            ),
            if (joinError != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  joinError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleJoinRequest() async {
    setState(() {
      joinLoading = true;
      joinError = null;
    });
    try {
      await JoinRequestService.sendJoinRequest(
        widget.event.id,
        message: _messageController.text.trim(),
      );
      setState(() {
        joinRequested = true;
        joinLoading = false;
      });
    } catch (e) {
      setState(() {
        joinError = "Errore: ${e.toString()}";
        joinLoading = false;
      });
    }
  }

  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
