import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_presence/models/class_model.dart';

class ClassFormDialog extends StatefulWidget {
  final ClassGroup? classGroup;
  final Function(ClassGroup) onSave;

  const ClassFormDialog({Key? key, this.classGroup, required this.onSave})
    : super(key: key);

  @override
  _ClassFormDialogState createState() => _ClassFormDialogState();
}

class _ClassFormDialogState extends State<ClassFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _capacityController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedDepartmentId;
  int _level = 1;
  int? _selectedHeadTeacherId;
  bool _status = true;

  final List<Map<String, dynamic>> _departments = [
    {'id': 1, 'name': 'Teknik Informatika'},
    {'id': 2, 'name': 'Sistem Informasi'},
  ];

  final List<Map<String, dynamic>> _headTeachers = [
    {'id': 1, 'name': 'Dr. Ahmad'},
    {'id': 2, 'name': 'Prof. Budi'},
    {'id': 3, 'name': 'Dr. Cici'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.classGroup != null) {
      _codeController.text = widget.classGroup!.code;
      _nameController.text = widget.classGroup!.name;
      _academicYearController.text = widget.classGroup!.academicYear;
      _capacityController.text = widget.classGroup!.capacity?.toString() ?? '';
      _notesController.text = widget.classGroup!.notes ?? '';
      _selectedDepartmentId = widget.classGroup!.departmentId;
      _level = widget.classGroup!.level;
      _selectedHeadTeacherId = widget.classGroup!.headTeacherId;
      _status = widget.classGroup!.status;
    } else {
      _academicYearController.text = '2024/2025';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.classGroup == null ? 'Tambah Kelas' : 'Edit Kelas'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Kode Kelas *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode kelas wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Kelas *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama kelas wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                value: _selectedDepartmentId,
                decoration: InputDecoration(
                  labelText: 'Departemen / Program Studi *',
                  border: OutlineInputBorder(),
                ),
                items: _departments
                    .map(
                      (dept) => DropdownMenuItem<int>(
                        value: dept['id'] as int,
                        child: Text(dept['name']),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedDepartmentId = value),
                validator: (value) {
                  if (value == null) {
                    return 'Departemen wajib dipilih';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _level,
                decoration: InputDecoration(
                  labelText: 'Tingkat / Semester *',
                  border: OutlineInputBorder(),
                ),
                items: List.generate(8, (i) => i + 1)
                    .map(
                      (level) => DropdownMenuItem<int>(
                        value: level,
                        child: Text('$level'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _level = value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _academicYearController,
                decoration: InputDecoration(
                  labelText: 'Tahun Ajaran *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tahun ajaran wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                value: _selectedHeadTeacherId,
                decoration: InputDecoration(
                  labelText: 'Wali Kelas / Dosen PA',
                  border: OutlineInputBorder(),
                ),
                items: _headTeachers
                    .map(
                      (teacher) => DropdownMenuItem<int>(
                        value: teacher['id'] as int,
                        child: Text(teacher['name']),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedHeadTeacherId = value),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _capacityController,
                decoration: InputDecoration(
                  labelText: 'Kapasitas',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Status: '),
                  Switch(
                    value: _status,
                    onChanged: (value) => setState(() => _status = value),
                  ),
                  Text(_status ? 'Aktif' : 'Nonaktif'),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('Batal')),
        ElevatedButton(onPressed: _save, child: Text('Simpan')),
      ],
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final classGroup = ClassGroup(
        id: widget.classGroup?.id ?? 0,
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        departmentId: _selectedDepartmentId,
        departmentName: _departments.firstWhere(
          (d) => d['id'] == _selectedDepartmentId,
        )['name'],
        level: _level,
        academicYear: _academicYearController.text.trim(),
        headTeacherId: _selectedHeadTeacherId,
        headTeacherName: _headTeachers.firstWhere(
          (h) => h['id'] == _selectedHeadTeacherId,
        )['name'],
        capacity: _capacityController.text.isEmpty
            ? null
            : int.parse(_capacityController.text),
        membersCount: widget.classGroup?.membersCount ?? 0,
        status: _status,
        notes: _notesController.text.isEmpty
            ? null
            : _notesController.text.trim(),
      );

      widget.onSave(classGroup);
      Get.back();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _academicYearController.dispose();
    _capacityController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
