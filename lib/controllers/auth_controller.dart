import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _error;
  AppUser? _currentUser;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AppUser? get currentUser => _currentUser;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  Future<bool> login(String phone, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await _authService.signInWithPhoneAndPassword(phone, password);
      if (user != null) {
        // 🔍 Fetch the user document from Firestore to get name
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .where('phone', isEqualTo: phone)
            .limit(1)
            .get();

        String name = '';
        if (userDoc.docs.isNotEmpty) {
          name = userDoc.docs.first['name'] ?? '';
        }

        _currentUser = AppUser(
          uid: user.uid,
          phoneNumber: phone,
          name: name,
        );
        return true;
      } else {
        _setError('Invalid phone or password');
        return false;
      }
    } catch (e) {
      _setError('Login failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String phone, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final user = await _authService.registerWithPhoneAndPassword(name, phone, password);
      if (user != null) {
        _currentUser = AppUser(
          uid: user.uid,
          phoneNumber: phone,
          name: name,
        );
        return true;
      } else {
        _setError('Account already exists or registration failed');
        return false;
      }
    } catch (e) {
      _setError('Registration failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
