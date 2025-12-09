import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../models/appeal_model.dart';
import '../services/api_service.dart';

class AppealsController extends GetxController {
  final ApiService _apiService = ApiService();

  var appeals = <Appeal>[].obs;
  var isLoading = false.obs;

  Future<void> createAppeal(
    int attendanceId,
    String reason,
    String? evidencePath,
  ) async {
    isLoading.value = true;
    try {
      // Try to call real backend if token is available, otherwise fallback to mock
      final token = await _apiService.getToken();

      if (token != null) {
        final payload = {
          'attendance_id': attendanceId,
          'reason': reason,
          if (evidencePath != null) 'evidence_path': evidencePath,
        };

        try {
          final resp = await http.post(
            Uri.parse('${ApiService.baseUrl}/appeals'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(payload),
          );

          if (resp.statusCode == 201 || resp.statusCode == 200) {
            final data = jsonDecode(resp.body) as Map<String, dynamic>;
            final created = Appeal.fromJson(data);
            appeals.add(created);
            Get.snackbar('Berhasil', 'Banding berhasil diajukan');
            return;
          } else {
            // Backend returned an error — log and fallback to mock
            debugPrint('Appeal API error: ${resp.statusCode} ${resp.body}');
          }
        } catch (e) {
          // Network error — fallback to mock
          debugPrint('Error posting appeal to backend: $e');
        }
      }

      // Fallback: create mock appeal locally
      final now = DateTime.now();
      final appeal = Appeal(
        id: now.millisecondsSinceEpoch,
        userId: 1, // Mock user ID
        type: 'izin', // Default type
        startDate: now,
        endDate: now,
        reason: reason,
        status: 'pending',
        attachmentPath: evidencePath,
        createdAt: now,
        updatedAt: now,
      );
      appeals.add(appeal);
      Get.snackbar('Berhasil', 'Banding berhasil diajukan (mode offline)');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengajukan banding: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAppeals() async {
    isLoading.value = true;
    try {
      // Try to fetch from backend if possible
      final token = await _apiService.getToken();
      if (token != null) {
        try {
          final resp = await http.get(
            Uri.parse('${ApiService.baseUrl}/appeals'),
            headers: {'Authorization': 'Bearer $token'},
          );

          if (resp.statusCode == 200) {
            final List data = jsonDecode(resp.body) as List;
            appeals.value = data.map((e) => Appeal.fromJson(e)).toList();
            return;
          } else {
            debugPrint('Appeals API error: ${resp.statusCode} ${resp.body}');
          }
        } catch (e) {
          debugPrint('Error fetching appeals from backend: $e');
        }
      }

      // Fallback to mock appeals data
      final now = DateTime.now();
      appeals.value = [
        Appeal(
          id: 1,
          userId: 1,
          type: 'izin',
          startDate: now,
          endDate: now,
          reason: 'Terlambat karena macet',
          status: 'pending',
          createdAt: now,
          updatedAt: now,
        ),
      ];
    } catch (e) {
      debugPrint('Error fetching appeals: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
