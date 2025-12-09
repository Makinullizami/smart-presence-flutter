import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/user_device_model.dart';

class DeviceController extends GetxController {
  final ApiService _apiService = ApiService();

  // Device data
  var devices = <UserDevice>[].obs;
  var isLoading = false.obs;
  var maxDevices = 2.obs; // Configurable limit

  @override
  void onInit() {
    super.onInit();
    loadDevices();
  }

  Future<void> loadDevices() async {
    try {
      isLoading.value = true;
      final response = await _apiService.getDevices();

      final deviceList = response['devices'] as List;
      final maxDeviceCount = response['max_devices'] ?? 2;

      devices.value = deviceList
          .map((json) => UserDevice.fromJson(json))
          .toList();
      maxDevices.value = maxDeviceCount;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat daftar perangkat: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerDevice(Map<String, dynamic> deviceData) async {
    try {
      isLoading.value = true;
      final response = await _apiService.registerDevice(deviceData);

      if (response['requires_verification'] == true) {
        // Device requires verification
        Get.snackbar(
          'Verifikasi Diperlukan',
          response['message'] ?? 'Perangkat baru memerlukan verifikasi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );

        // Show verification dialog
        _showVerificationDialog(response['device']);
      } else {
        // Device registered successfully
        await loadDevices();
        Get.snackbar(
          'Berhasil',
          'Perangkat berhasil didaftarkan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mendaftarkan perangkat: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyDevice(String deviceId, String verificationCode) async {
    try {
      isLoading.value = true;
      final response = await _apiService.verifyDevice(
        deviceId,
        verificationCode,
      );

      await loadDevices();
      Get.snackbar(
        'Berhasil',
        'Perangkat berhasil diverifikasi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memverifikasi perangkat: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeDevice(int deviceId) async {
    try {
      isLoading.value = true;
      await _apiService.removeDevice(deviceId);

      await loadDevices();
      Get.snackbar(
        'Berhasil',
        'Perangkat berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus perangkat: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showVerificationDialog(Map<String, dynamic> deviceData) {
    final verificationCodeController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Verifikasi Perangkat Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Kode verifikasi telah dikirim ke email Anda. Masukkan kode untuk memverifikasi perangkat baru.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            TextField(
              controller: verificationCodeController,
              decoration: InputDecoration(
                labelText: 'Kode Verifikasi',
                hintText: 'Masukkan 6 digit kode',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final code = verificationCodeController.text.trim();
              if (code.isNotEmpty && code.length == 6) {
                Get.back();
                await verifyDevice(deviceData['device_id'], code);
              } else {
                Get.snackbar(
                  'Error',
                  'Masukkan kode verifikasi yang valid (6 digit)',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Verifikasi'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Get current device
  UserDevice? getCurrentDevice() {
    return devices.firstWhereOrNull((device) => device.isCurrentDevice);
  }

  // Get active devices count
  int getActiveDevicesCount() {
    return devices.where((device) => device.isActive).length;
  }

  // Check if can add more devices
  bool canAddMoreDevices() {
    return getActiveDevicesCount() < maxDevices.value;
  }

  // Get device by ID
  UserDevice? getDeviceById(int id) {
    return devices.firstWhereOrNull((device) => device.id == id);
  }
}
