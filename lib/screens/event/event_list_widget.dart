import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/event_controller.dart';
import '../controllers/auth_controller.dart';

class EventListWidget extends StatefulWidget {
  const EventListWidget({super.key});

  @override
  State<EventListWidget> createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final eventController = Provider.of<EventController>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);
    final userId = authController.currentUser?.uid;
    if (userId != null) {
      await eventController.loadUserEvents(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventController = Provider.of<EventController>(context);

    if (eventController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (eventController.events.isEmpty) {
      return const Center(child: Text('No events available.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: eventController.events.length,
      itemBuilder: (context, index) {
        final event = eventController.events[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: event['imageUrl'] != null
                ? Image.network(event['imageUrl'], width: 60, height: 60, fit: BoxFit.cover)
                : const Icon(Icons.event),
            title: Text(event['title'] ?? 'No Title'),
            subtitle: Text(event['description'] ?? 'No Description'),
            trailing: Text(
              event['date'] != null
                  ? (event['date'].toDate() as DateTime).toLocal().toString().split(' ')[0]
                  : '',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
