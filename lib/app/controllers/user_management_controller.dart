import 'dart:convert';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../../models/user_management_model.dart';

class UserManagementController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Observable variables
  var isLoading = false.obs;
  var users = <UserModel>[].obs;
  var pagination = Rxn<PaginationInfo>();
  var roles = <RoleOption>[].obs;
  var departments = <DepartmentModel>[].obs;
  var classes = <ClassModel>[].obs;

  // Filter variables
  var searchQuery = ''.obs;
  var selectedRole = Rxn<String>();
  var selectedDepartment = Rxn<String>();
  var selectedClass = Rxn<String>();
  var selectedStatus = 'all'.obs; // all, active, inactive
  var currentPage = 1.obs;
  var perPage = 15.obs;

  @override
  void onInit() {
    super.onInit();
    loadMetaData();
    loadUsers();
  }

  Future<void> loadMetaData() async {
    try {
      // Load roles
      final rolesResponse = await _apiService.get('/users-meta/roles');
      final rolesData = jsonDecode(rolesResponse.body);
      roles.value = (rolesData['roles'] as List)
          .map((role) => RoleOption.fromJson(role))
          .toList();

      // Load departments
      final deptResponse = await _apiService.get('/users-meta/departments');
      final deptData = jsonDecode(deptResponse.body);
      departments.value = (deptData['departments'] as List)
          .map((dept) => DepartmentModel.fromJson(dept))
          .toList();

      // Load classes
      final classResponse = await _apiService.get('/users-meta/classes');
      final classData = jsonDecode(classResponse.body);
      classes.value = (classData['classes'] as List)
          .map((cls) => ClassModel.fromJson(cls))
          .toList();
    } catch (e) {
      print('Error loading meta data: $e');
    }
  }

  Future<void> loadUsers({bool resetPage = true}) async {
    try {
      isLoading.value = true;
      if (resetPage) currentPage.value = 1;

      final queryParams = <String, dynamic>{
        'page': currentPage.value.toString(),
        'per_page': perPage.value.toString(),
      };

      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      if (selectedRole.value != null) {
        queryParams['role'] = selectedRole.value;
      }

      if (selectedDepartment.value != null) {
        queryParams['department_id'] = selectedDepartment.value;
      }

      if (selectedClass.value != null) {
        queryParams['class_id'] = selectedClass.value;
      }

      if (selectedStatus.value != 'all') {
        queryParams['status'] = selectedStatus.value == 'active' ? '1' : '0';
      }

      final response = await _apiService.get(
        '/users',
        queryParameters: queryParams,
      );
      final data = jsonDecode(response.body);
      final userListResponse = UserListResponse.fromJson(data);

      users.value = userListResponse.users;
      pagination.value = userListResponse.pagination;
    } catch (e) {
      print('Error loading users: $e');
      Get.snackbar('Error', 'Failed to load users');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser(UserFormData formData) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(
        '/users',
        data: formData.toJson(),
      );
      final data = jsonDecode(response.body);

      Get.snackbar('Success', 'User created successfully');
      loadUsers(); // Reload the list
      return data;
    } catch (e) {
      print('Error creating user: $e');
      Get.snackbar('Error', 'Failed to create user');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(int userId, UserFormData formData) async {
    try {
      isLoading.value = true;
      final response = await _apiService.put(
        '/users/$userId',
        data: formData.toJson(),
      );
      final data = jsonDecode(response.body);

      Get.snackbar('Success', 'User updated successfully');
      loadUsers(); // Reload the list
      return data;
    } catch (e) {
      print('Error updating user: $e');
      Get.snackbar('Error', 'Failed to update user');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      isLoading.value = true;
      await _apiService.delete('/users/$userId');

      Get.snackbar('Success', 'User deactivated successfully');
      loadUsers(); // Reload the list
    } catch (e) {
      print('Error deleting user: $e');
      Get.snackbar('Error', 'Failed to deactivate user');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleUserStatus(int userId) async {
    try {
      isLoading.value = true;
      await _apiService.post('/users/$userId/toggle-status');

      Get.snackbar('Success', 'User status updated successfully');
      loadUsers(); // Reload the list
    } catch (e) {
      print('Error toggling user status: $e');
      Get.snackbar('Error', 'Failed to update user status');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetUserPassword(int userId, String newPassword) async {
    try {
      isLoading.value = true;
      await _apiService.post(
        '/users/$userId/reset-password',
        data: {'password': newPassword, 'password_confirmation': newPassword},
      );

      Get.snackbar('Success', 'Password reset successfully');
    } catch (e) {
      print('Error resetting password: $e');
      Get.snackbar('Error', 'Failed to reset password');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter methods
  void setSearchQuery(String query) {
    searchQuery.value = query;
    loadUsers();
  }

  void setRoleFilter(String? role) {
    selectedRole.value = role;
    loadUsers();
  }

  void setDepartmentFilter(String? departmentId) {
    selectedDepartment.value = departmentId;
    loadUsers();
  }

  void setClassFilter(String? classId) {
    selectedClass.value = classId;
    loadUsers();
  }

  void setStatusFilter(String status) {
    selectedStatus.value = status;
    loadUsers();
  }

  void goToPage(int page) {
    currentPage.value = page;
    loadUsers(resetPage: false);
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedRole.value = null;
    selectedDepartment.value = null;
    selectedClass.value = null;
    selectedStatus.value = 'all';
    currentPage.value = 1;
    loadUsers();
  }
}
