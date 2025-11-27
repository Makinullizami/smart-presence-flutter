class User {
  final int id;
  final String name;
  final String email;
  final String role; // 'admin' or 'student'
  final String? nim;
  final String? className;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.nim,
    this.className,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      nim: json['nim'],
      className: json['class'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'nim': nim,
      'class': className,
    };
  }
}
