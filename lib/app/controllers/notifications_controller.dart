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
      print('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markRead(int id) async {
    try {
      await _notificationService.markRead(id);
      final notification = notifications.firstWhereOrNull((n) => n.id == id);
      if (notification != null) {
        notification.isRead = true;
        notifications.refresh();
      }
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }
}
