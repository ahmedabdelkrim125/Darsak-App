class AttendanceSummary {
  const AttendanceSummary({required this.present, required this.absent});

  final int present;
  final int absent;

  int get total => present + absent;

  String get rateLabel {
    if (total == 0) return '—';
    return '${(present * 100 / total).round()}%';
  }
}