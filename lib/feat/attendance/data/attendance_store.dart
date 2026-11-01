import 'package:flutter/foundation.dart';
import '../../../core/database/run_local.dart';
import '../../../core/helper/date_formatter.dart';
import '../../../core/helper/id_generator.dart';
import 'attendance_local_source.dart';
import 'models/attendance_record.dart';
import 'models/attendance_status.dart';
import 'models/attendance_summary.dart';

class AttendanceStore extends ChangeNotifier {
  AttendanceStore._();

  static final AttendanceStore instance = AttendanceStore._();

  final List<AttendanceRecord> _records = [];

  Future<void> load() async {
    final loaded = await AttendanceLocalSource.instance.load();
    _records
      ..clear()
      ..addAll(loaded);
    notifyListeners();
  }

  AttendanceStatus? statusOf(String studentId, DateTime date) {
    for (final record in _records) {
      if (record.studentId == studentId &&
          DateFormatter.sameDay(record.date, date)) {
        return record.status;
      }
    }
    return null;
  }

  List<AttendanceRecord> recordsOf(String studentId, DateTime month) {
    final result = _records
        .where(
          (record) =>
              record.studentId == studentId &&
              DateFormatter.sameMonth(record.date, month),
        )
        .toList();
    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  AttendanceSummary summaryOf(String studentId, DateTime month) {
    var present = 0;
    var delayed = 0;
    var absent = 0;
    for (final record in recordsOf(studentId, month)) {
      switch (record.status) {
        case AttendanceStatus.present:
          present++;
        case AttendanceStatus.delayed:
          delayed++;
        case AttendanceStatus.absent:
          absent++;
      }
    }
    return AttendanceSummary(
      present: present,
      delayed: delayed,
      absent: absent,
    );
  }

  void mark({
    required String studentId,
    required String groupId,
    required DateTime date,
    required AttendanceStatus status,
  }) {
    final day = DateFormatter.dateOnly(date);
    final index = _records.indexWhere(
      (record) =>
          record.studentId == studentId &&
          DateFormatter.sameDay(record.date, day),
    );

    if (index != -1 && _records[index].status == status) {
      final removed = _records.removeAt(index);
      runLocal(() => AttendanceLocalSource.instance.delete(removed.id));
      notifyListeners();
      return;
    }

    final record = AttendanceRecord(
      id: IdGenerator.attendanceId(studentId, day),
      studentId: studentId,
      groupId: groupId,
      date: day,
      status: status,
    );
    if (index == -1) {
      _records.add(record);
    } else {
      _records[index] = record;
    }
    runLocal(() => AttendanceLocalSource.instance.save(record));
    notifyListeners();
  }

  void reset() {
    _records.clear();
    notifyListeners();
  }
}
