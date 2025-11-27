class Assignment {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final String status; // 'pending', 'submitted', 'graded'
  final String? attachmentUrl;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.attachmentUrl,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: json['due_date'],
      status: json['status'],
      attachmentUrl: json['attachment_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'status': status,
      'attachment_url': attachmentUrl,
    };
  }
}
