import 'dart:typed_data';
import '../models/report_model.dart';

class ReportRepository {
  // Get attendance report based on filter
  Future<AttendanceReportResult> getAttendanceReport(
    ReportFilter filter,
  ) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Generate mock data based on report type
    final summary = _generateMockSummary(filter);
    final rows = _generateMockRows(filter);

    return AttendanceReportResult(summary: summary, rows: rows);
  }

  // Export report to Excel
  Future<Uint8List> exportReportToExcel(ReportFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Mock Excel data - in real implementation, this would generate actual Excel file
    return Uint8List.fromList([0x50, 0x4B, 0x03, 0x04]); // Mock Excel header
  }

  // Export report to PDF
  Future<Uint8List> exportReportToPdf(ReportFilter filter) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Mock PDF data - in real implementation, this would generate actual PDF file
    return Uint8List.fromList([0x25, 0x50, 0x44, 0x46]); // Mock PDF header
  }

  // Mock data generators
  AttendanceReportSummary _generateMockSummary(ReportFilter filter) {
    return AttendanceReportSummary(
      totalDays: 25,
      totalPresent: 580,
      totalLate: 45,
      totalPermission: 23,
      totalSick: 12,
      totalAbsent: 18,
      totalOvertime: 8,
      averageAttendancePercent: 87.5,
    );
  }

  List<dynamic> _generateMockRows(ReportFilter filter) {
    switch (filter.reportType) {
      case ReportType.perUser:
        return _generateUserReportRows();
      case ReportType.perClass:
        return _generateClassReportRows();
      case ReportType.perDepartment:
        return _generateDepartmentReportRows();
      case ReportType.leaveSummary:
        return _generateLeaveReportRows();
      case ReportType.dailySummary:
      case ReportType.monthlySummary:
      default:
        return _generateUserReportRows();
    }
  }

  List<AttendanceRecordRow> _generateUserReportRows() {
    return [
      AttendanceRecordRow(
        date: '2024-12-01',
        userId: 1,
        userName: 'Ahmad Santoso',
        userCode: '12345678',
        departmentName: 'Teknik Informatika',
        className: 'TI-1A',
        checkInTime: '08:00',
        checkOutTime: '17:00',
        status: 'Hadir',
        note: null,
      ),
      AttendanceRecordRow(
        date: '2024-12-01',
        userId: 2,
        userName: 'Budi Setiawan',
        userCode: '12345679',
        departmentName: 'Teknik Informatika',
        className: 'TI-1A',
        checkInTime: '08:15',
        checkOutTime: '17:00',
        status: 'Terlambat',
        note: 'Terlambat 15 menit',
      ),
      AttendanceRecordRow(
        date: '2024-12-01',
        userId: 3,
        userName: 'Cici Lestari',
        userCode: '12345680',
        departmentName: 'Sistem Informasi',
        className: 'SI-1A',
        checkInTime: null,
        checkOutTime: null,
        status: 'Alfa',
        note: 'Tidak hadir tanpa keterangan',
      ),
    ];
  }

  List<ClassReportRow> _generateClassReportRows() {
    return [
      ClassReportRow(
        date: '2024-12-01',
        classId: 1,
        className: 'TI-1A',
        departmentName: 'Teknik Informatika',
        membersCount: 30,
        presentCount: 28,
        lateCount: 2,
        permissionCount: 0,
        sickCount: 0,
        absentCount: 0,
        attendancePercent: 93.3,
      ),
      ClassReportRow(
        date: '2024-12-01',
        classId: 2,
        className: 'SI-1A',
        departmentName: 'Sistem Informasi',
        membersCount: 25,
        presentCount: 22,
        lateCount: 1,
        permissionCount: 1,
        sickCount: 1,
        absentCount: 0,
        attendancePercent: 88.0,
      ),
    ];
  }

  List<DepartmentReportRow> _generateDepartmentReportRows() {
    return [
      DepartmentReportRow(
        dateOrMonth: '2024-12-01',
        departmentId: 1,
        departmentName: 'Teknik Informatika',
        membersCount: 150,
        presentCount: 142,
        lateCount: 8,
        permissionCount: 5,
        sickCount: 3,
        absentCount: 2,
        attendancePercent: 94.7,
      ),
      DepartmentReportRow(
        dateOrMonth: '2024-12-01',
        departmentId: 2,
        departmentName: 'Sistem Informasi',
        membersCount: 120,
        presentCount: 115,
        lateCount: 5,
        permissionCount: 3,
        sickCount: 2,
        absentCount: 0,
        attendancePercent: 95.8,
      ),
    ];
  }

  List<LeaveReportRow> _generateLeaveReportRows() {
    return [
      LeaveReportRow(
        date: '2024-12-01',
        userId: 1,
        userName: 'Ahmad Santoso',
        userCode: '12345678',
        type: 'Izin',
        reason: 'Keperluan keluarga',
        status: 'Disetujui',
        approvedByName: 'Dr. Budi',
      ),
      LeaveReportRow(
        date: '2024-12-02',
        userId: 2,
        userName: 'Budi Setiawan',
        userCode: '12345679',
        type: 'Sakit',
        reason: 'Demam',
        status: 'Disetujui',
        approvedByName: 'Dr. Ahmad',
      ),
      LeaveReportRow(
        date: '2024-12-03',
        userId: 3,
        userName: 'Cici Lestari',
        userCode: '12345680',
        type: 'Cuti',
        reason: 'Liburan',
        status: 'Pending',
        approvedByName: null,
      ),
    ];
  }
}
