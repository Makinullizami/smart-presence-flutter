import 'package:flutter/foundation.dart' show debugPrint;
import 'package:get/get.dart';
import '../../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationsController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      notifications.value = await _notificationService.fetchNotifications();
    } catch (e) {
      debugPrint('Error fetching notifications: $e');
      Get.snackbar('Error', 'Gagal memuat notifikasi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markRead(int id) async {
    try {
      await _notificationService.markRead(id);
      final index = notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        final updated = notifications[index];
        notifications[index] = NotificationModel(
          id: updated.id,
          userId: updated.userId,
          title: updated.title,
          message: updated.message,
          type: updated.type,
          data: updated.data,
          isRead: true,
          readAt: DateTime.now(),
          createdAt: updated.createdAt,
          updatedAt: DateTime.now(),
        );
        notifications.refresh();
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      Get.snackbar('Error', 'Gagal memperbarui notifikasi: $e');
    }
  }
}
