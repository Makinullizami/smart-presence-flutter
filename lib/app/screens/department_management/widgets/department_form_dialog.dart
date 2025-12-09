import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_presence/models/department_model.dart';

class DepartmentFormDialog extends StatefulWidget {
  final Department? department;
  final Function(Department) onSave;

  const DepartmentFormDialog({Key? key, this.department, required this.onSave})
    : super(key: key);

  @override
  _DepartmentFormDialogState createState() => _DepartmentFormDialogState();
}

class _DepartmentFormDialogState extends State<DepartmentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _shortNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedUnitId;
  int? _selectedHeadId;
  bool _status = true;

  final List<Map<String, dynamic>> _units = [
    {'id': 1, 'name': 'Fakultas Teknik'},
    {'id': 2, 'name': 'Fakultas Ekonomi'},
  ];

  final List<Map<String, dynamic>> _heads = [
    {'id': 1, 'name': 'Dr. Ahmad'},
    {'id': 2, 'name': 'Prof. Budi'},
    {'id': 3, 'name': 'Dr. Cici'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.department != null) {
      _codeController.text = widget.department!.code;
      _nameController.text = widget.department!.name;
      _shortNameController.text = widget.department!.shortName ?? '';
      _locationController.text = widget.department!.location ?? '';
      _notesController.text = widget.department!.notes ?? '';
      _selectedUnitId = widget.department!.unitId;
      _selectedHeadId = widget.department!.headId;
      _status = widget.department!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.department == null ? 'Tambah Departemen' : 'Edit Departemen',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Kode Departemen *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode departemen wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Departemen *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama departemen wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _shortNameController,
                decoration: InputDecoration(
                  labelText: 'Singkatan',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                value: _selectedUnitId,
                decoration: InputDecoration(
                  labelText: 'Unit / Divisi Induk',
                  border: OutlineInputBorder(),
                ),
                items: _units
                    .map(
                      (unit) => DropdownMenuItem<int>(
                        value: unit['id'] as int,
                        child: Text(unit['name']),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedUnitId = value),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int?>(
                value: _selectedHeadId,
                decoration: InputDecoration(
                  labelText: 'Kepala Departemen',
                  border: OutlineInputBorder(),
                ),
                items: _heads
                    .map(
                      (head) => DropdownMenuItem<int>(
                        value: head['id'] as int,
                        child: Text(head['name']),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedHeadId = value),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Lokasi / Gedung',
                  border: OutlineInputBorder(),
                ),
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
      final department = Department(
        id: widget.department?.id ?? 0,
        code: _codeController.text.trim(),
        name: _nameController.text.trim(),
        shortName: _shortNameController.text.isEmpty
            ? null
            : _shortNameController.text.trim(),
        unitName: _units.firstWhere((u) => u['id'] == _selectedUnitId)['name'],
        unitId: _selectedUnitId,
        headId: _selectedHeadId,
        headName: _heads.firstWhere((h) => h['id'] == _selectedHeadId)['name'],
        location: _locationController.text.isEmpty
            ? null
            : _locationController.text.trim(),
        status: _status,
        membersCount: widget.department?.membersCount ?? 0,
        classesCount: widget.department?.classesCount ?? 0,
        notes: _notesController.text.isEmpty
            ? null
            : _notesController.text.trim(),
      );

      widget.onSave(department);
      Get.back();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _shortNameController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
