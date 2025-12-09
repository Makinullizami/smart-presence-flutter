import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/attendance_model.dart';

class AttendanceController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final attendances = <Attendance>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAttendances();
  }

  Future<void> loadAttendances() async {
    try {
      isLoading.value = true;
      // In demo mode, create mock data
      final now = DateTime.now();
      attendances.value = [
        Attendance(
          id: 1,
          userId: 1,
          date: DateTime.now().subtract(const Duration(days: 1)),
          checkInTime: '07:45',
          checkOutTime: '16:30',
          status: 'present',
          notes: null,
          isOfflineSync: false,
          createdAt: now.subtract(const Duration(days: 1)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
        Attendance(
          id: 2,
          userId: 1,
          date: DateTime.now().subtract(const Duration(days: 2)),
          checkInTime: '08:15',
          checkOutTime: '17:00',
          status: 'late',
          notes: 'Terlambat 15 menit',
          isOfflineSync: false,
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
        Attendance(
          id: 3,
          userId: 1,
          date: DateTime.now().subtract(const Duration(days: 3)),
          checkInTime: '07:30',
          checkOutTime: '16:45',
          status: 'present',
          notes: null,
          isOfflineSync: false,
          createdAt: now.subtract(const Duration(days: 3)),
          updatedAt: now.subtract(const Duration(days: 3)),
        ),
        Attendance(
          id: 4,
          userId: 1,
          date: DateTime.now().subtract(const Duration(days: 4)),
          checkInTime: null,
          checkOutTime: null,
          status: 'absent',
          notes: 'Tidak hadir',
          isOfflineSync: false,
          createdAt: now.subtract(const Duration(days: 4)),
          updatedAt: now.subtract(const Duration(days: 4)),
        ),
        Attendance(
          id: 5,
          userId: 1,
          date: DateTime.now().subtract(const Duration(days: 5)),
          checkInTime: '07:50',
          checkOutTime: '16:20',
          status: 'present',
          notes: null,
          isOfflineSync: false,
          createdAt: now.subtract(const Duration(days: 5)),
          updatedAt: now.subtract(const Duration(days: 5)),
        ),
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load attendances: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> performAttendance() async {
    try {
      isLoading.value = true;
      // Mock attendance
      Get.snackbar('Success', 'Absensi berhasil dicatat');
      await loadAttendances();
    } catch (e) {
      Get.snackbar('Error', 'Failed to perform attendance: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String get statusText {
    final todayAttendance = attendances.firstWhereOrNull(
      (attendance) =>
          attendance.date.day == DateTime.now().day &&
          attendance.date.month == DateTime.now().month &&
          attendance.date.year == DateTime.now().year,
    );

    if (todayAttendance == null) return 'Belum Absen';

    switch (todayAttendance.status) {
      case 'present':
        return 'Hadir';
      case 'late':
        return 'Terlambat';
      case 'absent':
        return 'Tidak Hadir';
      default:
        return 'Belum Absen';
    }
  }

  int get presentCount =>
      attendances.where((a) => a.status == 'present').length;
  int get lateCount => attendances.where((a) => a.status == 'late').length;
  int get absentCount => attendances.where((a) => a.status == 'absent').length;

  double get attendancePercentage {
    if (attendances.isEmpty) return 0.0;
    return (presentCount / attendances.length) * 100;
  }
}
