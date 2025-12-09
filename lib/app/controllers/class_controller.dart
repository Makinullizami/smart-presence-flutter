import 'package:get/get.dart';
import '../../models/class_model.dart';
import '../../services/class_repository.dart';

class ClassController extends GetxController {
  final ClassRepository _repository = ClassRepository();

  // Observable variables
  var classes = <ClassGroup>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedClasses = <int>[].obs;

  // Filters
  var searchQuery = ''.obs;
  var selectedDepartmentId = Rxn<int>();
  var selectedLevel = Rxn<int>();
  var selectedAcademicYear = ''.obs;
  var selectedStatus = Rxn<bool>();
  var currentPage = 1.obs;
  var perPage = 10.obs;
  var totalPages = 1.obs;

  // Detail data
  var currentClass = Rxn<ClassGroup>();
  var classMembers = <ClassMember>[].obs;
  var classSchedules = <ClassSchedule>[].obs;
  var attendanceSetting = Rxn<ClassAttendanceSetting>();

  @override
  void onInit() {
    super.onInit();
    loadClasses();
  }

  // Load classes with filters
  Future<void> loadClasses({bool resetPage = true}) async {
    if (resetPage) currentPage.value = 1;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.getClasses(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        departmentId: selectedDepartmentId.value,
        level: selectedLevel.value,
        academicYear: selectedAcademicYear.value.isEmpty
            ? null
            : selectedAcademicYear.value,
        status: selectedStatus.value,
        page: currentPage.value,
        perPage: perPage.value,
      );
      classes.assignAll(result);
      totalPages.value = (classes.length / perPage.value).ceil();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Update filters
  void updateFilters({
    String? search,
    int? department,
    int? level,
    String? academicYear,
    bool? status,
  }) {
    if (search != null) searchQuery.value = search;
    if (department != null) selectedDepartmentId.value = department;
    if (level != null) selectedLevel.value = level;
    if (academicYear != null) selectedAcademicYear.value = academicYear;
    if (status != null) selectedStatus.value = status;
    loadClasses();
  }

  // Create class
  Future<void> createClass(ClassGroup classGroup) async {
    try {
      final newClass = await _repository.createClass(classGroup);
      classes.add(newClass);
      Get.snackbar('Berhasil', 'Kelas berhasil dibuat');
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat kelas: $e');
    }
  }

  // Update class
  Future<void> updateClass(ClassGroup classGroup) async {
    try {
      final updated = await _repository.updateClass(classGroup);
      final index = classes.indexWhere((c) => c.id == classGroup.id);
      if (index != -1) {
        classes[index] = updated;
      }
      Get.snackbar('Berhasil', 'Kelas berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui kelas: $e');
    }
  }

  // Delete class
  Future<void> deleteClass(int id) async {
    try {
      await _repository.deleteClass(id);
      classes.removeWhere((c) => c.id == id);
      Get.snackbar('Berhasil', 'Kelas berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus kelas: $e');
    }
  }

  // Bulk update status
  Future<void> bulkUpdateStatus(bool status) async {
    if (selectedClasses.isEmpty) return;

    try {
      await _repository.bulkUpdateStatus(selectedClasses, status);
      for (var id in selectedClasses) {
        final index = classes.indexWhere((c) => c.id == id);
        if (index != -1) {
          classes[index] = classes[index].copyWith(status: status);
        }
      }
      selectedClasses.clear();
      Get.snackbar('Berhasil', 'Status kelas berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status: $e');
    }
  }

  // Load class detail
  Future<void> loadClassDetail(int id) async {
    try {
      currentClass.value = await _repository.getClassDetail(id);
      await loadClassMembers(id);
      await loadClassSchedules(id);
      await loadAttendanceSetting(id);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail kelas: $e');
    }
  }

  // Load class members
  Future<void> loadClassMembers(int classId) async {
    try {
      final members = await _repository.getClassMembers(classId);
      classMembers.assignAll(members);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat anggota: $e');
    }
  }

  // Load class schedules
  Future<void> loadClassSchedules(int classId) async {
    try {
      final schedules = await _repository.getClassSchedules(classId);
      classSchedules.assignAll(schedules);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat jadwal: $e');
    }
  }

  // Load attendance setting
  Future<void> loadAttendanceSetting(int classId) async {
    try {
      final setting = await _repository.getClassAttendanceSetting(classId);
      attendanceSetting.value = setting;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat pengaturan absensi: $e');
    }
  }

  // Update attendance setting
  Future<void> updateAttendanceSetting(ClassAttendanceSetting setting) async {
    try {
      await _repository.updateClassAttendanceSetting(setting);
      attendanceSetting.value = setting;
      Get.snackbar('Berhasil', 'Pengaturan absensi berhasil disimpan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan pengaturan: $e');
    }
  }

  // Add members
  Future<void> addMembers(int classId, List<int> userIds) async {
    try {
      await _repository.addMembersToClass(classId, userIds);
      await loadClassMembers(classId);
      Get.snackbar('Berhasil', 'Anggota berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan anggota: $e');
    }
  }

  // Remove member
  Future<void> removeMember(int classId, int memberId) async {
    try {
      await _repository.removeMemberFromClass(classId, memberId);
      classMembers.removeWhere((m) => m.id == memberId);
      Get.snackbar('Berhasil', 'Anggota berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus anggota: $e');
    }
  }

  // Add schedule
  Future<void> addSchedule(int classId, ClassSchedule schedule) async {
    try {
      await _repository.addScheduleToClass(classId, schedule);
      await loadClassSchedules(classId);
      Get.snackbar('Berhasil', 'Jadwal berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan jadwal: $e');
    }
  }

  // Update schedule
  Future<void> updateSchedule(ClassSchedule schedule) async {
    try {
      await _repository.updateSchedule(schedule);
      await loadClassSchedules(schedule.id); // Assuming classId is available
      Get.snackbar('Berhasil', 'Jadwal berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui jadwal: $e');
    }
  }

  // Delete schedule
  Future<void> deleteSchedule(int id) async {
    try {
      await _repository.deleteSchedule(id);
      classSchedules.removeWhere((s) => s.id == id);
      Get.snackbar('Berhasil', 'Jadwal berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus jadwal: $e');
    }
  }

  // Toggle selection
  void toggleSelection(int id) {
    if (selectedClasses.contains(id)) {
      selectedClasses.remove(id);
    } else {
      selectedClasses.add(id);
    }
  }

  // Select all
  void selectAll() {
    selectedClasses.assignAll(classes.map((c) => c.id));
  }

  // Clear selection
  void clearSelection() {
    selectedClasses.clear();
  }

  // Change page
  void changePage(int page) {
    currentPage.value = page;
    loadClasses(resetPage: false);
  }

  // Change per page
  void changePerPage(int value) {
    perPage.value = value;
    loadClasses();
  }
}
