import 'payment_status.dart';

class PaymentEntry {
  const PaymentEntry({
    required this.studentId,
    required this.studentName,
    required this.username,
    required this.groupId,
    required this.groupName,
    required this.subject,
    required this.yearLabel,
    required this.fee,
    required this.paid,
    required this.lastPaidAt,
  });

  final String studentId;
  final String studentName;
  final String? username;
  final String groupId;
  final String groupName;
  final String subject;
  final String yearLabel;
  final int fee;
  final int paid;
  final DateTime? lastPaidAt;

  int get remaining => fee > paid ? fee - paid : 0;

  PaymentStatus get status {
    if (paid <= 0) return PaymentStatus.unpaid;
    if (paid >= fee) return PaymentStatus.paid;
    return PaymentStatus.partial;
  }
}
