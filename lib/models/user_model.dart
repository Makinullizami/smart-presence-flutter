class User {
  final int id;
  final String name;
  final String email;
  final String? nim;
  final String? employeeId;
  final int? classId;
  final int? departmentId;
  final String role;
  final String? phone;
  final String? address;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profilePhotoPath;
  final String? bio;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final Map<String, dynamic>? notificationPreferences;
  final String? languagePreference;
  final String? themePreference;
  final String? fcmToken;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.nim,
    this.employeeId,
    this.classId,
    this.departmentId,
    required this.role,
    this.phone,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.profilePhotoPath,
    this.bio,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.notificationPreferences,
    this.languagePreference,
    this.themePreference,
    this.fcmToken,
    required this.isActive,
    this.lastLoginAt,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      nim: json['nim'],
      employeeId: json['employee_id'],
      classId: json['class_id'],
      departmentId: json['department_id'],
      role: json['role'],
      phone: json['phone'],
      address: json['address'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      gender: json['gender'],
      profilePhotoPath: json['profile_photo_path'],
      bio: json['bio'],
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactPhone: json['emergency_contact_phone'],
      notificationPreferences: json['notification_preferences'],
      languagePreference: json['language_preference'],
      themePreference: json['theme_preference'],
      fcmToken: json['fcm_token'],
      isActive: json['is_active'] ?? true,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nim': nim,
      'employee_id': employeeId,
      'class_id': classId,
      'department_id': departmentId,
      'role': role,
      'phone': phone,
      'address': address,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'profile_photo_path': profilePhotoPath,
      'bio': bio,
      'emergency_contact_name': emergencyContactName,
      'emergency_contact_phone': emergencyContactPhone,
      'notification_preferences': notificationPreferences,
      'language_preference': languagePreference,
      'theme_preference': themePreference,
      'fcm_token': fcmToken,
      'is_active': isActive,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isStudent => role == 'user';
  bool get isSupervisor => role == 'supervisor';
  bool get isAdmin => role == 'admin';
}
