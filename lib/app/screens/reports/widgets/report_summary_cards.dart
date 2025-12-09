import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/report_controller.dart';

class ReportSummaryCards extends GetView<ReportController> {
  const ReportSummaryCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary = controller.reportResult.value?.summary;
    if (summary == null) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          SizedBox(height: 16),
          GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildSummaryCard(
                'Total Hari Kerja',
                summary.totalDays.toString(),
                Icons.calendar_today,
                Colors.blue,
              ),
              _buildSummaryCard(
                'Total Hadir',
                summary.totalPresent.toString(),
                Icons.check_circle,
                Colors.green,
              ),
              _buildSummaryCard(
                'Total Terlambat',
                summary.totalLate.toString(),
                Icons.schedule,
                Colors.orange,
              ),
              _buildSummaryCard(
                'Total Izin',
                summary.totalPermission.toString(),
                Icons.sick,
                Colors.purple,
              ),
              _buildSummaryCard(
                'Total Sakit',
                summary.totalSick.toString(),
                Icons.local_hospital,
                Colors.red,
              ),
              _buildSummaryCard(
                'Total Alfa',
                summary.totalAbsent.toString(),
                Icons.cancel,
                Colors.grey,
              ),
              _buildSummaryCard(
                'Total Lembur',
                summary.totalOvertime.toString(),
                Icons.work,
                Colors.indigo,
              ),
              _buildSummaryCard(
                'Persentase Kehadiran',
                '${summary.averageAttendancePercent.toStringAsFixed(1)}%',
                Icons.pie_chart,
                Colors.teal,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
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
}
