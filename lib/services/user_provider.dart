// lib/services/user_provider.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  Future<void> fetchUserById(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (doc.exists) {
        _user = doc.data();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
