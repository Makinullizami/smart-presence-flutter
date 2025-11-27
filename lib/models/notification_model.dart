class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String createdAt;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      createdAt: json['created_at'],
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'created_at': createdAt,
      'is_read': isRead,
    };
  }
}
