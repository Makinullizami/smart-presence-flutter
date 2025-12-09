import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/report_controller.dart';
import 'package:smart_presence/models/report_model.dart';

class ReportFilterPanel extends GetView<ReportController> {
  const ReportFilterPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter & Kontrol',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 16),

            // Report Type
            Obx(
              () => DropdownButtonFormField<ReportType>(
                value: controller.selectedReportType.value,
                decoration: InputDecoration(
                  labelText: 'Jenis Laporan',
                  border: OutlineInputBorder(),
                ),
                items: ReportType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(controller.getReportTypeDisplayName(type)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => controller.updateReportType(value!),
              ),
            ),
            SizedBox(height: 16),

            // Date Range (conditional)
            Obx(() {
              if (controller.selectedReportType.value !=
                  ReportType.monthlySummary) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Tanggal Mulai',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text: controller.dateStart.value != null
                                    ? '${controller.dateStart.value!.day}/${controller.dateStart.value!.month}/${controller.dateStart.value!.year}'
                                    : '',
                              ),
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      controller.dateStart.value ??
                                      DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  controller.updateFilters(startDate: date);
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Obx(
                            () => TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Tanggal Selesai',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              controller: TextEditingController(
                                text: controller.dateEnd.value != null
                                    ? '${controller.dateEnd.value!.day}/${controller.dateEnd.value!.month}/${controller.dateEnd.value!.year}'
                                    : '',
                              ),
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      controller.dateEnd.value ??
                                      DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  controller.updateFilters(endDate: date);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => DropdownButtonFormField<int>(
                              value: controller.selectedMonth.value,
                              decoration: InputDecoration(
                                labelText: 'Bulan',
                                border: OutlineInputBorder(),
                              ),
                              items: List.generate(12, (i) => i + 1)
                                  .map(
                                    (month) => DropdownMenuItem(
                                      value: month,
                                      child: Text(_getMonthName(month)),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) =>
                                  controller.updateFilters(month: value),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Obx(
                            () => DropdownButtonFormField<int>(
                              value: controller.selectedYear.value,
                              decoration: InputDecoration(
                                labelText: 'Tahun',
                                border: OutlineInputBorder(),
                              ),
                              items:
                                  List.generate(
                                        5,
                                        (i) => DateTime.now().year - 2 + i,
                                      )
                                      .map(
                                        (year) => DropdownMenuItem(
                                          value: year,
                                          child: Text(year.toString()),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) =>
                                  controller.updateFilters(year: value),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }
            }),

            // Organization Filters
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<int?>(
                      value: controller.selectedDepartmentId.value,
                      decoration: InputDecoration(
                        labelText: 'Departemen',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text('Semua')),
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Teknik Informatika'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Sistem Informasi'),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.updateFilters(departmentId: value),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<int?>(
                      value: controller.selectedClassId.value,
                      decoration: InputDecoration(
                        labelText: 'Kelas',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text('Semua')),
                        DropdownMenuItem(value: 1, child: Text('TI-1A')),
                        DropdownMenuItem(value: 2, child: Text('SI-1A')),
                      ],
                      onChanged: (value) =>
                          controller.updateFilters(classId: value),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // User Filters
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Cari pengguna (nama / NIP / NIM)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) =>
                        controller.updateFilters(query: value),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String?>(
                      value: controller.selectedRole.value,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text('Semua')),
                        DropdownMenuItem(
                          value: 'student',
                          child: Text('Mahasiswa'),
                        ),
                        DropdownMenuItem(
                          value: 'lecturer',
                          child: Text('Dosen'),
                        ),
                        DropdownMenuItem(
                          value: 'employee',
                          child: Text('Karyawan'),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.updateFilters(role: value),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Status Filters
            Text(
              'Status Kehadiran:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                children: ['Hadir', 'Terlambat', 'Izin', 'Sakit', 'Alfa']
                    .map(
                      (status) => FilterChip(
                        label: Text(status),
                        selected: controller.selectedStatuses.contains(status),
                        onSelected: (selected) {
                          final statuses = List<String>.from(
                            controller.selectedStatuses,
                          );
                          if (selected) {
                            statuses.add(status);
                          } else {
                            statuses.remove(status);
                          }
                          controller.updateFilters(statuses: statuses);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.loadReport,
                    icon: Icon(Icons.search),
                    label: Text('Tampilkan Laporan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                OutlinedButton(
                  onPressed: controller.resetFilters,
                  child: Text('Reset Filter'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }
}
