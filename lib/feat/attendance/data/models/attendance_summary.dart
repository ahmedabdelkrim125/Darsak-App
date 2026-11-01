class AttendanceSummary {
  const AttendanceSummary({
    required this.present,
    required this.absent,
    this.delayed = 0,
  });

  final int present;
  final int absent;
  final int delayed;

  int get total => present + delayed + absent;

  String get rateLabel {
    if (total == 0) return '—';
    return '${((present + delayed) * 100 / total).round()}%';
  }
}
