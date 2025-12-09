import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/dashboard_model.dart';

class SupervisorDashboardController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final dashboardData = Rxn<SupervisorDashboard>();

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      // In demo mode, create mock data
      final today = DateTime.now().toIso8601String().split('T')[0];
      dashboardData.value = SupervisorDashboard(
        date: today,
        classes: [
          ClassDashboard(
            classId: 1,
            className: 'Kelas A',
            totalStudents: 18,
            presentCount: 15,
            lateCount: 1,
            absentCount: 2,
            attendancePercentage: 83.3,
            attendanceDetails: [
              StudentAttendance(
                userId: 1,
                name: 'Ahmad Surya',
                status: 'present',
                checkInTime: '07:45',
              ),
              StudentAttendance(
                userId: 2,
                name: 'Siti Aminah',
                status: 'late',
                checkInTime: '08:15',
                notes: 'Terlambat 15 menit',
              ),
            ],
          ),
          ClassDashboard(
            classId: 2,
            className: 'Kelas B',
            totalStudents: 16,
            presentCount: 12,
            lateCount: 1,
            absentCount: 3,
            attendancePercentage: 75.0,
            attendanceDetails: [
              StudentAttendance(
                userId: 3,
                name: 'Budi Santoso',
                status: 'present',
                checkInTime: '07:30',
              ),
            ],
          ),
          ClassDashboard(
            classId: 3,
            className: 'Kelas C',
            totalStudents: 20,
            presentCount: 11,
            lateCount: 1,
            absentCount: 8,
            attendancePercentage: 55.0,
            attendanceDetails: [],
          ),
        ],
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }

  Future<void> approveLeave(int leaveId) async {
    try {
      // Mock approval
      Get.snackbar('Success', 'Leave request approved');
      await refreshData();
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve leave: $e');
    }
  }

  Future<void> rejectLeave(int leaveId) async {
    try {
      // Mock rejection
      Get.snackbar('Success', 'Leave request rejected');
      await refreshData();
    } catch (e) {
      Get.snackbar('Error', 'Failed to reject leave: $e');
    }
  }

  Future<void> addAttendanceNote(int userId, String note) async {
    try {
      // Mock note addition
      Get.snackbar('Success', 'Attendance note added');
      await refreshData();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add note: $e');
    }
  }
}
