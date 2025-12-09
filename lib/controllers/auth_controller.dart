import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final user = Rxn<User>();
  final isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final storedUser = await _apiService.getStoredUser();
      final token = await _apiService.getToken();

      if (storedUser != null && token != null) {
        user.value = storedUser;
        // Navigate to appropriate dashboard based on role
        _navigateToDashboard();
      }
    } catch (e) {
      // User not logged in or token expired
      user.value = null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiService.login(email, password);
      final userData = User.fromJson(response['user']);

      user.value = userData;

      // Navigate to appropriate dashboard
      _navigateToDashboard();
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _apiService.register(name, email, password, role);

      // After successful registration, login automatically
      await login(email, password);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
      user.value = null;
      Get.offAllNamed('/login');
    } catch (e) {
      // Even if logout fails, clear local data
      user.value = null;
      Get.offAllNamed('/login');
    }
  }

  void _navigateToDashboard() {
    if (user.value != null) {
      switch (user.value!.role) {
        case 'user':
          Get.offAllNamed('/student-dashboard');
          break;
        case 'supervisor':
          Get.offAllNamed('/supervisor-dashboard');
          break;
        case 'admin':
          Get.offAllNamed('/admin-dashboard');
          break;
        default:
          Get.offAllNamed('/student-dashboard');
      }
    }
  }

  bool get isLoggedIn => user.value != null;
  bool get isStudent => user.value?.isStudent ?? false;
  bool get isSupervisor => user.value?.isSupervisor ?? false;
  bool get isAdmin => user.value?.isAdmin ?? false;
}
