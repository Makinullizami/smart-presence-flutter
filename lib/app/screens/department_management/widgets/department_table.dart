import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/department_controller.dart';
import 'package:smart_presence/models/department_model.dart';
import '../../../routes/app_routes.dart';
import 'department_form_dialog.dart';

class DepartmentTable extends StatelessWidget {
  const DepartmentTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DepartmentController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text(controller.errorMessage.value),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.loadDepartments(),
                child: Text('Coba Lagi'),
              ),
            ],
          ),
        );
      }

      return Card(
        margin: const EdgeInsets.all(16.0),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Bulk actions
            Obx(
              () => controller.selectedDepartments.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.blue.shade50,
                      child: Row(
                        children: [
                          Text(
                            '${controller.selectedDepartments.length} dipilih',
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () => controller.bulkUpdateStatus(true),
                            child: Text('Aktifkan'),
                          ),
                          TextButton(
                            onPressed: () => controller.bulkUpdateStatus(false),
                            child: Text('Nonaktifkan'),
                          ),
                          TextButton(
                            onPressed: () =>
                                _showDeleteConfirmDialog(context, controller),
                            child: Text(
                              'Hapus',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),

            // Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Obx(
                        () => Checkbox(
                          value:
                              controller.selectedDepartments.length ==
                                  controller.departments.length &&
                              controller.departments.isNotEmpty,
                          onChanged: (value) {
                            if (value == true) {
                              controller.selectAll();
                            } else {
                              controller.clearSelection();
                            }
                          },
                        ),
                      ),
                    ),
                    DataColumn(label: Text('Kode')),
                    DataColumn(label: Text('Nama Departemen')),
                    DataColumn(label: Text('Unit Induk')),
                    DataColumn(label: Text('Kepala Departemen')),
                    DataColumn(label: Text('Anggota')),
                    DataColumn(label: Text('Kelas')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: controller.departments
                      .map(
                        (dept) => DataRow(
                          selected: controller.selectedDepartments.contains(
                            dept.id,
                          ),
                          onSelectChanged: (selected) {
                            controller.toggleSelection(dept.id);
                          },
                          cells: [
                            DataCell(
                              Checkbox(
                                value: controller.selectedDepartments.contains(
                                  dept.id,
                                ),
                                onChanged: (value) =>
                                    controller.toggleSelection(dept.id),
                              ),
                            ),
                            DataCell(Text(dept.code)),
                            DataCell(Text(dept.name)),
                            DataCell(Text(dept.unitName ?? '-')),
                            DataCell(Text(dept.headName ?? '-')),
                            DataCell(Text('${dept.membersCount}')),
                            DataCell(Text('${dept.classesCount}')),
                            DataCell(_buildStatusChip(dept.status)),
                            DataCell(_buildActions(context, dept, controller)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // Pagination
            Obx(
              () => Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Tampilkan: '),
                        DropdownButton<int>(
                          value: controller.perPage.value,
                          items: [10, 20, 50]
                              .map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text('$value'),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              controller.changePerPage(value!),
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
                        Text(
                          'Halaman ${controller.currentPage.value} dari ${controller.totalPages.value}',
                        ),
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
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatusChip(bool status) {
    return Chip(
      label: Text(
        status ? 'Aktif' : 'Nonaktif',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: status ? Colors.green : Colors.grey,
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildActions(
    BuildContext context,
    Department dept,
    DepartmentController controller,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.visibility, color: Colors.blue),
          onPressed: () =>
              Get.toNamed(AppRoutes.departmentDetail, arguments: dept.id),
          tooltip: 'Detail',
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _showEditDialog(context, dept, controller),
          tooltip: 'Edit',
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () =>
              _showDeleteConfirmDialog(context, controller, dept: dept),
          tooltip: 'Hapus',
        ),
      ],
    );
  }

  void _showEditDialog(
    BuildContext context,
    Department dept,
    DepartmentController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => DepartmentFormDialog(
        department: dept,
        onSave: (department) => controller.updateDepartment(department),
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    DepartmentController controller, {
    Department? dept,
  }) {
    final ids = dept != null ? [dept.id] : controller.selectedDepartments;
    final message = dept != null
        ? 'Yakin ingin menghapus departemen "${dept.name}"?'
        : 'Yakin ingin menghapus ${ids.length} departemen terpilih?';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              if (dept != null) {
                controller.deleteDepartment(dept.id);
              } else {
                // For bulk delete, delete one by one
                for (var id in ids) {
                  controller.deleteDepartment(id);
                }
                controller.clearSelection();
              }
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
