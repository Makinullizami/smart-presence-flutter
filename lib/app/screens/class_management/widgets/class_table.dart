import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/class_controller.dart';
import 'package:smart_presence/models/class_model.dart';
import '../../../routes/app_routes.dart';
import 'class_form_dialog.dart';

class ClassTable extends StatelessWidget {
  const ClassTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClassController>();

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
                onPressed: () => controller.loadClasses(),
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
              () => controller.selectedClasses.isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.blue.shade50,
                      child: Row(
                        children: [
                          Text('${controller.selectedClasses.length} dipilih'),
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
                              controller.selectedClasses.length ==
                                  controller.classes.length &&
                              controller.classes.isNotEmpty,
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
                    DataColumn(label: Text('Kode Kelas')),
                    DataColumn(label: Text('Nama Kelas')),
                    DataColumn(label: Text('Departemen')),
                    DataColumn(label: Text('Tingkat')),
                    DataColumn(label: Text('Tahun Ajaran')),
                    DataColumn(label: Text('Wali Kelas')),
                    DataColumn(label: Text('Anggota')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Aksi')),
                  ],
                  rows: controller.classes
                      .map(
                        (cls) => DataRow(
                          selected: controller.selectedClasses.contains(cls.id),
                          onSelectChanged: (selected) {
                            controller.toggleSelection(cls.id);
                          },
                          cells: [
                            DataCell(
                              Checkbox(
                                value: controller.selectedClasses.contains(
                                  cls.id,
                                ),
                                onChanged: (value) =>
                                    controller.toggleSelection(cls.id),
                              ),
                            ),
                            DataCell(Text(cls.code)),
                            DataCell(Text(cls.name)),
                            DataCell(Text(cls.departmentName ?? '-')),
                            DataCell(Text('${cls.level}')),
                            DataCell(Text(cls.academicYear)),
                            DataCell(Text(cls.headTeacherName ?? '-')),
                            DataCell(Text('${cls.membersCount}')),
                            DataCell(_buildStatusChip(cls.status)),
                            DataCell(_buildActions(context, cls, controller)),
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
    ClassGroup cls,
    ClassController controller,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.visibility, color: Colors.blue),
          onPressed: () =>
              Get.toNamed(AppRoutes.classDetail, arguments: cls.id),
          tooltip: 'Detail',
        ),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.orange),
          onPressed: () => _showEditDialog(context, cls, controller),
          tooltip: 'Edit',
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () =>
              _showDeleteConfirmDialog(context, controller, cls: cls),
          tooltip: 'Hapus',
        ),
      ],
    );
  }

  void _showEditDialog(
    BuildContext context,
    ClassGroup cls,
    ClassController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => ClassFormDialog(
        classGroup: cls,
        onSave: (classGroup) => controller.updateClass(classGroup),
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    ClassController controller, {
    ClassGroup? cls,
  }) {
    final ids = cls != null ? [cls.id] : controller.selectedClasses;
    final message = cls != null
        ? 'Yakin ingin menghapus kelas "${cls.name}"?'
        : 'Yakin ingin menghapus ${ids.length} kelas terpilih?';

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
              if (cls != null) {
                controller.deleteClass(cls.id);
              } else {
                // For bulk delete, delete one by one
                for (var id in ids) {
                  controller.deleteClass(id);
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
