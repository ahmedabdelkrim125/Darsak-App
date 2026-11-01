enum AttendanceStatus {
  present('present', 'حاضر'),
  delayed('late', 'متأخر'),
  absent('absent', 'غائب');

  const AttendanceStatus(this.key, this.label);

  final String key;
  final String label;

  static AttendanceStatus fromKey(String key) {
    return values.firstWhere(
      (status) => status.key == key,
      orElse: () => AttendanceStatus.present,
    );
  }
}
