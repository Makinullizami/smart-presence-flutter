import 'package:get/get.dart';
import '../../models/assignment_model.dart';
import '../services/assignments_service.dart';

class AssignmentsController extends GetxController {
  final AssignmentsService _assignmentsService = AssignmentsService();

  var assignments = <Assignment>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAssignments();
  }

  Future<void> fetchAssignments() async {
    isLoading.value = true;
    try {
      assignments.value = await _assignmentsService.fetchAssignments();
    } catch (e) {
      print('Error fetching assignments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAssignment(int assignmentId, String filePath) async {
    try {
      await _assignmentsService.submitAssignment(assignmentId, filePath);
      Get.snackbar('Berhasil', 'Tugas berhasil dikumpulkan');
      await fetchAssignments(); // Refresh list
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengumpulkan tugas: $e');
    }
  }
}
