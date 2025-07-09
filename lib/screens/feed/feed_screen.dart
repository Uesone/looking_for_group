import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/event_feed.dart';
import '../../services/event_feed_service.dart';
import '../../services/location_device.dart';
import '../../widgets/event_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<EventFeed>> _futureEvents;
  double? _lat;
  double? _lon;
  double _radiusKm = 25;
  bool _geoEnabled = false;

  @override
  void initState() {
    super.initState();
    _futureEvents = EventFeedService().fetchEventFeed();
  }

  void _refreshFeed() {
    setState(() {
      if (_geoEnabled && _lat != null && _lon != null) {
        _futureEvents = EventFeedService().fetchEventFeed(
          latitude: _lat,
          longitude: _lon,
          radiusKm: _radiusKm,
        );
      } else {
        _futureEvents = EventFeedService().fetchEventFeed();
      }
    });
  }

  Future<void> _toggleGeoFeed() async {
    if (!_geoEnabled) {
      try {
        Position pos = await getCurrentPosition();
        setState(() {
          _lat = pos.latitude;
          _lon = pos.longitude;
          _geoEnabled = true;
          _futureEvents = EventFeedService().fetchEventFeed(
            latitude: _lat,
            longitude: _lon,
            radiusKm: _radiusKm,
          );
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Errore geolocalizzazione: $e")));
      }
    } else {
      setState(() {
        _geoEnabled = false;
        _futureEvents = EventFeedService().fetchEventFeed();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Eventi'),
        actions: [
          IconButton(
            icon: Icon(_geoEnabled ? Icons.gps_fixed : Icons.gps_not_fixed),
            tooltip: _geoEnabled
                ? 'Mostra tutti gli eventi'
                : 'Solo eventi vicino a me',
            onPressed: _toggleGeoFeed,
          ),
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
