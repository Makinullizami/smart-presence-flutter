import 'dart:convert';
import 'package:get/get.dart';
import '../services/api_service.dart';

class SettingsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var isLoading = false.obs;
  var isSaving = false.obs;

  // Profil Instansi
  var appName = ''.obs;
  var institutionName = ''.obs;
  var institutionAddress = ''.obs;
  var institutionPhone = ''.obs;
  var institutionEmail = ''.obs;

  // Aturan Absensi Global
  var attendanceToleranceMinutes = 10.obs;
  var minimumAttendancePercentage = 75.obs;
  var workingHoursStart = '08:00'.obs;
  var workingHoursEnd = '17:00'.obs;

  // Lokasi & Perangkat
  var geofenceEnabled = true.obs;
  var geofenceCenterLat = '-6.2088'.obs;
  var geofenceCenterLng = '106.8456'.obs;
  var geofenceRadiusMeters = 500.obs;

  // Face Recognition & Foto Absensi
  var faceRecognitionThreshold = '0.8'.obs;
  var requirePhotoOnAttendance = true.obs;

  // Notifikasi & Email
  var emailNotificationsEnabled = true.obs;
  var smsNotificationsEnabled = false.obs;
  var pushNotificationsEnabled = true.obs;

  // Sistem & Keamanan
  var sessionTimeoutMinutes = 60.obs;
  var passwordMinLength = 8.obs;
  var requireSpecialCharacters = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('/settings');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _loadSettingsFromJson(data);
      }
    } catch (e) {
      print('Error fetching settings: $e');
      Get.snackbar('Error', 'Gagal memuat pengaturan');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveSettings() async {
    try {
      isSaving.value = true;
      final settings = _buildSettingsJson();

      final response = await _apiService.post('/settings', data: settings);

      if (response.statusCode == 200) {
        Get.snackbar('Berhasil', 'Pengaturan berhasil disimpan');
      } else {
        throw Exception('Failed to save settings');
      }
    } catch (e) {
      print('Error saving settings: $e');
      Get.snackbar('Error', 'Gagal menyimpan pengaturan');
    } finally {
      isSaving.value = false;
    }
  }

  void _loadSettingsFromJson(Map<String, dynamic> data) {
    // Profil Instansi
    appName.value = data['app_name'] ?? 'Smart Presence';
    institutionName.value = data['institution_name'] ?? '';
    institutionAddress.value = data['institution_address'] ?? '';
    institutionPhone.value = data['institution_phone'] ?? '';
    institutionEmail.value = data['institution_email'] ?? '';

    // Aturan Absensi Global
    attendanceToleranceMinutes.value =
        data['attendance_tolerance_minutes'] ?? 10;
    minimumAttendancePercentage.value =
        data['minimum_attendance_percentage'] ?? 75;
    workingHoursStart.value = data['working_hours_start'] ?? '08:00';
    workingHoursEnd.value = data['working_hours_end'] ?? '17:00';

    // Lokasi & Perangkat
    geofenceEnabled.value = data['geofence_enabled'] ?? true;
    geofenceCenterLat.value = data['geofence_center_lat'] ?? '-6.2088';
    geofenceCenterLng.value = data['geofence_center_lng'] ?? '106.8456';
    geofenceRadiusMeters.value = data['geofence_radius_meters'] ?? 500;

    // Face Recognition & Foto Absensi
    faceRecognitionThreshold.value =
        data['face_recognition_threshold'] ?? '0.8';
    requirePhotoOnAttendance.value =
        data['require_photo_on_attendance'] ?? true;

    // Notifikasi & Email
    emailNotificationsEnabled.value =
        data['email_notifications_enabled'] ?? true;
    smsNotificationsEnabled.value = data['sms_notifications_enabled'] ?? false;
    pushNotificationsEnabled.value = data['push_notifications_enabled'] ?? true;

    // Sistem & Keamanan
    sessionTimeoutMinutes.value = data['session_timeout_minutes'] ?? 60;
    passwordMinLength.value = data['password_min_length'] ?? 8;
    requireSpecialCharacters.value = data['require_special_characters'] ?? true;
  }

  Map<String, dynamic> _buildSettingsJson() {
    return {
      // Profil Instansi
      'app_name': appName.value,
      'institution_name': institutionName.value,
      'institution_address': institutionAddress.value,
      'institution_phone': institutionPhone.value,
      'institution_email': institutionEmail.value,

      // Aturan Absensi Global
      'attendance_tolerance_minutes': attendanceToleranceMinutes.value,
      'minimum_attendance_percentage': minimumAttendancePercentage.value,
      'working_hours_start': workingHoursStart.value,
      'working_hours_end': workingHoursEnd.value,

      // Lokasi & Perangkat
      'geofence_enabled': geofenceEnabled.value,
      'geofence_center_lat': geofenceCenterLat.value,
      'geofence_center_lng': geofenceCenterLng.value,
      'geofence_radius_meters': geofenceRadiusMeters.value,

      // Face Recognition & Foto Absensi
      'face_recognition_threshold': faceRecognitionThreshold.value,
      'require_photo_on_attendance': requirePhotoOnAttendance.value,

      // Notifikasi & Email
      'email_notifications_enabled': emailNotificationsEnabled.value,
      'sms_notifications_enabled': smsNotificationsEnabled.value,
      'push_notifications_enabled': pushNotificationsEnabled.value,

      // Sistem & Keamanan
      'session_timeout_minutes': sessionTimeoutMinutes.value,
      'password_min_length': passwordMinLength.value,
      'require_special_characters': requireSpecialCharacters.value,
    };
  }
}
