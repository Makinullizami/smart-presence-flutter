import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/supervisor_dashboard_controller.dart';

class SupervisorStatsCard extends StatelessWidget {
  final SupervisorDashboardController controller =
      Get.find<SupervisorDashboardController>();

  SupervisorStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value ||
          controller.dashboardData.value == null) {
        return const Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      final data = controller.dashboardData.value!;
      final totalStudents = data.classes.fold(
        0,
        (sum, cls) => sum + cls.totalStudents,
      );
      final totalPresent = data.classes.fold(
        0,
        (sum, cls) => sum + cls.presentCount,
      );
      final totalLate = data.classes.fold(0, (sum, cls) => sum + cls.lateCount);
      final totalAbsent = data.classes.fold(
        0,
        (sum, cls) => sum + cls.absentCount,
      );
      final attendanceRate = totalStudents > 0
          ? (totalPresent / totalStudents * 100)
          : 0.0;

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Statistik Hari Ini',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      icon: Icons.people,
                      label: 'Total Siswa',
                      value: totalStudents.toString(),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      icon: Icons.check_circle,
                      label: 'Hadir',
                      value: totalPresent.toString(),
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      icon: Icons.access_time,
                      label: 'Terlambat',
                      value: totalLate.toString(),
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      icon: Icons.cancel,
                      label: 'Tidak Hadir',
                      value: totalAbsent.toString(),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tingkat Kehadiran: ${attendanceRate.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
