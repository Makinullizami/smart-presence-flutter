import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/supervisor_dashboard_controller.dart';

class AttendanceVerificationCard extends StatelessWidget {
  final SupervisorDashboardController controller =
      Get.find<SupervisorDashboardController>();

  AttendanceVerificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value ||
          controller.dashboardData.value == null) {
        return const SizedBox.shrink();
      }

      final data = controller.dashboardData.value!;
      final recentAttendances = data.classes
          .expand((cls) => cls.attendanceDetails)
          .take(3)
          .toList();

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.verified_user,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Verifikasi Kehadiran Terbaru',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (recentAttendances.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Belum ada data kehadiran hari ini'),
                  ),
                )
              else
                ...recentAttendances.map(
                  (attendance) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue[100],
                          child: Text(attendance.name[0]),
                          radius: 16,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                attendance.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Check-in: ${attendance.checkInTime ?? 'N/A'}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: attendance.status == 'present'
                                ? Colors.green[100]
                                : attendance.status == 'late'
                                ? Colors.orange[100]
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            attendance.status == 'present'
                                ? 'Hadir'
                                : attendance.status == 'late'
                                ? 'Terlambat'
                                : 'Tidak Hadir',
                            style: TextStyle(
                              color: attendance.status == 'present'
                                  ? Colors.green[800]
                                  : attendance.status == 'late'
                                  ? Colors.orange[800]
                                  : Colors.red[800],
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
