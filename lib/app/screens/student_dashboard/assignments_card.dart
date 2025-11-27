import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_dashboard_controller.dart';
import '../../models/assignment_model.dart';

class AssignmentsCard extends StatelessWidget {
  final StudentDashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final assignments = controller.assignments.take(3).toList();

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment, color: Colors.blue.shade600, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Tugas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.snackbar(
                        'Info',
                        'Halaman tugas lengkap akan segera hadir',
                      );
                    },
                    child: Text('Lihat Semua'),
                  ),
                ],
              ),
              SizedBox(height: 16),

              if (assignments.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment_turned_in,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tidak ada tugas',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: assignments.length,
                  itemBuilder: (context, index) {
                    final assignment = assignments[index];
                    return _buildAssignmentItem(assignment);
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildAssignmentItem(Assignment assignment) {
    final isOverdue = DateTime.now().isAfter(
      DateTime.parse(assignment.dueDate),
    );
    final isSubmitted = assignment.status == 'submitted';

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSubmitted
            ? Colors.green.shade50
            : isOverdue
            ? Colors.red.shade50
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSubmitted
              ? Colors.green.shade200
              : isOverdue
              ? Colors.red.shade200
              : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: isSubmitted
                  ? Colors.green.shade500
                  : isOverdue
                  ? Colors.red.shade500
                  : Colors.orange.shade500,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignment.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Deadline: ${_formatDate(assignment.dueDate)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isOverdue
                        ? Colors.red.shade600
                        : Colors.grey.shade600,
                  ),
                ),
                Text(
                  'Status: ${assignment.status == 'pending'
                      ? 'Belum Dikerjakan'
                      : assignment.status == 'submitted'
                      ? 'Sudah Dikumpul'
                      : assignment.status}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          if (!isSubmitted)
            IconButton(
              onPressed: () {
                Get.snackbar('Info', 'Fitur submit tugas akan segera hadir');
              },
              icon: Icon(
                Icons.upload_file,
                color: Colors.blue.shade600,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
