import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_dashboard_controller.dart';

class ProfileCard extends StatelessWidget {
  final StudentDashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.user.value;
      final todayAttendance = controller.todayAttendance.value;

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              // Profile Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.blue.shade600,
                ),
              ),
              SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Nama Siswa',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'NIM: ${user?.nim ?? '12345678'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    Text(
                      'Kelas: ${user?.className ?? 'XII IPA 1'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // Attendance Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: todayAttendance != null
                      ? Colors.green.shade500
                      : Colors.orange.shade500,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      todayAttendance != null
                          ? Icons.check_circle
                          : Icons.schedule,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      todayAttendance != null ? 'Hadir' : 'Belum Absen',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
}
