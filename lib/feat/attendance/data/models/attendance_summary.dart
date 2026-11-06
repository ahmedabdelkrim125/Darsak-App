class AttendanceSummary {
  const AttendanceSummary({
    required this.present,
    required this.absent,
    required this.lateCount,
  });

  final int present;
  final int absent;
  final int lateCount;

  int get total => present + absent + lateCount;

  String get rateLabel {
    if (total == 0) return '—';
    return '${((present + lateCount) * 100 / total).round()}%';
  }
}
