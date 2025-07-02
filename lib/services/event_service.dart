import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class EventService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<String?> uploadImage(File imageFile) async {
    try {
      final id = _uuid.v4();
      final ref = _storage.ref().child('event_images/$id.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String createdBy,
    List<String>? participants,
    String? imageUrl,
    String? groupId,
  }) async {
    try {
      await _db.collection('events').add({
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'createdBy': createdBy,
        'participants': participants ?? [],
        'imageUrl': imageUrl,
        'groupId': groupId,
        'archived': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Event creation failed: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForUser(String userId) async {
    try {
      final snapshot = await _db
          .collection('events')
          .where('participants', arrayContains: userId)
          .where('archived', isEqualTo: false)
          .orderBy('date', descending: false)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getEventsForGroup(String groupId) async {
    try {
      final snapshot = await _db
          .collection('events')
          .where('groupId', isEqualTo: groupId)
          .where('archived', isEqualTo: false)
          .orderBy('date')
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching group events: $e');
      return [];
    }
  }

  Future<void> archivePastEvents() async {
    try {
      final now = DateTime.now();
      final pastEvents = await _db
          .collection('events')
          .where('date', isLessThan: Timestamp.fromDate(now))
          .where('archived', isEqualTo: false)
          .get();

      for (final doc in pastEvents.docs) {
        await doc.reference.update({'archived': true});
      }
    } catch (e) {
      print('Archiving failed: $e');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _db.collection('events').doc(eventId).delete();
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  Future<void> archiveEvent(String eventId) async {
    try {
      await _db.collection('events').doc(eventId).update({'archived': true});
    } catch (e) {
      print('Error archiving event: $e');
    }
  }

}
