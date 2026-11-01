import 'attendance_status.dart';

class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.groupId,
    required this.date,
    required this.status,
  });

  final String id;
  final String studentId;
  final String groupId;
  final DateTime date;
  final AttendanceStatus status;
}
