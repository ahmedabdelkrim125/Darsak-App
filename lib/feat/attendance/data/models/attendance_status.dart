enum AttendanceStatus {
  present('present', 'حاضر'),
  absent('absent', 'غائب'),
  tardy('late', 'متأخر');

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
