class Timetable {
  final int id;
  final String subject;
  final String startTime;
  final String endTime;
  final String room;
  final String lecturer;

  Timetable({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.lecturer,
  });

  factory Timetable.fromJson(Map<String, dynamic> json) {
    return Timetable(
      id: json['id'],
      subject: json['subject'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      room: json['room'],
      lecturer: json['lecturer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'lecturer': lecturer,
    };
  }
}
