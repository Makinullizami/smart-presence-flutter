class ClassGroup {
  final int id;
  final String code;
  final String name;
  final int? departmentId;
  final String? departmentName;
  final int level;
  final String academicYear;
  final int? headTeacherId;
  final String? headTeacherName;
  final int? capacity;
  final int membersCount;
  final bool status;
  final String? notes;

  ClassGroup({
    required this.id,
    required this.code,
    required this.name,
    this.departmentId,
    this.departmentName,
    required this.level,
    required this.academicYear,
    this.headTeacherId,
    this.headTeacherName,
    this.capacity,
    required this.membersCount,
    required this.status,
    this.notes,
  });

  factory ClassGroup.fromJson(Map<String, dynamic> json) {
    return ClassGroup(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      departmentId: json['department_id'],
      departmentName: json['department_name'],
      level: json['level'] ?? 1,
      academicYear: json['academic_year'] ?? '',
      headTeacherId: json['head_teacher_id'],
      headTeacherName: json['head_teacher_name'],
      capacity: json['capacity'],
      membersCount: json['members_count'] ?? 0,
      status: json['status'] == 1 || json['status'] == true,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'department_id': departmentId,
      'department_name': departmentName,
      'level': level,
      'academic_year': academicYear,
      'head_teacher_id': headTeacherId,
      'head_teacher_name': headTeacherName,
      'capacity': capacity,
      'members_count': membersCount,
      'status': status,
      'notes': notes,
    };
  }

  ClassGroup copyWith({
    int? id,
    String? code,
    String? name,
    int? departmentId,
    String? departmentName,
    int? level,
    String? academicYear,
    int? headTeacherId,
    String? headTeacherName,
    int? capacity,
    int? membersCount,
    bool? status,
    String? notes,
  }) {
    return ClassGroup(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      departmentId: departmentId ?? this.departmentId,
      departmentName: departmentName ?? this.departmentName,
      level: level ?? this.level,
      academicYear: academicYear ?? this.academicYear,
      headTeacherId: headTeacherId ?? this.headTeacherId,
      headTeacherName: headTeacherName ?? this.headTeacherName,
      capacity: capacity ?? this.capacity,
      membersCount: membersCount ?? this.membersCount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

class ClassMember {
  final int id;
  final int userId;
  final String name;
  final String studentCode;
  final bool status;
  final bool isClassLeader;

  ClassMember({
    required this.id,
    required this.userId,
    required this.name,
    required this.studentCode,
    required this.status,
    required this.isClassLeader,
  });

  factory ClassMember.fromJson(Map<String, dynamic> json) {
    return ClassMember(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      studentCode: json['student_code'] ?? '',
      status: json['status'] == 1 || json['status'] == true,
      isClassLeader: json['is_class_leader'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'student_code': studentCode,
      'status': status,
      'is_class_leader': isClassLeader,
    };
  }
}

class ClassSchedule {
  final int id;
  final String day;
  final String startTime;
  final String endTime;
  final String subjectName;
  final String? teacherName;
  final String? room;

  ClassSchedule({
    required this.id,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.subjectName,
    this.teacherName,
    this.room,
  });

  factory ClassSchedule.fromJson(Map<String, dynamic> json) {
    return ClassSchedule(
      id: json['id'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      subjectName: json['subject_name'],
      teacherName: json['teacher_name'],
      room: json['room'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'subject_name': subjectName,
      'teacher_name': teacherName,
      'room': room,
    };
  }
}

class ClassAttendanceSetting {
  final int classId;
  final bool useDepartmentDefault;
  final String? defaultStartTime;
  final String? defaultEndTime;
  final int lateToleranceMinutes;
  final bool requireFaceRecognition;
  final bool requireLocation;
  final double minAttendancePercent;

  ClassAttendanceSetting({
    required this.classId,
    required this.useDepartmentDefault,
    this.defaultStartTime,
    this.defaultEndTime,
    required this.lateToleranceMinutes,
    required this.requireFaceRecognition,
    required this.requireLocation,
    required this.minAttendancePercent,
  });

  factory ClassAttendanceSetting.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceSetting(
      classId: json['class_id'],
      useDepartmentDefault: json['use_department_default'] ?? true,
      defaultStartTime: json['default_start_time'],
      defaultEndTime: json['default_end_time'],
      lateToleranceMinutes: json['late_tolerance_minutes'] ?? 0,
      requireFaceRecognition: json['require_face_recognition'] ?? false,
      requireLocation: json['require_location'] ?? false,
      minAttendancePercent: (json['min_attendance_percent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'use_department_default': useDepartmentDefault,
      'default_start_time': defaultStartTime,
      'default_end_time': defaultEndTime,
      'late_tolerance_minutes': lateToleranceMinutes,
      'require_face_recognition': requireFaceRecognition,
      'require_location': requireLocation,
      'min_attendance_percent': minAttendancePercent,
    };
  }
}
