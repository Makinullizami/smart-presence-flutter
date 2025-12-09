import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/report_model.dart';
import '../../services/report_repository.dart';
import 'dart:typed_data';

class ReportController extends GetxController {
  final ReportRepository _repository = ReportRepository();

  // Filter state
  var selectedReportType = ReportType.perUser.obs;
  var dateStart = Rxn<DateTime>();
  var dateEnd = Rxn<DateTime>();
  var selectedMonth = Rxn<int>();
  var selectedYear = 2024.obs;
  var selectedDepartmentId = Rxn<int>();
  var selectedClassId = Rxn<int>();
  var selectedShiftId = Rxn<int>();
  var userQuery = ''.obs;
  var selectedRole = Rxn<String>();
  var selectedStatuses = <String>[
    'Hadir',
    'Terlambat',
    'Izin',
    'Sakit',
    'Alfa',
  ].obs;

  // Data state
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var reportResult = Rxn<AttendanceReportResult>();

  // Pagination
  var currentPage = 1.obs;
  var perPage = 10.obs;
  var totalPages = 1.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default date range (last 7 days)
    final now = DateTime.now();
    dateStart.value = now.subtract(const Duration(days: 7));
    dateEnd.value = now;
  }

  // Update report type and reset relevant filters
  void updateReportType(ReportType type) {
    selectedReportType.value = type;

    // Reset date filters based on type
    if (type == ReportType.monthlySummary) {
      dateStart.value = null;
      dateEnd.value = null;
      selectedMonth.value = DateTime.now().month;
      selectedYear.value = DateTime.now().year;
    } else {
      selectedMonth.value = null;
      selectedYear.value = DateTime.now().year;
      if (dateStart.value == null || dateEnd.value == null) {
        final now = DateTime.now();
        dateStart.value = now.subtract(const Duration(days: 7));
        dateEnd.value = now;
      }
    }
  }

  // Update filters
  void updateFilters({
    DateTime? startDate,
    DateTime? endDate,
    int? month,
    int? year,
    int? departmentId,
    int? classId,
    int? shiftId,
    String? query,
    String? role,
    List<String>? statuses,
  }) {
    if (startDate != null) dateStart.value = startDate;
    if (endDate != null) dateEnd.value = endDate;
    if (month != null) selectedMonth.value = month;
    if (year != null) selectedYear.value = year;
    if (departmentId != null) selectedDepartmentId.value = departmentId;
    if (classId != null) selectedClassId.value = classId;
    if (shiftId != null) selectedShiftId.value = shiftId;
    if (query != null) userQuery.value = query;
    if (role != null) selectedRole.value = role;
    if (statuses != null) selectedStatuses.assignAll(statuses);
  }

  // Reset all filters
  void resetFilters() {
    selectedReportType.value = ReportType.perUser;
    final now = DateTime.now();
    dateStart.value = now.subtract(const Duration(days: 7));
    dateEnd.value = now;
    selectedMonth.value = null;
    selectedYear.value = DateTime.now().year;
    selectedDepartmentId.value = null;
    selectedClassId.value = null;
    selectedShiftId.value = null;
    userQuery.value = '';
    selectedRole.value = null;
    selectedStatuses.assignAll(['Hadir', 'Terlambat', 'Izin', 'Sakit', 'Alfa']);
    currentPage.value = 1;
  }

  // Generate current filter
  ReportFilter getCurrentFilter() {
    return ReportFilter(
      reportType: selectedReportType.value,
      dateStart: dateStart.value,
      dateEnd: dateEnd.value,
      month: selectedMonth.value,
      year: selectedYear.value,
      departmentId: selectedDepartmentId.value,
      classId: selectedClassId.value,
      shiftId: selectedShiftId.value,
      userQuery: userQuery.value.isEmpty ? null : userQuery.value,
      role: selectedRole.value,
      selectedStatuses: selectedStatuses,
    );
  }

  // Load report data
  Future<void> loadReport() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final filter = getCurrentFilter();
      final result = await _repository.getAttendanceReport(filter);
      reportResult.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
      reportResult.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  // Export to Excel
  Future<void> exportToExcel() async {
    try {
      final filter = getCurrentFilter();
      final data = await _repository.exportReportToExcel(filter);
      // In real implementation, this would save the file or trigger download
      Get.snackbar('Berhasil', 'Laporan Excel berhasil diekspor');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengekspor Excel: $e');
    }
  }

  // Export to PDF
  Future<void> exportToPdf() async {
    try {
      final filter = getCurrentFilter();
      final data = await _repository.exportReportToPdf(filter);
      // In real implementation, this would save the file or trigger download
      Get.snackbar('Berhasil', 'Laporan PDF berhasil diekspor');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengekspor PDF: $e');
    }
  }

  // Print report
  void printReport() {
    // In real implementation, this would open print dialog
    Get.snackbar('Info', 'Fitur cetak akan dibuka');
  }

  // Change page
  void changePage(int page) {
    currentPage.value = page;
    loadReport();
  }

  // Change per page
  void changePerPage(int value) {
    perPage.value = value;
    currentPage.value = 1;
    loadReport();
  }

  // Get report type display name
  String getReportTypeDisplayName(ReportType type) {
    switch (type) {
      case ReportType.dailySummary:
        return 'Ringkasan Harian';
      case ReportType.monthlySummary:
        return 'Ringkasan Bulanan';
      case ReportType.perUser:
        return 'Per Pengguna';
      case ReportType.perClass:
        return 'Per Kelas';
      case ReportType.perDepartment:
        return 'Per Departemen';
      case ReportType.leaveSummary:
        return 'Rekap Izin / Sakit / Cuti';
    }
  }

  // Get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Colors.green;
      case 'terlambat':
        return Colors.orange;
      case 'izin':
        return Colors.blue;
      case 'sakit':
        return Colors.purple;
      case 'alfa':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Get status display name
  String getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return 'Hadir';
      case 'terlambat':
        return 'Terlambat';
      case 'izin':
        return 'Izin';
      case 'sakit':
        return 'Sakit';
      case 'alfa':
        return 'Alfa';
      default:
        return status;
    }
  }
}
