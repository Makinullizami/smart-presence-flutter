class Department {
  final int id;
  final String code;
  final String name;
  final String? shortName;
  final String? unitName;
  final int? unitId;
  final int? headId;
  final String? headName;
  final String? location;
  final bool status;
  final int membersCount;
  final int classesCount;
  final String? notes;

  Department({
    required this.id,
    required this.code,
    required this.name,
    this.shortName,
    this.unitName,
    this.unitId,
    this.headId,
    this.headName,
    this.location,
    required this.status,
    required this.membersCount,
    required this.classesCount,
    this.notes,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      shortName: json['short_name'],
      unitName: json['unit_name'],
      unitId: json['unit_id'],
      headId: json['head_id'],
      headName: json['head_name'],
      location: json['location'],
      status: json['status'] == 1 || json['status'] == true,
      membersCount: json['members_count'] ?? 0,
      classesCount: json['classes_count'] ?? 0,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'short_name': shortName,
      'unit_name': unitName,
      'unit_id': unitId,
      'head_id': headId,
      'head_name': headName,
      'location': location,
      'status': status,
      'members_count': membersCount,
      'classes_count': classesCount,
      'notes': notes,
    };
  }

  Department copyWith({
    int? id,
    String? code,
    String? name,
    String? shortName,
    String? unitName,
    int? unitId,
    int? headId,
    String? headName,
    String? location,
    bool? status,
    int? membersCount,
    int? classesCount,
    String? notes,
  }) {
    return Department(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      unitName: unitName ?? this.unitName,
      unitId: unitId ?? this.unitId,
      headId: headId ?? this.headId,
      headName: headName ?? this.headName,
      location: location ?? this.location,
      status: status ?? this.status,
      membersCount: membersCount ?? this.membersCount,
      classesCount: classesCount ?? this.classesCount,
      notes: notes ?? this.notes,
    );
  }
}

class DepartmentMember {
  final int id;
  final int userId;
  final String name;
  final String role;
  final bool isDeputyHead;
  final bool status;

  DepartmentMember({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.isDeputyHead,
    required this.status,
  });

  factory DepartmentMember.fromJson(Map<String, dynamic> json) {
    return DepartmentMember(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      role: json['role'],
      isDeputyHead: json['is_deputy_head'] ?? false,
      status: json['status'] == 1 || json['status'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'role': role,
      'is_deputy_head': isDeputyHead,
      'status': status,
    };
  }
}

class DepartmentClass {
  final int id;
  final String name;
  final String level;
  final int studentCount;
  final String? advisorName;

  DepartmentClass({
    required this.id,
    required this.name,
    required this.level,
    required this.studentCount,
    this.advisorName,
  });

  factory DepartmentClass.fromJson(Map<String, dynamic> json) {
    return DepartmentClass(
      id: json['id'],
      name: json['name'],
      level: json['level'],
      studentCount: json['student_count'] ?? 0,
      advisorName: json['advisor_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'student_count': studentCount,
      'advisor_name': advisorName,
    };
  }
}

class DepartmentAttendanceSetting {
  final int departmentId;
  final String? defaultStartTime;
  final String? defaultEndTime;
  final int lateToleranceMinutes;
  final bool requireFaceRecognition;
  final bool requireLocation;
  final double geofenceRadiusMeters;
  final double minimumAttendancePercent;

  DepartmentAttendanceSetting({
    required this.departmentId,
    this.defaultStartTime,
    this.defaultEndTime,
    required this.lateToleranceMinutes,
    required this.requireFaceRecognition,
    required this.requireLocation,
    required this.geofenceRadiusMeters,
    required this.minimumAttendancePercent,
  });

  factory DepartmentAttendanceSetting.fromJson(Map<String, dynamic> json) {
    return DepartmentAttendanceSetting(
      departmentId: json['department_id'],
      defaultStartTime: json['default_start_time'],
      defaultEndTime: json['default_end_time'],
      lateToleranceMinutes: json['late_tolerance_minutes'] ?? 0,
      requireFaceRecognition: json['require_face_recognition'] ?? false,
      requireLocation: json['require_location'] ?? false,
      geofenceRadiusMeters: (json['geofence_radius_meters'] ?? 0).toDouble(),
      minimumAttendancePercent: (json['minimum_attendance_percent'] ?? 0)
          .toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department_id': departmentId,
      'default_start_time': defaultStartTime,
      'default_end_time': defaultEndTime,
      'late_tolerance_minutes': lateToleranceMinutes,
      'require_face_recognition': requireFaceRecognition,
      'require_location': requireLocation,
      'geofence_radius_meters': geofenceRadiusMeters,
      'minimum_attendance_percent': minimumAttendancePercent,
    };
  }
}
