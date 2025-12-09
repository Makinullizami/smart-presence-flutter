class Announcement {
  final int id;
  final String title;
  final String content;
  final String category;
  final String targetType;
  final int? targetId;
  final String? priority;
  final String? attachmentPath;
  final int createdBy;
  final User? creator;
  final DateTime createdAt;
  final DateTime updatedAt;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.targetType,
    this.targetId,
    this.priority,
    this.attachmentPath,
    required this.createdBy,
    this.creator,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      targetType: json['target_type'],
      targetId: json['target_id'],
      priority: json['priority'],
      attachmentPath: json['attachment_path'],
      createdBy: json['created_by'],
      creator: json['creator'] != null ? User.fromJson(json['creator']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'target_type': targetType,
      'target_id': targetId,
      'priority': priority,
      'attachment_path': attachmentPath,
      'created_by': createdBy,
      'creator': creator?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String getCategoryLabel() {
    switch (category) {
      case 'academic':
        return 'Akademik';
      case 'general':
        return 'Umum';
      case 'urgent':
        return 'Penting';
      case 'administrative':
        return 'Administratif';
      default:
        return category;
    }
  }

  String getPriorityLabel() {
    switch (priority) {
      case 'low':
        return 'Rendah';
      case 'normal':
        return 'Normal';
      case 'high':
        return 'Tinggi';
      case 'urgent':
        return 'Urgent';
      default:
        return 'Normal';
    }
  }

  bool isUrgent() {
    return priority == 'urgent' || category == 'urgent';
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }
}
