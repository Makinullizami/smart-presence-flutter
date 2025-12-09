import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/report_controller.dart';
import 'package:smart_presence/models/report_model.dart';

class ReportDynamicTable extends GetView<ReportController> {
  const ReportDynamicTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(controller.errorMessage.value),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadReport(),
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      final result = controller.reportResult.value;
      if (result == null || result.rows.isEmpty) {
        return Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 200,
            child: Center(child: Text('Tidak ada data untuk ditampilkan')),
          ),
        );
      }

      return Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Table header with search
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari dalam tabel...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        // TODO: Implement table search
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Menampilkan ${result.rows.length} data'),
                ],
              ),
            ),

            // Table
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: _getColumns(controller.selectedReportType.value),
                    rows: _getRows(
                      result.rows,
                      controller.selectedReportType.value,
                      controller,
                    ),
                  ),
                ),
              ),
            ),

            // Pagination
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Tampilkan: '),
                      DropdownButton<int>(
                        value: controller.perPage.value,
                        items: [10, 25, 50]
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text('$value'),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => controller.changePerPage(value!),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: controller.currentPage.value > 1
                            ? () => controller.changePage(
                                controller.currentPage.value - 1,
                              )
                            : null,
                        icon: Icon(Icons.chevron_left),
                      ),
                      Text('Halaman ${controller.currentPage.value}'),
                      IconButton(
                        onPressed:
                            controller.currentPage.value <
                                controller.totalPages.value
                            ? () => controller.changePage(
                                controller.currentPage.value + 1,
                              )
                            : null,
                        icon: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  List<DataColumn> _getColumns(ReportType reportType) {
    switch (reportType) {
      case ReportType.perUser:
        return [
          DataColumn(label: Text('Tanggal')),
          DataColumn(label: Text('Nama Pengguna')),
          DataColumn(label: Text('NIP/NIM')),
          DataColumn(label: Text('Departemen')),
          DataColumn(label: Text('Kelas')),
          DataColumn(label: Text('Jam Masuk')),
          DataColumn(label: Text('Jam Pulang')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Keterangan')),
        ];
      case ReportType.perClass:
        return [
          DataColumn(label: Text('Tanggal')),
          DataColumn(label: Text('Nama Kelas')),
          DataColumn(label: Text('Departemen')),
          DataColumn(label: Text('Jumlah Anggota')),
          DataColumn(label: Text('Hadir')),
          DataColumn(label: Text('Terlambat')),
          DataColumn(label: Text('Izin')),
          DataColumn(label: Text('Sakit')),
          DataColumn(label: Text('Alfa')),
          DataColumn(label: Text('Persentase')),
        ];
      case ReportType.perDepartment:
        return [
          DataColumn(label: Text('Tanggal/Bulan')),
          DataColumn(label: Text('Departemen')),
          DataColumn(label: Text('Jumlah Anggota')),
          DataColumn(label: Text('Hadir')),
          DataColumn(label: Text('Terlambat')),
          DataColumn(label: Text('Izin')),
          DataColumn(label: Text('Sakit')),
          DataColumn(label: Text('Alfa')),
          DataColumn(label: Text('Persentase')),
        ];
      case ReportType.leaveSummary:
        return [
          DataColumn(label: Text('Tanggal')),
          DataColumn(label: Text('Nama Pengguna')),
          DataColumn(label: Text('NIP/NIM')),
          DataColumn(label: Text('Jenis')),
          DataColumn(label: Text('Alasan')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Disetujui Oleh')),
        ];
      default:
        return [DataColumn(label: Text('Data'))];
    }
  }

  List<DataRow> _getRows(
    List<dynamic> rows,
    ReportType reportType,
    ReportController controller,
  ) {
    return rows.map((row) {
      switch (reportType) {
        case ReportType.perUser:
          final userRow = row as AttendanceRecordRow;
          return DataRow(
            cells: [
              DataCell(Text(userRow.date)),
              DataCell(Text(userRow.userName)),
              DataCell(Text(userRow.userCode)),
              DataCell(Text(userRow.departmentName)),
              DataCell(Text(userRow.className)),
              DataCell(Text(userRow.checkInTime ?? '-')),
              DataCell(Text(userRow.checkOutTime ?? '-')),
              DataCell(_buildStatusChip(userRow.status, controller)),
              DataCell(Text(userRow.note ?? '-')),
            ],
          );
        case ReportType.perClass:
          final classRow = row as ClassReportRow;
          return DataRow(
            cells: [
              DataCell(Text(classRow.date)),
              DataCell(Text(classRow.className)),
              DataCell(Text(classRow.departmentName)),
              DataCell(Text(classRow.membersCount.toString())),
              DataCell(Text(classRow.presentCount.toString())),
              DataCell(Text(classRow.lateCount.toString())),
              DataCell(Text(classRow.permissionCount.toString())),
              DataCell(Text(classRow.sickCount.toString())),
              DataCell(Text(classRow.absentCount.toString())),
              DataCell(
                Text('${classRow.attendancePercent.toStringAsFixed(1)}%'),
              ),
            ],
          );
        case ReportType.perDepartment:
          final deptRow = row as DepartmentReportRow;
          return DataRow(
            cells: [
              DataCell(Text(deptRow.dateOrMonth)),
              DataCell(Text(deptRow.departmentName)),
              DataCell(Text(deptRow.membersCount.toString())),
              DataCell(Text(deptRow.presentCount.toString())),
              DataCell(Text(deptRow.lateCount.toString())),
              DataCell(Text(deptRow.permissionCount.toString())),
              DataCell(Text(deptRow.sickCount.toString())),
              DataCell(Text(deptRow.absentCount.toString())),
              DataCell(
                Text('${deptRow.attendancePercent.toStringAsFixed(1)}%'),
              ),
            ],
          );
        case ReportType.leaveSummary:
          final leaveRow = row as LeaveReportRow;
          return DataRow(
            cells: [
              DataCell(Text(leaveRow.date)),
              DataCell(Text(leaveRow.userName)),
              DataCell(Text(leaveRow.userCode)),
              DataCell(Text(leaveRow.type)),
              DataCell(Text(leaveRow.reason)),
              DataCell(_buildLeaveStatusChip(leaveRow.status)),
              DataCell(Text(leaveRow.approvedByName ?? '-')),
            ],
          );
        default:
          return DataRow(cells: [DataCell(Text('Data tidak valid'))]);
      }
    }).toList();
  }

  Widget _buildStatusChip(String status, ReportController controller) {
    return Chip(
      label: Text(
        controller.getStatusDisplayName(status),
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: controller.getStatusColor(status),
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildLeaveStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'disetujui':
        color = Colors.green;
        break;
      case 'ditolak':
        color = Colors.red;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(status, style: TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }
}
