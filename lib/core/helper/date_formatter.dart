import '../const/week_days.dart';

class DateFormatter {
  DateFormatter._();

  static const List<String> months = [
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

  static String monthYear(DateTime date) {
    return '${months[date.month - 1]} ${date.year}';
  }

  static String shortDate(DateTime date) {
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static String full(DateTime date) {
    return '${WeekDays.label(date.weekday)}، ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime monthStart(DateTime date) {
    return DateTime(date.year, date.month);
  }

  static DateTime addMonths(DateTime date, int step) {
    return DateTime(date.year, date.month + step);
  }

  static DateTime startOfWeek(DateTime date) {
    return DateTime(date.year, date.month, date.day - (date.weekday + 1) % 7);
  }

  static bool sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool sameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static int leadingBlanks(DateTime firstOfMonth) {
    return (firstOfMonth.weekday + 1) % 7;
  }
}