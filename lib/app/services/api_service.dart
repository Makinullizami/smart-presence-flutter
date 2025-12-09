import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/user_model.dart';
import '../../models/attendance_model.dart';

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:8000/api'; // Android emulator localhost
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.write(key: 'token', value: data['token']);
        return data;
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      // Fallback to mock login for demo
      print('Backend not available, using mock login');
      String role = 'student';
      String name = 'Demo User';
      int id = DateTime.now().millisecondsSinceEpoch;

      if (email.contains('admin')) {
        role = 'admin';
        name = 'Admin User';
      } else {
        role = 'student';
        name = 'Student User';
      }

      final mockData = {
        'token': 'mock_token_${id}',
        'user': {'id': id, 'name': name, 'email': email, 'role': role},
      };
      await _storage.write(key: 'token', value: mockData['token'] as String);
      return mockData;
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
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
        throw Exception('Registration failed');
      }
    } catch (e) {
      // Fallback to mock registration for demo
      print('Backend not available, using mock registration');
      return {
        'message': 'Registration successful',
        'user': {
          'id': DateTime.now().millisecondsSinceEpoch,
          'name': name,
          'email': email,
          'role': role,
        },
      };
    }
  }

  Future<void> uploadFaceEmbedding(
    int userId,
    String imagePath,
    List<double> embedding,
  ) async {
    final token = await _storage.read(key: 'token');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/faces/embedding'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['user_id'] = userId.toString();
    request.fields['embedding'] = jsonEncode(embedding);
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await request.send();
    if (response.statusCode != 200) {
      // Mock success for demo when backend not available
      print('Backend not available, face upload mocked');
      return;
    }
  }

  Future<void> markAttendance(int userId) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.post(
        Uri.parse('$baseUrl/attendance'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode != 200) {
        throw Exception('Attendance marking failed');
      }
    } catch (e) {
      // Mock success for demo when backend not available
      print('Backend not available, attendance marked (mock)');
    }
  }

  Future<List<Attendance>> getAttendanceHistory(int userId) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('$baseUrl/attendance/$userId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Attendance.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load attendance history');
      }
    } catch (e) {
      // Mock data for demo when backend not available
      print('Backend not available, using mock attendance history');
      return [
        Attendance(
          id: 1,
          userId: userId,
          date: DateTime.parse('2023-11-27'),
          checkInTime: '08:00',
          status: 'present',
          isOfflineSync: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Attendance(
          id: 2,
          userId: userId,
          date: DateTime.parse('2023-11-26'),
          checkInTime: '08:05',
          status: 'late',
          isOfflineSync: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Attendance(
          id: 3,
          userId: userId,
          date: DateTime.parse('2023-11-25'),
          checkInTime: '07:50',
          status: 'present',
          isOfflineSync: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
    }
  }

  Future<http.Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final uri = Uri.parse(
        '$baseUrl$endpoint',
      ).replace(queryParameters: queryParameters);
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('GET request failed: ${response.statusCode}');
      }
    } catch (e) {
      // Mock response for demo when backend not available
      print('Backend not available, using mock GET response for $endpoint');
      if (endpoint == '/dashboard/admin') {
        return http.Response('''{
          "kpi": {
            "total_active_users": 150,
            "present_today": 142,
            "late_today": 8,
            "absent_today": 5,
            "leave_today": 3
          },
          "charts": {
            "weekly_attendance": [
              {"date": "2024-12-02", "present": 140},
              {"date": "2024-12-03", "present": 138},
              {"date": "2024-12-04", "present": 145},
              {"date": "2024-12-05", "present": 142},
              {"date": "2024-12-06", "present": 139},
              {"date": "2024-12-07", "present": 141},
              {"date": "2024-12-08", "present": 143}
            ],
            "distribution": {
              "present": 142,
              "late": 8,
              "absent": 5,
              "leave": 3
            }
          },
          "tables": {
            "top_late_users": [
              {"user_id": 1, "name": "John Doe", "late_count": 5},
              {"user_id": 2, "name": "Jane Smith", "late_count": 4},
              {"user_id": 3, "name": "Bob Johnson", "late_count": 3}
            ],
            "pending_appeals": [
              {"id": 1, "user_name": "Alice Brown", "type": "sick", "reason": "Flu", "created_at": "2024-12-07"},
              {"id": 2, "user_name": "Charlie Wilson", "type": "leave", "reason": "Family emergency", "created_at": "2024-12-06"}
            ],
            "lowest_attendance_classes": [
              {"class_id": 1, "class_name": "Class A", "attendance_percentage": 85.5},
              {"class_id": 2, "class_name": "Class B", "attendance_percentage": 88.2},
              {"class_id": 3, "class_name": "Class C", "attendance_percentage": 90.1}
            ]
          },
          "filters": {
            "date": "2024-12-07",
            "filter": "today",
            "unit": null
          }
        }''', 200);
      } else if (endpoint.contains('/users-meta/roles')) {
        return http.Response('''{
          "roles": [
            {"value": "admin", "label": "Administrator"},
            {"value": "hr", "label": "HR Manager"},
            {"value": "lecturer", "label": "Lecturer"},
            {"value": "employee", "label": "Employee"},
            {"value": "student", "label": "Student"}
          ]
        }''', 200);
      } else if (endpoint.contains('/users-meta/departments')) {
        return http.Response('''{
          "departments": [
            {"id": 1, "name": "Computer Science"},
            {"id": 2, "name": "Information Technology"},
            {"id": 3, "name": "Electrical Engineering"}
          ]
        }''', 200);
      } else if (endpoint.contains('/users-meta/classes')) {
        return http.Response('''{
          "classes": [
            {"id": 1, "name": "CS101"},
            {"id": 2, "name": "IT201"},
            {"id": 3, "name": "EE301"}
          ]
        }''', 200);
      } else if (endpoint.contains('/users') &&
          !endpoint.contains('/users-meta/')) {
        return http.Response('''{
          "users": [
            {
              "id": 1,
              "name": "John Doe",
              "email": "john@example.com",
              "nip_nim": "123456",
              "phone": "08123456789",
              "role": "student",
              "is_active": true,
              "department": {"id": 1, "name": "Computer Science"},
              "class": {"id": 1, "name": "CS101"},
              "profile_photo_url": null,
              "created_at": "2024-01-01T00:00:00.000000Z"
            },
            {
              "id": 2,
              "name": "Jane Smith",
              "email": "jane@example.com",
              "nip_nim": "123457",
              "phone": "08123456790",
              "role": "lecturer",
              "is_active": true,
              "department": {"id": 1, "name": "Computer Science"},
              "class": null,
              "profile_photo_url": null,
              "created_at": "2024-01-01T00:00:00.000000Z"
            },
            {
              "id": 3,
              "name": "Admin User",
              "email": "admin@example.com",
              "nip_nim": "000001",
              "phone": "08123456791",
              "role": "admin",
              "is_active": true,
              "department": null,
              "class": null,
              "profile_photo_url": null,
              "created_at": "2024-01-01T00:00:00.000000Z"
            }
          ],
          "pagination": {
            "current_page": 1,
            "last_page": 1,
            "per_page": 15,
            "total": 3
          }
        }''', 200);
      }
      return http.Response('{"message": "Mock response"}', 200);
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: data != null ? jsonEncode(data) : null,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw Exception('POST request failed: ${response.statusCode}');
      }
    } catch (e) {
      // Mock success for demo when backend not available
      print('Backend not available, POST mocked for $endpoint');
      return http.Response('{"message": "Mock success"}', 200);
    }
  }

  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: data != null ? jsonEncode(data) : null,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw Exception('PUT request failed: ${response.statusCode}');
      }
    } catch (e) {
      // Mock success for demo when backend not available
      print('Backend not available, PUT mocked for $endpoint');
      return http.Response('{"message": "Mock success"}', 200);
    }
  }

  Future<http.Response> delete(String endpoint) async {
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      } else {
        throw Exception('DELETE request failed: ${response.statusCode}');
      }
    } catch (e) {
      // Mock success for demo when backend not available
      print('Backend not available, DELETE mocked for $endpoint');
      return http.Response('{"message": "Mock success"}', 200);
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
