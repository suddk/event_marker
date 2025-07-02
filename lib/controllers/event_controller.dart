import 'dart:io';
import 'package:flutter/material.dart';
import '../services/event_service.dart';

class EventController with ChangeNotifier {
  final EventService _eventService = EventService();

  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _events = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get events => _events;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  /// 🔄 Load events for the current user
  Future<void> loadUserEvents(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      final userEvents = await _eventService.getEventsForUser(userId);
      _events = userEvents;
    } catch (e) {
      _setError('Failed to load events');
    } finally {
      _setLoading(false);
    }
  }

  /// ➕ Create a new event
  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String createdBy,
    List<String>? participants,
    String? groupId,
    File? imageFile,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _eventService.uploadImage(imageFile);
      }

      await _eventService.createEvent(
        title: title,
        description: description,
        date: date,
        createdBy: createdBy,
        participants: participants,
        imageUrl: imageUrl,
        groupId: groupId,
      );

      await loadUserEvents(createdBy); // Refresh event list
    } catch (e) {
      _setError('Failed to create event');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> archiveEvent(String eventId) async {
  _setLoading(true);
  _setError(null);

  try {
    await _eventService.archivePastEvents(); // ❌ WRONG (archives *all* past)
    // ✅ Instead:
    await _eventService.archiveEvent(eventId);
  } catch (e) {
    _setError('Failed to archive event');
  } finally {
    _setLoading(false);
  }
}

  /// 🗑 Delete an event
  Future<void> deleteEvent(String eventId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _eventService.deleteEvent(eventId);
    } catch (e) {
      _setError('Failed to delete event');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getEventsForUser(String userId) async {
  _setLoading(true);
  _setError(null);

  try {
    final events = await _eventService.getEventsForUser(userId);
    _events = events;
    notifyListeners();
  } catch (e) {
    _setError('Failed to load events');
  } finally {
    _setLoading(false);
  }
}

  /// 🔒 Archive outdated events (system/maintenance use)
  Future<void> archivePastEvents() async {
    try {
      await _eventService.archivePastEvents();
    } catch (e) {
      _setError('Failed to archive events');
    }
  }
}
