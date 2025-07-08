import 'package:flutter/material.dart';
import '../../models/event_feed.dart';
import '../../services/event_service.dart';
import '../../widgets/event_card.dart'; // <-- aggiorna il nome qui!

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<EventFeed>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = EventService().fetchEventFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed Eventi')),
      body: FutureBuilder<List<EventFeed>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nessun evento trovato.'));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return EventCard(event: event);
            },
          );
        },
      ),
    );
  }
}
