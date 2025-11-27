import 'package:get/get.dart';
import '../services/api_service.dart';
import '../../models/attendance_model.dart';

class AttendanceController extends GetxController {
  final ApiService _apiService = ApiService();

  var attendances = <Attendance>[].obs;
  var isLoading = false.obs;

  Future<void> markAttendance(int userId) async {
    isLoading.value = true;
    try {
      await _apiService.markAttendance(userId);
      Get.snackbar('Berhasil', 'Kehadiran berhasil ditandai');
      await fetchAttendanceHistory(userId);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menandai kehadiran: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAttendanceHistory(int userId) async {
    isLoading.value = true;
    try {
      attendances.value = await _apiService.getAttendanceHistory(userId);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat kehadiran: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
