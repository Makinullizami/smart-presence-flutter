import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_presence/controllers/auth_controller.dart';
import '../../controllers/admin_controller.dart';
import '../../../models/dashboard_model.dart';
import '../../routes/app_routes.dart';

class DashboardAdminView extends GetView<AdminController> {
  const DashboardAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.dashboard, size: 28),
            SizedBox(width: 8),
            Text('🏠 Dashboard Utama'),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      ),
      drawer: _buildDrawer(),
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
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.dashboard.value == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal memuat data dashboard'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: controller.fetchDashboard,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final data = controller.dashboard.value!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: 16),
                _buildQuickActionsRow(),
                const SizedBox(height: 24),

                // Global Filters
                _buildGlobalFilters(controller),
                const SizedBox(height: 24),

                // KPI Cards
                _buildKPICards(data.kpi),
                const SizedBox(height: 32),

                // Charts
                _buildCharts(data.charts),
                const SizedBox(height: 32),

                // Summary Tables
                _buildSummaryTables(data.tables),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Bagian ucapan selamat datang
  Widget _buildWelcomeSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 26,
              child: Icon(Icons.admin_panel_settings, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, Admin 👋',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Berikut ringkasan kehadiran dan aktivitas penting hari ini.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Aksi cepat menuju modul-modul utama
  Widget _buildQuickActionsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final children = [
          _buildQuickActionCard(
            icon: Icons.people,
            label: 'Manajemen Pengguna',
            color: Colors.blue,
            onTap: () => Get.toNamed(AppRoutes.userManagement),
          ),
          _buildQuickActionCard(
            icon: Icons.business,
            label: 'Manajemen Departemen',
            color: Colors.indigo,
            onTap: () => Get.toNamed(AppRoutes.departmentManagement),
          ),
          _buildQuickActionCard(
            icon: Icons.class_,
            label: 'Manajemen Kelas',
            color: Colors.teal,
            onTap: () => Get.toNamed(AppRoutes.classManagement),
          ),
          _buildQuickActionCard(
            icon: Icons.analytics,
            label: 'Laporan Kehadiran',
            color: Colors.deepOrange,
            onTap: () => Get.toNamed(AppRoutes.reports),
          ),
        ];

        if (isWide) {
          return Row(
            children: children
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: c,
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Column(
          children: children
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: c,
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlobalFilters(AdminController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Global',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sesuaikan periode dan unit untuk melihat data dashboard sesuai kebutuhan.',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: controller.selectedFilter.value,
                    decoration: const InputDecoration(
                      labelText: 'Periode',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'today', child: Text('Hari Ini')),
                      DropdownMenuItem(
                        value: 'week',
                        child: Text('Minggu Ini'),
                      ),
                      DropdownMenuItem(
                        value: 'month',
                        child: Text('Bulan Ini'),
                      ),
                    ],
                    onChanged: (value) {
                      controller.updateFilters(filter: value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: controller.selectedUnit.value,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Semua')),
                      // Tambahkan opsi unit/departemen/kelas dari controller jika sudah ada
                    ],
                    onChanged: (value) {
                      controller.updateFilters(unit: value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: controller.fetchDashboard,
                icon: const Icon(Icons.refresh),
                label: const Text('Terapkan / Refresh'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICards(AdminKPI kpi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Cepat (KPI)',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Pantau jumlah user aktif, kehadiran, keterlambatan, dan izin hari ini.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildKPICard(
              'Total User Aktif',
              kpi.totalActiveUsers.toString(),
              Icons.people,
              Colors.blue,
            ),
            _buildKPICard(
              'Hadir Hari Ini',
              kpi.presentToday.toString(),
              Icons.check_circle,
              Colors.green,
            ),
            _buildKPICard(
              'Terlambat Hari Ini',
              kpi.lateToday.toString(),
              Icons.schedule,
              Colors.orange,
            ),
            _buildKPICard(
              'Izin/Cuti/Sakit Hari Ini',
              kpi.leaveToday.toString(),
              Icons.sick,
              Colors.purple,
            ),
            _buildKPICard(
              'Tidak Hadir (Alfa)',
              kpi.absentToday.toString(),
              Icons.cancel,
              Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
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

  Widget _buildCharts(AdminCharts charts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Grafik Kehadiran',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 16),
        // Weekly Attendance Chart
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grafik Batang: Kehadiran per Hari (Minggu Ini)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: charts.weeklyAttendance.isNotEmpty
                          ? charts.weeklyAttendance
                                    .map((e) => e.present.toDouble())
                                    .reduce((a, b) => a > b ? a : b) +
                                10
                          : 100,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() <
                                  charts.weeklyAttendance.length) {
                                final date =
                                    charts.weeklyAttendance[value.toInt()].date;
                                final weekday = DateTime.parse(date).weekday;
                                const labels = [
                                  'Sen',
                                  'Sel',
                                  'Rab',
                                  'Kam',
                                  'Jum',
                                  'Sab',
                                  'Min',
                                ];
                                return Text(labels[weekday - 1]);
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: false),
                      barGroups: charts.weeklyAttendance.asMap().entries.map((
                        entry,
                      ) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.present.toDouble(),
                              color: Colors.blue,
                              width: 16,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Distribution Pie Chart
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grafik Pie: Distribusi Status Kehadiran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: charts.distribution.present.toDouble(),
                          title: 'Hadir\n${charts.distribution.present}',
                          color: Colors.green,
                          radius: 60,
                        ),
                        PieChartSectionData(
                          value: charts.distribution.late.toDouble(),
                          title: 'Terlambat\n${charts.distribution.late}',
                          color: Colors.orange,
                          radius: 60,
                        ),
                        PieChartSectionData(
                          value: charts.distribution.absent.toDouble(),
                          title: 'Alfa\n${charts.distribution.absent}',
                          color: Colors.red,
                          radius: 60,
                        ),
                        PieChartSectionData(
                          value: charts.distribution.leave.toDouble(),
                          title:
                              'Izin/Cuti/Sakit\n${charts.distribution.leave}',
                          color: Colors.purple,
                          radius: 60,
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryTables(AdminTables tables) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tabel Ringkasan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 16),
        // Top 10 Late Users
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top 10 Pegawai/Mahasiswa Paling Sering Terlambat',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tables.topLateUsers.length,
                  itemBuilder: (context, index) {
                    final user = tables.topLateUsers[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(user.name),
                      subtitle: Text('Terlambat ${user.lateCount}x'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Pending Appeals
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Izin yang Pending Approval',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (tables.pendingAppeals.isEmpty)
                  const Text(
                    'Tidak ada izin yang pending.',
                    style: TextStyle(fontSize: 13),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tables.pendingAppeals.length,
                    itemBuilder: (context, index) {
                      final appeal = tables.pendingAppeals[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appeal.userName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${appeal.type} - ${appeal.reason}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              appeal.createdAt,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Lowest Attendance Classes
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kelas/Tim dengan Kehadiran Terendah Hari Ini',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (tables.lowestAttendanceClasses.isEmpty)
                  const Text(
                    'Semua kelas/tim memiliki kehadiran yang cukup baik hari ini.',
                    style: TextStyle(fontSize: 13),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tables.lowestAttendanceClasses.length,
                    itemBuilder: (context, index) {
                      final cls = tables.lowestAttendanceClasses[index];
                      return ListTile(
                        title: Text(cls.className),
                        trailing: Text(
                          '${cls.attendancePercentage}%',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: Colors.blue.shade600,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sistem Kehadiran',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: true,
            onTap: () {
              Get.back(); // Close drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Manajemen Pengguna'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.userManagement);
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Manajemen Departemen'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.departmentManagement);
            },
          ),
          ListTile(
            leading: const Icon(Icons.class_),
            title: const Text('Manajemen Kelas'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.classManagement);
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Laporan'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.reports);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.settings);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Get.back();
              Get.find<AuthController>().logout();
            },
          ),
        ],
      ),
    );
  }
}
