import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/class_controller.dart';
import 'widgets/class_form_dialog.dart';
import 'widgets/class_table.dart';
import 'widgets/class_toolbar.dart';

class ClassManagementView extends StatelessWidget {
  const ClassManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClassController());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.class_, size: 28),
            SizedBox(width: 8),
            Text('📚 Manajemen Kelas'),
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
                    'Dashboard > Manajemen Kelas',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manajemen Kelas',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Kelola kelas, anggota, jadwal, dan pengaturan absensi',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Toolbar
            ClassToolbar(),

            // Table
            Expanded(child: ClassTable()),
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

  void _showAddDialog(BuildContext context, ClassController controller) {
    showDialog(
      context: context,
      builder: (context) => ClassFormDialog(
        onSave: (classGroup) => controller.createClass(classGroup),
      ),
    );
  }
}
