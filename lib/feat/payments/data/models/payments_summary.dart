import 'payment_entry.dart';
import 'payment_status.dart';

class PaymentsSummary {
  const PaymentsSummary({
    required this.total,
    required this.paid,
    required this.partial,
    required this.unpaid,
  });

  factory PaymentsSummary.of(List<PaymentEntry> entries) {
    var paid = 0;
    var partial = 0;
    var unpaid = 0;
    for (final entry in entries) {
      switch (entry.status) {
        case PaymentStatus.paid:
          paid++;
        case PaymentStatus.partial:
          partial++;
        case PaymentStatus.unpaid:
          unpaid++;
      }
    }
    return PaymentsSummary(
      total: entries.length,
      paid: paid,
      partial: partial,
      unpaid: unpaid,
    );
  }

  final int total;
  final int paid;
  final int partial;
  final int unpaid;
}
