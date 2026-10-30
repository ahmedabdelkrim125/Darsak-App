class PaymentRecord {
  const PaymentRecord({
    required this.id,
    required this.studentId,
    required this.groupId,
    required this.month,
    required this.amount,
    required this.paidAt,
  });

  final String id;
  final String studentId;
  final String groupId;
  final DateTime month;
  final int amount;
  final DateTime paidAt;
}
