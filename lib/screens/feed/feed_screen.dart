import 'package:flutter/material.dart';
import '../../models/event_feed.dart';
import '../../services/event_feed_service.dart';
import '../../widgets/event_card.dart';

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
    _futureEvents = EventFeedService().fetchEventFeed();
  }

  void _refreshFeed() {
    setState(() {
      _futureEvents = EventFeedService().fetchEventFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Eventi'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle, size: 30),
            onSelected: (value) {
              if (value == 'dashboard') {
                Navigator.pushNamed(context, '/user_dashboard');
              } else if (value == 'profile') {
                Navigator.pushNamed(context, '/profile');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'dashboard', child: Text('Dashboard')),
              const PopupMenuItem(value: 'profile', child: Text('Profilo')),
            ],
          ),
        ],
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.pushNamed(context, '/event_create');
          if (created == true) {
            _refreshFeed();
          }
        },
        tooltip: 'Crea evento',
        child: const Icon(Icons.add),
      ),
    );
  }
}
