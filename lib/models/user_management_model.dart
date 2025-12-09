// User Management Models

class UserListResponse {
  final List<UserModel> users;
  final PaginationInfo pagination;

  UserListResponse({required this.users, required this.pagination});

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    return UserListResponse(
      users: (json['users'] as List)
          .map((user) => UserModel.fromJson(user))
          .toList(),
      pagination: PaginationInfo.fromJson(json['pagination']),
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationInfo({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String nipNim;
  final String? phone;
  final String role;
  final bool isActive;
  final DepartmentModel? department;
  final ClassModel? classModel;
  final String? profilePhotoUrl;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.nipNim,
    required this.role,
    required this.isActive,
    this.phone,
    this.department,
    this.classModel,
    this.profilePhotoUrl,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      nipNim: json['nip_nim'],
      phone: json['phone'],
      role: json['role'],
      isActive: json['is_active'] ?? true,
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'])
          : null,
      classModel: json['class'] != null
          ? ClassModel.fromJson(json['class'])
          : null,
      profilePhotoUrl: json['profile_photo_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nip_nim': nipNim,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'department': department?.toJson(),
      'class': classModel?.toJson(),
      'profile_photo_url': profilePhotoUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

class DepartmentModel {
  final int id;
  final String name;

  DepartmentModel({required this.id, required this.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class ClassModel {
  final int id;
  final String name;

  ClassModel({required this.id, required this.name});

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class RoleOption {
  final String value;
  final String label;

  RoleOption({required this.value, required this.label});

  factory RoleOption.fromJson(Map<String, dynamic> json) {
    return RoleOption(value: json['value'], label: json['label']);
  }
}

class UserFormData {
  String name;
  String email;
  String nipNim;
  String? phone;
  String role;
  int? departmentId;
  int? classId;
  String? password;

  UserFormData({
    this.name = '',
    this.email = '',
    this.nipNim = '',
    this.phone,
    this.role = 'student',
    this.departmentId,
    this.classId,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'nip_nim': nipNim,
      'phone': phone,
      'role': role,
      'department_id': departmentId,
      'class_id': classId,
      if (password != null && password!.isNotEmpty) 'password': password,
    };
  }

  void fromUser(UserModel user) {
    name = user.name;
    email = user.email;
    nipNim = user.nipNim;
    phone = user.phone;
    role = user.role;
    departmentId = user.department?.id;
    classId = user.classModel?.id;
  }
}
