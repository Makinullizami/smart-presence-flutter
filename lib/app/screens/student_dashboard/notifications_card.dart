import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_dashboard_controller.dart';
import '../../models/notification_model.dart';

class NotificationsCard extends StatelessWidget {
  final StudentDashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final notifications = controller.notifications.take(3).toList();

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Notifikasi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.snackbar(
                        'Info',
                        'Halaman notifikasi lengkap akan segera hadir',
                      );
                    },
                    child: Text('Lihat Semua'),
                  ),
                ],
              ),
              SizedBox(height: 16),

              if (notifications.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tidak ada notifikasi',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return _buildNotificationItem(notification);
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: notification.isRead
              ? Colors.grey.shade200
              : Colors.blue.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? Colors.transparent
                  : Colors.blue.shade500,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification.body,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  _formatDate(notification.createdAt),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Hari ini';
      } else if (difference.inDays == 1) {
        return 'Kemarin';
      } else {
        return '${difference.inDays} hari yang lalu';
      }
    } catch (e) {
      return dateString;
    }
  }
}
