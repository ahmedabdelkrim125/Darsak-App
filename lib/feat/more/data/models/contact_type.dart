enum ContactType {
  message('رسالة'),
  suggestion('اقتراح'),
  problem('مشكلة');

  const ContactType(this.label);

  final String label;
}
