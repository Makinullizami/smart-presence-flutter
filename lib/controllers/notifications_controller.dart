import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../services/api_service.dart';

class NotificationsController extends GetxController {
  final ApiService _apiService = ApiService();

  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final data = await _apiService.getNotifications();
      notifications.assignAll(data);
      _updateUnreadCount();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    try {
      await _apiService.markNotificationAsRead(notificationId);

      // Update local state
      final index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        notifications[index] = NotificationModel(
          id: notifications[index].id,
          userId: notifications[index].userId,
          title: notifications[index].title,
          message: notifications[index].message,
          type: notifications[index].type,
          data: notifications[index].data,
          isRead: true,
          createdAt: notifications[index].createdAt,
          updatedAt: notifications[index].updatedAt,
        );
        notifications.refresh();
        _updateUnreadCount();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark notification as read: $e');
    }
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  // Get notifications by type
  List<NotificationModel> getNotificationsByType(String type) {
    return notifications.where((n) => n.type == type).toList();
  }

  // Get unread notifications
  List<NotificationModel> getUnreadNotifications() {
    return notifications.where((n) => !n.isRead).toList();
  }

  // Mark all as read
  Future<void> markAllAsRead() async {
    try {
      for (final notification in getUnreadNotifications()) {
        await markAsRead(notification.id);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark all notifications as read: $e');
    }
  }
}
