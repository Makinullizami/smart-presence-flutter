enum ReportType {
  dailySummary,
  monthlySummary,
  perUser,
  perClass,
  perDepartment,
  leaveSummary,
}

class AttendanceReportSummary {
  final int totalDays;
  final int totalPresent;
  final int totalLate;
  final int totalPermission;
  final int totalSick;
  final int totalAbsent;
  final int totalOvertime;
  final double averageAttendancePercent;

  AttendanceReportSummary({
    required this.totalDays,
    required this.totalPresent,
    required this.totalLate,
    required this.totalPermission,
    required this.totalSick,
    required this.totalAbsent,
    required this.totalOvertime,
    required this.averageAttendancePercent,
  });

  factory AttendanceReportSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceReportSummary(
      totalDays: json['total_days'] ?? 0,
      totalPresent: json['total_present'] ?? 0,
      totalLate: json['total_late'] ?? 0,
      totalPermission: json['total_permission'] ?? 0,
      totalSick: json['total_sick'] ?? 0,
      totalAbsent: json['total_absent'] ?? 0,
      totalOvertime: json['total_overtime'] ?? 0,
      averageAttendancePercent: (json['average_attendance_percent'] ?? 0)
          .toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_days': totalDays,
      'total_present': totalPresent,
      'total_late': totalLate,
      'total_permission': totalPermission,
      'total_sick': totalSick,
      'total_absent': totalAbsent,
      'total_overtime': totalOvertime,
      'average_attendance_percent': averageAttendancePercent,
    };
  }
}

class AttendanceRecordRow {
  final String date;
  final int userId;
  final String userName;
  final String userCode;
  final String departmentName;
  final String className;
  final String? checkInTime;
  final String? checkOutTime;
  final String status;
  final String? note;

  AttendanceRecordRow({
    required this.date,
    required this.userId,
    required this.userName,
    required this.userCode,
    required this.departmentName,
    required this.className,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.note,
  });

  factory AttendanceRecordRow.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordRow(
      date: json['date'],
      userId: json['user_id'],
      userName: json['user_name'],
      userCode: json['user_code'],
      departmentName: json['department_name'],
      className: json['class_name'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      status: json['status'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'user_id': userId,
      'user_name': userName,
      'user_code': userCode,
      'department_name': departmentName,
      'class_name': className,
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'status': status,
      'note': note,
    };
  }
}

class ClassReportRow {
  final String date;
  final int classId;
  final String className;
  final String departmentName;
  final int membersCount;
  final int presentCount;
  final int lateCount;
  final int permissionCount;
  final int sickCount;
  final int absentCount;
  final double attendancePercent;

  ClassReportRow({
    required this.date,
    required this.classId,
    required this.className,
    required this.departmentName,
    required this.membersCount,
    required this.presentCount,
    required this.lateCount,
    required this.permissionCount,
    required this.sickCount,
    required this.absentCount,
    required this.attendancePercent,
  });

  factory ClassReportRow.fromJson(Map<String, dynamic> json) {
    return ClassReportRow(
      date: json['date'],
      classId: json['class_id'],
      className: json['class_name'],
      departmentName: json['department_name'],
      membersCount: json['members_count'] ?? 0,
      presentCount: json['present_count'] ?? 0,
      lateCount: json['late_count'] ?? 0,
      permissionCount: json['permission_count'] ?? 0,
      sickCount: json['sick_count'] ?? 0,
      absentCount: json['absent_count'] ?? 0,
      attendancePercent: (json['attendance_percent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'class_id': classId,
      'class_name': className,
      'department_name': departmentName,
      'members_count': membersCount,
      'present_count': presentCount,
      'late_count': lateCount,
      'permission_count': permissionCount,
      'sick_count': sickCount,
      'absent_count': absentCount,
      'attendance_percent': attendancePercent,
    };
  }
}

class DepartmentReportRow {
  final String dateOrMonth;
  final int departmentId;
  final String departmentName;
  final int membersCount;
  final int presentCount;
  final int lateCount;
  final int permissionCount;
  final int sickCount;
  final int absentCount;
  final double attendancePercent;

  DepartmentReportRow({
    required this.dateOrMonth,
    required this.departmentId,
    required this.departmentName,
    required this.membersCount,
    required this.presentCount,
    required this.lateCount,
    required this.permissionCount,
    required this.sickCount,
    required this.absentCount,
    required this.attendancePercent,
  });

  factory DepartmentReportRow.fromJson(Map<String, dynamic> json) {
    return DepartmentReportRow(
      dateOrMonth: json['date_or_month'],
      departmentId: json['department_id'],
      departmentName: json['department_name'],
      membersCount: json['members_count'] ?? 0,
      presentCount: json['present_count'] ?? 0,
      lateCount: json['late_count'] ?? 0,
      permissionCount: json['permission_count'] ?? 0,
      sickCount: json['sick_count'] ?? 0,
      absentCount: json['absent_count'] ?? 0,
      attendancePercent: (json['attendance_percent'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_or_month': dateOrMonth,
      'department_id': departmentId,
      'department_name': departmentName,
      'members_count': membersCount,
      'present_count': presentCount,
      'late_count': lateCount,
      'permission_count': permissionCount,
      'sick_count': sickCount,
      'absent_count': absentCount,
      'attendance_percent': attendancePercent,
    };
  }
}

class LeaveReportRow {
  final String date;
  final int userId;
  final String userName;
  final String userCode;
  final String type;
  final String reason;
  final String status;
  final String? approvedByName;

  LeaveReportRow({
    required this.date,
    required this.userId,
    required this.userName,
    required this.userCode,
    required this.type,
    required this.reason,
    required this.status,
    this.approvedByName,
  });

  factory LeaveReportRow.fromJson(Map<String, dynamic> json) {
    return LeaveReportRow(
      date: json['date'],
      userId: json['user_id'],
      userName: json['user_name'],
      userCode: json['user_code'],
      type: json['type'],
      reason: json['reason'],
      status: json['status'],
      approvedByName: json['approved_by_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'user_id': userId,
      'user_name': userName,
      'user_code': userCode,
      'type': type,
      'reason': reason,
      'status': status,
      'approved_by_name': approvedByName,
    };
  }
}

class ReportFilter {
  final ReportType reportType;
  final DateTime? dateStart;
  final DateTime? dateEnd;
  final int? month;
  final int? year;
  final int? departmentId;
  final int? classId;
  final int? shiftId;
  final String? userQuery;
  final String? role;
  final List<String> selectedStatuses;

  ReportFilter({
    required this.reportType,
    this.dateStart,
    this.dateEnd,
    this.month,
    this.year,
    this.departmentId,
    this.classId,
    this.shiftId,
    this.userQuery,
    this.role,
    required this.selectedStatuses,
  });

  Map<String, dynamic> toJson() {
    return {
      'report_type': reportType.toString(),
      'date_start': dateStart?.toIso8601String(),
      'date_end': dateEnd?.toIso8601String(),
      'month': month,
      'year': year,
      'department_id': departmentId,
      'class_id': classId,
      'shift_id': shiftId,
      'user_query': userQuery,
      'role': role,
      'selected_statuses': selectedStatuses,
    };
  }
}

class AttendanceReportResult {
  final AttendanceReportSummary summary;
  final List<dynamic> rows; // Can be any of the row types

  AttendanceReportResult({required this.summary, required this.rows});
}
