import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/report_controller.dart';
import 'widgets/report_filter_panel.dart';
import 'widgets/report_summary_cards.dart';
import 'widgets/report_dynamic_table.dart';

class AttendanceReportPage extends GetView<ReportController> {
  const AttendanceReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.report, size: 28),
            SizedBox(width: 8),
            Text('📊 Laporan Kehadiran'),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard > Laporan',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Laporan Kehadiran',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rekap data kehadiran berdasarkan tanggal, pengguna, kelas, dan departemen.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              // Filter Panel
              ReportFilterPanel(),

              // Summary Cards (shown only when report is loaded)
              Obx(() {
                if (controller.reportResult.value != null) {
                  return ReportSummaryCards();
                }
                return SizedBox.shrink();
              }),

              // Export Buttons (shown only when report is loaded)
              Obx(() {
                if (controller.reportResult.value != null) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.exportToExcel,
                          icon: Icon(Icons.file_download),
                          label: Text('Export Excel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: controller.exportToPdf,
                          icon: Icon(Icons.picture_as_pdf),
                          label: Text('Export PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: controller.printReport,
                          icon: Icon(Icons.print),
                          label: Text('Cetak'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              }),

              SizedBox(height: 16),

              // Dynamic Table
              ReportDynamicTable(),
            ],
          ),
        ),
      ),
    );
  }
}
