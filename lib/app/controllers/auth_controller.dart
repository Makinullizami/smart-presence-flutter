import 'package:get/get.dart';
import '../services/api_service.dart';
import '../../models/user_model.dart';

class AuthController extends GetxController {
  final ApiService _apiService = ApiService();

  var isLoading = false.obs;
  var user = Rxn<User>();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await _apiService.login(email, password);
      user.value = User.fromJson(response['user']);
      if (user.value!.role == 'admin') {
        Get.offAllNamed('/admin-dashboard');
      } else {
        Get.offAllNamed('/student-dashboard');
      }
    } catch (e) {
      Get.snackbar('Error', 'Login gagal: $e');
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
    isLoading.value = true;
    try {
      await _apiService.register(name, email, password, role);
      Get.snackbar('Berhasil', 'Pendaftaran berhasil. Silakan masuk.');
      Get.offNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Pendaftaran gagal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    user.value = null;
    Get.offAllNamed('/login');
  }

  Future<void> checkAuthStatus() async {
    final token = await _apiService.getToken();
    if (token != null) {
      // In a real app, you might fetch user data here
      // For now, assume user is logged in
      Get.offAllNamed('/dashboard');
    }
  }
}
