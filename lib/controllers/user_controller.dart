import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? _userId;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _error;

  String? get userId => _userId;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    if (_userId == null) return;
    _setLoading(true);
    _setError(null);

    try {
      final doc = await _db.collection('users').doc(_userId).get();
      if (doc.exists) {
        _userData = doc.data();
      } else {
        _userData = null;
        _setError("User not found");
      }
    } catch (e) {
      _setError("Failed to fetch user data");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updates) async {
    if (_userId == null) return;

    try {
      await _db.collection('users').doc(_userId).update(updates);
      await fetchUserData(); // Refresh
    } catch (e) {
      _setError("Failed to update user data");
    }
  }

  void clearUser() {
    _userId = null;
    _userData = null;
    notifyListeners();
  }
}
