import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_dashboard_controller.dart';

class StatsCard extends StatelessWidget {
  final StudentDashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = controller.attendanceStats.value;

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
                  Icon(Icons.bar_chart, color: Colors.blue.shade600, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Statistik Kehadiran',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Hadir',
                      stats?.totalPresent.toString() ?? '25',
                      Colors.green.shade500,
                      Icons.check_circle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      'Tidak Hadir',
                      stats?.totalAbsent.toString() ?? '2',
                      Colors.red.shade500,
                      Icons.cancel,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Terlambat',
                      stats?.totalLate.toString() ?? '3',
                      Colors.orange.shade500,
                      Icons.schedule,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      'Persentase',
                      '${stats?.attendancePercentage.toStringAsFixed(1) ?? '89.3'}%',
                      Colors.blue.shade500,
                      Icons.percent,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Current Streak
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange.shade600,
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Streak Kehadiran',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          Text(
                            '${stats?.currentStreak ?? 5} hari berturut-turut',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
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
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 2),
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
