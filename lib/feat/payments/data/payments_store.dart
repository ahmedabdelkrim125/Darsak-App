import 'package:flutter/foundation.dart';
import '../../../core/helper/date_formatter.dart';
import '../../classroom/data/classroom_store.dart';
import '../../classroom/data/models/classroom_group.dart';
import '../../classroom/data/models/classroom_student.dart';
import 'models/payment_entry.dart';
import 'models/payment_filter.dart';
import 'models/payment_group_summary.dart';
import 'models/payment_record.dart';
import 'models/payment_status.dart';

class PaymentsStore extends ChangeNotifier {
  PaymentsStore._();

  static final PaymentsStore instance = PaymentsStore._();

  final List<PaymentRecord> _records = [];
  int _counter = 0;

  List<PaymentRecord> recordsOf(String studentId, DateTime month) {
    final result = _records
        .where(
          (record) =>
              record.studentId == studentId &&
              DateFormatter.sameMonth(record.month, month),
        )
        .toList();
    result.sort((a, b) => b.paidAt.compareTo(a.paidAt));
    return result;
  }

  PaymentEntry _entry(
    ClassroomGroup group,
    ClassroomStudent student,
    DateTime month,
  ) {
    final records = recordsOf(student.id, month);
    final paid = records.fold<int>(0, (total, record) => total + record.amount);
    return PaymentEntry(
      studentId: student.id,
      studentName: student.name,
      username: student.username,
      groupId: group.id,
      groupName: group.name,
      subject: group.subject,
      yearLabel: group.year.label,
      fee: group.monthlyFee,
      paid: paid,
      lastPaidAt: records.isEmpty ? null : records.first.paidAt,
    );
  }

  PaymentEntry? entryOf(String studentId, DateTime month) {
    for (final group in ClassroomStore.instance.groups) {
      for (final student in group.students) {
        if (student.id == studentId) return _entry(group, student, month);
      }
    }
    return null;
  }

  List<PaymentEntry> entries(
    DateTime month, {
    String query = '',
    PaymentFilter filter = const PaymentFilter(),
  }) {
    final text = query.trim().toLowerCase();
    final result = <PaymentEntry>[];
    for (final group in ClassroomStore.instance.groups) {
      if (filter.groupId != null && filter.groupId != group.id) continue;
      for (final student in group.students) {
        final entry = _entry(group, student, month);
        if (filter.status != null && entry.status != filter.status) continue;
        if (text.isNotEmpty && !_matches(entry, text)) continue;
        result.add(entry);
      }
    }
    return result;
  }

  bool _matches(PaymentEntry entry, String text) {
    return entry.studentName.toLowerCase().contains(text) ||
        entry.groupName.toLowerCase().contains(text) ||
        (entry.username?.contains(text) ?? false);
  }

  List<PaymentGroupSummary> groupSummaries(DateTime month) {
    final result = <PaymentGroupSummary>[];
    for (final group in ClassroomStore.instance.groups) {
      var paid = 0;
      var partial = 0;
      var unpaid = 0;
      var collected = 0;
      for (final student in group.students) {
        final entry = _entry(group, student, month);
        collected += entry.paid;
        switch (entry.status) {
          case PaymentStatus.paid:
            paid++;
          case PaymentStatus.partial:
            partial++;
          case PaymentStatus.unpaid:
            unpaid++;
        }
      }
      result.add(
        PaymentGroupSummary(
          groupId: group.id,
          title: '${group.subject} - ${group.name}',
          yearLabel: group.year.label,
          fee: group.monthlyFee,
          studentsCount: group.students.length,
          paid: paid,
          partial: partial,
          unpaid: unpaid,
          collected: collected,
          expected: group.monthlyFee * group.students.length,
        ),
      );
    }
    return result;
  }

  String? addPayment({
    required String studentId,
    required DateTime month,
    required int amount,
    required DateTime paidAt,
  }) {
    final entry = entryOf(studentId, month);
    if (entry == null) return 'الطالب غير موجود';
    if (amount <= 0) return 'أدخل مبلغاً صحيحاً';
    if (entry.remaining == 0) return 'هذا الشهر مدفوع بالكامل';
    if (amount > entry.remaining) {
      return 'المبلغ أكبر من المتبقي (${entry.remaining} جنيه)';
    }
    _records.add(
      PaymentRecord(
        id: '${++_counter}',
        studentId: studentId,
        groupId: entry.groupId,
        month: DateFormatter.monthStart(month),
        amount: amount,
        paidAt: DateFormatter.dateOnly(paidAt),
      ),
    );
    notifyListeners();
    return null;
  }

  String? payRemaining({
    required String studentId,
    required DateTime month,
    required DateTime paidAt,
  }) {
    final entry = entryOf(studentId, month);
    if (entry == null) return 'الطالب غير موجود';
    return addPayment(
      studentId: studentId,
      month: month,
      amount: entry.remaining,
      paidAt: paidAt,
    );
  }

  void deleteRecord(String id) {
    _records.removeWhere((record) => record.id == id);
    notifyListeners();
  }
}
