import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserByPhone(String phone) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      return {'id': doc.id, ...doc.data()};
    } catch (e) {
      print('Error fetching user by phone: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (!doc.exists) return null;

      return {'id': doc.id, ...doc.data()!};
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> searchUsersByName(String query) async {
    try {
      final snapshot = await _db
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
  try {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }


  Future<void> updateUserName(String userId, String newName) async {
    try {
      await _db.collection('users').doc(userId).update({
        'name': newName,
      });
    } catch (e) {
      print('Error updating user name: $e');
    }
  }
}
