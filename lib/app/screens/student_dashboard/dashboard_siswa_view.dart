import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_presence/controllers/attendance_controller.dart';
import 'package:smart_presence/controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class DashboardSiswaView extends StatefulWidget {
  const DashboardSiswaView({Key? key}) : super(key: key);

  @override
  State<DashboardSiswaView> createState() => _DashboardSiswaViewState();
}

class _DashboardSiswaViewState extends State<DashboardSiswaView> {
  late final AttendanceController attendanceController;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    attendanceController = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Siswa'),
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Get.toNamed(AppRoutes.notifications),
          ),
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
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => attendanceController.loadAttendances(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Obx(
                  () => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green[600]!, Colors.green[800]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authController.user.value?.name ?? 'Siswa',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dashboard Siswa • ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Kehadiran Bulan Ini',
                        '28/30',
                        Icons.calendar_today,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Persentase',
                        '93%',
                        Icons.pie_chart,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Terlambat',
                        '2',
                        Icons.schedule,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Tidak Hadir',
                        '0',
                        Icons.cancel,
                        Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Quick Actions
                Text(
                  'Aksi Cepat',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Action Buttons Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.camera_alt,
                      title: 'Absensi',
                      subtitle: 'Lakukan absensi wajah',
                      color: Colors.green,
                      onTap: () => Get.toNamed(AppRoutes.attendance),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.calendar_view_day,
                      title: 'Riwayat',
                      subtitle: 'Lihat riwayat absensi',
                      color: Colors.blue,
                      onTap: () => Get.toNamed(AppRoutes.personalReport),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.event_note,
                      title: 'Izin/Cuti',
                      subtitle: 'Ajukan izin atau cuti',
                      color: Colors.orange,
                      onTap: () => _showLeaveRequestDialog(context),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.schedule,
                      title: 'Jadwal',
                      subtitle: 'Lihat jadwal kuliah',
                      color: Colors.purple,
                      onTap: () => _showScheduleDialog(context),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.announcement,
                      title: 'Pengumuman',
                      subtitle: 'Informasi terbaru',
                      color: Colors.teal,
                      onTap: () => Get.toNamed(AppRoutes.announcements),
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.person,
                      title: 'Profil',
                      subtitle: 'Kelola profil Anda',
                      color: Colors.indigo,
                      onTap: () => Get.toNamed('/profile'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Recent Attendance
                Text(
                  'Riwayat Kehadiran Terbaru',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                Obx(
                  () => attendanceController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: attendanceController.attendances.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Center(
                                    child: Text(
                                      'Belum ada data kehadiran',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      attendanceController.attendances.length >
                                          5
                                      ? 5
                                      : attendanceController.attendances.length,
                                  itemBuilder: (context, index) {
                                    final attendance =
                                        attendanceController.attendances[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            attendance.status == 'present'
                                            ? Colors.green.shade100
                                            : attendance.status == 'late'
                                            ? Colors.orange.shade100
                                            : Colors.red.shade100,
                                        child: Icon(
                                          attendance.status == 'present'
                                              ? Icons.check
                                              : attendance.status == 'late'
                                              ? Icons.schedule
                                              : Icons.close,
                                          color: attendance.status == 'present'
                                              ? Colors.green
                                              : attendance.status == 'late'
                                              ? Colors.orange
                                              : Colors.red,
                                        ),
                                      ),
                                      title: Text(
                                        'Tanggal: ${attendance.date.toIso8601String().split('T')[0]}',
                                      ),
                                      subtitle: Text(
                                        'Waktu: ${attendance.checkInTime ?? '-'}',
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: attendance.status == 'present'
                                              ? Colors.green.shade100
                                              : attendance.status == 'late'
                                              ? Colors.orange.shade100
                                              : Colors.red.shade100,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          attendance.statusText,
                                          style: TextStyle(
                                            color:
                                                attendance.status == 'present'
                                                ? Colors.green.shade800
                                                : attendance.status == 'late'
                                                ? Colors.orange.shade800
                                                : Colors.red.shade800,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                ),

                const SizedBox(height: 24),

                // Announcements Preview
                Text(
                  'Pengumuman Terbaru',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _buildAnnouncementPreview(context),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementPreview(BuildContext context) {
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
                Icon(Icons.campaign, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Pengumuman Terbaru',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Mock announcement
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jadwal Ujian Tengah Semester',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ujian tengah semester akan dimulai pada tanggal 15 November 2024. Pastikan untuk mempersiapkan diri dengan baik.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2 jam yang lalu',
                    style: TextStyle(color: Colors.grey[500], fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => Get.toNamed(AppRoutes.announcements),
                child: const Text('Lihat Semua Pengumuman'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLeaveRequestDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Ajukan Izin/Cuti'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Jenis Izin',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'izin', child: Text('Izin')),
                DropdownMenuItem(value: 'sakit', child: Text('Sakit')),
                DropdownMenuItem(value: 'cuti', child: Text('Cuti')),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tanggal Mulai',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                // Show date picker
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tanggal Selesai',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                // Show date picker
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Alasan',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Sukses', 'Permohonan izin telah diajukan');
            },
            child: const Text('Ajukan'),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Jadwal Hari Ini',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildScheduleItem(
                    '08:00 - 10:00',
                    'Matematika',
                    'Ruang 101',
                    Colors.blue,
                  ),
                  _buildScheduleItem(
                    '10:30 - 12:00',
                    'Bahasa Indonesia',
                    'Ruang 202',
                    Colors.green,
                  ),
                  _buildScheduleItem(
                    '13:00 - 14:30',
                    'Fisika',
                    'Lab Fisika',
                    Colors.orange,
                  ),
                  _buildScheduleItem(
                    '15:00 - 16:30',
                    'Kimia',
                    'Lab Kimia',
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    String time,
    String subject,
    String room,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    room,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
