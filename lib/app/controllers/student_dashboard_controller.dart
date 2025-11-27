import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../models/attendance_model.dart';
import '../../models/attendance_stat_model.dart';
import '../../models/timetable_model.dart';
import '../../models/notification_model.dart';
import '../../models/assignment_model.dart';
import '../../models/message_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class StudentDashboardController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observables
  var user = Rxn<User>();
  var todayAttendance = Rxn<Attendance>();
  var attendanceStats = Rxn<AttendanceStat>();
  var timetableToday = <Timetable>[].obs;
  var notifications = <NotificationModel>[].obs;
  var assignments = <Assignment>[].obs;
  var messages = <Message>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      // Load all dashboard data
      await Future.wait([
        _loadUserData(),
        _loadTodayAttendance(),
        _loadAttendanceStats(),
        _loadTimetableToday(),
        _loadNotifications(),
        _loadAssignments(),
        _loadMessages(),
      ]);
    } catch (e) {
      print('Error loading dashboard data: $e');
      // Load mock data for demo
      _loadMockData();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadUserData() async {
    // Get user from auth controller
    final authController = Get.find<AuthController>();
    user.value = authController.user.value;
  }

  Future<void> _loadTodayAttendance() async {
    try {
      final response = await _apiService.getAttendanceHistory(
        user.value?.id ?? 1,
      );
      final today = DateTime.now().toIso8601String().split('T')[0];
      todayAttendance.value = response.firstWhereOrNull(
        (attendance) => attendance.date == today,
      );
    } catch (e) {
      // Mock today attendance
      todayAttendance.value = Attendance(
        id: 1,
        userId: user.value?.id ?? 1,
        date: DateTime.now().toIso8601String().split('T')[0],
        time: '08:00',
        status: 'present',
      );
    }
  }

  Future<void> _loadAttendanceStats() async {
    try {
      // This would call a real API endpoint
      // For now, mock data
      attendanceStats.value = AttendanceStat(
        totalPresent: 25,
        totalAbsent: 2,
        totalLate: 3,
        attendancePercentage: 89.3,
        currentStreak: 5,
      );
    } catch (e) {
      attendanceStats.value = AttendanceStat(
        totalPresent: 25,
        totalAbsent: 2,
        totalLate: 3,
        attendancePercentage: 89.3,
        currentStreak: 5,
      );
    }
  }

  Future<void> _loadTimetableToday() async {
    try {
      // Mock timetable data
      timetableToday.value = [
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
      ];
    } catch (e) {
      timetableToday.clear();
    }
  }

  Future<void> _loadNotifications() async {
    try {
      // Mock notifications
      notifications.value = [
        NotificationModel(
          id: 1,
          title: 'Pengumuman Libur',
          body: 'Besok ada libur nasional',
          createdAt: '2024-11-27T08:00:00Z',
          isRead: false,
        ),
        NotificationModel(
          id: 2,
          title: 'Tugas Matematika',
          body: 'Deadline tugas besok',
          createdAt: '2024-11-26T15:00:00Z',
          isRead: true,
        ),
        NotificationModel(
          id: 3,
          title: 'Ujian Akhir Semester',
          body: 'Jadwal UAS telah diumumkan',
          createdAt: '2024-11-25T10:00:00Z',
          isRead: false,
        ),
      ];
    } catch (e) {
      notifications.clear();
    }
  }

  Future<void> _loadAssignments() async {
    try {
      // Mock assignments
      assignments.value = [
        Assignment(
          id: 1,
          title: 'Tugas Matematika',
          description: 'Kerjakan soal halaman 45-50',
          dueDate: '2024-12-01',
          status: 'pending',
        ),
        Assignment(
          id: 2,
          title: 'Makalah Bahasa Indonesia',
          description: 'Tema: Teknologi Modern',
          dueDate: '2024-12-05',
          status: 'submitted',
        ),
      ];
    } catch (e) {
      assignments.clear();
    }
  }

  Future<void> _loadMessages() async {
    try {
      // Mock messages
      messages.value = [
        Message(
          id: 1,
          title: 'Pengumuman UAS',
          content: 'Ujian akhir semester dimulai minggu depan',
          sender: 'Admin Sekolah',
          createdAt: '2024-11-27T07:00:00Z',
          isRead: false,
        ),
      ];
    } catch (e) {
      messages.clear();
    }
  }

  void _loadMockData() {
    // Load all mock data
    _loadUserData();
    _loadTodayAttendance();
    _loadAttendanceStats();
    _loadTimetableToday();
    _loadNotifications();
    _loadAssignments();
    _loadMessages();
  }

  Future<void> refresh() async {
    await loadDashboardData();
  }

  void goToAttendance() {
    Get.toNamed('/attendance');
  }
}
