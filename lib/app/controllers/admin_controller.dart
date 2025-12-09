import 'dart:convert';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../../models/dashboard_model.dart';

class AdminController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var isLoading = false.obs;
  var dashboard = Rxn<AdminDashboard>();
  var selectedDate = DateTime.now().obs;
  var selectedFilter = 'today'.obs;
  var selectedUnit = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  Future<void> fetchDashboard() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get(
        '/dashboard/admin',
        queryParameters: {
          'date': selectedDate.value.toIso8601String().split('T')[0],
          'filter': selectedFilter.value,
          if (selectedUnit.value != null) 'unit': selectedUnit.value,
        },
      );

      final data = jsonDecode(response.body);
      dashboard.value = AdminDashboard.fromJson(data);
    } catch (e) {
      print('Error fetching admin dashboard: $e');
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  void updateFilters({DateTime? date, String? filter, String? unit}) {
    if (date != null) selectedDate.value = date;
    if (filter != null) selectedFilter.value = filter;
    if (unit != null) selectedUnit.value = unit;
    fetchDashboard();
  }
}
