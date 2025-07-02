import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<User?> signInWithPhoneAndPassword(String phone, String password) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('phone', isEqualTo: phone)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      // Optional: Use anonymous sign-in to simulate a session
      final currentUser = _auth.currentUser;
      return currentUser ?? (await _auth.signInAnonymously()).user;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<User?> registerWithPhoneAndPassword(
      String name, String phone, String password) async {
    try {
      final existing = await _db
          .collection('users')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) return null;

      await _db.collection('users').add({
        'name': name,
        'phone': phone,
        'password': password,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return _auth.currentUser ?? (await _auth.signInAnonymously()).user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserProfile(String phone) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return snapshot.docs.first;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }
}
