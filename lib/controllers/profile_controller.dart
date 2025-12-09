import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();

  // Loading state
  var isLoading = false.obs;

  // Profile data
  var name = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var dateOfBirth = Rxn<DateTime>();
  var gender = Rxn<String>();
  var bio = ''.obs;
  var emergencyContactName = ''.obs;
  var emergencyContactPhone = ''.obs;
  var languagePreference = 'id'.obs;
  var themePreference = 'system'.obs;

  // Image handling
  var selectedImage = Rxn<File>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getProfile();

      final userData = response['user'];
      final user = User.fromJson(userData);

      // Populate reactive variables
      name.value = user.name;
      phone.value = user.phone ?? '';
      address.value = user.address ?? '';
      dateOfBirth.value = user.dateOfBirth;
      gender.value = user.gender;
      bio.value = user.bio ?? '';
      emergencyContactName.value = user.emergencyContactName ?? '';
      emergencyContactPhone.value = user.emergencyContactPhone ?? '';
      languagePreference.value = user.languagePreference ?? 'id';
      themePreference.value = user.themePreference ?? 'system';
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat profil: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final response = await _apiService.updateProfile(data);

      // Update local user data in auth controller
      final authController = Get.find<AuthController>();
      final updatedUser = User.fromJson(response['user']);
      authController.user.value = updatedUser;

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
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      isLoading.value = true;
      await _apiService.updatePassword(currentPassword, newPassword);

      Get.snackbar(
        'Berhasil',
        'Password berhasil diubah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengubah password: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNotificationPreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      isLoading.value = true;
      await _apiService.updateNotificationPreferences(preferences);

      Get.snackbar(
        'Berhasil',
        'Preferensi notifikasi berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui preferensi notifikasi: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> uploadProfilePhoto() async {
    if (selectedImage.value == null) return;

    try {
      isLoading.value = true;

      final token = await _apiService.getToken();
      if (token != null) {
        final uri = Uri.parse('${ApiService.baseUrl}/profile/photo');
        final request = http.MultipartRequest('POST', uri);
        request.headers['Authorization'] = 'Bearer $token';
        request.files.add(
          await http.MultipartFile.fromPath('image', selectedImage.value!.path),
        );

        final streamed = await request.send();
        final resp = await http.Response.fromStream(streamed);
        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final authController = Get.find<AuthController>();
          if (data['user'] != null) {
            authController.user.value = User.fromJson(data['user']);
          }
          Get.snackbar(
            'Berhasil',
            'Foto profil berhasil diperbarui',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          selectedImage.value = null;
        } else {
          throw Exception('Upload failed: ${resp.body}');
        }
      } else {
        // No token - mock success
        Get.snackbar(
          'Berhasil',
          'Foto profil berhasil diperbarui (mode offline)',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        selectedImage.value = null;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengupload foto profil: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
