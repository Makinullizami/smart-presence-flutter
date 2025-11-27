import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_dashboard_controller.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StudentDashboardController dashboardController = Get.find();

    return Obx(() {
      final todayAttendance = dashboardController.todayAttendance.value;

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
                    Icons.access_time,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Absensi Hari Ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Status
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: todayAttendance != null
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: todayAttendance != null
                        ? Colors.green.shade200
                        : Colors.orange.shade200,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      todayAttendance != null
                          ? Icons.check_circle
                          : Icons.schedule,
                      color: todayAttendance != null
                          ? Colors.green.shade600
                          : Colors.orange.shade600,
                      size: 32,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todayAttendance != null
                                ? 'Sudah Absen'
                                : 'Belum Absen Hari Ini',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: todayAttendance != null
                                  ? Colors.green.shade700
                                  : Colors.orange.shade700,
                            ),
                          ),
                          if (todayAttendance != null)
                            Text(
                              'Jam: ${todayAttendance.time}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: todayAttendance == null
                      ? dashboardController.goToAttendance
                      : null,
                  icon: Icon(
                    todayAttendance == null ? Icons.camera_alt : Icons.check,
                  ),
                  label: Text(
                    todayAttendance == null ? 'Absen Sekarang' : 'Sudah Absen',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: todayAttendance == null
                        ? Colors.blue.shade600
                        : Colors.grey.shade400,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              if (todayAttendance == null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'Tekan tombol di atas untuk melakukan absensi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
