import '../../models/message_model.dart';
import 'api_service.dart';

class MessagesService {
  final ApiService _apiService = ApiService();

  Future<List<Message>> fetchMessages() async {
    try {
      // Mock data for now
      return _getMockMessages();
    } catch (e) {
      print('Error fetching messages: $e');
      return _getMockMessages();
    }
  }

  List<Message> _getMockMessages() {
    return [
      Message(
        id: 1,
        title: 'Pengumuman UAS',
        content:
            'Ujian akhir semester dimulai minggu depan. Silakan persiapkan diri dengan baik.',
        sender: 'Admin Sekolah',
        createdAt: '2024-11-27T07:00:00Z',
        isRead: false,
      ),
      Message(
        id: 2,
        title: 'Jadwal Kegiatan',
        content: 'Ada kegiatan bakti sosial besok pagi di desa tetangga.',
        sender: 'OSIS',
        createdAt: '2024-11-26T14:00:00Z',
        isRead: true,
      ),
    ];
  }
}
