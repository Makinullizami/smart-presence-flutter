import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/class_controller.dart';

class ClassToolbar extends StatelessWidget {
  const ClassToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassController>();

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari kelas (nama / kode)...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) => controller.updateFilters(search: value),
            ),
            SizedBox(height: 16),

            // Filters
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
                          controller.updateFilters(department: value),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<int?>(
                      value: controller.selectedLevel.value,
                      decoration: InputDecoration(
                        labelText: 'Tingkat / Semester',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text('Semua')),
                        for (int i = 1; i <= 8; i++)
                          DropdownMenuItem(value: i, child: Text('$i')),
                      ],
                      onChanged: (value) =>
                          controller.updateFilters(level: value),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedAcademicYear.value.isEmpty
                          ? null
                          : controller.selectedAcademicYear.value,
                      decoration: InputDecoration(
                        labelText: 'Tahun Ajaran',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text('Semua')),
                        DropdownMenuItem(
                          value: '2024/2025',
                          child: Text('2024/2025'),
                        ),
                        DropdownMenuItem(
                          value: '2023/2024',
                          child: Text('2023/2024'),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.updateFilters(academicYear: value),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<bool?>(
                      value: controller.selectedStatus.value,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text('Semua')),
                        DropdownMenuItem(value: true, child: Text('Aktif')),
                        DropdownMenuItem(value: false, child: Text('Nonaktif')),
                      ],
                      onChanged: (value) =>
                          controller.updateFilters(status: value),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.loadClasses(),
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
