import '../models/class_model.dart';

class ClassRepository {
  // Get classes with filters
  Future<List<ClassGroup>> getClasses({
    String? search,
    int? departmentId,
    int? level,
    String? academicYear,
    bool? status,
    int page = 1,
    int perPage = 10,
  }) async {
    // Mock data for demo
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    var classes = _getMockClasses();

    // Apply filters
    if (search != null && search.isNotEmpty) {
      classes = classes
          .where(
            (c) =>
                c.name.toLowerCase().contains(search.toLowerCase()) ||
                c.code.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
    }

    if (departmentId != null) {
      classes = classes.where((c) => c.departmentId == departmentId).toList();
    }

    if (level != null) {
      classes = classes.where((c) => c.level == level).toList();
    }

    if (academicYear != null && academicYear.isNotEmpty) {
      classes = classes.where((c) => c.academicYear == academicYear).toList();
    }

    if (status != null) {
      classes = classes.where((c) => c.status == status).toList();
    }

    // Pagination
    final start = (page - 1) * perPage;
    final end = start + perPage;
    return classes.sublist(start, end.clamp(0, classes.length));
  }

  // Create class
  Future<ClassGroup> createClass(ClassGroup classGroup) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return classGroup.copyWith(id: DateTime.now().millisecondsSinceEpoch);
  }

  // Update class
  Future<ClassGroup> updateClass(ClassGroup classGroup) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return classGroup;
  }

  // Delete class
  Future<void> deleteClass(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Bulk update status
  Future<void> bulkUpdateStatus(List<int> ids, bool status) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get class detail
  Future<ClassGroup> getClassDetail(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockClasses().firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Class not found'),
    );
  }

  // Get class members
  Future<List<ClassMember>> getClassMembers(int classId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockClassMembers(classId);
  }

  // Add members to class
  Future<void> addMembersToClass(int classId, List<int> userIds) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Remove member from class
  Future<void> removeMemberFromClass(int classId, int memberId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get class schedules
  Future<List<ClassSchedule>> getClassSchedules(int classId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _getMockClassSchedules(classId);
  }

  // Add schedule to class
  Future<void> addScheduleToClass(int classId, ClassSchedule schedule) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Update schedule
  Future<void> updateSchedule(ClassSchedule schedule) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Delete schedule
  Future<void> deleteSchedule(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Get class attendance setting
  Future<ClassAttendanceSetting> getClassAttendanceSetting(int classId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return ClassAttendanceSetting(
      classId: classId,
      useDepartmentDefault: true,
      defaultStartTime: '08:00',
      defaultEndTime: '17:00',
      lateToleranceMinutes: 15,
      requireFaceRecognition: true,
      requireLocation: true,
      minAttendancePercent: 75,
    );
  }

  // Update class attendance setting
  Future<void> updateClassAttendanceSetting(
    ClassAttendanceSetting setting,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // Mock data methods
  List<ClassGroup> _getMockClasses() {
    return [
      ClassGroup(
        id: 1,
        code: 'TI-1A',
        name: 'Teknik Informatika 1A',
        departmentId: 1,
        departmentName: 'Teknik Informatika',
        level: 1,
        academicYear: '2024/2025',
        headTeacherId: 1,
        headTeacherName: 'Dr. Ahmad',
        capacity: 30,
        membersCount: 28,
        status: true,
        notes: 'Kelas reguler',
      ),
      ClassGroup(
        id: 2,
        code: 'TI-1B',
        name: 'Teknik Informatika 1B',
        departmentId: 1,
        departmentName: 'Teknik Informatika',
        level: 1,
        academicYear: '2024/2025',
        headTeacherId: 2,
        headTeacherName: 'Prof. Budi',
        capacity: 30,
        membersCount: 25,
        status: true,
      ),
      ClassGroup(
        id: 3,
        code: 'SI-1A',
        name: 'Sistem Informasi 1A',
        departmentId: 2,
        departmentName: 'Sistem Informasi',
        level: 1,
        academicYear: '2024/2025',
        headTeacherId: 3,
        headTeacherName: 'Dr. Cici',
        capacity: 25,
        membersCount: 22,
        status: false,
        notes: 'Kelas nonaktif sementara',
      ),
    ];
  }

  List<ClassMember> _getMockClassMembers(int classId) {
    return [
      ClassMember(
        id: 1,
        userId: 1,
        name: 'Ahmad Santoso',
        studentCode: '12345678',
        status: true,
        isClassLeader: true,
      ),
      ClassMember(
        id: 2,
        userId: 2,
        name: 'Budi Setiawan',
        studentCode: '12345679',
        status: true,
        isClassLeader: false,
      ),
      ClassMember(
        id: 3,
        userId: 3,
        name: 'Cici Lestari',
        studentCode: '12345680',
        status: true,
        isClassLeader: false,
      ),
    ];
  }

  List<ClassSchedule> _getMockClassSchedules(int classId) {
    return [
      ClassSchedule(
        id: 1,
        day: 'Senin',
        startTime: '08:00',
        endTime: '10:00',
        subjectName: 'Pemrograman Dasar',
        teacherName: 'Dr. Ahmad',
        room: 'Lab Komputer 1',
      ),
      ClassSchedule(
        id: 2,
        day: 'Rabu',
        startTime: '10:00',
        endTime: '12:00',
        subjectName: 'Basis Data',
        teacherName: 'Prof. Budi',
        room: 'Ruang 201',
      ),
    ];
  }
}
