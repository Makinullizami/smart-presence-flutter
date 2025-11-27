import '../../models/assignment_model.dart';
import 'api_service.dart';

class AssignmentsService {
  final ApiService _apiService = ApiService();

  Future<List<Assignment>> fetchAssignments() async {
    try {
      // Mock data for now
      return _getMockAssignments();
    } catch (e) {
      print('Error fetching assignments: $e');
      return _getMockAssignments();
    }
  }

  Future<void> submitAssignment(int assignmentId, String filePath) async {
    try {
      // This would upload the file to the server
      print('Submitted assignment $assignmentId');
    } catch (e) {
      print('Error submitting assignment: $e');
    }
  }

  List<Assignment> _getMockAssignments() {
    return [
      Assignment(
        id: 1,
        title: 'Tugas Matematika',
        description: 'Kerjakan soal halaman 45-50 tentang aljabar linear',
        dueDate: '2024-12-01',
        status: 'pending',
      ),
      Assignment(
        id: 2,
        title: 'Makalah Bahasa Indonesia',
        description:
            'Tema: Pengaruh Teknologi Modern terhadap Bahasa Indonesia',
        dueDate: '2024-12-05',
        status: 'submitted',
      ),
      Assignment(
        id: 3,
        title: 'Praktikum Fisika',
        description: 'Laporan praktikum gerak parabola',
        dueDate: '2024-12-03',
        status: 'pending',
        attachmentUrl: 'https://example.com/assignment3.pdf',
      ),
    ];
  }
}
