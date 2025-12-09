import '../models/department_model.dart';

class DepartmentRepository {
  // Get departments with filters
  Future<List<Department>> getDepartments({
    String? search,
    int? unitId,
    bool? status,
    int page = 1,
    int perPage = 10,
  }) async {
    // Mock data for demo
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    var departments = _getMockDepartments();

    // Apply filters
    if (search != null && search.isNotEmpty) {
      departments = departments
          .where(
            (d) =>
                d.name.toLowerCase().contains(search.toLowerCase()) ||
                d.code.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }

    if (unitId != null) {
      departments = departments.where((d) => d.unitId == unitId).toList();
    }

    if (status != null) {
      departments = departments.where((d) => d.status == status).toList();
    }

    // Pagination
    final start = (page - 1) * perPage;
    final end = start + perPage;
    return departments.sublist(start, end.clamp(0, departments.length));
  }

  // Create department
  Future<Department> createDepartment(Department department) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return department.copyWith(id: DateTime.now().millisecondsSinceEpoch);
  }

  // Update department
  Future<Department> updateDepartment(Department department) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return department;
  }

  // Delete department
  Future<void> deleteDepartment(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Bulk update status
  Future<void> bulkUpdateStatus(List<int> ids, bool status) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get department detail
  Future<Department> getDepartmentDetail(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockDepartments().firstWhere(
      (d) => d.id == id,
      orElse: () => throw Exception('Department not found'),
    );
  }

  // Get department members
  Future<List<DepartmentMember>> getDepartmentMembers(int departmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockMembers(departmentId);
  }

  // Add members to department
  Future<void> addMembersToDepartment(
    int departmentId,
    List<int> userIds,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Remove member from department
  Future<void> removeMemberFromDepartment(
    int departmentId,
    int memberId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get department classes
  Future<List<DepartmentClass>> getDepartmentClasses(int departmentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockClasses(departmentId);
  }

  // Add class to department
  Future<void> addClassToDepartment(int departmentId, int classId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Remove class from department
  Future<void> removeClassFromDepartment(int departmentId, int classId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get department attendance setting
  Future<DepartmentAttendanceSetting> getDepartmentAttendanceSetting(
    int departmentId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return DepartmentAttendanceSetting(
      departmentId: departmentId,
      defaultStartTime: '08:00',
      defaultEndTime: '17:00',
      lateToleranceMinutes: 15,
      requireFaceRecognition: true,
      requireLocation: true,
      geofenceRadiusMeters: 100,
      minimumAttendancePercent: 75,
    );
  }

  // Update department attendance setting
  Future<void> updateDepartmentAttendanceSetting(
    DepartmentAttendanceSetting setting,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Mock data methods
  List<Department> _getMockDepartments() {
    return [
      Department(
        id: 1,
        code: 'TI',
        name: 'Teknik Informatika',
        shortName: 'TI',
        unitName: 'Fakultas Teknik',
        unitId: 1,
        headId: 1,
        headName: 'Dr. Ahmad',
        location: 'Gedung A',
        status: true,
        membersCount: 25,
        classesCount: 5,
        notes: 'Departemen utama',
      ),
      Department(
        id: 2,
        code: 'SI',
        name: 'Sistem Informasi',
        shortName: 'SI',
        unitName: 'Fakultas Teknik',
        unitId: 1,
        headId: 2,
        headName: 'Prof. Budi',
        location: 'Gedung B',
        status: true,
        membersCount: 20,
        classesCount: 4,
      ),
      Department(
        id: 3,
        code: 'TE',
        name: 'Teknik Elektro',
        shortName: 'TE',
        unitName: 'Fakultas Teknik',
        unitId: 1,
        headId: 3,
        headName: 'Dr. Cici',
        location: 'Gedung C',
        status: false,
        membersCount: 15,
        classesCount: 3,
      ),
    ];
  }

  List<DepartmentMember> _getMockMembers(int departmentId) {
    return [
      DepartmentMember(
        id: 1,
        userId: 1,
        name: 'Ahmad Santoso',
        role: 'Dosen',
        isDeputyHead: false,
        status: true,
      ),
      DepartmentMember(
        id: 2,
        userId: 2,
        name: 'Budi Setiawan',
        role: 'Mahasiswa',
        isDeputyHead: false,
        status: true,
      ),
      DepartmentMember(
        id: 3,
        userId: 3,
        name: 'Cici Lestari',
        role: 'Dosen',
        isDeputyHead: true,
        status: true,
      ),
    ];
  }

  List<DepartmentClass> _getMockClasses(int departmentId) {
    return [
      DepartmentClass(
        id: 1,
        name: 'TI-1A',
        level: '2023',
        studentCount: 30,
        advisorName: 'Dr. Ahmad',
      ),
      DepartmentClass(
        id: 2,
        name: 'TI-1B',
        level: '2023',
        studentCount: 28,
        advisorName: 'Prof. Budi',
      ),
    ];
  }
}
