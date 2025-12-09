import 'package:get/get.dart';
import '../../models/department_model.dart';
import '../../services/department_repository.dart';

class DepartmentController extends GetxController {
  final DepartmentRepository _repository = DepartmentRepository();

  // Observable variables
  var departments = <Department>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var selectedDepartments = <int>[].obs;

  // Filters
  var searchQuery = ''.obs;
  var selectedUnitId = Rxn<int>();
  var selectedStatus = Rxn<bool>();
  var currentPage = 1.obs;
  var perPage = 10.obs;
  var totalPages = 1.obs;

  // Detail data
  var currentDepartment = Rxn<Department>();
  var departmentMembers = <DepartmentMember>[].obs;
  var departmentClasses = <DepartmentClass>[].obs;
  var attendanceSetting = Rxn<DepartmentAttendanceSetting>();

  @override
  void onInit() {
    super.onInit();
    loadDepartments();
  }

  // Load departments with filters
  Future<void> loadDepartments({bool resetPage = true}) async {
    if (resetPage) currentPage.value = 1;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.getDepartments(
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        unitId: selectedUnitId.value,
        status: selectedStatus.value,
        page: currentPage.value,
        perPage: perPage.value,
      );
      departments.assignAll(result);
      totalPages.value = (departments.length / perPage.value).ceil();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Update filters
  void updateFilters({String? search, int? unit, bool? status}) {
    if (search != null) searchQuery.value = search;
    if (unit != null) selectedUnitId.value = unit;
    if (status != null) selectedStatus.value = status;
    loadDepartments();
  }

  // Create department
  Future<void> createDepartment(Department department) async {
    try {
      final newDept = await _repository.createDepartment(department);
      departments.add(newDept);
      Get.snackbar('Berhasil', 'Departemen berhasil dibuat');
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat departemen: $e');
    }
  }

  // Update department
  Future<void> updateDepartment(Department department) async {
    try {
      final updated = await _repository.updateDepartment(department);
      final index = departments.indexWhere((d) => d.id == department.id);
      if (index != -1) {
        departments[index] = updated;
      }
      Get.snackbar('Berhasil', 'Departemen berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui departemen: $e');
    }
  }

  // Delete department
  Future<void> deleteDepartment(int id) async {
    try {
      await _repository.deleteDepartment(id);
      departments.removeWhere((d) => d.id == id);
      Get.snackbar('Berhasil', 'Departemen berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus departemen: $e');
    }
  }

  // Bulk update status
  Future<void> bulkUpdateStatus(bool status) async {
    if (selectedDepartments.isEmpty) return;

    try {
      await _repository.bulkUpdateStatus(selectedDepartments, status);
      for (var id in selectedDepartments) {
        final index = departments.indexWhere((d) => d.id == id);
        if (index != -1) {
          departments[index] = departments[index].copyWith(status: status);
        }
      }
      selectedDepartments.clear();
      Get.snackbar('Berhasil', 'Status departemen berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status: $e');
    }
  }

  // Load department detail
  Future<void> loadDepartmentDetail(int id) async {
    try {
      currentDepartment.value = await _repository.getDepartmentDetail(id);
      await loadDepartmentMembers(id);
      await loadDepartmentClasses(id);
      await loadAttendanceSetting(id);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail departemen: $e');
    }
  }

  // Load department members
  Future<void> loadDepartmentMembers(int departmentId) async {
    try {
      final members = await _repository.getDepartmentMembers(departmentId);
      departmentMembers.assignAll(members);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat anggota: $e');
    }
  }

  // Load department classes
  Future<void> loadDepartmentClasses(int departmentId) async {
    try {
      final classes = await _repository.getDepartmentClasses(departmentId);
      departmentClasses.assignAll(classes);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat kelas: $e');
    }
  }

  // Load attendance setting
  Future<void> loadAttendanceSetting(int departmentId) async {
    try {
      final setting = await _repository.getDepartmentAttendanceSetting(
        departmentId,
      );
      attendanceSetting.value = setting;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat pengaturan absensi: $e');
    }
  }

  // Update attendance setting
  Future<void> updateAttendanceSetting(
    DepartmentAttendanceSetting setting,
  ) async {
    try {
      await _repository.updateDepartmentAttendanceSetting(setting);
      attendanceSetting.value = setting;
      Get.snackbar('Berhasil', 'Pengaturan absensi berhasil disimpan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan pengaturan: $e');
    }
  }

  // Add members
  Future<void> addMembers(int departmentId, List<int> userIds) async {
    try {
      await _repository.addMembersToDepartment(departmentId, userIds);
      await loadDepartmentMembers(departmentId);
      Get.snackbar('Berhasil', 'Anggota berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan anggota: $e');
    }
  }

  // Remove member
  Future<void> removeMember(int departmentId, int memberId) async {
    try {
      await _repository.removeMemberFromDepartment(departmentId, memberId);
      departmentMembers.removeWhere((m) => m.id == memberId);
      Get.snackbar('Berhasil', 'Anggota berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus anggota: $e');
    }
  }

  // Add class
  Future<void> addClass(int departmentId, int classId) async {
    try {
      await _repository.addClassToDepartment(departmentId, classId);
      await loadDepartmentClasses(departmentId);
      Get.snackbar('Berhasil', 'Kelas berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan kelas: $e');
    }
  }

  // Remove class
  Future<void> removeClass(int departmentId, int classId) async {
    try {
      await _repository.removeClassFromDepartment(departmentId, classId);
      departmentClasses.removeWhere((c) => c.id == classId);
      Get.snackbar('Berhasil', 'Kelas berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus kelas: $e');
    }
  }

  // Toggle selection
  void toggleSelection(int id) {
    if (selectedDepartments.contains(id)) {
      selectedDepartments.remove(id);
    } else {
      selectedDepartments.add(id);
    }
  }

  // Select all
  void selectAll() {
    selectedDepartments.assignAll(departments.map((d) => d.id));
  }

  // Clear selection
  void clearSelection() {
    selectedDepartments.clear();
  }

  // Change page
  void changePage(int page) {
    currentPage.value = page;
    loadDepartments(resetPage: false);
  }

  // Change per page
  void changePerPage(int value) {
    perPage.value = value;
    loadDepartments();
  }
}
