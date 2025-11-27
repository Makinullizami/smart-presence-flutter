import 'package:get/get.dart';
import '../../models/timetable_model.dart';
import '../services/timetable_service.dart';

class TimetableController extends GetxController {
  final TimetableService _timetableService = TimetableService();

  var timetables = <Timetable>[].obs;
  var isLoading = false.obs;

  Future<void> getTimetableByDate(String date) async {
    isLoading.value = true;
    try {
      timetables.value = await _timetableService.getTimetableByDate(date);
    } catch (e) {
      print('Error loading timetable: $e');
      // Load mock data
      _loadMockTimetable(date);
    } finally {
      isLoading.value = false;
    }
  }

  void _loadMockTimetable(String date) {
    // Mock timetable data
    timetables.value = [
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
    ];
  }
}
