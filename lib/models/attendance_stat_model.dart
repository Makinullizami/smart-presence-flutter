class AttendanceStat {
  final int totalPresent;
  final int totalAbsent;
  final int totalLate;
  final double attendancePercentage;
  final int currentStreak;

  AttendanceStat({
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLate,
    required this.attendancePercentage,
    required this.currentStreak,
  });

  factory AttendanceStat.fromJson(Map<String, dynamic> json) {
    return AttendanceStat(
      totalPresent: json['total_present'] ?? 0,
      totalAbsent: json['total_absent'] ?? 0,
      totalLate: json['total_late'] ?? 0,
      attendancePercentage: (json['attendance_percentage'] ?? 0.0).toDouble(),
      currentStreak: json['current_streak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_present': totalPresent,
      'total_absent': totalAbsent,
      'total_late': totalLate,
      'attendance_percentage': attendancePercentage,
      'current_streak': currentStreak,
    };
  }
}
