enum NotificationFilter {
  all('الكل'),
  lessons('الحصص'),
  payments('المدفوعات'),
  students('الطلاب'),
  system('النظام');

  const NotificationFilter(this.label);

  final String label;
}
