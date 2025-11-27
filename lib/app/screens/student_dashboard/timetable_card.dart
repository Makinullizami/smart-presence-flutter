import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/student_dashboard_controller.dart';
import '../../models/timetable_model.dart';

class TimetableCard extends StatelessWidget {
  final StudentDashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final timetables = controller.timetableToday;

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.schedule, color: Colors.blue.shade600, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Jadwal Hari Ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              if (timetables.isEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.event_note,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tidak ada kelas hari ini',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: timetables.length,
                  itemBuilder: (context, index) {
                    final timetable = timetables[index];
                    return _buildTimetableItem(timetable);
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTimetableItem(Timetable timetable) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Column(
              children: [
                Text(
                  timetable.startTime,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                Text(
                  '-',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
                ),
                Text(
                  timetable.endTime,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timetable.subject,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Ruang: ${timetable.room}',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
                ),
                Text(
                  'Pengajar: ${timetable.lecturer}',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.blue.shade400),
        ],
      ),
    );
  }
}
