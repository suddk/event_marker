import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/auth_controller.dart';
import 'event_create_screen.dart';

class EventListScreen extends StatefulWidget {
  final String? groupId;

  const EventListScreen({super.key, this.groupId});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  @override
  void initState() {
    super.initState();
    final eventController = Provider.of<EventController>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);

    if (widget.groupId != null) {
      eventController.loadGroupEvents(widget.groupId!);
    } else {
      final userId = authController.currentUser?.uid ?? '';
      eventController.loadUserEvents(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventController = Provider.of<EventController>(context);
    final events = eventController.events;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: eventController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? const Center(child: Text('No events found'))
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    final timestamp = event['date'];
                    final date = timestamp is Timestamp
                        ? timestamp.toDate()
                        : DateTime.tryParse(timestamp.toString());

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(event['title'] ?? ''),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event['description'] ?? ''),
                            const SizedBox(height: 4),
                            Text(date != null
                                ? 'Date: ${date.toLocal()}'
                                : 'Date unavailable'),
                          ],
                        ),
                        leading: event['imageUrl'] != null
                            ? Image.network(
                                event['imageUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.event),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EventCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
