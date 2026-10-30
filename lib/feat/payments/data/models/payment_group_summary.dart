class PaymentGroupSummary {
  const PaymentGroupSummary({
    required this.groupId,
    required this.title,
    required this.yearLabel,
    required this.fee,
    required this.studentsCount,
    required this.paid,
    required this.partial,
    required this.unpaid,
    required this.collected,
    required this.expected,
  });

  final String groupId;
  final String title;
  final String yearLabel;
  final int fee;
  final int studentsCount;
  final int paid;
  final int partial;
  final int unpaid;
  final int collected;
  final int expected;

  double get progress => expected == 0 ? 0 : collected / expected;
}
