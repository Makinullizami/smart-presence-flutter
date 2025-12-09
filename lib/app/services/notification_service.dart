import 'package:flutter/foundation.dart' show debugPrint;

import '../../models/notification_model.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _api_service = ApiService();

  // Simple in-memory cache for mock notifications
  final List<NotificationModel> _cache = [];

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      if (_cache.isEmpty) {
        _cache.addAll(_getMockNotifications());
      }
      return List<NotificationModel>.from(_cache);
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      return List<NotificationModel>.from(_cache);
    }
  }

  Future<void> markRead(int id) async {
    try {
      // Simulate API call here if needed using _api_service

      final index = _cache.indexWhere((n) => n.id == id);
      if (index != -1) {
        final existing = _cache[index];
        final now = DateTime.now();
        _cache[index] = NotificationModel(
          id: existing.id,
          userId: existing.userId,
          title: existing.title,
          message: existing.message,
          type: existing.type,
          data: existing.data,
          isRead: true,
          readAt: now,
          createdAt: existing.createdAt,
          updatedAt: now,
        );
      }
      debugPrint('Marked notification $id as read (mock)');
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      rethrow;
    }
  }

  List<NotificationModel> _getMockNotifications() {
    final now = DateTime.now();
    return [
      NotificationModel(
        id: 1,
        userId: 1,
        title: 'Pengumuman Libur',
        message: 'Besok ada libur nasional untuk memperingati hari kemerdekaan',
        type: 'system',
        data: null,
        isRead: false,
        readAt: null,
        createdAt: now.subtract(Duration(days: 9)),
        updatedAt: now.subtract(Duration(days: 9)),
      ),
      NotificationModel(
        id: 2,
        userId: 1,
        title: 'Tugas Matematika',
        message: 'Deadline pengumpulan tugas matematika besok pukul 08:00',
        type: 'assignment',
        data: null,
        isRead: true,
        readAt: now.subtract(Duration(days: 8)),
        createdAt: now.subtract(Duration(days: 8)),
        updatedAt: now.subtract(Duration(days: 8)),
      ),
      NotificationModel(
        id: 3,
        userId: 1,
        title: 'Ujian Akhir Semester',
        message: 'Jadwal UAS telah diumumkan. Silakan cek portal akademik',
        type: 'schedule',
        data: null,
        isRead: false,
        readAt: null,
        createdAt: now.subtract(Duration(days: 10)),
        updatedAt: now.subtract(Duration(days: 10)),
      ),
    ];
  }
}
