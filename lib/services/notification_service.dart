// lib/services/notification_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔔 Request permission and get device token
  Future<String?> initializeFCM(String userId) async {
    try {
      await _messaging.requestPermission();
      String? token = await _messaging.getToken();
      if (token != null) {
        await _firestore.collection('users').doc(userId).update({'fcmToken': token});
      }
      return token;
    } catch (e) {
      print('Error initializing FCM: $e');
      return null;
    }
  }

  /// 🚀 Send a notification via FCM HTTP v1 API (using legacy API key)
  Future<void> sendNotificationToToken({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const String serverKey = 'YOUR_SERVER_KEY'; // Replace with your FCM server key
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
        }),
      );

      if (response.statusCode != 200) {
        print('Failed to send FCM notification: ${response.body}');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  /// 📣 Notify all users in a group (multi-device delivery)
  Future<void> notifyGroup({
    required String groupId,
    required String title,
    required String body,
  }) async {
    try {
      final groupDoc = await _firestore.collection('groups').doc(groupId).get();
      if (!groupDoc.exists) return;

      final List members = groupDoc['members'];
      for (String userId in members) {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        final token = userDoc.data()?['fcmToken'];
        if (token != null) {
          await sendNotificationToToken(
            token: token,
            title: title,
            body: body,
          );
        }
      }
    } catch (e) {
      print('Error notifying group: $e');
    }
  }

  /// 🔔 Send notification to a specific userId
  Future<void> notifyUser({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final token = userDoc.data()?['fcmToken'];
      if (token != null) {
        await sendNotificationToToken(
          token: token,
          title: title,
          body: body,
        );
      }
    } catch (e) {
      print('Error notifying user: $e');
    }
  }
}
