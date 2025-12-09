import 'user_model.dart';

class ClassDashboard {
  final int classId;
  final String className;
  final int totalStudents;
  final int presentCount;
  final int lateCount;
  final int absentCount;
  final double attendancePercentage;
  final List<StudentAttendance> attendanceDetails;

  ClassDashboard({
    required this.classId,
    required this.className,
    required this.totalStudents,
    required this.presentCount,
    required this.lateCount,
    required this.absentCount,
    required this.attendancePercentage,
    required this.attendanceDetails,
  });

  factory ClassDashboard.fromJson(Map<String, dynamic> json) {
    return ClassDashboard(
      classId: json['class_id'],
      className: json['class_name'],
      totalStudents: json['total_students'],
      presentCount: json['present_count'],
      lateCount: json['late_count'],
      absentCount: json['absent_count'],
      attendancePercentage: json['attendance_percentage'].toDouble(),
      attendanceDetails: (json['attendance_details'] as List)
          .map((item) => StudentAttendance.fromJson(item))
          .toList(),
    );
  }
}

class StudentAttendance {
  final int userId;
  final String name;
  final String status;
  final String? checkInTime;
  final String? notes;

  StudentAttendance({
    required this.userId,
    required this.name,
    required this.status,
    this.checkInTime,
    this.notes,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      userId: json['user_id'],
      name: json['name'],
      status: json['status'],
      checkInTime: json['check_in_time'],
      notes: json['notes'],
    );
  }
}

class SupervisorDashboard {
  final String date;
  final List<ClassDashboard> classes;

  SupervisorDashboard({required this.date, required this.classes});

  factory SupervisorDashboard.fromJson(Map<String, dynamic> json) {
    return SupervisorDashboard(
      date: json['date'],
      classes: (json['classes'] as List)
          .map((item) => ClassDashboard.fromJson(item))
          .toList(),
    );
  }
}

class AdminDashboard {
  final AdminKPI kpi;
  final AdminCharts charts;
  final AdminTables tables;
  final AdminFilters filters;

  AdminDashboard({
    required this.kpi,
    required this.charts,
    required this.tables,
    required this.filters,
  });

  factory AdminDashboard.fromJson(Map<String, dynamic> json) {
    return AdminDashboard(
      kpi: AdminKPI.fromJson(json['kpi']),
      charts: AdminCharts.fromJson(json['charts']),
      tables: AdminTables.fromJson(json['tables']),
      filters: AdminFilters.fromJson(json['filters']),
    );
  }
}

class AdminKPI {
  final int totalActiveUsers;
  final int presentToday;
  final int lateToday;
  final int absentToday;
  final int leaveToday;

  AdminKPI({
    required this.totalActiveUsers,
    required this.presentToday,
    required this.lateToday,
    required this.absentToday,
    required this.leaveToday,
  });

  factory AdminKPI.fromJson(Map<String, dynamic> json) {
    return AdminKPI(
      totalActiveUsers: json['total_active_users'],
      presentToday: json['present_today'],
      lateToday: json['late_today'],
      absentToday: json['absent_today'],
      leaveToday: json['leave_today'],
    );
  }
}

class AdminCharts {
  final List<WeeklyAttendance> weeklyAttendance;
  final AttendanceDistribution distribution;

  AdminCharts({required this.weeklyAttendance, required this.distribution});

  factory AdminCharts.fromJson(Map<String, dynamic> json) {
    return AdminCharts(
      weeklyAttendance: (json['weekly_attendance'] as List)
          .map((item) => WeeklyAttendance.fromJson(item))
          .toList(),
      distribution: AttendanceDistribution.fromJson(json['distribution']),
    );
  }
}

class WeeklyAttendance {
  final String date;
  final int present;

  WeeklyAttendance({required this.date, required this.present});

  factory WeeklyAttendance.fromJson(Map<String, dynamic> json) {
    return WeeklyAttendance(date: json['date'], present: json['present']);
  }
}

class AttendanceDistribution {
  final int present;
  final int late;
  final int absent;
  final int leave;

  AttendanceDistribution({
    required this.present,
    required this.late,
    required this.absent,
    required this.leave,
  });

  factory AttendanceDistribution.fromJson(Map<String, dynamic> json) {
    return AttendanceDistribution(
      present: json['present'],
      late: json['late'],
      absent: json['absent'],
      leave: json['leave'],
    );
  }
}

class AdminTables {
  final List<LateUser> topLateUsers;
  final List<PendingAppeal> pendingAppeals;
  final List<LowAttendanceClass> lowestAttendanceClasses;

  AdminTables({
    required this.topLateUsers,
    required this.pendingAppeals,
    required this.lowestAttendanceClasses,
  });

  factory AdminTables.fromJson(Map<String, dynamic> json) {
    return AdminTables(
      topLateUsers: (json['top_late_users'] as List)
          .map((item) => LateUser.fromJson(item))
          .toList(),
      pendingAppeals: (json['pending_appeals'] as List)
          .map((item) => PendingAppeal.fromJson(item))
          .toList(),
      lowestAttendanceClasses: (json['lowest_attendance_classes'] as List)
          .map((item) => LowAttendanceClass.fromJson(item))
          .toList(),
    );
  }
}

class LateUser {
  final int userId;
  final String name;
  final int lateCount;

  LateUser({required this.userId, required this.name, required this.lateCount});

  factory LateUser.fromJson(Map<String, dynamic> json) {
    return LateUser(
      userId: json['user_id'],
      name: json['name'],
      lateCount: json['late_count'],
    );
  }
}

class PendingAppeal {
  final int id;
  final String userName;
  final String type;
  final String reason;
  final String createdAt;

  PendingAppeal({
    required this.id,
    required this.userName,
    required this.type,
    required this.reason,
    required this.createdAt,
  });

  factory PendingAppeal.fromJson(Map<String, dynamic> json) {
    return PendingAppeal(
      id: json['id'],
      userName: json['user_name'],
      type: json['type'],
      reason: json['reason'],
      createdAt: json['created_at'],
    );
  }
}

class LowAttendanceClass {
  final int classId;
  final String className;
  final double attendancePercentage;

  LowAttendanceClass({
    required this.classId,
    required this.className,
    required this.attendancePercentage,
  });

  factory LowAttendanceClass.fromJson(Map<String, dynamic> json) {
    return LowAttendanceClass(
      classId: json['class_id'],
      className: json['class_name'],
      attendancePercentage: json['attendance_percentage'].toDouble(),
    );
  }
}

class AdminFilters {
  final String date;
  final String filter;
  final String? unit;

  AdminFilters({required this.date, required this.filter, this.unit});

  factory AdminFilters.fromJson(Map<String, dynamic> json) {
    return AdminFilters(
      date: json['date'],
      filter: json['filter'],
      unit: json['unit'],
    );
  }
}
