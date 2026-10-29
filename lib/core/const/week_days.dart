class WeekDays {
  WeekDays._();

  static const List<int> order = [6, 7, 1, 2, 3, 4, 5];

  static const Map<int, String> _labels = {
    1: 'الاثنين',
    2: 'الثلاثاء',
    3: 'الأربعاء',
    4: 'الخميس',
    5: 'الجمعة',
    6: 'السبت',
    7: 'الأحد',
  };

  static String label(int weekday) => _labels[weekday] ?? '';

  static String labels(Set<int> weekdays) {
    return [
      for (final day in order)
        if (weekdays.contains(day)) label(day),
    ].join('، ');
  }
}
