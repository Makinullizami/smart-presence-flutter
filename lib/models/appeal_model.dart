class Appeal {
  final int id;
  final int attendanceId;
  final int userId;
  final String reason;
  final String status; // 'pending', 'approved', 'rejected'
  final String createdAt;
  final String? evidencePath;

  Appeal({
    required this.id,
    required this.attendanceId,
    required this.userId,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.evidencePath,
  });

  factory Appeal.fromJson(Map<String, dynamic> json) {
    return Appeal(
      id: json['id'],
      attendanceId: json['attendance_id'],
      userId: json['user_id'],
      reason: json['reason'],
      status: json['status'],
      createdAt: json['created_at'],
      evidencePath: json['evidence_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attendance_id': attendanceId,
      'user_id': userId,
      'reason': reason,
      'status': status,
      'created_at': createdAt,
      'evidence_path': evidencePath,
    };
  }
}
