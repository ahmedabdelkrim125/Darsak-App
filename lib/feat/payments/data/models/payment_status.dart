enum PaymentStatus {
  paid('مدفوع'),
  partial('مدفوع جزئياً'),
  unpaid('لم يدفع');

  const PaymentStatus(this.label);

  final String label;
}
