import 'package:get/get.dart';
import '../../models/appeal_model.dart';
import '../services/api_service.dart';

class AppealsController extends GetxController {
  final ApiService _apiService = ApiService();

  var appeals = <Appeal>[].obs;
  var isLoading = false.obs;

  Future<void> createAppeal(
    int attendanceId,
    String reason,
    String evidencePath,
  ) async {
    isLoading.value = true;
    try {
      // This would call the real API
      // For now, create mock appeal
      final appeal = Appeal(
        id: DateTime.now().millisecondsSinceEpoch,
        attendanceId: attendanceId,
        userId: 1, // Mock user ID
        reason: reason,
        status: 'pending',
        createdAt: DateTime.now().toIso8601String(),
        evidencePath: evidencePath,
      );
      appeals.add(appeal);
      Get.snackbar('Berhasil', 'Banding berhasil diajukan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengajukan banding: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAppeals() async {
    isLoading.value = true;
    try {
      // Mock appeals data
      appeals.value = [
        Appeal(
          id: 1,
          attendanceId: 1,
          userId: 1,
          reason: 'Terlambat karena macet',
          status: 'pending',
          createdAt: '2024-11-27T08:00:00Z',
        ),
      ];
    } catch (e) {
      print('Error fetching appeals: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
