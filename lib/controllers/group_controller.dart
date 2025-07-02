import 'package:flutter/material.dart';
import '../services/group_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class GroupController with ChangeNotifier {
  final GroupService _groupService = GroupService();

  bool _isLoading = false;
  String? _error;
  List<Map<String, dynamic>> _groups = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get groups => _groups;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  Future<String?> createGroup(String name, String adminId) async {
    _setLoading(true);
    _setError(null);

    try {
      final groupId = await _groupService.createGroup(name, adminId);
      return groupId;
    } catch (e) {
      _setError('Group creation failed');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<String>> getPendingRequests(String groupId) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('groups').doc(groupId).get();
      final data = snapshot.data();
      if (data != null && data['pendingRequests'] is List) {
        return List<String>.from(data['pendingRequests']);
      }
      return [];
    } catch (e) {
      print('Error fetching pending requests: $e');
      return [];
    }
  }

  Future<Map<String, String>> getUserNames(List<String> userIds) async {
    final Map<String, String> names = {};
    try {
      for (final userId in userIds) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        final name = doc.data()?['name'] ?? userId;
        names[userId] = name;
      }
    } catch (e) {
      print('Error fetching user names: $e');
    }
    return names;
  }


  Future<bool> joinGroup(String groupId, String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await _groupService.requestToJoinGroup(groupId, userId);
      return success;
    } catch (e) {
      _setError('Failed to send join request');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getUserGroups(String userId) async {
    _setLoading(true);
    _setError(null);

    try {
      final groupList = await _groupService.getUserGroups(userId);
      _groups = groupList;
    } catch (e) {
      _setError('Error loading groups');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> approveUser(String groupId, String userId) async {
    await _groupService.approveJoinRequest(groupId, userId);
    await getUserGroups(userId); // Refresh user's group list
  }

  Future<void> rejectUser(String groupId, String userId) async {
    await _groupService.rejectJoinRequest(groupId, userId);
  }
}
