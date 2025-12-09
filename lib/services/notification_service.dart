import 'dart:convert';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final storage = const FlutterSecureStorage();

  static const String baseUrl =
      'http://localhost:8000/api'; // Change this to your backend URL

  Future<void> initialize() async {
    // Initialize timezone data for scheduled notifications
    try {
      tz.initializeTimeZones();
    } catch (_) {
      // ignore if timezone data already initialized
    }

    // Initialize local notifications
    final AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    debugPrint('Notification service initialized successfully');
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    final payload = response.payload;
    if (payload != null) {
      // Navigate to appropriate screen based on notification type
      _handleNotificationNavigation(payload);
    }
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'smart_presence_channel',
      'Smart Presence',
      channelDescription: 'Notifications for Smart Presence app',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  void _handleNotificationNavigation(String type) {
    // Handle navigation based on notification type
    switch (type) {
      case 'attendance_reminder':
        // Navigate to attendance screen
        break;
      case 'leave_approved':
      case 'leave_rejected':
        // Navigate to appeals screen
        break;
      case 'announcement':
        // Navigate to announcements screen
        break;
      default:
        // Navigate to notifications screen
        break;
    }
  }

  // Schedule attendance reminder
  Future<void> scheduleAttendanceReminder(
    DateTime attendanceTime, {
    int minutesBefore = 10,
  }) async {
    final reminderTime = attendanceTime.subtract(
      Duration(minutes: minutesBefore),
    );

    if (reminderTime.isAfter(DateTime.now())) {
      final androidDetails = AndroidNotificationDetails(
        'attendance_reminder_channel',
        'Attendance Reminders',
        channelDescription: 'Reminders for attendance check-in',
        importance: Importance.high,
        priority: Priority.high,
      );

      final iosDetails = DarwinNotificationDetails();

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final scheduled = tz.TZDateTime.from(reminderTime, tz.local);

      await _localNotifications.zonedSchedule(
        'attendance_reminder_${attendanceTime.millisecondsSinceEpoch}'.hashCode,
        'Waktunya Absen!',
        'Jangan lupa melakukan absensi masuk dalam ${minutesBefore} menit.',
        scheduled,
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // Send push notification to specific user
  Future<void> sendPushNotification({
    required int userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) return;

    try {
      await http.post(
        Uri.parse('$baseUrl/notifications/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'title': title,
          'body': body,
          'type': type,
          'data': data,
        }),
      );
    } catch (e) {
      debugPrint('Failed to send push notification: $e');
    }
  }

  // Send broadcast notification to all users
  Future<void> sendBroadcastNotification({
    required String title,
    required String body,
    required String type,
    String? targetRole,
    Map<String, dynamic>? data,
  }) async {
    final token = await storage.read(key: 'token');
    if (token == null) return;

    try {
      await http.post(
        Uri.parse('$baseUrl/notifications/broadcast'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'body': body,
          'type': type,
          'target_role': targetRole,
          'data': data,
        }),
      );
    } catch (e) {
      debugPrint('Failed to send broadcast notification: $e');
    }
  }

  // Get notification history
  Future<List<NotificationModel>> getNotificationHistory() async {
    final token = await storage.read(key: 'token');
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List)
            .map((item) => NotificationModel.fromJson(item))
            .toList();
      }
    } catch (e) {
      debugPrint('Failed to get notification history: $e');
    }

    return [];
  }

  // Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    final token = await storage.read(key: 'token');
    if (token == null) return;

    try {
      await http.put(
        Uri.parse('$baseUrl/notifications/$notificationId/read'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      debugPrint('Failed to mark notification as read: $e');
    }
  }
}
