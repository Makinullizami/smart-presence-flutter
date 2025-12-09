import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/user_management_controller.dart';
import '../../../models/user_management_model.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserManagementController controller = Get.put(
      UserManagementController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Pengguna'),
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
          children: [
            // Filters and Search
            _buildFiltersSection(controller),

            // Action Buttons
            _buildActionButtons(),

            // User List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (controller.users.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada pengguna ditemukan',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Table Header
                    _buildTableHeader(),

                    // User List
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          final user = controller.users[index];
                          return _buildUserRow(user, controller);
                        },
                      ),
                    ),

                    // Pagination
                    _buildPagination(controller),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(UserManagementController controller) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter & Pencarian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            SizedBox(height: 16),

            // Search
            TextField(
              decoration: InputDecoration(
                labelText: 'Cari pengguna...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.setSearchQuery(value),
            ),

            SizedBox(height: 16),

            // Filters Row
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String?>(
                      value: controller.selectedRole.value,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Semua Role'),
                        ),
                        ...controller.roles.map(
                          (role) => DropdownMenuItem(
                            value: role.value,
                            child: Text(role.label),
                          ),
                        ),
                      ],
                      onChanged: (value) => controller.setRoleFilter(value),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String?>(
                      value: controller.selectedDepartment.value,
                      decoration: InputDecoration(
                        labelText: 'Departemen',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Semua Departemen'),
                        ),
                        ...controller.departments.map(
                          (dept) => DropdownMenuItem(
                            value: dept.id.toString(),
                            child: Text(dept.name),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.setDepartmentFilter(value),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                Expanded(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value: controller.selectedStatus.value,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text('Semua Status'),
                        ),
                        DropdownMenuItem(value: 'active', child: Text('Aktif')),
                        DropdownMenuItem(
                          value: 'inactive',
                          child: Text('Tidak Aktif'),
                        ),
                      ],
                      onChanged: (value) => controller.setStatusFilter(value!),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Reset Filters Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => controller.resetFilters(),
                icon: Icon(Icons.clear),
                label: Text('Reset Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to add user screen
              Get.toNamed('/user-management/add');
            },
            icon: Icon(Icons.add),
            label: Text('Tambah Pengguna'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          SizedBox(width: 16),

          ElevatedButton.icon(
            onPressed: () {
              // Navigate to import screen
              Get.toNamed('/user-management/import');
            },
            icon: Icon(Icons.upload_file),
            label: Text('Import Excel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          SizedBox(width: 16),

          ElevatedButton.icon(
            onPressed: () {
              // Navigate to role management
              Get.toNamed('/user-management/roles');
            },
            icon: Icon(Icons.admin_panel_settings),
            label: Text('Kelola Role'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.blue.shade100,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'NIP/NIM',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Departemen/Kelas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(UserModel user, UserManagementController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: user.profilePhotoUrl != null
                      ? NetworkImage(user.profilePhotoUrl!)
                      : null,
                  child: user.profilePhotoUrl == null
                      ? Text(user.name[0].toUpperCase())
                      : null,
                ),
                SizedBox(width: 12),
                Text(user.name),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(user.nipNim)),
          Expanded(flex: 1, child: _buildRoleChip(user.role)),
          Expanded(
            flex: 2,
            child: Text(user.department?.name ?? user.classModel?.name ?? '-'),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user.isActive
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user.isActive ? 'Aktif' : 'Tidak Aktif',
                style: TextStyle(
                  color: user.isActive
                      ? Colors.green.shade800
                      : Colors.red.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Navigate to edit user
                    Get.toNamed('/user-management/edit/${user.id}');
                  },
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: Icon(
                    user.isActive ? Icons.block : Icons.check_circle,
                    color: user.isActive ? Colors.red : Colors.green,
                  ),
                  onPressed: () => controller.toggleUserStatus(user.id),
                  tooltip: user.isActive ? 'Nonaktifkan' : 'Aktifkan',
                ),
                IconButton(
                  icon: Icon(Icons.lock_reset, color: Colors.orange),
                  onPressed: () => _showResetPasswordDialog(user, controller),
                  tooltip: 'Reset Password',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    switch (role) {
      case 'admin':
        color = Colors.red;
        break;
      case 'hr':
        color = Colors.blue;
        break;
      case 'lecturer':
        color = Colors.green;
        break;
      case 'employee':
        color = Colors.purple;
        break;
      case 'student':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPagination(UserManagementController controller) {
    return Obx(() {
      final pagination = controller.pagination.value;
      if (pagination == null) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: pagination.currentPage > 1
                  ? () => controller.goToPage(pagination.currentPage - 1)
                  : null,
              icon: Icon(Icons.chevron_left),
            ),

            Text(
              'Halaman ${pagination.currentPage} dari ${pagination.lastPage}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            IconButton(
              onPressed: pagination.currentPage < pagination.lastPage
                  ? () => controller.goToPage(pagination.currentPage + 1)
                  : null,
              icon: Icon(Icons.chevron_right),
            ),
          ],
        ),
      );
    });
  }

  void _showResetPasswordDialog(
    UserModel user,
    UserManagementController controller,
  ) {
    final passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reset password untuk ${user.name}?'),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text.isNotEmpty) {
                controller.resetUserPassword(user.id, passwordController.text);
                Get.back();
              }
            },
            child: Text('Reset'),
          ),
        ],
      ),
    );
  }
}
