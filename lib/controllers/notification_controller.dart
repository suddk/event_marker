import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationController with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  Future<String?> initializeFCM(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      final token = await _notificationService.initializeFCM(userId);
      return token;
    } catch (e) {
      _setError("Failed to initialize notifications");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> notifyUser({
    required String userId,
    required String title,
    required String body,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await _notificationService.notifyUser(
        userId: userId,
        title: title,
        body: body,
      );
    } catch (e) {
      _setError("Failed to send user notification");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> notifyGroup({
    required String groupId,
    required String title,
    required String body,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      await _notificationService.notifyGroup(
        groupId: groupId,
        title: title,
        body: body,
      );
    } catch (e) {
      _setError("Failed to send group notification");
    } finally {
      _setLoading(false);
    }
  }
}
