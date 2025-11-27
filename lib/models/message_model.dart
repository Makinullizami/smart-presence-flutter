class Message {
  final int id;
  final String title;
  final String content;
  final String sender;
  final String createdAt;
  final bool isRead;

  Message({
    required this.id,
    required this.title,
    required this.content,
    required this.sender,
    required this.createdAt,
    required this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      sender: json['sender'],
      createdAt: json['created_at'],
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'sender': sender,
      'created_at': createdAt,
      'is_read': isRead,
    };
  }
}
