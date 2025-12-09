import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../models/appeal_model.dart';
import '../models/dashboard_model.dart';
import '../models/notification_model.dart';
import '../models/announcement_model.dart' as announcement_model;

class ApiService {
  static const String baseUrl =
      'http://localhost:8000/api'; // Change this to your backend URL
  static const bool demoMode = true; // Set to false when backend is available
  static const storage = FlutterSecureStorage();

  // Authentication methods
  Future<Map<String, dynamic>> login(String email, String password) async {
    if (demoMode) {
      // Simulate login in demo mode
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Check if user exists in stored data
      final storedUserJson = await storage.read(key: 'user');
      if (storedUserJson != null) {
        final storedUser = jsonDecode(storedUserJson);
        if (storedUser['email'] == email) {
          // Generate a demo token
          final demoToken =
              'demo_token_${DateTime.now().millisecondsSinceEpoch}';

          // Update last login
          storedUser['last_login_at'] = DateTime.now().toIso8601String();

          // Store updated data
          await storage.write(key: 'token', value: demoToken);
          await storage.write(key: 'user', value: jsonEncode(storedUser));

          return {
            'token': demoToken,
            'user': storedUser,
            'message': 'Login successful (Demo Mode)',
          };
        }
      }

      // Demo login for default accounts
      if (email == 'admin@demo.com' && password == 'admin123') {
        final demoToken =
            'demo_token_admin_${DateTime.now().millisecondsSinceEpoch}';
        final userData = {
          'id': 1,
          'name': 'Admin Demo',
          'email': email,
          'role': 'admin',
          'nim': null,
          'employee_id': 'ADM001',
          'class_id': null,
          'department_id': 1,
          'phone': '081234567890',
          'address': 'Demo Address',
          'date_of_birth': null,
          'gender': 'male',
          'profile_photo_path': null,
          'bio': 'Demo admin account',
          'emergency_contact_name': null,
          'emergency_contact_phone': null,
          'notification_preferences': {'email': true, 'push': true},
          'language_preference': 'id',
          'theme_preference': 'light',
          'fcm_token': null,
          'is_active': true,
          'last_login_at': DateTime.now().toIso8601String(),
          'email_verified_at': DateTime.now().toIso8601String(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        await storage.write(key: 'token', value: demoToken);
        await storage.write(key: 'user', value: jsonEncode(userData));

        return {
          'token': demoToken,
          'user': userData,
          'message': 'Login successful (Demo Mode)',
        };
      }

      if (email == 'user@demo.com' && password == 'user123') {
        final demoToken =
            'demo_token_user_${DateTime.now().millisecondsSinceEpoch}';
        final userData = {
          'id': 2,
          'name': 'User Demo',
          'email': email,
          'role': 'user',
          'nim': '12345678',
          'employee_id': null,
          'class_id': 1,
          'department_id': null,
          'phone': '081234567891',
          'address': 'Demo Student Address',
          'date_of_birth': null,
          'gender': 'female',
          'profile_photo_path': null,
          'bio': 'Demo student account',
          'emergency_contact_name': null,
          'emergency_contact_phone': null,
          'notification_preferences': {'email': true, 'push': true},
          'language_preference': 'id',
          'theme_preference': 'light',
          'fcm_token': null,
          'is_active': true,
          'last_login_at': DateTime.now().toIso8601String(),
          'email_verified_at': DateTime.now().toIso8601String(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        await storage.write(key: 'token', value: demoToken);
        await storage.write(key: 'user', value: jsonEncode(userData));

        return {
          'token': demoToken,
          'user': userData,
          'message': 'Login successful (Demo Mode)',
        };
      }

      throw Exception('Invalid email or password');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);
      await storage.write(key: 'user', value: jsonEncode(data['user']));
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    if (demoMode) {
      // Simulate successful registration in demo mode
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Simulate network delay

      // Generate a demo token
      final demoToken = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';

      // Create demo user data
      final userData = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'name': name,
        'email': email,
        'role': role,
        'nim': role == 'user' ? '12345678' : null,
        'employee_id': role != 'user'
            ? 'EMP${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}'
            : null,
        'class_id': role == 'user' ? 1 : null,
        'department_id': role != 'user' ? 1 : null,
        'phone': null,
        'address': null,
        'date_of_birth': null,
        'gender': null,
        'profile_photo_path': null,
        'bio': null,
        'emergency_contact_name': null,
        'emergency_contact_phone': null,
        'notification_preferences': null,
        'language_preference': 'id',
        'theme_preference': 'light',
        'fcm_token': null,
        'is_active': true,
        'last_login_at': DateTime.now().toIso8601String(),
        'email_verified_at': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      // Store demo data
      await storage.write(key: 'token', value: demoToken);
      await storage.write(key: 'user', value: jsonEncode(userData));

      return {
        'token': demoToken,
        'user': userData,
        'message': 'Registration successful (Demo Mode)',
      };
    }

    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

  Future<void> logout() async {
    final token = await storage.read(key: 'token');
    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    }
    await storage.deleteAll();
  }

  // Get stored token
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // Get stored user
  Future<User?> getStoredUser() async {
    final userJson = await storage.read(key: 'user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Generic authenticated request method
  Future<http.Response> _authenticatedRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final uri = Uri.parse('$baseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    http.Response response;
    if (method == 'GET') {
      response = await http.get(uri, headers: headers);
    } else if (method == 'POST') {
      response = await http.post(uri, headers: headers, body: jsonEncode(body));
    } else if (method == 'PUT') {
      response = await http.put(uri, headers: headers, body: jsonEncode(body));
    } else if (method == 'DELETE') {
      response = await http.delete(uri, headers: headers);
    } else {
      throw Exception('Unsupported HTTP method: $method');
    }

    return response;
  }

  // Attendance methods
  Future<List<Attendance>> getAttendanceHistory(int userId) async {
    final response = await _authenticatedRequest('GET', '/attendance/$userId');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((item) => Attendance.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load attendance history');
    }
  }

  Future<Map<String, dynamic>> markAttendance({
    required String validationMethod,
    Map<String, dynamic>? location,
    String? notes,
  }) async {
    final response = await _authenticatedRequest(
      'POST',
      '/attendance',
      body: {
        'validation_method': validationMethod,
        'location': location,
        'notes': notes,
      },
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to mark attendance: ${response.body}');
    }
  }

  // Appeal/Leave request methods
  Future<List<Appeal>> getAppeals() async {
    final response = await _authenticatedRequest('GET', '/appeals');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((item) => Appeal.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load appeals');
    }
  }

  Future<Appeal> createAppeal({
    required String type,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    String? attachmentPath,
  }) async {
    final response = await _authenticatedRequest(
      'POST',
      '/appeals',
      body: {
        'type': type,
        'start_date': startDate.toIso8601String().split('T')[0],
        'end_date': endDate.toIso8601String().split('T')[0],
        'reason': reason,
        'attachment': attachmentPath,
      },
    );

    if (response.statusCode == 201) {
      return Appeal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create appeal: ${response.body}');
    }
  }

  Future<Appeal> approveAppeal(int appealId) async {
    final response = await _authenticatedRequest(
      'POST',
      '/appeals/$appealId/approve',
    );

    if (response.statusCode == 200) {
      return Appeal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to approve appeal: ${response.body}');
    }
  }

  Future<Appeal> rejectAppeal(int appealId, String rejectionReason) async {
    final response = await _authenticatedRequest(
      'POST',
      '/appeals/$appealId/reject',
      body: {'rejection_reason': rejectionReason},
    );

    if (response.statusCode == 200) {
      return Appeal.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to reject appeal: ${response.body}');
    }
  }

  // Dashboard methods
  Future<SupervisorDashboard> getSupervisorDashboard() async {
    final response = await _authenticatedRequest(
      'GET',
      '/dashboard/supervisor',
    );

    if (response.statusCode == 200) {
      return SupervisorDashboard.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load dashboard: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> markManualAttendance({
    required int userId,
    required DateTime date,
    required String status,
    String? checkInTime,
    String? checkOutTime,
    String? notes,
  }) async {
    final response = await _authenticatedRequest(
      'POST',
      '/attendance/manual',
      body: {
        'user_id': userId,
        'date': date.toIso8601String().split('T')[0],
        'status': status,
        'check_in_time': checkInTime,
        'check_out_time': checkOutTime,
        'notes': notes,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to mark manual attendance: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> addAttendanceNote({
    required int userId,
    required DateTime date,
    required String notes,
  }) async {
    final response = await _authenticatedRequest(
      'POST',
      '/attendance/note',
      body: {
        'user_id': userId,
        'date': date.toIso8601String().split('T')[0],
        'notes': notes,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add attendance note: ${response.body}');
    }
  }

  // Notification methods
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _authenticatedRequest('GET', '/notifications');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    final response = await _authenticatedRequest(
      'PUT',
      '/notifications/$notificationId/read',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }

  // Face recognition methods
  Future<Map<String, dynamic>> uploadFaceEmbedding(
    List<double> embedding,
  ) async {
    final response = await _authenticatedRequest(
      'POST',
      '/faces/embedding',
      body: {'embedding': embedding},
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to upload face embedding: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> recognizeFace(List<double> embedding) async {
    final response = await _authenticatedRequest(
      'POST',
      '/faces/recognize',
      body: {'embedding': embedding},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Face recognition failed: ${response.body}');
    }
  }

  // Report methods
  Future<Map<String, dynamic>> getPersonalReport({
    String? month,
    String? year,
  }) async {
    final queryParams = <String, String>{};
    if (month != null) queryParams['month'] = month;
    if (year != null) queryParams['year'] = year;

    final uri = Uri.parse(
      '$baseUrl/reports/personal',
    ).replace(queryParameters: queryParams);
    final token = await getToken();
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load personal report: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getSupervisorReport({String? date}) async {
    final queryParams = <String, String>{};
    if (date != null) queryParams['date'] = date;

    final uri = Uri.parse(
      '$baseUrl/reports/supervisor',
    ).replace(queryParameters: queryParams);
    final token = await getToken();
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load supervisor report: ${response.body}');
    }
  }

  // Announcement methods
  Future<List<announcement_model.Announcement>> getAnnouncements({
    String? category,
    String? search,
    String? dateFrom,
    String? dateTo,
    int limit = 20,
  }) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;
    if (dateFrom != null) queryParams['date_from'] = dateFrom;
    if (dateTo != null) queryParams['date_to'] = dateTo;
    queryParams['limit'] = limit.toString();

    final uri = Uri.parse(
      '$baseUrl/announcements',
    ).replace(queryParameters: queryParams);
    final token = await getToken();
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as List)
          .map((item) => announcement_model.Announcement.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load announcements');
    }
  }

  Future<announcement_model.Announcement> getAnnouncement(int id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/announcements/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return announcement_model.Announcement.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to load announcement');
    }
  }

  // Profile management methods
  Future<Map<String, dynamic>> getProfile() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/profile/password'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update password: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateNotificationPreferences(
    Map<String, dynamic> preferences,
  ) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/profile/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(preferences),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to update notification preferences: ${response.body}',
      );
    }
  }

  // Device management methods
  Future<Map<String, dynamic>> getDevices() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/devices'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<Map<String, dynamic>> registerDevice(
    Map<String, dynamic> deviceData,
  ) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/devices'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(deviceData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register device: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> verifyDevice(
    String deviceId,
    String verificationCode,
  ) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/devices/verify'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'device_id': deviceId,
        'verification_code': verificationCode,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify device: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> removeDevice(int deviceId) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/devices/$deviceId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to remove device: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateFcmToken(String fcmToken) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/profile/fcm-token'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'fcm_token': fcmToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update FCM token: ${response.body}');
    }
  }

  Future<announcement_model.Announcement> createAnnouncement({
    required String title,
    required String content,
    required String category,
    required String targetType,
    int? targetId,
    String? priority,
    String? attachmentPath,
  }) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/announcements'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': category,
        'target_type': targetType,
        'target_id': targetId,
        'priority': priority,
        'attachment': attachmentPath,
      }),
    );

    if (response.statusCode == 201) {
      return announcement_model.Announcement.fromJson(
        jsonDecode(response.body)['announcement'],
      );
    } else {
      throw Exception('Failed to create announcement: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getAnnouncementCategories() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/announcements/categories'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Map<String, dynamic>> getAnnouncementTargets() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/announcements/targets'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load targets');
    }
  }
}
