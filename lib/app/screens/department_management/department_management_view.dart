import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/department_controller.dart';
import 'widgets/department_form_dialog.dart';
import 'widgets/department_table.dart';
import 'widgets/department_toolbar.dart';

class DepartmentManagementView extends StatelessWidget {
  const DepartmentManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DepartmentController());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.business, size: 28),
            SizedBox(width: 8),
            Text('🏢 Manajemen Departemen'),
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
                    'Dashboard > Manajemen Departemen',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manajemen Departemen',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Kelola departemen, anggota, dan pengaturan absensi',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Toolbar
            DepartmentToolbar(),

            // Table
            Expanded(child: DepartmentTable()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, controller),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  void _showAddDialog(BuildContext context, DepartmentController controller) {
    showDialog(
      context: context,
      builder: (context) => DepartmentFormDialog(
        onSave: (department) => controller.createDepartment(department),
      ),
    );
  }
}
