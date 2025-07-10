import 'package:flutter/material.dart';
import '../models/event_feed.dart';

/// Card evento per il feed: mostra SOLO città, mai location.
/// Mostra la distanza SOLO se presente (geo attiva).
class EventCard extends StatelessWidget {
  final EventFeed event;

  const EventCard({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          // TODO: navigazione dettaglio evento
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prossimamente: dettaglio evento!')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Titolo Evento
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 7),

              /// Tipo Attività e Città
              Row(
                children: [
                  const Icon(Icons.sports_basketball_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    event.activityType,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_city_outlined, size: 18),
                  const SizedBox(width: 3),
                  Text(
                    event.city ?? 'Città non disponibile',
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// Data, Max partecipanti, (distanza opzionale)
              Row(
                children: [
                  const Icon(Icons.event_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(event.date),
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 14),
                  const Icon(Icons.group_outlined, size: 18),
                  const SizedBox(width: 3),
                  Text(
                    "${event.maxParticipants} posti",
                    style: const TextStyle(fontSize: 15),
                  ),
                  if (event.distanceFromUser != null) ...[
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      "${event.distanceFromUser!.toStringAsFixed(1)} km da te",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 15),

              /// Creatore Evento e Livello
              Row(
                children: [
                  const CircleAvatar(radius: 13, child: Icon(Icons.person)),
                  const SizedBox(width: 7),
                  Text(
                    event.creatorUsername,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 11),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withAlpha((255 * 0.13).round()),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      "Lv.${event.creatorLevel}",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ritorna la data in formato gg/mm/aaaa
  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }
}
