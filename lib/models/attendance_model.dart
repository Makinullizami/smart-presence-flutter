class Attendance {
  final int id;
  final int userId;
  final String date;
  final String time;
  final String status; // 'present', 'absent', 'late'

  Attendance({
    required this.id,
    required this.userId,
    required this.date,
    required this.time,
    required this.status,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      userId: json['user_id'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'time': time,
      'status': status,
    };
  }
}
