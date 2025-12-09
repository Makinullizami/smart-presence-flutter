import 'package:get/get.dart';
import '../models/announcement_model.dart' as announcement_model;
import '../services/api_service.dart';

class AnnouncementsController extends GetxController {
  final ApiService _apiService = ApiService();

  var announcements = <announcement_model.Announcement>[].obs;
  var isLoading = false.obs;
  var selectedCategory = ''.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadAnnouncements();
  }

  Future<void> loadAnnouncements({
    String? category,
    String? search,
    String? dateFrom,
    String? dateTo,
  }) async {
    try {
      isLoading.value = true;
      final data = await _apiService.getAnnouncements(
        category: category,
        search: search,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      announcements.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load announcements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAnnouncements() async {
    await loadAnnouncements(
      category: selectedCategory.value.isNotEmpty
          ? selectedCategory.value
          : null,
      search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
    );
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    refreshAnnouncements();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    refreshAnnouncements();
  }

  List<announcement_model.Announcement> getFilteredAnnouncements() {
    return announcements.where((announcement) {
      // Filter by category if selected
      if (selectedCategory.value.isNotEmpty &&
          announcement.category != selectedCategory.value) {
        return false;
      }

      // Filter by search query
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        return announcement.title.toLowerCase().contains(query) ||
            announcement.content.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  List<announcement_model.Announcement> getUrgentAnnouncements() {
    return announcements.where((a) => a.isUrgent()).toList();
  }

  List<announcement_model.Announcement> getAnnouncementsByCategory(
    String category,
  ) {
    return announcements.where((a) => a.category == category).toList();
  }

  announcement_model.Announcement? getAnnouncementById(int id) {
    try {
      return announcements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
}
