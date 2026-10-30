class NotificationFormat {
  NotificationFormat._();

  static const List<String> _weekdays = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  static const List<String> _months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static String time(DateTime value) {
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour < 12 ? 'ص' : 'م';
    return '$hour:$minute $period';
  }

  static String date(DateTime value) {
    return '${_weekdays[value.weekday - 1]}، ${value.day} '
        '${_months[value.month - 1]} ${value.year}';
  }

  static bool sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String? heading(DateTime value, DateTime now) {
    if (sameDay(value, now)) return 'اليوم';
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    if (sameDay(value, yesterday)) return 'أمس';
    return null;
  }
}
