import 'payment_status.dart';

class PaymentFilter {
  const PaymentFilter({this.status, this.groupId});

  final PaymentStatus? status;
  final String? groupId;

  bool get isActive => status != null || groupId != null;
}
