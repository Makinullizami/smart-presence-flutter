import 'package:flutter/foundation.dart' show debugPrint;
import 'package:get/get.dart';
import '../../models/user_model.dart';
import '../../models/attendance_model.dart';
import '../../models/attendance_stat_model.dart';
import '../../models/timetable_model.dart';
import '../../models/notification_model.dart';
import '../../models/assignment_model.dart';
import '../../models/message_model.dart';
import '../services/api_service.dart';
import '../../controllers/auth_controller.dart';

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
      debugPrint('Error loading dashboard data: $e');
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
      final today = DateTime.now();
      todayAttendance.value = response.firstWhereOrNull(
        (attendance) =>
            attendance.date.year == today.year &&
            attendance.date.month == today.month &&
            attendance.date.day == today.day,
      );
    } catch (e) {
      // Mock today attendance
      final now = DateTime.now();
      todayAttendance.value = Attendance(
        id: 1,
        userId: user.value?.id ?? 1,
        date: now,
        checkInTime: '08:00',
        status: 'present',
        isOfflineSync: false,
        createdAt: now,
        updatedAt: now,
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
          userId: user.value?.id ?? 1,
          title: 'Pengumuman Libur',
          message: 'Besok ada libur nasional',
          type: 'system',
          isRead: false,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          updatedAt: DateTime.now().subtract(Duration(hours: 2)),
        ),
        NotificationModel(
          id: 2,
          userId: user.value?.id ?? 1,
          title: 'Tugas Matematika',
          message: 'Deadline tugas besok',
          type: 'assignment',
          isRead: true,
          createdAt: DateTime.now().subtract(Duration(hours: 8)),
          updatedAt: DateTime.now().subtract(Duration(hours: 8)),
        ),
        NotificationModel(
          id: 3,
          userId: user.value?.id ?? 1,
          title: 'Ujian Akhir Semester',
          message: 'Jadwal UAS telah diumumkan',
          type: 'schedule',
          isRead: false,
          createdAt: DateTime.now().subtract(Duration(hours: 24)),
          updatedAt: DateTime.now().subtract(Duration(hours: 24)),
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
          createdAt: DateTime.now()
              .subtract(Duration(hours: 20))
              .toIso8601String(),
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
