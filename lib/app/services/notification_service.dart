import '../../models/notification_model.dart';
import 'api_service.dart';

class NotificationService {
  final ApiService _apiService = ApiService();

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      // Mock data for now
      return _getMockNotifications();
    } catch (e) {
      print('Error fetching notifications: $e');
      return _getMockNotifications();
    }
  }

  Future<void> markRead(int id) async {
    try {
      // This would call the real API
      print('Marked notification $id as read');
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        id: 1,
        title: 'Pengumuman Libur',
        body: 'Besok ada libur nasional untuk memperingati hari kemerdekaan',
        createdAt: '2024-11-27T08:00:00Z',
        isRead: false,
      ),
      NotificationModel(
        id: 2,
        title: 'Tugas Matematika',
        body: 'Deadline pengumpulan tugas matematika besok pukul 08:00',
        createdAt: '2024-11-26T15:00:00Z',
        isRead: true,
      ),
      NotificationModel(
        id: 3,
        title: 'Ujian Akhir Semester',
        body: 'Jadwal UAS telah diumumkan. Silakan cek portal akademik',
        createdAt: '2024-11-25T10:00:00Z',
        isRead: false,
      ),
    ];
  }
}
