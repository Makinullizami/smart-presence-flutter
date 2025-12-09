import 'user_model.dart';

class Attendance {
  final int id;
  final int userId;
  final DateTime date;
  final String? checkInTime;
  final String? checkOutTime;
  final String status;
  final String? notes;
  final Map<String, dynamic>? location;
  final String? validationMethod;
  final bool isOfflineSync;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;

  Attendance({
    required this.id,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    this.notes,
    this.location,
    this.validationMethod,
    required this.isOfflineSync,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      status: json['status'],
      notes: json['notes'],
      location: json['location'],
      validationMethod: json['validation_method'],
      isOfflineSync: json['is_offline_sync'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T')[0],
      'check_in_time': checkInTime,
      'check_out_time': checkOutTime,
      'status': status,
      'notes': notes,
      'location': location,
      'validation_method': validationMethod,
      'is_offline_sync': isOfflineSync,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }

  bool get isPresent => status == 'present';
  bool get isLate => status == 'late';
  bool get isAbsent => status == 'absent';
  bool get isEarlyLeave => status == 'early_leave';

  String get statusText {
    switch (status) {
      case 'present':
        return 'Hadir';
      case 'late':
        return 'Terlambat';
      case 'absent':
        return 'Tidak Hadir';
      case 'early_leave':
        return 'Pulang Cepat';
      default:
        return status;
    }
  }

  String get statusColor {
    switch (status) {
      case 'present':
        return 'green';
      case 'late':
        return 'orange';
      case 'absent':
      case 'early_leave':
        return 'red';
      default:
        return 'grey';
    }
  }
}
