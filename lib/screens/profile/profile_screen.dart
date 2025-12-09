import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';
import 'device_management_screen.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Profil'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.devices),
            onPressed: () => Get.to(() => DeviceManagementScreen()),
            tooltip: 'Kelola Perangkat',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final user = authController.user.value;
        if (user == null) {
          return Center(child: Text('User tidak ditemukan'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Photo Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: user.profilePhotoPath != null
                            ? NetworkImage(user.profilePhotoPath!)
                            : null,
                        child: user.profilePhotoPath == null
                            ? Icon(Icons.person, size: 60, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20,
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                            onPressed: () => _showImagePicker(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Basic Information Section
                _buildSectionTitle('Informasi Dasar'),
                _buildTextField(
                  label: 'Nama Lengkap',
                  initialValue: user.name,
                  onChanged: (value) => controller.name.value = value,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Nama tidak boleh kosong';
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Email',
                  initialValue: user.email,
                  enabled: false, // Email cannot be changed
                ),
                _buildTextField(
                  label: 'Nomor Telepon',
                  initialValue: user.phone,
                  onChanged: (value) => controller.phone.value = value,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    final cleaned = v.replaceAll(RegExp(r'[^0-9+]'), '');
                    if (cleaned.length < 7) return 'Nomor telepon tidak valid';
                    return null;
                  },
                  keyboardType: TextInputType.phone,
                ),

                // Student/Employee specific fields
                if (user.isStudent) ...[
                  _buildTextField(
                    label: 'NIM',
                    initialValue: user.nim,
                    enabled: false, // NIM cannot be changed
                  ),
                ] else ...[
                  _buildTextField(
                    label: 'ID Karyawan',
                    initialValue: user.employeeId,
                    enabled: false, // Employee ID cannot be changed
                  ),
                ],

                const SizedBox(height: 24),

                // Personal Information Section
                _buildSectionTitle('Informasi Pribadi'),
                _buildTextField(
                  label: 'Alamat',
                  initialValue: user.address,
                  onChanged: (value) => controller.address.value = value,
                  maxLines: 3,
                ),
                _buildDateField(
                  label: 'Tanggal Lahir',
                  initialValue: user.dateOfBirth,
                  onChanged: (value) => controller.dateOfBirth.value = value,
                ),
                _buildDropdownField(
                  label: 'Jenis Kelamin',
                  value: user.gender,
                  items: [
                    DropdownMenuItem(value: 'male', child: Text('Laki-laki')),
                    DropdownMenuItem(value: 'female', child: Text('Perempuan')),
                    DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                  ],
                  onChanged: (value) => controller.gender.value = value,
                ),
                _buildTextField(
                  label: 'Bio',
                  initialValue: user.bio,
                  onChanged: (value) => controller.bio.value = value,
                  maxLines: 3,
                ),

                const SizedBox(height: 24),

                // Emergency Contact Section
                _buildSectionTitle('Kontak Darurat'),
                _buildTextField(
                  label: 'Nama Kontak Darurat',
                  initialValue: user.emergencyContactName,
                  onChanged: (value) =>
                      controller.emergencyContactName.value = value,
                ),
                _buildTextField(
                  label: 'Nomor Telepon Kontak Darurat',
                  initialValue: user.emergencyContactPhone,
                  onChanged: (value) =>
                      controller.emergencyContactPhone.value = value,
                  keyboardType: TextInputType.phone,
                ),

                SizedBox(height: 24),

                // Preferences Section
                _buildSectionTitle('Preferensi'),
                _buildDropdownField(
                  label: 'Bahasa',
                  value: user.languagePreference ?? 'id',
                  items: [
                    DropdownMenuItem(
                      value: 'id',
                      child: Text('Bahasa Indonesia'),
                    ),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (value) => controller.languagePreference.value =
                      value ?? controller.languagePreference.value,
                ),
                _buildDropdownField(
                  label: 'Tema',
                  value: user.themePreference ?? 'system',
                  items: [
                    DropdownMenuItem(value: 'light', child: Text('Terang')),
                    DropdownMenuItem(value: 'dark', child: Text('Gelap')),
                    DropdownMenuItem(
                      value: 'system',
                      child: Text('Sesuai Sistem'),
                    ),
                  ],
                  onChanged: (value) => controller.themePreference.value =
                      value ?? controller.themePreference.value,
                ),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _saveProfile(context),
                        child: Text('Simpan Perubahan'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Change Password Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _showChangePasswordDialog(context),
                    child: const Text('Ubah Password'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: !enabled,
          fillColor: enabled ? null : Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    DateTime? initialValue,
    Function(DateTime?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final date = await showDatePicker(
            context: Get.context!,
            initialDate: initialValue ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (date != null && onChanged != null) {
            onChanged(date);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                initialValue != null
                    ? '${initialValue.day}/${initialValue.month}/${initialValue.year}'
                    : 'Pilih tanggal',
              ),
              Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    String? value,
    required List<DropdownMenuItem<String>> items,
    Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Ambil Foto'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      controller.selectedImage.value = File(pickedFile.path);
      // TODO: Upload image to server
    }
  }

  void _saveProfile(BuildContext context) async {
    // Validate form
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      Get.snackbar('Error', 'Periksa input yang belum benar');
      return;
    }

    try {
      final user = authController.user.value!;
      final data = {
        'name': controller.name.value.isNotEmpty
            ? controller.name.value
            : user.name,
        'phone': controller.phone.value,
        'address': controller.address.value,
        'date_of_birth': controller.dateOfBirth.value?.toIso8601String(),
        'gender': controller.gender.value,
        'bio': controller.bio.value,
        'emergency_contact_name': controller.emergencyContactName.value,
        'emergency_contact_phone': controller.emergencyContactPhone.value,
        'language_preference': controller.languagePreference.value,
        'theme_preference': controller.themePreference.value,
      };

      await controller.updateProfile(data);

      Get.snackbar(
        'Berhasil',
        'Profil berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui profil: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ubah Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Lama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                Get.snackbar('Error', 'Password konfirmasi tidak cocok');
                return;
              }

              try {
                await controller.updatePassword(
                  currentPasswordController.text,
                  newPasswordController.text,
                );

                Navigator.of(context).pop();
                Get.snackbar(
                  'Berhasil',
                  'Password berhasil diubah',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar('Error', 'Gagal mengubah password: $e');
              }
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
