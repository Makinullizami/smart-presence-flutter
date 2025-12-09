import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_dashboard_controller.dart';
import '../../../controllers/auth_controller.dart';
import 'attendance_card.dart';
import 'stats_card.dart';
import 'timetable_card.dart';
import 'notifications_card.dart';
import 'assignments_card.dart';
import 'messages_card.dart';
import 'profile_card.dart';

class StudentDashboardView extends StatelessWidget {
  const StudentDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StudentDashboardController controller = Get.put(
      StudentDashboardController(),
    );
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Siswa'),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  const ProfileCard(),

                  const SizedBox(height: 20),

                  // Quick Attendance Section
                  const AttendanceCard(),

                  const SizedBox(height: 20),

                  // Stats Section
                  const StatsCard(),

                  const SizedBox(height: 20),

                  // Today's Timetable
                  const TimetableCard(),

                  const SizedBox(height: 20),

                  // Notifications
                  const NotificationsCard(),

                  const SizedBox(height: 20),

                  // Assignments
                  const AssignmentsCard(),

                  const SizedBox(height: 20),

                  // Messages
                  const MessagesCard(),

                  const SizedBox(height: 20),

                  // Quick Actions
                  _buildQuickActions(),

                  const SizedBox(height: 20),

                  // Footer
                  _buildFooter(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.face,
                  label: 'Re-enroll Face',
                  onTap: () {
                    Get.snackbar(
                      'Info',
                      'Fitur re-enroll face akan segera hadir',
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.photo_camera,
                  label: 'Upload Foto',
                  onTap: () {
                    Get.snackbar('Info', 'Fitur upload foto akan segera hadir');
                  },
                ),
                _buildActionButton(
                  icon: Icons.approval,
                  label: 'Request Appeal',
                  onTap: () {
                    Get.toNamed('/appeals');
                  },
                ),
                _buildActionButton(
                  icon: Icons.qr_code,
                  label: 'QR Backup',
                  onTap: () {
                    Get.snackbar('Info', 'Fitur QR backup akan segera hadir');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue.shade600, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.blue.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            'Smart Presence - Absen Cerdas',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'v1.0.0 - Flutter + Laravel',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
