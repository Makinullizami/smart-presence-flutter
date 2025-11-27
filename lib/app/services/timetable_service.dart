import '../../models/timetable_model.dart';
import 'api_service.dart';

class TimetableService {
  final ApiService _apiService = ApiService();

  Future<List<Timetable>> getTimetableByDate(String date) async {
    try {
      // This would call the real API
      // For now, return mock data
      return _getMockTimetable();
    } catch (e) {
      print('Error fetching timetable: $e');
      return _getMockTimetable();
    }
  }

  List<Timetable> _getMockTimetable() {
    return [
      Timetable(
        id: 1,
        subject: 'Matematika',
        startTime: '08:00',
        endTime: '09:30',
        room: 'Ruang 101',
        lecturer: 'Dr. Ahmad',
      ),
      Timetable(
        id: 2,
        subject: 'Bahasa Indonesia',
        startTime: '10:00',
        endTime: '11:30',
        room: 'Ruang 102',
        lecturer: 'Bu Siti',
      ),
      Timetable(
        id: 3,
        subject: 'IPA',
        startTime: '13:00',
        endTime: '14:30',
        room: 'Lab IPA',
        lecturer: 'Pak Budi',
      ),
      Timetable(
        id: 4,
        subject: 'PKN',
        startTime: '15:00',
        endTime: '16:30',
        room: 'Ruang 103',
        lecturer: 'Bu Rina',
      ),
    ];
  }
}
