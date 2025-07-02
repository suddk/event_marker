// lib/screens/events/event_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../controllers/event_controller.dart';
import '../../controllers/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final eventController = Provider.of<EventController>(context, listen: false);
    final userId = authController.currentUser?.uid ?? '';
    final isCreator = event['createdBy'] == userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: isCreator
            ? [
                IconButton(
                  icon: const Icon(Icons.archive),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Archive Event'),
                        content: const Text('Are you sure you want to archive this event?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Archive'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await eventController.archiveEvent(event['id']);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Delete Event'),
                        content: const Text('This action cannot be undone. Proceed?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await eventController.deleteEvent(event['id']);
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(event['title'] ?? '', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(event['description'] ?? ''),
            const SizedBox(height: 8),
            if (event['date'] != null)
              Text(
                'Date: ${DateFormat.yMMMMd().format((event['date'] as Timestamp).toDate())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16),
            if (event['imageUrl'] != null)
              Image.network(event['imageUrl'], height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text('Participants: ${event['participants']?.length ?? 0}'),
          ],
        ),
      ),
    );
  }
}
