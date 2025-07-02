import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String createdBy;
  final String groupId;
  final String? imageUrl;
  final bool archived;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.createdBy,
    required this.groupId,
    this.imageUrl,
    this.archived = false,
  });

  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    return Event(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      createdBy: data['createdBy'] ?? '',
      groupId: data['groupId'] ?? '',
      imageUrl: data['imageUrl'],
      archived: data['archived'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'createdBy': createdBy,
      'groupId': groupId,
      'imageUrl': imageUrl,
      'archived': archived,
    };
  }
}
