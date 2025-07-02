// lib/services/group_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class GroupService {
  final CollectionReference groups = FirebaseFirestore.instance.collection('groups');

  Future<String?> createGroup(String name, String adminId) async {
    try {
      final doc = await groups.add({
        'name': name,
        'adminId': adminId,
        'members': [adminId],
        'createdAt': FieldValue.serverTimestamp(),
      });
      return doc.id;
    } catch (e) {
      print('Error creating group: $e');
      return null;
    }
  }

  Future<bool> joinGroup(String groupId, String userId) async {
    try {
      final groupDoc = await groups.doc(groupId).get();
      if (groupDoc.exists) {
        final List members = groupDoc['members'] ?? [];
        if (!members.contains(userId)) {
          members.add(userId);
          await groups.doc(groupId).update({'members': members});
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error joining group: $e');
      return false;
    }
  }

  Future<bool> requestToJoinGroup(String groupId, String userId) async {
  try {
    final doc = await groups.doc(groupId).get();
    if (!doc.exists) return false;

    final data = doc.data() as Map<String, dynamic>;
    final List<String> pending = List<String>.from(data['pendingRequests'] ?? []);
    final List<String> members = List<String>.from(data['members'] ?? []);

    if (!members.contains(userId) && !pending.contains(userId)) {
      pending.add(userId);
      await groups.doc(groupId).update({'pendingRequests': pending});
    }

      return true;
    } catch (e) {
      print('Error requesting to join group: $e');
      return false;
    }
  }

  Future<void> approveJoinRequest(String groupId, String userId) async {
  final doc = await groups.doc(groupId).get();
  if (!doc.exists) return;

  final data = doc.data() as Map<String, dynamic>;
  final List<String> members = List<String>.from(data['members'] ?? []);
  final List<String> pending = List<String>.from(data['pendingRequests'] ?? []);

  if (pending.contains(userId)) {
    pending.remove(userId);
    members.add(userId);

    await groups.doc(groupId).update({
      'members': members,
      'pendingRequests': pending,
    });
  }
}

Future<void> rejectJoinRequest(String groupId, String userId) async {
  final doc = await groups.doc(groupId).get();
  if (!doc.exists) return;

  final data = doc.data() as Map<String, dynamic>;
  final List<String> pending = List<String>.from(data['pendingRequests'] ?? []);

  if (pending.contains(userId)) {
    pending.remove(userId);
    await groups.doc(groupId).update({
      'pendingRequests': pending,
    });
  }
}



  Future<List<Map<String, dynamic>>> getUserGroups(String userId) async {
    try {
      final snapshot = await groups.where('members', arrayContains: userId).get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error fetching groups: $e');
      return [];
    }
  }
}
