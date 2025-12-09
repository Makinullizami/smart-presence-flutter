import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/department_controller.dart';

class DepartmentToolbar extends StatelessWidget {
  const DepartmentToolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DepartmentController>();

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
                hintText: 'Cari departemen (nama / kode)...',
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
                      value: controller.selectedUnitId.value,
                      decoration: InputDecoration(
                        labelText: 'Unit / Divisi Induk',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: null, child: Text('Semua')),
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Fakultas Teknik'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Fakultas Ekonomi'),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.updateFilters(unit: value),
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
                  onPressed: () => controller.loadDepartments(),
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
